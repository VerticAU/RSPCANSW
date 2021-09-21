public without sharing class ClientNotesCreateRecordMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
        };

        super.process(this.request);

        this.retrieveContactRecord();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void retrieveContactRecord() {

        String recordId = this.request.getRequiredString('recordId');
        String sObjectName = this.request.getRequiredString('sObjectName');

        String contactRelation = this.request.getString('contactRelation');

        if (String.isNotBlank(contactRelation)) {
            //conditions.add(' FROM ' + sObjectName + ' WHERE :contactRelation =: recordId)');
            List<SObject> contacts = Database.query('SELECT ' + contactRelation + ' FROM ' + sObjectName + ' WHERE Id  =: recordId');
            if(contacts != null && contacts.size() > 0){
                response.dto.put('contactId', contacts.get(0).Id);
            }
        }
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}