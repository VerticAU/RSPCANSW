public class OpportunitySplitPaymentsTableCtrl {

    Opportunity oppVar;
    Opportunity mainOpportunity;
    Id mainOpportunityId;
    List<Opportunity> opportunitiesInTable;

    public Id opportunityId {
        get {
            return opportunityId;
        }
        set {
            opportunityId = value;
            initRecords();
        }
    }

    public void initRecords() {

        this.oppVar = (Opportunity) vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                RecordType.Name,
                Parent_Opportunity__c
            FROM Opportunity
            WHERE Id = :this.opportunityId
        ]);

        if (this.oppVar.RecordType.Name == 'Split Payment') {

            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                FROM Opportunity
                WHERE Parent_Opportunity__c = :this.opportunityId
            ];
            this.mainOpportunityId = this.opportunityId;

        }
        else if(oppVar.Parent_Opportunity__c != null){

            Opportunity parentSplitPaymentOpp = [SELECT Id FROM Opportunity WHERE Id = :oppVar.Parent_Opportunity__c];
            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                FROM Opportunity
                WHERE Parent_Opportunity__c = :parentSplitPaymentOpp.Id
            ];
            this.mainOpportunityId = parentSplitPaymentOpp.Id;

        }
        else{
            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                FROM Opportunity
                WHERE Id = :this.opportunityId
            ];
            this.mainOpportunityId = this.opportunityId;
        }
        fillOpportunityDetails(this.mainOpportunityId);


    }

    public void fillOpportunityDetails(Id oppId){
        this.mainOpportunity = (Opportunity) vertic_Utils.arrays.firstOrNull([
            SELECT Id,
                Receipt_Number_Formula__c,
                CloseDate,
                npsp__Primary_Contact__r.Name,
                npsp__Primary_Contact__r.MailingCity,
                npsp__Primary_Contact__r.MailingCountry,
                npsp__Primary_Contact__r.MailingStreet,
                npsp__Primary_Contact__r.MailingState,
                npsp__Primary_Contact__r.MailingPostalCode,
                RecordType.Name,Parent_Opportunity__c,
                Name
            FROM Opportunity
            WHERE Id = :oppId
        ]);
    }

    public Opportunity getOpportunity() {
        return this.mainOpportunity;
    }

    public List<Opportunity> getOpportunitiesInTable() {
        return opportunitiesInTable;
    }

    public Decimal getPaymentTotal() {
        return vertic_Utils.sObjects.sum(this.opportunitiesInTable, 'Amount');
    }

//    public Integer getOpportunitiesSplitPaymentCount() {
//        return vertic_Utils.objects.defaultIfNull();
//    }
}