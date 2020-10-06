public without sharing class EzidebitGetPaymentsScheduleProc extends vertic_ScheduledProc {
    /**
       * ==============================================================================================================
       *                                              SCHEDULER METHODS
       * ==============================================================================================================
       */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        Database.executeBatch(new EzidebitGetPaymentsBatch(), 1);

        return this.response;
    }

    public override String getScheduledJobName() {
        return 'Ezidebit Get Payments - Every Day at 8 PM';
    }

    public override String getScheduledCRON() {
        return '0 0 20 1/1 * ? *'; //Every Day at 8 PM
    }

    public override Type getScheduledProcType() {
        return EzidebitGetPaymentsScheduleProc.class;
    }

    public override Boolean isQueueable() {
        return true;
    }

    /**
     * ==============================================================================================================
     *                                             BATCH INIT
     * ==============================================================================================================
     */

}