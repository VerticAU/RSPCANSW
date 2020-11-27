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

//        Integer financialYear = this.request.getInteger('filter.financialYear');
        String contactId = this.request.getString('filter.contactId');
        String marketId = this.request.getString('filter.marketId');
        String channel = this.request.getString('filter.channel');
        String acknowledgmentStatus = this.request.getString('filter.acknowledgmentStatus');

        Date startDate = this.request.getISODate('filter.startDate');
        Date endDate = this.request.getISODate('filter.endDate');

        Set<Id> contactIds = new Set<Id>();

        List<String> contributionConditions = new List<String>{
            'Status__c = \'Processed\'',
            'Amount__c >= 0',
            'Date__c != null'
        };

        if (startDate != null) {
            contributionConditions.add('Date__c >= :startDate');
        }

        if (endDate != null) {
            contributionConditions.add('Date__c <= :endDate');
        }

        if (String.isNotBlank(contactId)) {
            contributionConditions.add('Contact__c = :contactId');
        }

        if(String.isNotBlank(marketId)){
            contributionConditions.add('Market__c = :marketId');
        }

        if ('receipted'.equalsIgnoreCase(acknowledgmentStatus)) {
            contributionConditions.add('Contact__r.Last_Receipt_Date__c != null');
        }
        if ('unreceipted'.equalsIgnoreCase(acknowledgmentStatus)) {
            contributionConditions.add('Contact__r.Last_Receipt_Date__c = null');
        }

        if ('Email'.equalsIgnoreCase(channel)) {
            contributionConditions.add('(Contact__r.Email != null AND Contact__r.Receipt_Preference__c = \'Email\')');
        }

        if ('Letter'.equalsIgnoreCase(channel)) {
            contributionConditions.add('((Contact__r.Receipt_Preference__c = \'Letter\') OR (Contact__c != null AND Contact__r.Receipt_Preference__c = null))');
        }

        String aggregateSOQL = String.format(
            'SELECT Contact__c, COUNT(Id) FROM Donation__c WHERE {0} GROUP BY Contact__c LIMIT {1}',
            new List<String>{
                String.join(contributionConditions, ' AND '),
                String.valueOf(SEARCH_LIMIT + 1)
            }
        );

        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);

        for (AggregateResult aggregateResultVar : aggregateResults) {
            contactIds.add((Id) aggregateResultVar.get('Contact__c'));
        }


        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'Email',
            'Receipt_Preference__c',
            'Last_Receipt_Date__c'
        });

        List<String> conditions = new List<String>{
            'Id IN :contactIds'
        };

        if (!conditions.isEmpty()) {
            queryFactory.setCondition(String.join(conditions, ' AND '));
        }

        queryFactory.getOrderings().clear();
//        queryFactory.addOrdering(Contact.Last_Receipt_Date__c, fflib_QueryFactory.SortOrder.ASCENDING, false);
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
            Contact contactVar = (Contact) record;

            Boolean hasEmail;
            String channel = 'Letter';

            hasEmail = String.isNotBlank(contactVar.Email);
//            channel = vertic_Utils.objects.defaultIfNull(contactVar.Receipt_Preference__c, 'Letter');

            List<String> channels = new List<String>{
                'Letter'
            };

            if (hasEmail) {
                channels.add('Email');
            } else {
                channel = 'Letter';
            }

            dataMap.put('channels', channels);
            dataMap.put('channel', channel);
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