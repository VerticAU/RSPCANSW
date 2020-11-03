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

        Opportunity opp = new Opportunity();
        this.request.getMapper().mapToSObject('contribution', opp);

        String paymentIntentId;
        if(opp.Payment_Method__c == 'Credit Card'){
            paymentIntentId = this.request.getRequiredString('contribution.paymentIntentId');
        }

        opp.Name = 'Donation';
        opp.StageName = 'Closed Won';
        opp.RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Donation');

        Savepoint sp = Database.setSavepoint();
        try {

            insert opp;

            npe01__OppPayment__c payment = (npe01__OppPayment__c) vertic_Utils.arrays.firstOrException([
                SELECT Id FROM npe01__OppPayment__c
                WHERE npe01__Opportunity__c =: opp.Id
                ORDER BY CreatedDate LIMIT 1
            ]);

            npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(Id = payment.Id);
            oppPayment.npe01__Payment_Amount__c = opp.Amount;
            oppPayment.npsp_plus__Gateway_Transaction_ID__c = paymentIntentId;
            oppPayment.npe01__Payment_Method__c = opp.Payment_Method__c;
            oppPayment.npe01__Payment_Date__c = Date.today();
            oppPayment.npe01__Paid__c = true;
            oppPayment.npe01__Written_Off__c = false;
            update oppPayment;

            this.response.put('opportunityId', opp.Id);
            this.response.put('oppPaymentId', payment.Id);

        } catch (Exception e) {
            Database.rollback(sp);
            throw e;
        } finally {}

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