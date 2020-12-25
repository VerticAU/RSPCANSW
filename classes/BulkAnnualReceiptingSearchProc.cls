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
    private List<Account> accounts;

    private Date startDate;
    private Date endDate;

    private String contactId;
    private String accountId;

    public static final Integer SEARCH_LIMIT = 1000;

    private void doSubmit() {
        this.retrieveDonors();
        this.mapDonors();
    }

    private void addDateConditions(List<String> contributionConditions){
        this.startDate = this.request.getISODate('filter.startDate');
        this.endDate = this.request.getISODate('filter.endDate');

        if (this.startDate != null) { contributionConditions.add('CloseDate >= :startDate'); }
        if (this.endDate != null) {  contributionConditions.add('CloseDate <= :endDate'); }
    }

//    private void addContactChannelConditons(List<String> contributionConditions){
//        String channel = this.request.getString('filter.channel');
//        switch on channel {
//            when 'Email' { contributionConditions.add('(Contact__r.Email != null AND Contact__r.Receipt_Preference__c = \'Email\')'); }
//            when 'Mail' { contributionConditions.add('((Contact__r.Receipt_Preference__c = \'Mail\') OR (Contact__c != null AND Contact__r.Receipt_Preference__c = null))'); }
//        }
//    }
//
//    private void addAccountChannelConditons(List<String> contributionConditions){
//        String channel = this.request.getString('filter.channel');
//        switch on channel {
//            when 'Email' { contributionConditions.add('(Organisation__r.Email__c != null AND Organisation__r.Receipt_Preference__c = \'Email\')'); }
//            when 'Mail' { contributionConditions.add('((Organisation__r.Receipt_Preference__c = \'Mail\') OR (Organisation__c != null AND Organisation__r.Receipt_Preference__c = null))'); }
//        }
//    }

    private void addAcknowledgmentStatusConditons(List<String> contributionConditions){
        String status= this.request.getString('filter.acknowledgmentStatus');
        switch on status {
            when 'receipted' { contributionConditions.add('npsp__Acknowledgment_Status__c != null'); }
            when 'unreceipted' {contributionConditions.add('npsp__Acknowledgment_Status__c = null'); }
        }
    }

    private void retrieveDonors() {
        List<String> contributionConditions = new List<String>{
            'StageName = \'Closed Won\'',
            'Amount >= 0',
            'CloseDate != null'
        };

        this.addDateConditions(contributionConditions);
        this.addAcknowledgmentStatusConditons(contributionConditions);

        this.contactId = this.request.getString('filter.contactId');
        this.accountId = this.request.getString('filter.organisationId');

        if(this.contactId != null && this.contactId != ''){
            contributionConditions.add('npsp__Primary_Contact__c = :contactId');
            this.contacts = this.retrieveContacts(contributionConditions);
        } else if(this.accountId != null && this.accountId != '') {
            contributionConditions.add('AccountId = :accountId');
            this.accounts = this.retrieveAccounts(contributionConditions);
        } else {
            this.contacts = this.retrieveContacts(contributionConditions.clone());
            this.accounts = this.retrieveAccounts(contributionConditions.clone());
        }
    }

    private List<Contact> retrieveContacts(List<String> contributionConditions){
//        this.addContactChannelConditons(contributionConditions);
//        contributionConditions.add('npsp__Primary_Contact__r.Receipt_Frequency__c = \'Annually\'');

        String aggregateSOQL = this.formattQueryForContact(contributionConditions);
        System.debug('aggregateSOQL: ' + aggregateSOQL);
        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);

        Set<Id> contactIds = new Set<Id>();
        for (AggregateResult aggregateResultVar : aggregateResults) {
            contactIds.add((Id) aggregateResultVar.get('npsp__Primary_Contact__c'));
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'Email'
        });

        List<String> conditions = new List<String>{ 'Id IN :contactIds' };

        if (!conditions.isEmpty()) { queryFactory.setCondition(String.join(conditions, ' AND ')); }

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Contact.Name, fflib_QueryFactory.SortOrder.ASCENDING);
        queryFactory.setLimit(SEARCH_LIMIT);

        System.debug('contacts soql: ' + queryFactory.toSOQL());
        return Database.query(queryFactory.toSOQL());
    }

    private List<Account> retrieveAccounts(List<String> contributionConditions){
//        this.addAccountChannelConditons(contributionConditions);
//        contributionConditions.add('Organisation__r.Receipt_Frequency__c = \'Annually\'');

        String aggregateSOQL = this.formattQueryForAccount(contributionConditions);
        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);

        Set<Id> accountIds = new Set<Id>();
        for (AggregateResult aggregateResultVar : aggregateResults) {
            accountIds.add((Id) aggregateResultVar.get('AccountId'));
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Account.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'Email__c'
        });

        List<String> conditions = new List<String>{ 'Id IN :accountIds' };

        if (!conditions.isEmpty()) { queryFactory.setCondition(String.join(conditions, ' AND ')); }

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Account.Name, fflib_QueryFactory.SortOrder.ASCENDING);
        queryFactory.setLimit(SEARCH_LIMIT);

        return Database.query(queryFactory.toSOQL());
    }

    private String formattQueryForContact(List<String> contributionConditions){
        return String.format(
            'SELECT npsp__Primary_Contact__c, COUNT(Id) FROM Opportunity WHERE {0} GROUP BY npsp__Primary_Contact__c LIMIT {1}',
            new List<String>{
                String.join(contributionConditions, ' AND '),
                String.valueOf(SEARCH_LIMIT)
            }
        );
    }

    private String formattQueryForAccount(List<String> contributionConditions){
        return String.format(
            'SELECT AccountId, COUNT(Id) FROM Opportunity WHERE {0} GROUP BY AccountId LIMIT {1}',
            new List<String>{
                String.join(contributionConditions, ' AND '),
                String.valueOf(SEARCH_LIMIT)
            }
        );
    }

    private void mapDonors() {
        List<SObject> sObjects = new List<SObject>();

        if(this.contacts != null){ sObjects.addAll(this.contacts); }
        if(this.accounts != null){ sObjects.addAll(this.accounts); }

        this.response.getMapper().mapFromListSObjects('donors', sObjects, new vertic_AutoMapper.BinderQueue(new CommitmentChannelBinder()), SEARCH_LIMIT);
    }

    public class CommitmentChannelBinder extends vertic_AutoMapper.AbstractBinder {

        public void bind(SObject record, Map<String, Object> dataMap) {

            Boolean hasEmail;
            String channel;

            switch on String.valueOf(record.getSObjectType()) {
                when 'Contact' {
                    Contact contact = (Contact) record;
                    hasEmail = String.isNotBlank(contact.Email);
                    channel = 'Mail';
                }
                when 'Account' {
                    Account account = (Account) record;
                    hasEmail = String.isNotBlank(account.Email__c);
                    channel = 'Mail';
                }
            }

            List<String> channels = new List<String>{ 'Mail' };

            if (hasEmail) {
                channels.add('Email');
            } else {
                channel = 'Mail';
            }

            dataMap.put('channels', channels);
            dataMap.put('channel', channel);
            dataMap.put('selected', true);
        }
    }



