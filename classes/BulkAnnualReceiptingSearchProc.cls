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
    private String campaignId;

    public static final Integer SEARCH_LIMIT = 1000;

    private void doSubmit() {
        this.retrieveDonors();
        this.mapDonors();
    }

    private void addCampaignConditions(List<String> contributionConditions){
        this.campaignId = this.request.getString('filter.campaignId');
        if (!String.isBlank(this.campaignId)) { contributionConditions.add('CampaignId = :campaignId'); }
    }

    private void addDateConditions(List<String> contributionConditions){
        this.startDate = this.request.getISODate('filter.startDate');
        this.endDate = this.request.getISODate('filter.endDate');

        if (this.startDate != null) { contributionConditions.add('CloseDate >= :startDate'); }
        if (this.endDate != null) {  contributionConditions.add('CloseDate <= :endDate'); }
    }

    private void addAcknowledgmentStatusConditions(List<String> contributionConditions){
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
            'CloseDate != null',
            'npe03__Recurring_Donation__c != null'
        };

        this.addDateConditions(contributionConditions);
        this.addAcknowledgmentStatusConditions(contributionConditions);
        this.addCampaignConditions(contributionConditions);

        this.contactId = this.request.getString('filter.contactId');
        this.accountId = this.request.getString('filter.organisationId');

        Boolean isIndividualOnly = this.request.getBoolean('filter.isIndividualOnly') == true;
        Boolean isOrganisationOnly = this.request.getBoolean('filter.isOrganisationOnly') == true;

        if(isIndividualOnly && String.isBlank(this.contactId)){
            this.contacts = this.retrieveContacts(contributionConditions.clone());
        } else if(isOrganisationOnly && String.isBlank(this.accountId)){
            this.accounts = this.retrieveAccounts(contributionConditions.clone());
        } else if(!String.isBlank(this.contactId)){
            contributionConditions.add('npsp__Primary_Contact__c = :contactId');
            this.contacts = this.retrieveContacts(contributionConditions);
        } else if(!String.isBlank(this.accountId)) {
            contributionConditions.add('AccountId = :accountId');
            this.accounts = this.retrieveAccounts(contributionConditions);
        } else {
            this.contacts = this.retrieveContacts(contributionConditions.clone());
            this.accounts = this.retrieveAccounts(contributionConditions.clone());
        }
    }

    private List<Contact> retrieveContacts(List<String> contributionConditions){
        String aggregateSOQL = this.formatQueryForContact(contributionConditions);
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
            'Email',
            'IsEmailBounced',
            'Receipt_Preference__c'
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
        String aggregateSOQL = this.formatQueryForAccount(contributionConditions);
        List<AggregateResult> aggregateResults = Database.query(aggregateSOQL);

        Set<Id> accountIds = new Set<Id>();
        for (AggregateResult aggregateResultVar : aggregateResults) {
            accountIds.add((Id) aggregateResultVar.get('AccountId'));
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Account.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'Email__c',
            'npe01__One2OneContact__r.Email',
            'npe01__One2OneContact__r.IsEmailBounced',
            'npe01__One2OneContact__r.Receipt_Preference__c'
        });

        List<String> conditions = new List<String>{ 'Id IN :accountIds' };

        if (!conditions.isEmpty()) { queryFactory.setCondition(String.join(conditions, ' AND ')); }

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Account.Name, fflib_QueryFactory.SortOrder.ASCENDING);
        queryFactory.setLimit(SEARCH_LIMIT);

        return Database.query(queryFactory.toSOQL());
    }

    private String formatQueryForContact(List<String> contributionConditions){
        return String.format(
            'SELECT npsp__Primary_Contact__c, COUNT(Id) FROM Opportunity WHERE {0} GROUP BY npsp__Primary_Contact__c LIMIT {1}',
            new List<String>{
                String.join(contributionConditions, ' AND '),
                String.valueOf(SEARCH_LIMIT)
            }
        );
    }

    private String formatQueryForAccount(List<String> contributionConditions){
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

            String email;
            String receiptPreference;
            Boolean isEmailBounced;
            Boolean hasEmail;

            Boolean isDisabled = false;

            List<String> channels = new List<String>{};
            switch on String.valueOf(record.getSObjectType()) {
                when 'Contact' {
                    Contact contact = (Contact) record;
                    dataMap.put('isIndividual', true);

                    email = contact.Email;
                    isEmailBounced = contact.IsEmailBounced == true;
                    receiptPreference = contact.Receipt_Preference__c;
                }
                when 'Account' {
                    Account account = (Account) record;
                    dataMap.put('isIndividual', false);

                    if(account.npe01__One2OneContact__c != null){
                        email = account.npe01__One2OneContact__r.Email;
                        isEmailBounced = account.npe01__One2OneContact__r.IsEmailBounced == true;
                        receiptPreference = account.npe01__One2OneContact__r.Receipt_Preference__c;
                    } else {
                        isDisabled = true;
                    }
                }
            }

            hasEmail = String.isNotBlank(email);

            if(!isDisabled){
                channels.add('Postal Receipt');
                if(hasEmail && !isEmailBounced){
                    channels.add('Email Receipt');
                }

                switch on receiptPreference {
                    when 'Email Receipt' {
                        if(hasEmail && !isEmailBounced){
                            dataMap.put('channel', 'Email Receipt');
                        } else {
                            dataMap.put('channel', 'Postal Receipt');
                        }
                    }
                    when 'Postal Receipt' {
                        dataMap.put('channel', 'Postal Receipt');
                    }
                    when 'No Receipt' {
                        dataMap.put('channel', 'No Receipt');
                    }
                    when else {
                        if(hasEmail && !isEmailBounced){
                            dataMap.put('channel', 'Email Receipt');
                        } else {
                            dataMap.put('channel', 'Postal Receipt');
                        }
                    }
                }
            }

            dataMap.put('email', email);
            dataMap.put('hasEmail', hasEmail);
            dataMap.put('isEmailBounced', isEmailBounced);
            dataMap.put('channels', channels);
            dataMap.put('isDisabled', isDisabled);
        }
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

}