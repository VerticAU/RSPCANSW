public without sharing class BulkAnnualReceiptingSearchProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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

    private List<Contact> contacts;
    public static final Integer SEARCH_LIMIT = 300;

    private void doSubmit() {

        this.retrieveContacts();
        this.mapContacts();

    }

    private void retrieveContacts() {

        Date startDate = this.request.getISODate('filter.startDate');
        Date endDate = this.request.getISODate('filter.endDate');
        String campaignId = this.request.getString('filter.campaignId');
        String contactId = this.request.getString('filter.contactId');
        String accountId = this.request.getString('filter.accountId');
        Boolean isIndividualOnly = this.request.getBoolean('filter.isIndividualOnly');
        Boolean isOrganisationOnly = this.request.getBoolean('filter.isOrganisationOnly');

        Set<Id> contactIds = new Set<Id>();

        List<String> contributionConditions = new List<String>{
            'npsp__Status__c = \'Processed\'',
            'npe03__Amount__c >= 0',
            'npe03__Date_Established__c != null'
        };

        if (startDate != null) {
            contributionConditions.add('npe03__Date_Established__c >= :startDate');
        }

        if (endDate != null) {
            contributionConditions.add('npe03__Date_Established__c <= :endDate');
        }

        if (String.isNotBlank(campaignId)) {
            contributionConditions.add('CampaignId = :campaignId');
        }

        if (String.isNotBlank(contactId)) {
            contributionConditions.add('npe03__Contact__c = :contactId');
        }

        if (String.isNotBlank(accountId)) {
            contributionConditions.add('AccountId = :accountId');
        }

        if(isIndividualOnly == true){
            contributionConditions.add('npe03__Contact__c != null');
        }

        if(isOrganisationOnly == true){
            contributionConditions.add('AccountId != null');
            contributionConditions.add('npe03__Contact__c = null');
        }

        String aggregateSOQL = String.format(
            'SELECT npe03__Contact__c, COUNT(Id) FROM npe03__Recurring_Donation__c WHERE {0} GROUP BY npe03__Contact__c LIMIT {1}',
            new List<String>{
                String.join(contributionConditions, ' AND '),
                String.valueOf(SEARCH_LIMIT + 1)
            }
        );

        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);
        for (AggregateResult aggregateResultVar : aggregateResults) {
            contactIds.add((Id) aggregateResultVar.get('npe03__Contact__c'));
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'Email'
//            'Last_Receipt_Date__c'
        });

        List<String> conditions = new List<String>{ 'Id IN :contactIds' };
        if (!conditions.isEmpty()) {
            queryFactory.setCondition(String.join(conditions, ' AND '));
        }

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Contact.Name, fflib_QueryFactory.SortOrder.ASCENDING);
        queryFactory.setLimit(SEARCH_LIMIT + 1);

        this.contacts = Database.query(queryFactory.toSOQL());
    }

    private void mapContacts() {
        this.response.getMapper().mapFromListSObjects(
            'contacts',
            this.contacts,
            new vertic_AutoMapper.BinderQueue(new CommitmentChannelBinder()),
            SEARCH_LIMIT
        );
    }

    public class CommitmentChannelBinder extends vertic_AutoMapper.AbstractBinder {
        public void bind(SObject record, Map<String, Object> dataMap) {
            dataMap.put('selected', true);
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