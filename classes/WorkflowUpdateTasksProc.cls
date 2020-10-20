public class WorkflowUpdateTasksProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    private List<Task> tasks = new List<Task>();
    private Set<Id> taskIds = new Set<Id>();
    private Map<Id, SObject> existingTasks = new Map<Id, SObject>();
    private Map<String, Task> mapGroupKeyToMainTask = new Map<String, Task>();


    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType>{
        Task.SObjectType,
        Opportunity.SObjectType
    });

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.mapSObject();
        this.updateTasks();

        this.checkAdditionConditions();

        fflib_SObjectDomain.getTriggerEvent(TaskDomain.class).disableAfterUpdate();
        fflib_SObjectDomain.getTriggerEvent(TaskDomain.class).disableBeforeUpdate();
        uow.commitWork();
        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void mapSObject() {

        this.tasks = (List<Task>) this.request.getList('records');
        this.existingTasks = (Map<Id, Task>) this.request.get('existingRecords');

        for (Task task : this.tasks) {

            Boolean isUpdated = vertic_Utils.sObjects.isSomeFieldChanged(task, this.existingTasks.get(task.Id), new List<String>{
                'Subject',
                'Depended_Task_Name__c',
                'ActivityDate',
                'Activity_Days__c',
                'Description',
                'Status',
                'Priority',
                'WhatId',
                'WhoId',
                'Type'
            });
            System.debug('1 task.Id ' + task.Id);

            if (isUpdated && task.Group_Key__c != null) {
                System.debug('2 task.Id ' + task.Id);
                this.taskIds.add(task.Id);
                this.mapGroupKeyToMainTask.put(task.Group_Key__c, task);
            }
        }
    }

    private void updateTasks() {

        if (this.taskIds.size() == 0) {
            return;
        }

        for (Task currentTask : new List<Task>([
            SELECT Group_Key__c, OwnerId
            FROM Task
            WHERE Group_Key__c IN :this.mapGroupKeyToMainTask.keySet() AND Id NOT IN :taskIds
        ])) {
            Task clonedTask = mapGroupKeyToMainTask.get(currentTask.Group_Key__c).clone(false, true);
            clonedTask.Id = currentTask.Id;
            clonedTask.OwnerId = currentTask.OwnerId;
            clonedTask.Next_Workflow_Name__c = '';
            uow.registerUpsert(clonedTask);
        }
    }


    private void checkAdditionConditions() {

        Map<String, Task> taskByOppId = new Map<String, Task>();

        for (Task task : this.tasks) {

            Boolean isUpdated = vertic_Utils.sObjects.isSomeFieldChanged(task, this.existingTasks.get(task.Id), new List<String>{
                'Status'
            });

            if (isUpdated && 'Completed'.equals(task.Status) && String.isNotEmpty(task.Depended_Task_Name__c) && String.valueOf(task.WhatId.getSobjectType()).equals('Opportunity')) {
                taskByOppId.put(task.WhatId, task);
            }
        }

        for (Opportunity opportunity : new List<Opportunity>([SELECT Id FROM Opportunity WHERE Id IN :taskByOppId.keySet()])) {
            opportunity.Run_Workflow_Rule_With_Name__c = taskByOppId.get(opportunity.Id).Depended_Task_Name__c;
            uow.registerUpsert(opportunity);
        }
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}