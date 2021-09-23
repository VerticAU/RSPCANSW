public without sharing class ClientNotesCreateRecordSubmitProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        super.process(this.request);

        this.doSubmit();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    caseman__ClientNote__c clientNote = new caseman__ClientNote__c();

    private void doSubmit() {
        this.request.getMapper().mapToSObject('clientNote', this.clientNote);

        if(this.request.getString('clientNote.date') != null && this.request.getString('clientNote.time') != null){
            this.clientNote.Interaction_Date_Time__c = Datetime.newInstance(this.request.getISODate('clientNote.date'), vertic_Utils.dates.timeStringToTime(this.request.getString('clientNote.time')));
        }

        insert clientNote;

    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}