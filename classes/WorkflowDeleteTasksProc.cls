public class WorkflowDeleteTasksProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {


    /**
    * ==============================================================================================================
    *                                              PROCESS
    * ==============================================================================================================
    */

    private List<String> deletedTaskIds = new List<String>();
    private List<String> groupKeys = new List<String>();

    public override vertic_Response process(vertic_Request request) {

        this.request = request;

        this.mapSObject();
        this.deleteTasks();

        return this.response;
    }

    private void mapSObject() {
        for (Task task : (List<Task>) this.request.getList('records')) {
            if (task.Group_Key__c != null) {
                this.deletedTaskIds.add(task.Id);
                this.groupKeys.add(task.Group_Key__c);
            }
        }
    }

    private void deleteTasks() {
        List<Task> tasksToDelete = new List<Task>([
            SELECT Id
            FROM Task
            WHERE Group_Key__c IN :this.groupKeys AND Id NOT IN :this.deletedTaskIds
        ]);

        fflib_SObjectDomain.getTriggerEvent(TaskDomain.class).disableAll();

        System.debug('tasksToDelete: ' + tasksToDelete);
        delete tasksToDelete;
    }
}