public without sharing class EstateManagementQAMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            npe5__Affiliation__c.npe5__Status__c,
            AccountContactRelation.Roles
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.initMetadata();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void initMetadata() {

        String recordId = this.request.getString('recordId');

        Account accountEstate = (Account) vertic_Utils.arrays.firstOrNull([
            SELECT Id
            FROM Account
            WHERE Deceased_Donor__c =:recordId AND Account.RecordType.DeveloperName = 'Estate'
            ORDER BY CreatedDate DESC
        ]);

        if (accountEstate == null) {
            this.response.put('hasEstate', false);
        } else {
            this.response.put('hasEstate', true);
        }

        Opportunity opportunityGiW = (Opportunity) vertic_Utils.arrays.firstOrNull([
            SELECT Id, Name, npsp__Primary_Contact__c, npsp__Primary_Contact__r.Name, npsp__Primary_Contact__r.Id, StageName, Type,
                Deceased_Date__c, Date_of_Will__c, npsp__Qualified_Date__c,
                Paperwork_Received__c,Bequest_Percentage__c, npe01__Payments_Made__c,
                Expected_Value_P__c, Expected_Value__c, Probability, Date_Notified_of_Death__c,
                Account.Name, Account.Id, npsp__Primary_Contact__r.npsp__Deceased__c, npsp__Primary_Contact__r.Date_Notified_of_Death__c,
                RecordType.Name, Amount
            FROM Opportunity
            WHERE npsp__Primary_Contact__c = :recordId AND RecordType.DeveloperName = 'Bequest'
            ORDER BY CreatedDate DESC
        ]);


        if (opportunityGiW == null) {
            this.response.put('hasBequest', false);
            return;
        } else {
            this.response.put('hasBequest', true);
        }

        if (opportunityGiW.npsp__Primary_Contact__r.npsp__Deceased__c) {
            this.response.put('deceasedContact', true);
        } else {
            this.response.put('deceasedContact', false);
        }


        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>([
            SELECT Id, Product2.Name, Quantity, UnitPrice, CreatedDate
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunityGiW.Id
        ]);


        this.response.put('opportunity', opportunityGiW);
        this.response.put('probability', opportunityGiW.Probability == null ? null : opportunityGiW.Probability.format() + '%');
        this.response.put('oppRecordTypeName', opportunityGiW.RecordType.Name);
        this.response.put('opportunityLineItems', opportunityLineItems);
        this.response.put('dateNotifiedOfDeath', opportunityGiW.npsp__Primary_Contact__r.Date_Notified_of_Death__c == null ? null : opportunityGiW.npsp__Primary_Contact__r.Date_Notified_of_Death__c.format());


    }


    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties: 
    // vertic_meta_request
    // vertic_meta_response

}