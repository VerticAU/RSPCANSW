public without sharing class ClientNotesSearchMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            caseman__ClientNote__c.caseman__TypeOfInteraction__c
        };

        super.process(this.request);

        this.init();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        Id filterRecordId = this.request.getString('filterRecordId');
        if(String.isNotBlank(filterRecordId)){
            SObjectType filterRecordSObjectType = filterRecordId.getSobjectType();

            String filterName;
            if(filterRecordSObjectType == Contact.SObjectType){
                filterName = 'contactId';
            } else if(filterRecordSObjectType == User.SObjectType){
                filterName = 'userId';
            } else if(filterRecordSObjectType == Case.SObjectType){
                filterName = 'caseId';
            } else if(filterRecordSObjectType == pmdm__ProgramEngagement__c.SObjectType){
                filterName = 'programEngagementId';
            } else {
                return;
            }
            this.response.put('filter.' + filterName, filterRecordId);
        }
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}