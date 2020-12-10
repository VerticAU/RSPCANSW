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
        this.afterAction(new Map<Id, SObject>());
    }
    
    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {}
    
    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        this.afterAction(existingRecords);
    }

    private void afterAction(Map<Id, SObject> existingRecords) {
        Set<Id> opportunityIds = vertic_Utils.sObjects.getIdFieldValues(Records, npe01__OppPayment__c.npe01__Opportunity__c);
        Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>([
            SELECT
                StageName,
                npsp__Primary_Contact__c,
                npe03__Recurring_Donation__c
            FROM Opportunity
            WHERE Id IN :opportunityIds
        ]);

        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (npe01__OppPayment__c payment : (List<npe01__OppPayment__c>) Records) {
            Opportunity opportunityVar = opportunitiesByIds.get(payment.npe01__Opportunity__c);

            npe01__OppPayment__c existingPayment = (npe01__OppPayment__c) existingRecords.get(payment.Id);

            if (existingPayment == null || vertic_Utils.sObjects.isSomeFieldChanged(payment, existingPayment, new List<SObjectField> {
                npe01__OppPayment__c.EziDebit_Transaction_ID__c,
                npe01__OppPayment__c.npe01__Payment_Method__c
            })) {
                initEziDebitPayment(asyncProcess, payment, opportunityVar);
            }
        }
        asyncProcess.enqueue();
    }

    private static void initEziDebitPayment(vertic_AsyncProcess asyncProcess, npe01__OppPayment__c payment, Opportunity opportunityVar) {
        if (EzidebitAddBankDebitProc.shouldBeProcessed(payment, opportunityVar)) {
            Vertic_Async_Process__c vap = vertic_AsyncProcess.create(
                EzidebitAddBankDebitProc.class,
                new Map<String, Object>{
                    'recordId' => payment.Id
                }
            );
            vap.Description__c = 'Payment Request';
            vap.Group_Key__c = 'EziDebit-' + payment.Id;
            if (payment.npe01__Scheduled_Date__c != null && payment.npe01__Scheduled_Date__c > Date.today()) {
                vap.Run_After__c = payment.npe01__Scheduled_Date__c;
            }
            asyncProcess.add(vap);
        }
    }

}