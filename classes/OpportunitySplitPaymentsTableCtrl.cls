public with sharing class OpportunitySplitPaymentsTableCtrl {

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
                npsp__Primary_Contact__r.Name,
                npsp__Primary_Contact__r.MailingCity,
                npsp__Primary_Contact__r.MailingCountry,
                npsp__Primary_Contact__r.MailingStreet,
                npsp__Primary_Contact__r.MailingState,
                npsp__Primary_Contact__r.MailingPostalCode,
                RecordType.Name,
                npsp_plus__Payment_Fees__c
            FROM Opportunity
            WHERE Id = :this.opportunityId
        ]);

        if ('Split Payment'.equalsIgnoreCase(this.oppVar?.RecordType?.Name)) {

            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Total_Amount__c, Amount, RecordType.Name
                FROM Opportunity
                WHERE Parent_Opportunity__c = :this.opportunityId
                AND StageName = 'Closed Won'
            ];

        } else {
            this.opportunitiesInTable = (List<Opportunity>) [
                SELECT Id, RecordType.DeveloperName, Total_Amount__c, Amount, RecordType.Name
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
        Decimal sum = vertic_Utils.sObjects.sum(this.opportunitiesInTable, 'Total_Amount__c');
        if ('Split Payment'.equalsIgnoreCase(this.oppVar?.RecordType?.Name)) {
            return sum + vertic_Utils.objects.defaultIfNull(this.oppVar?.npsp_plus__Payment_Fees__c, 0);
        }
        return sum;
    }

//    public Integer getOpportunitiesSplitPaymentCount() {
//        return vertic_Utils.objects.defaultIfNull();
//    }
}