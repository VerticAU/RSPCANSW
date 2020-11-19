public without sharing class BulkContributionManagementSubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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
            npsp__Batch__c.SObjectType,
            Opportunity.SObjectType
        },
        new vertic_UnitOfWork.DatabaseDMLIml()
    );

    private npsp__Batch__c batchVar;

    private void doSubmit() {

        this.createBatch();

        List<Opportunity> opportunitys = (List<Opportunity>) this.request.get('opportunitys', List<Opportunity>.class);

        RecordType donationRecType = (RecordType) vertic_Utils.arrays.firstOrException([
            SELECT Id
            FROM RecordType
            WHERE DeveloperName = 'Donation'
            AND NamespacePrefix != 'npsp_plus_dres'
        ]);


        for (Opportunity opportunityVar : opportunitys) {

            opportunityVar.Name = 'Donation';
            opportunityVar.StageName = 'Closed Won';
            opportunityVar.RecordTypeId = donationRecType.Id;

            this.uow.registerUpsert(opportunityVar, false);
            opportunityVar.Status__c = 'Pending';

            if (opportunityVar.Id == null) {
                this.uow.registerRelationship(opportunityVar, Opportunity.npsp__Batch__c, this.batchVar);
            }
        }

        uow.commitWork();

        this.response.getMapper().mapAnyValue('batchId', this.batchVar.Id);

    }


    private void createBatch() {
        String batchId = this.request.getString('batchId');

        this.assertBatchIsPending(batchId);

        this.batchVar = new npsp__Batch__c(
            Id = batchId,
            npsp__Batch_Status__c = 'Pending'
        );
        this.uow.registerUpsert(batchVar);
    }

    private void assertBatchIsPending(String batchId) {
        if (String.isNotBlank(batchId)) {
            npsp__Batch__c batchVar = (npsp__Batch__c) vertic_Utils.arrays.firstOrException(
            [SELECT Id, npsp__Batch_Status__c FROM npsp__Batch__c WHERE Id = :batchId],
                'No Batch with Id: ' + batchId
            );
            if (!'Pending'.equalsIgnoreCase(batchVar.npsp__Batch_Status__c)) {
                throw new vertic_Structs.ValidationException('Only Pending Bath can be saved.');
            }
        }
    }
}




//        Opportunity opp = new Opportunity();
//        this.request.getMapper().mapToSObject('contribution', opp);

//        String paymentIntentId;
//        if(opp.Payment_Method__c == 'Credit Card'){
//            paymentIntentId = this.request.getRequiredString('contribution.paymentIntentId');
//        }

//        opp.Name = 'Donation';
//        opp.StageName = 'Closed Won';



//        Savepoint sp = Database.setSavepoint();
//        try {
//
//            insert opp;
//
//            npe01__OppPayment__c payment = (npe01__OppPayment__c) vertic_Utils.arrays.firstOrException([
//                SELECT Id FROM npe01__OppPayment__c
//                WHERE npe01__Opportunity__c =: opp.Id
//                ORDER BY CreatedDate LIMIT 1
//            ]);
//
//            npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(Id = payment.Id);
//            oppPayment.npe01__Payment_Amount__c = opp.Amount;
//            oppPayment.npsp_plus__Gateway_Transaction_ID__c = paymentIntentId;
//            oppPayment.npe01__Payment_Method__c = opp.Payment_Method__c;
//            oppPayment.npe01__Payment_Date__c = Date.today();
//            oppPayment.npe01__Paid__c = true;
//            oppPayment.npe01__Written_Off__c = false;
//            update oppPayment;
//
//            this.response.put('opportunityId', opp.Id);
//            this.response.put('oppPaymentId', payment.Id);
//
//            System.debug(this.response);
//        } catch (Exception e) {
//            Database.rollback(sp);
//            throw e;
//        } finally {}

//    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response

//}