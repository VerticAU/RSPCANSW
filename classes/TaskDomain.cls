public without sharing class TaskDomain extends fflib_SObjectDomain {

    public TaskDomain(List<Task> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new TaskDomain(sObjectList);
        }
    }


    public override void onBeforeInsert() {
        new WOrkflowCreateTasksProc().process(new vertic_Request(new Map<String, Object>{
            'records' => Records
        }));
    }

    public override void onAfterInsert() {

    }


    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {

    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        new WorkflowUpdateTasksProc().process(new vertic_Request(new Map<String, Object>{
            'records' => Records,
            'existingRecords' => existingRecords
        }));
    }


    public override void onBeforeDelete() {
        new WorkflowDeleteTasksProc().process(new vertic_Request(new Map<String, Object>{
            'records' => Records
        }));
    }

    public override void onAfterDelete() {


    }


}