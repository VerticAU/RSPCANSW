public without sharing class BulkContributionManagementSaveRecProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(
        new List<SObjectType>{
            Batch__c.SObjectType,
            Opportunity.SObjectType
        },
        new vertic_UnitOfWork.DatabaseDMLIml()
    );

    private Batch__c batchVar;

    private void doSubmit() {

        this.createBatch();


//        List<Opportunity> opportunities = (List<Opportunity>) this.request.get('contributions', List<Opportunity>.class);

        List<Opportunity> opportunities = this.request.getMapper().mapToListSObjects('contributions', Opportunity.SObjectType);

        RecordType donationRecType = (RecordType) vertic_Utils.arrays.firstOrException([
            SELECT Id
            FROM RecordType
            WHERE DeveloperName = 'Donation'
            AND NamespacePrefix != 'npsp_plus_dres'
        ]);

        for (Opportunity opportunityVar : opportunities) {

            opportunityVar.Name = 'Donation';
            opportunityVar.StageName = 'Closed Won';
            opportunityVar.RecordTypeId = donationRecType.Id;
            opportunityVar.Status__c = 'Pending';

            this.uow.registerUpsert(opportunityVar);

            if (opportunityVar.Batch__c == null) {
                this.uow.registerRelationship(opportunityVar, Opportunity.Batch__c, this.batchVar);
            }
        }
        uow.commitWork();


        opportunities = [
            SELECT Id,
                Amount,
                Payment_Method__c,
                Stripe_Payment_Id__c,
                Stripe_Customer_Id__c, (
                SELECT npe01__Payment_Method__c, npsp_plus__Gateway_Transaction_ID__c
                FROM npe01__OppPayment__r
                ORDER BY CreatedDate DESC
                LIMIT 1
            )
            FROM Opportunity
            WHERE Batch__c = :batchVar.Id
            FOR UPDATE
        ];

        List<npe01__OppPayment__c> oppPaymentsListToUpdate = new List<npe01__OppPayment__c>();

        for (Opportunity opportunity : opportunities) {

            if (opportunity.npe01__OppPayment__r != null && opportunity.npe01__OppPayment__r.size() > 0) {

                npe01__OppPayment__c oppPayment = opportunity.npe01__OppPayment__r[0];

                if (oppPayment.npsp_plus__Gateway_Transaction_ID__c != null && oppPayment.npe01__Paid__c == true) {
                    continue;
                }

                oppPayment.npe01__Paid__c = false;
                oppPayment.npe01__Written_Off__c = false;
                oppPayment.npe01__Payment_Amount__c = opportunity.Amount;
                oppPayment.npe01__Payment_Method__c = opportunity.Payment_Method__c;

                oppPaymentsListToUpdate.add(oppPayment);
            }
        }

        update oppPaymentsListToUpdate;

        this.response.getMapper().mapAnyValue('batchId', this.batchVar.Id);
    }


    private void createBatch() {
        String batchId = this.request.getString('batchId');

        this.assertBatchIsPending(batchId);

        this.batchVar = new Batch__c(
            Id = batchId,
            Name = 'Bulk Donation ' + System.now(),
            Batch_Status__c = 'Pending'
        );
        this.uow.registerUpsert(batchVar);
    }

    private void assertBatchIsPending(String batchId) {
        if (String.isNotBlank(batchId)) {
            Batch__c batchVar = (Batch__c) vertic_Utils.arrays.firstOrException(
            [SELECT Id, Batch_Status__c FROM Batch__c WHERE Id = :batchId],
                'No Batch with Id: ' + batchId
            );
            if (!'Pending'.equalsIgnoreCase(batchVar.Batch_Status__c)) {
                throw new vertic_Structs.ValidationException('Only Pending Bath can be saved.');
            }
        }
    }
}


/**
 * ==============================================================================================================
 *                                               STRUCTURES
 * ==============================================================================================================
 */

// Proposed Live Templates to override Super properties:
// vertic_request
// vertic_response

//}