//    private List<Contact> contacts;
//    public static final Integer SEARCH_LIMIT = 300;
//
//    private void doSubmit() {
//
//        this.retrieveContacts();
//        this.mapContacts();
//
//    }
//
//    private void retrieveContacts() {
//
//        Date startDate = this.request.getISODate('filter.startDate');
//        Date endDate = this.request.getISODate('filter.endDate');
//        String campaignId = this.request.getString('filter.campaignId');
//        String contactId = this.request.getString('filter.contactId');
//        String accountId = this.request.getString('filter.accountId');
//        Boolean isIndividualOnly = this.request.getBoolean('filter.isIndividualOnly');
//        Boolean isOrganisationOnly = this.request.getBoolean('filter.isOrganisationOnly');
//
//        Set<Id> contactIds = new Set<Id>();
//
//        List<String> contributionConditions = new List<String>{
//            'StageName = \'Closed Won\'',
//            'Amount >= 0',
//            'CloseDate != null'
//        };
//
//        if (startDate != null) {
//            contributionConditions.add('CloseDate >= :startDate');
//        }
//
//        if (endDate != null) {
//            contributionConditions.add('CloseDate <= :endDate');
//        }
//
//        if (String.isNotBlank(campaignId)) {
//            contributionConditions.add('CampaignId = :campaignId');
//        }
//
//        if (String.isNotBlank(contactId)) {
//            contributionConditions.add('npsp__Primary_Contact__c = :contactId');
//        }
//
//        if (String.isNotBlank(accountId)) {
//            contributionConditions.add('AccountId = :accountId');
//        }
//
//        if(isIndividualOnly == true){
//            contributionConditions.add('npsp__Primary_Contact__c != null');
//        }
//
//        if(isOrganisationOnly == true){
//            contributionConditions.add('AccountId != null');
//            contributionConditions.add('npsp__Primary_Contact__c = null');
//        }
//
//        String aggregateSOQL = String.format(
//            'SELECT npsp__Primary_Contact__c, COUNT(Id) FROM Opportunity WHERE {0} GROUP BY npsp__Primary_Contact__c LIMIT {1}',
//            new List<String>{
//                String.join(contributionConditions, ' AND '),
//                String.valueOf(SEARCH_LIMIT + 1)
//            }
//        );
//
//        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);
//        for (AggregateResult aggregateResultVar : aggregateResults) {
//            contactIds.add((Id) aggregateResultVar.get('npsp__Primary_Contact__c'));
//        }
//
//        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
//        queryFactory.selectFields(new Set<String>{
//            'Id',
//            'Name',
//            'Email'
//        });
//
//        List<String> conditions = new List<String>{ 'Id IN :contactIds' };
//        if (!conditions.isEmpty()) {
//            queryFactory.setCondition(String.join(conditions, ' AND '));
//        }
//
//        queryFactory.getOrderings().clear();
//        queryFactory.addOrdering(Contact.Name, fflib_QueryFactory.SortOrder.ASCENDING);
//        queryFactory.setLimit(SEARCH_LIMIT + 1);
//
//        this.contacts = Database.query(queryFactory.toSOQL());
//    }
//
//    private void mapContacts() {
//        this.response.getMapper().mapFromListSObjects(
//            'contacts',
//            this.contacts,
//            new vertic_AutoMapper.BinderQueue(new CommitmentChannelBinder()),
//            SEARCH_LIMIT
//        );
//    }
//
//    public class CommitmentChannelBinder extends vertic_AutoMapper.AbstractBinder {
//        public void bind(SObject record, Map<String, Object> dataMap) {
//            dataMap.put('selected', true);
//        }
//    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}