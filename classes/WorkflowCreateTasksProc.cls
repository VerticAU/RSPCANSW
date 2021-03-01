public without sharing class WorkflowCreateTasksProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    private List<Task> records;
    private Map<String, SObject> whatAndWhoIdsBySObjectMap = new Map<String, SObject>();

    public override vertic_Response process(vertic_Request request) {
        this.request = request;
        this.mapSObject();

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

        Set<Id> whoAndWhatIds = vertic_Utils.sObjects.getIdFieldValues(this.records, Task.WhatId);
        whoAndWhatIds.addAll(vertic_Utils.sObjects.getIdFieldValues(this.records, Task.WhoId));

        this.whatAndWhoIdsBySObjectMap = this.findWhoId(whoAndWhatIds);

        for (Task task : this.records) {
            try {
                payload = new vertic_DTO(task.Description);
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
            task.ActivityDate = task.Activity_Days__c == null ? task.ActivityDate : WorkflowService.calcActivityDate(Integer.valueOf(task.Activity_Days__c));
            task.Group_Name__c = task.Group_Name__c != null ? task.Group_Name__c.replaceAll(' ', '_') : '';
        }
    }

    private Map<String, SObject> findWhoId(Set<Id> Ids) {
        Map<String, SObject> sObjectsByIds = new Map<String, SObject>();
        for (Id idVar : Ids) {

            fflib_QueryFactory queryFactory;
            queryFactory = new fflib_QueryFactory(idVar.getSobjectType());
            Set<String> objectFields = new Set<String>(idVar.getSobjectType().getDescribe().fields.getMap().keySet());
            for (String field : objectFields) {
                try {
                    queryFactory.selectField(field);
                } catch (Exception e) {
                }
            }
            queryFactory.setCondition('Id = :idVar');
            sObjectsByIds.put(idVar, Database.query(queryFactory.toSOQL()));
        }
        return sObjectsByIds;
    }


    private void setWhatAndWhoIds(Task task, vertic_DTO payload) {
        if (task.WhatId != null && task.Skip_WhoId__c == false && payload.has('WhoId_Field')) {
            task.WhoId = (Id) ((SObject) this.whatAndWhoIdsBySObjectMap.get(task.WhatId)).get(payload.getString('WhoId_Field'));
        } else if (task.WhoId != null && task.Skip_WhatId__c == false && payload.has('WhatId_Field')) {
            task.WhatId = (Id) ((SObject) this.whatAndWhoIdsBySObjectMap.get(task.WhoId)).get(payload.getString('WhatId_Field'));
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