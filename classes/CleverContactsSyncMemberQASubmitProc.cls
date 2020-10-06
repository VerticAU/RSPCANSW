public without sharing class CleverContactsSyncMemberQASubmitProc extends vertic_AbstractProcessor {
    /**
    * ==============================================================================================================
    *                                              PROCESS
    * ==============================================================================================================
    */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.syncMembers();

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

    private void syncMembers(){
        String batchId = Database.executeBatch(new CleverContactsSyncMemberBatch(this.recordId), 1);
        this.response.getMapper().mapAnyValue('batchId', batchId);
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private String recordId;
}