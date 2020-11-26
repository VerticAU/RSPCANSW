public without sharing class EzidebitGetDDPaymentsScheduledProc extends vertic_ScheduledProc implements Database.Batchable<SObject>, Database.AllowsCallouts {

    /**
     * ==============================================================================================================
     *                                              SCHEDULED PROC OVERRIDES
     * ==============================================================================================================
     */

    public override String getScheduledJobName() {
        return 'EziDebit Get Scheduled Payments - Every Day at 8 PM';
    }

    public override String getScheduledCRON() {
        return '0 0 20 1/1 * ? *'; // Every Day at 8 PM
    }

    public override Type getScheduledProcType() {
        return EzidebitGetDDPaymentsScheduledProc.class;
    }

    public override Boolean isQueueable() {
        return true;
    }

    /**
     * ==============================================================================================================
     *                                              BATCHABLE OVERRIDES
     * ==============================================================================================================
     */

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id FROM Direct_Debit_Schedule__c WHERE Status__c = \'Active\' AND EziDebit_Customer_ID__c != null');
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        new EzidebitGetDDPaymentsProc().process(new vertic_Request(new Map<String, Object>{
            'recordId' => scope[0].Id
        }));
    }

    public void finish(Database.BatchableContext context) {
        System.debug('EzidebitGetScheduledPaymentsScheduleProc finished!');
    }

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.response.put('apexJobId', Database.executeBatch(this, 1));

        return this.response;
    }

}