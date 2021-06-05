public without sharing class OpportunityDomain extends fflib_SObjectDomain {

    public OpportunityDomain(List<Task> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new OpportunityDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        this.populateCampaignFromRD(this.Records);
    }
    public override void onAfterInsert() {}

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        this.populateCampaignFromRD(this.Records);

        MembershipService.sendMembershipReceipts(
            MembershipService.filterAcknowledgementNowMemberships(this.Records)
        );
        MembershipService.sendMembershipRenewalReceipts(
            MembershipService.filterRenewalNowMemberships(this.Records, (Map<Id, Opportunity>) existingRecords)
        );
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        MembershipService.updateActiveMembership(
            MembershipService.filterEnrolledMemberships(this.Records, (Map<Id, Opportunity>) existingRecords)
        );
    }

    public override void onBeforeDelete() {}
    public override void onAfterDelete() {}

    private void populateCampaignFromRD(List<Opportunity> opportunities){
        Map<Id, Opportunity> opportunitiesWithRDMap = new Map<Id, Opportunity>([
            SELECT Id, npe03__Recurring_Donation__c, npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c
            FROM Opportunity
            WHERE npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c != NULL
            AND Created_By_Recurring_Donation__c = TRUE
            AND CampaignId = NULL
            AND Id IN: vertic_Utils.sObjects.getStringFieldValues(opportunities, 'Id')
        ]);

        for(Opportunity opp: opportunities){
            if(opp.CampaignId == null && opportunitiesWithRDMap.containsKey(opp.Id)){
                Opportunity oppWithRD = opportunitiesWithRDMap.get(opp.Id);
                if(oppWithRD != null && oppWithRD.npe03__Recurring_Donation__c != null){
                    opp.CampaignId = oppWithRD.npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c;
                }
            }
        }
    }
}