public without sharing class OppPaymentDomain extends fflib_SObjectDomain implements fflib_ISObjectDomain {

    public OppPaymentDomain(List<npe01__OppPayment__c> sObjectList) {
        super(sObjectList);
        this.Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new OppPaymentDomain(sObjectList);
        }
    }
    
    public override void onBeforeInsert() {}
    
    public override void onAfterInsert() {
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (npe01__OppPayment__c payment : (List<npe01__OppPayment__c>) Records) {
            if (payment.npe01__Paid__c != true &&
                'EziDebit'.equals(payment.npe01__Payment_Method__c) &&
                payment.EziDebit_Transaction_ID__c == null) {


            }
        }
        asyncProcess.enqueue();
    }
    
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {}
    
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {}

}