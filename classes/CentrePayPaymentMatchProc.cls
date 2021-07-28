public without sharing class CentrePayPaymentMatchProc extends vertic_AbstractProcessor {


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.match();

        return this.response;
    }

    private void init(){
        this.paymentWrapper = (CentrePayProcessPaymentsSubmitProc.PaymentWrapper)
            this.request.get('wrapper', CentrePayProcessPaymentsSubmitProc.PaymentWrapper.class);
    }

    private void match(){

    }

    private String batchId;
    private CentrePayProcessPaymentsSubmitProc.PaymentWrapper paymentWrapper;

}