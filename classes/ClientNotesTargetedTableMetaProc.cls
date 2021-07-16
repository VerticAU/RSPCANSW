public without sharing class ClientNotesTargetedTableMetaProc extends vertic_MetadataProcessor {

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

        this.init();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private List<caseman__ClientNote__c> clientNotes;
    public static final Integer SEARCH_LIMIT = 100;
    public String searchQuery;

    private void init() {
        this.retrieveRecords();
        this.mapRecords();
    }

    private void retrieveRecords() {

        String recordId = this.request.getRequiredString('recordId');
        String sObjectName = this.request.getRequiredString('sObjectName');

        String contactRelation = this.request.getString('contactRelation');
        String targetRelation = this.request.getString('targetRelation');

        List<String> conditions = new List<String>{};
        if (String.isNotBlank(contactRelation)) {
            conditions.add('caseman__Client__c IN (SELECT ' + contactRelation + ' FROM ' + sObjectName + ' WHERE Id =: recordId)');
        } else if (String.isNotBlank(targetRelation)){
            conditions.add(targetRelation + ' =: recordId');
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(caseman__ClientNote__c.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id', 'Name',
            'caseman__Content__c',
            'Interaction_Date_Time__c',
            'caseman__Client__r.Name',
            'Owner.Name',
            'Case__r.CaseNumber',
            'caseman__ProgramEngagement__r.Name',
            'caseman__TypeOfInteraction__c'
        });
        queryFactory.setCondition(String.join(conditions, ' AND '));
        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(
            caseman__ClientNote__c.Interaction_Date_Time__c,
            fflib_QueryFactory.SortOrder.DESCENDING, true
        );
        queryFactory.setLimit(SEARCH_LIMIT + 1);

        this.searchQuery = queryFactory.toSOQL();
        this.clientNotes = (List<caseman__ClientNote__c>) Database.query(this.searchQuery);
    }

    private void mapRecords() {
        System.debug(this.clientNotes);

        this.response.getMapper().mapFromListSObjects(
            'notes',
            this.clientNotes,
            new vertic_AutoMapper.BinderQueue(new ClientNoteBinder()),
            SEARCH_LIMIT
        );
        this.response.put('query', this.searchQuery);
    }

    public class ClientNoteBinder extends vertic_AutoMapper.AbstractBinder {

        public void bind(SObject record, Map<String, Object> dataMap) {

        }
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}