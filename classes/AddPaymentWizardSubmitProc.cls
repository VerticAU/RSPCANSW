public class AddPaymentWizardSubmitProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.upsertPayment();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void upsertPayment() {
        npe01__OppPayment__c payment = new npe01__OppPayment__c();
        this.request.getMapper().mapToSObject('payment', payment);

        upsert payment;

        this.response.getMapper().mapFromSObject('payment', payment);
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}