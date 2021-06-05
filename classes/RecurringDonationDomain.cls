public without sharing class RecurringDonationDomain extends fflib_SObjectDomain implements fflib_ISObjectDomain {

    public RecurringDonationDomain(List<npe03__Recurring_Donation__c> sObjectList) {
        super(sObjectList);
        this.Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new RecurringDonationDomain(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {}
    
    public override void onAfterInsert() {}

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        setSetTemporaryPreviousOpportunityAmount(Records, existingRecords);
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (npe03__Recurring_Donation__c recurringDonation : (List<npe03__Recurring_Donation__c>) Records) {
            npe03__Recurring_Donation__c existingRecord = (npe03__Recurring_Donation__c) existingRecords.get(recurringDonation.Id);
            if (!'Active'.equals(recurringDonation.npsp__Status__c) && 'Active'.equals(existingRecord.npsp__Status__c) && String.isNotBlank(recurringDonation.EziDebit_Customer_ID__c)) {
                Vertic_Async_Process__c vap = vertic_AsyncProcess.create(
                    EzidebitChangeCustomerStatusProc.class,
                    new Map<String, Object>{
                        'recordId' => recurringDonation.Id
                    }
                );
                vap.Description__c = 'Cancel Customer';
                vap.Group_Key__c = 'EziDebit-' + recurringDonation.Id;
                asyncProcess.add(vap);
            }
        }
        if (System.isBatch() || System.isQueueable()) {
            asyncProcess.enqueue();
        } else {
            asyncProcess.enqueueAndRun();
        }

        this.populateCampaignFromRD(this.Records);
    }

    private static void setSetTemporaryPreviousOpportunityAmount(List<npe03__Recurring_Donation__c> recurringDonations, Map<Id, SObject> existingRecords) {
        for (npe03__Recurring_Donation__c recurringDonationVar : recurringDonations) {
            npe03__Recurring_Donation__c existingRD = (npe03__Recurring_Donation__c) existingRecords.get(recurringDonationVar.Id);
            if (recurringDonationVar.npe03__Amount__c != existingRD.npe03__Amount__c) {
                recurringDonationVar.Previous_Opportunity_Amount__c = recurringDonationVar.npe03__Amount__c;
            }
        }
    }

    private void populateCampaignFromRD(List<npe03__Recurring_Donation__c> recurringDonations){
        List<Opportunity> opportunities = [
            SELECT Id, CampaignId, npe03__Recurring_Donation__c, npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c
            FROM Opportunity
            WHERE npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c != NULL
            AND Created_By_Recurring_Donation__c = TRUE
            AND CampaignId = NULL
            AND npe03__Recurring_Donation__c IN: vertic_Utils.sObjects.getStringFieldValues(recurringDonations, 'Id')
        ];

        for(Opportunity opp: opportunities){
            opp.CampaignId = opp.npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c;
        }
        update opportunities;
    }
}