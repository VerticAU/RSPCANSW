public without sharing class EzidebitGetDDPaymentsScheduledProc extends vertic_ScheduledProc implements Database.Batchable<SObject>, Database.AllowsCallouts {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Set<Id> recordIds;

    public EzidebitGetDDPaymentsScheduledProc() {

    }
    public EzidebitGetDDPaymentsScheduledProc(Set<Id> recordIds) {
        this.recordIds = recordIds;
    }

    /**
     * ==============================================================================================================
     *                                              SCHEDULED PROC OVERRIDES
     * ==============================================================================================================
     */

    public override String getScheduledJobName() {
        return 'EziDebit Get Scheduled Payments - Every Day at 9AM and 4PM';
    }

    public override String getScheduledCRON() {
        return '0 0 9,16 * * ? *'; // Every Day at 9AM and 4PM
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
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(npe01__OppPayment__c.SObjectType);
        queryFactory.selectFields(npe01__OppPayment__c.SObjectType.getDescribe().fields.getMap().keySet().clone());
        List<String> conditions = new List<String>{
            'npe01__Payment_Method__c = \'EziDebit\'',
            'npsp_plus__Status__c = \'Pending\'',
            'EziDebit_Transaction_ID__c != NULL'
        };
        if (this.recordIds != null && this.recordIds.size() > 0) {
            conditions = new List<String> {'Id IN :recordIds'};
        }
        queryFactory.setCondition(String.join(conditions, ' AND '));
        return Database.getQueryLocator(queryFactory.toSOQL());
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (SObject record : scope) {
            Vertic_Async_Process__c vap = vertic_AsyncProcess.create(
                EzidebitGetPaymentDetailsProc.class,
                new Map<String, Object>{
                    'recordId' => record.Id
                }
            );
            vap.Description__c = 'Status Sync';
            vap.Group_Key__c = 'EziDebit-' + record.Id;
            asyncProcess.add(vap);
        }
        asyncProcess.enqueue();
    }

    public void finish(Database.BatchableContext context) {
    }

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        if (!'true'.equalsIgnoreCase(vertic_SettingService.getValue('EZIDEBIT_PROCESSING_DISABLED'))) {
            this.response.put('apexJobId', Database.executeBatch(this));
        }

        return this.response;
    }

}