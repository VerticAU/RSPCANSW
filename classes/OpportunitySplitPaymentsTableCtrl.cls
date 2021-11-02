public without sharing class OpportunitySplitPaymentsTableCtrl {

    Opportunity oppVar;
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
                Receipt_Number_Formula__c,
                CloseDate,
                Amount,
                npsp__Primary_Contact__r.Name,
                npsp__Primary_Contact__r.MailingCity,
                npsp__Primary_Contact__r.MailingCountry,
                npsp__Primary_Contact__r.MailingStreet,
                npsp__Primary_Contact__r.MailingState,
                npsp__Primary_Contact__r.MailingPostalCode,
                RecordType.DeveloperName, RecordType.Name
            FROM Opportunity
            WHERE Id = :this.opportunityId
        ]);

        if ('Split_Payment'.equalsIgnoreCase(this.oppVar.RecordType.DeveloperName)) {

            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                FROM Opportunity
                WHERE Parent_Opportunity__c = :this.opportunityId
                AND StageName = 'Closed Won'
            ];

        } else {
            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                FROM Opportunity
                WHERE Id = :this.opportunityId
                AND StageName = 'Closed Won'
            ];
        }
    }

    public Opportunity getOpportunity() {
        return this.oppVar;
    }

    public List<Opportunity> getOpportunitiesInTable() {
        return opportunitiesInTable;
    }

    public Decimal getPaymentTotal() {
        Decimal sum = vertic_Utils.sObjects.sum(this.opportunitiesInTable, 'Amount');
        if ('Split_Payment'.equalsIgnoreCase(this.oppVar.RecordType.DeveloperName) && this.oppVar.Amount > 0) {
            sum = this.oppVar.Amount;
        }
        return sum;
    }

//    public Integer getOpportunitiesSplitPaymentCount() {
//        return vertic_Utils.objects.defaultIfNull();
//    }
}