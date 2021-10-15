public class OpportunitySplitPaymentsTableCtrl {

    Opportunity opportunity;
    List<Opportunity> opportunitiesSplitPayment;

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
        this.opportunity = (Opportunity) vertic_Utils.arrays.firstOrNull([SELECT Id, Receipt_Number_Formula__c, CloseDate, npsp__Primary_Contact__r.Name, npsp__Primary_Contact__r.MailingCity, npsp__Primary_Contact__r.MailingCountry, npsp__Primary_Contact__r.MailingStreet, npsp__Primary_Contact__r.MailingState, npsp__Primary_Contact__r.MailingPostalCode
                                                                            FROM Opportunity
                                                                            WHERE Id = :this.opportunityId]);

        this.opportunitiesSplitPayment = (List<Opportunity>) [SELECT Id, RecordType.DeveloperName, Amount, RecordType.Name
                                                              FROM Opportunity
                                                              WHERE Parent_Opportunity__c = :this.opportunityId
                                                              AND StageName = 'Closed Won'];
    }

    public Opportunity getOpportunity() {
        return this.opportunity;
    }

    public List<Opportunity> getOpportunitiesSplitPayment() {
        return opportunitiesSplitPayment;
    }

    public Decimal getPaymentTotal() {
        return vertic_Utils.sObjects.sum(this.opportunitiesSplitPayment, 'Amount');
    }

//    public Integer getOpportunitiesSplitPaymentCount() {
//        return vertic_Utils.objects.defaultIfNull();
//    }
}