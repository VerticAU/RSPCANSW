public without sharing class EzidebitGetAdjustmentsScheduledProc extends vertic_ScheduledProc {

    /**
     * ==============================================================================================================
     *                                              SCHEDULED PROC OVERRIDES
     * ==============================================================================================================
     */

    public override String getScheduledJobName() {
        return 'EziDebit Get Adjustments Payments - Every Day at 10AM';
    }

    public override String getScheduledCRON() {
        return '0 0 9 * * ? *'; // Every Day at 10AM
    }

    public override Type getScheduledProcType() {
        return EzidebitGetAdjustmentsScheduledProc.class;
    }

    public override Boolean isQueueable() {
        return true;
    }

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        if ('true'.equalsIgnoreCase(vertic_SettingService.getValue('EZIDEBIT_PROCESSING_DISABLED'))) {
            return this.response;
        }

        List<EzidebitStructs.Payment> payments = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        ).getPayments(
            'ALL',
            'DR',
            'ADJ',
            null,
            String.valueOf(Date.today().addDays(-1)),
            String.valueOf(Date.today()),
            'SETTLEMENT',
            null,
            null
        );

        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();
        for (EzidebitStructs.Payment payment : payments) {
            Vertic_Async_Process__c vap = vertic_AsyncProcess.create(
                EzidebitGetPaymentDetailsProc.class,
                new Map<String, Object>{
                    'recordId' => payment.PaymentReference
                }
            );
            vap.Description__c = 'Adjustment';
            vap.Group_Key__c = 'EziDebit-' + payment.PaymentReference;
            asyncProcess.add(vap);
        }
        asyncProcess.enqueue();

        return this.response;
    }

}