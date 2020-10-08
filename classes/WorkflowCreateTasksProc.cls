public class WorkflowCreateTasksProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    private List<Task> records;
    private Map<String, List<String>> groupMemberMap = new Map<String, List<String>>();
    private Map<String, SObject> whatAndWhoIdsBySObjectMap = new Map<String, SObject>();
    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType>{
        Task.SObjectType
    });

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.mapSObject();


        fflib_SObjectDomain.getTriggerEvent(TaskDomain.class).disableBeforeInsert();
        uow.commitWork();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void mapSObject() {
        vertic_DTO payload = new vertic_DTO();
        this.records = (List<Task>) this.request.get('records');
        System.debug('this.records:  ' + this.records);
        this.groupMemberMap = WorkflowService.findUsersByGroups();
        System.debug('this.groupMemberMap ' + this.groupMemberMap);

        Set<Id> whoAndWhatIds = vertic_Utils.sObjects.getIdFieldValues(this.records, Task.WhatId);
        whoAndWhatIds.addAll(vertic_Utils.sObjects.getIdFieldValues(this.records, Task.WhoId));

        this.whatAndWhoIdsBySObjectMap = this.findWhoId(whoAndWhatIds);

        for (Task task : this.records) {


            try {
                payload = new vertic_DTO(task.Description);
                System.debug('1 payload ' + payload);
                vertic_AutoMapper autoMapper = new vertic_AutoMapper(payload.getMap());
                autoMapper.mapToSObject(task);
            } catch (Exception ex) {
                System.debug('can\'t parse: err');
            }
        }

        for (Task task : this.records) {
            try {
                payload = new vertic_DTO(task.Description);
                vertic_AutoMapper autoMapper = new vertic_AutoMapper(payload.getMap());
                autoMapper.mapToSObject(task);
            } catch (Exception ex) {
            }

            this.setWhatAndWhoIds(task, payload);
            System.debug('before - task.ActivityDate: ' + task.ActivityDate);
            task.ActivityDate = task.Activity_Days__c == null ? task.ActivityDate : WorkflowService.calcActivityDate(Integer.valueOf(task.Activity_Days__c));
            System.debug('after - task.ActivityDate: ' + task.ActivityDate);

            if (task.Group_Key__c == null && String.isNotBlank(task.Group_Name__c) && this.groupMemberMap.containsKey(task.Group_Name__c)) {

                task.Group_Key__c = vertic_Utils.strings.newGuid();

                List<String> userIds = this.groupMemberMap.get(task.Group_Name__c).clone();

                if (userIds.size() > 0) {
                    task.OwnerId = userIds.remove(0);
                }

                for (String userId : userIds) {
                    Task newTask = task.clone(false, true);
                    newTask.OwnerId = userId;
                    this.uow.registerNew(newTask);
                    System.debug('newTask: ' + newTask);
                }

            }
        }
    }

    private Map<String, SObject> findWhoId(Set<Id> Ids) {
        Map<String, SObject> sObjectsByIds = new Map<String, SObject>();
        for (Id idVar : Ids) {

            fflib_QueryFactory queryFactory;
            queryFactory = new fflib_QueryFactory(idVar.getSobjectType());
            queryFactory.selectFields(idVar.getSobjectType().getDescribe().fields.getMap().keySet());
            queryFactory.setCondition('Id = :idVar');
            System.debug('2 queryFactory= ' + queryFactory);

            sObjectsByIds.put(idVar, Database.query(queryFactory.toSOQL()));
        }
        System.debug(sObjectsByIds);
        return sObjectsByIds;
    }


    private void setWhatAndWhoIds(Task task, vertic_DTO payload) {

        System.debug('before changes: ');
        System.debug('task.WhatId: ' + task.WhatId);
        System.debug('task.Skip_WhatId__c: ' + task.Skip_WhatId__c);
        System.debug('task.WhoId: ' + task.WhoId);
        System.debug('task: ' + task);
        System.debug('payload: ' + payload);
        if (task.WhatId != null && task.Skip_WhoId__c == false && payload.has('WhoId_Field')) {
            task.WhoId = (Id) ((SObject) this.whatAndWhoIdsBySObjectMap.get(task.WhatId)).get(payload.getString('WhoId_Field'));
        } else if (task.WhoId != null && task.Skip_WhatId__c == false && payload.has('WhatId_Field')) {
            task.WhatId = (Id) ((SObject) this.whatAndWhoIdsBySObjectMap.get(task.WhoId)).get(payload.getString('WhatId_Field'));
        }
        System.debug('after changes: ');
        System.debug('task.WhatId: ' + task.WhatId);
        System.debug('task.WhoId: ' + task.WhoId);
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