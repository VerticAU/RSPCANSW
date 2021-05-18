public without sharing class EzidebitChangeCustomerStatusProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    // private String recordId;


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doProcess();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void doProcess() {
        String recordId = this.request.getRequiredString('recordId');

        npe03__Recurring_Donation__c recurringDonation = (npe03__Recurring_Donation__c) vertic_Utils.arrays.firstOrException([
            SELECT npsp__Status__c, EziDebit_Customer_ID__c, npsp__PaymentMethod__c FROM npe03__Recurring_Donation__c
            WHERE Id = :recordId
        ], 'Recurring Donation not found.');

        if (String.isNotBlank(recurringDonation.EziDebit_Customer_ID__c) && 'EziDebit'.equals(recurringDonation.npsp__PaymentMethod__c)) {
            String eziDebitStatus = 'Active'.equals(recurringDonation.npsp__Status__c) ? 'A' : 'H';
            new EzidebitPaymentProcessor(
                payment_ProcessorFactory.getGatewayCredentials('EziDebit')
            ).changeCustomerStatus(recurringDonation.EziDebit_Customer_ID__c, eziDebitStatus);

            List<npe01__OppPayment__c> payments = [SELECT Id FROM npe01__OppPayment__c WHERE npe01__Opportunity__r.npe03__Recurring_Donation__c = :recordId AND EziDebit_Transaction_ID__c = 'SCHEDULED'];
            for (npe01__OppPayment__c payment : payments) {
                payment.npe01__Written_Off__c = true;
            }
            update payments;
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