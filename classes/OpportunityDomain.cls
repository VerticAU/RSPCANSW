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

    public override void onBeforeInsert() {}
    public override void onAfterInsert() {}

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
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
}