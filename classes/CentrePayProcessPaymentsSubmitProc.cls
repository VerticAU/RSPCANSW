public without sharing class CentrePayProcessPaymentsSubmitProc extends vertic_AbstractProcessor {
    /**
    * ==============================================================================================================
    *                                              PROCESS
    * ==============================================================================================================
    */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.matchPayments();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        this.recordId = this.request.getRequiredString('recordId');
        this.paymentRows = this.request.getListAsMap('payments');
    }

    private void matchPayments(){
        String batchId = Database.executeBatch(new CentrePayProcessPaymentsBatch(this.paymentRows, this.recordId), 1);
        this.response.getMapper().mapAnyValue('batchId', batchId); //todo: add batch progress bar to lightning
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private String recordId;
    private List<Map<String, Object>> paymentRows;

}