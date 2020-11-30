public without sharing class EzidebitCreateScheduleBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {

    public Database.QueryLocator start(Database.BatchableContext context) {
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Direct_Debit_Schedule__c.SObjectType);
        queryFactory.selectFields(Direct_Debit_Schedule__c.SObjectType.getDescribe().fields.getMap().keySet().clone());
        List<String> conditions = new List<String> {
            'Status__c IN (\'Pending\', \'Under Review\')',
            'EziDebit_Customer_ID__c != NULL'
        };
        queryFactory.setCondition(String.join(conditions, ' AND '));
        return Database.getQueryLocator(queryFactory.toSOQL());
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (Direct_Debit_Schedule__c record : (List<Direct_Debit_Schedule__c>) scope) {
            Vertic_Async_Process__c vap = vertic_AsyncProcess.create(
                EzidebitCreateScheduleProc.class,
                new Map<String, Object>{
                    'recordId' => record.Id
                }
            );
            vap.Description__c = 'Pending'.equals(record.Status__c) ? 'Create Schedule' : 'Activate Customer';
            vap.Group_Key__c = 'Schedule-' + record.Id;
            asyncProcess.add(vap);
        }
        asyncProcess.enqueue();
    }

    public void finish(Database.BatchableContext context) {
    }
}