public without sharing class EstateManagementQAMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            npe5__Affiliation__c.npe5__Status__c
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

        AccountContactRelation accountEstate = (AccountContactRelation) vertic_Utils.arrays.firstOrNull([
            SELECT Id
            FROM AccountContactRelation
            WHERE ContactId = :recordId AND Account.RecordType.DeveloperName = 'Estate'
            ORDER BY CreatedDate DESC
        ]);

        if (accountEstate == null) {
            this.response.put('hasEstate', false);
        } else {
            this.response.put('hasEstate', true);
        }

        Opportunity opportunity = (Opportunity) vertic_Utils.arrays.firstOrNull([
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


        if (opportunity == null) {
            this.response.put('hasBequest', false);
            return;
        } else {
            this.response.put('hasBequest', true);
        }

        if (opportunity.npsp__Primary_Contact__r.npsp__Deceased__c) {
            this.response.put('deceasedContact', true);
        } else {
            this.response.put('deceasedContact', false);
        }


        List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>([
            SELECT Id, Product2.Name, Quantity, UnitPrice, CreatedDate
            FROM OpportunityLineItem
            WHERE OpportunityId = :opportunity.Id
        ]);

//        List<npe5__Affiliation__c> affiliations = new List<npe5__Affiliation__c>([
//            SELECT Id, npe5__Contact__r.Name, npe5__Role__c, npe5__Status__c, npe5__StartDate__c, npe5__EndDate__c FROM npe5__Affiliation__c WHERE npe5__Contact__c = :recordId
//        ]);


        this.response.put('opportunity', opportunity);
//        this.response.put('expectedValueDoll', opportunity.Expected_Value__c == null ? null : '$' + opportunity.Expected_Value__c.format());
//        this.response.put('expectedValuePercent', opportunity.Expected_Value_P__c == null ? null : opportunity.Expected_Value_P__c.format() + '%');
//        this.response.put('receivedToDate', opportunity.npe01__Payments_Made__c == null ? null : '$' + opportunity.npe01__Payments_Made__c.format());
        this.response.put('probability', opportunity.Probability == null ? null : opportunity.Probability.format() + '%');
//        this.response.put('deceasedDate', opportunity.Deceased_Date__c == null ? null : opportunity.Deceased_Date__c.format());
//        this.response.put('dateOfWill', opportunity.Date_of_Will__c == null ? null : opportunity.Date_of_Will__c.format());
        this.response.put('oppRecordTypeName', opportunity.RecordType.Name);
        this.response.put('opportunityLineItems', opportunityLineItems);
//        this.response.put('affiliations', affiliations);

        this.response.put('dateNotifiedOfDeath', opportunity.npsp__Primary_Contact__r.Date_Notified_of_Death__c == null ? null : opportunity.npsp__Primary_Contact__r.Date_Notified_of_Death__c.format());


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