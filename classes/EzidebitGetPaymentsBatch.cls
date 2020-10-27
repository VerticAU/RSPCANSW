public class EzidebitGetPaymentsBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Contact WHERE BPAY_CRN__c != NULL');
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        new EzidebitGetPaymentsProc().process(new vertic_Request(new Map<String, Object>{
            'recordId' => scope[0].Id
        }));
    }

    public void finish(Database.BatchableContext context) {
        System.debug('EzidebitGetPaymentsBatch finished!');
    }

}