public without sharing class ClientNotesSearchSubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

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

    private void doSubmit() {
        this.retrieveRecords();
        this.mapRecords();
    }

    private void retrieveRecords() {

        Date startDate = this.request.getISODate('filter.startDate');
        Date endDate = this.request.getISODate('filter.endDate');
        String contactId = this.request.getString('filter.contactId');
        String userId = this.request.getString('filter.userId');
        String caseId = this.request.getString('filter.caseId');
        String programEngagementId = this.request.getString('filter.programEngagementId');
        String typeOfInteraction = this.request.getString('filter.typeOfInteraction');
        String keyword = this.request.getString('filter.keyword');
        Boolean fuzzy = this.request.getBoolean('filter.fuzzy');

        Set<String> fields = new Set<String>{
            'Id', 'Name',
            'caseman__Content__c',
            'Interaction_Date_Time__c',
            'caseman__Client__r.Name',
            'Owner.Name',
            'Case__r.CaseNumber',
            'caseman__ProgramEngagement__r.Name',
            'caseman__TypeOfInteraction__c'
        };

        List<String> conditions = new List<String>{};
        if (startDate != null) { conditions.add('Interaction_Date_Time__c >= :startDate'); }
        if (endDate != null) { conditions.add('Interaction_Date_Time__c <= :endDate'); }
        if (String.isNotBlank(contactId)) { conditions.add('caseman__Client__c = :contactId'); }
        if (String.isNotBlank(userId)) { conditions.add('OwnerId = :userId'); }
        if (String.isNotBlank(caseId)) { conditions.add('Case__c = :caseId'); }
        if (String.isNotBlank(programEngagementId)) { conditions.add('caseman__ProgramEngagement__c = :programEngagementId'); }
        if (String.isNotBlank(typeOfInteraction)) { conditions.add('caseman__TypeOfInteraction__c = :typeOfInteraction'); }

        if(String.isNotBlank(keyword)){
            keyword = String.escapeSingleQuotes(keyword);

            if(keyword.contains(';')){
                List<String> keywords = new List<String>();
                for(String key : keyword.split(';')){
                    keywords.add(prepareKeyword(key, fuzzy));
                }
                keyword = String.join(keywords, ' OR ');
            } else {
                keyword = prepareKeyword(keyword, fuzzy);
            }

            System.debug('keyword ' + keyword);
            this.searchQuery = 'FIND \'' + keyword + '\'' +
                                ' IN ALL FIELDS' +
                                ' RETURNING caseman__ClientNote__c ( ' +
                                    String.join(new List<String>(fields), ', ') +
                                    ' WHERE ' + String.join(conditions, ' AND ') +
                                    ' ORDER BY Interaction_Date_Time__c DESC ' +
                                    ' LIMIT ' + (SEARCH_LIMIT + 1) +
                                ' )';

            List<List<SObject>> searchList = Search.query(this.searchQuery);
            this.clientNotes = (List<caseman__ClientNote__c>) searchList[0];
        } else {
            fflib_QueryFactory queryFactory = new fflib_QueryFactory(caseman__ClientNote__c.SObjectType);
            queryFactory.selectFields(fields);
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
    }

    private String prepareKeyword(String keyword, Boolean fuzzy){
        keyword = keyword.replaceAll('[^a-zA-Z0-9,.\\s+]', '');

        if(fuzzy == true){ keyword += '*'; }

        return keyword;
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
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}