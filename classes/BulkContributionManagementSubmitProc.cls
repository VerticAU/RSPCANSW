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


    private void doSubmit() {

        Opportunity opportunity = new Opportunity();
        this.request.getMapper().mapToSObject('contribution', opportunity);

        String paymentIntentId;
        if (opportunity.Payment_Method__c == 'Credit Card') {
            paymentIntentId = this.request.getRequiredString('contribution.paymentIntentId');
        }

        RecordType donationRecType = (RecordType) vertic_Utils.arrays.firstOrException([
            SELECT Id
            FROM RecordType
            WHERE DeveloperName = 'Donation'
            AND NamespacePrefix != 'npsp_plus_dres'
        ]);

        opportunity.Name = 'Donation';
        opportunity.StageName = 'Closed Won';
        opportunity.isCompleted__c = true;
        opportunity.RecordTypeId = donationRecType.Id;

        Savepoint sp = Database.setSavepoint();
        try {

            if (opportunity.Id != null) {
                update opportunity;
            } else {
                insert opportunity;
            }

            npe01__OppPayment__c payment = (npe01__OppPayment__c) vertic_Utils.arrays.firstOrException([
                SELECT Id, npsp_plus__Gateway_Transaction_ID__c, npsp_plus__Status__c
                FROM npe01__OppPayment__c
                WHERE npe01__Opportunity__c = :opportunity.Id
                ORDER BY CreatedDate DESC
                LIMIT 1
            ], 'Payment is not found for Contribution: ' + opportunity.Id);

            npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(
                Id = payment.Id,
                npe01__Payment_Amount__c = opportunity.Amount,
                npsp_plus__Gateway_Transaction_ID__c = paymentIntentId,
                npe01__Payment_Method__c = opportunity.Payment_Method__c,
                npe01__Payment_Date__c = Date.today(),
                npe01__Paid__c = true,
                npe01__Written_Off__c = false
            );
            update oppPayment;

            Opportunity uncompletedOpp = (Opportunity) vertic_Utils.arrays.firstOrNull([
                SELECT Id
                FROM Opportunity
                WHERE npsp__Batch__c = :opportunity.npsp__Batch__c AND
                isCompleted__c = false
            ]);
            if (uncompletedOpp == null) {
                update new npsp__Batch__c(Id = opportunity.npsp__Batch__c, npsp__Batch_Status__c = 'Complete');
            }

            this.response.put('opportunityId', opportunity.Id);
            this.response.put('oppPaymentId', payment.Id);

        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        } finally {
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

}