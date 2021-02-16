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
    
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {}
    
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
        asyncProcess.enqueueAndRun();
    }

}