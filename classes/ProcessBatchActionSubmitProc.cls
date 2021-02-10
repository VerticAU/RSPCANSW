public without sharing class ProcessBatchActionSubmitProc extends vertic_AbstractProcessor {
    /**
    * ==============================================================================================================
    *                                              PROCESS
    * ==============================================================================================================
    */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.processPayments();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        this.recordId = this.request.getRequiredString('recordId');
    }

    private void processPayments(){
        String batchId = Database.executeBatch(new ProcessPaymentsBatch(this.recordId), 1);
        this.response.getMapper().mapAnyValue('batchId', batchId);
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private String recordId;
}