public without sharing class TaskUpdateScheduledProc extends vertic_ScheduledProc {

    /**
       * ==============================================================================================================
       *                                              SCHEDULER METHODS
       * ==============================================================================================================
       */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        List<Task> tasks = new List<Task>([SELECT Id FROM Task WHERE Owner.Name = 'Vertic Developer' AND CreatedDate = TODAY AND Group_Name__c != NULL LIMIT 5000]);
        update tasks;

        return this.response;
    }

    public override String getScheduledJobName() {
        return 'Update Tasks for reassign to QUEUE - Every Day at 1 AM';
    }

    public override String getScheduledCRON() {
        return '0 0 1 * * ? *'; //Every Day at 1 AM
    }

    public override Type getScheduledProcType() {
        return TaskUpdateScheduledProc.class;
    }

    public override Boolean isQueueable() {
        return true;
    }
}