global without sharing class vertic_UpdateRecordsBatch implements Database.Batchable<SObject> {
    private SObjectType sObjectType;
    private List<String> conditions = new List<String>();
    private Map<Id, SObject> recordsMap = new Map<Id, SObject>();
    private Boolean optAllOrNone = true;
    private Set<Type> disabledDomains = new Set<Type>();

    global vertic_UpdateRecordsBatch(SObjectType sObjectType) {
        this(sObjectType, '');
    }

    global vertic_UpdateRecordsBatch(SObjectType sObjectType, String condition) {
        this(sObjectType, String.isNotBlank(condition) ? new List<String>{
            condition
        } : new List<String>());
    }

    global vertic_UpdateRecordsBatch(SObjectType sObjectType, List<String> conditions) {
        this(sObjectType, new Map<Id, SObject>(), conditions);
    }

    global vertic_UpdateRecordsBatch(Map<Id, SObject> recordsMap) {
        this(recordsMap, null);
    }

    global vertic_UpdateRecordsBatch(Map<Id, SObject> recordsMap, List<String> conditions) {
        this(recordsMap != null && recordsMap.size() > 0 ? recordsMap.values().get(0).getSObjectType() : null, recordsMap, conditions);
    }

    global vertic_UpdateRecordsBatch(SObjectType sObjectType, Map<Id, SObject> recordsMap, List<String> conditions) {
        this.sObjectType = sObjectType;
        this.conditions = conditions == null ? new List<String>() : conditions;
        this.recordsMap = recordsMap;
        if (recordsMap != null && recordsMap.size() > 0) {
            Set<String> ids = vertic_Utils.sObjects.getStringFieldValues(recordsMap.values(), 'Id');
            this.conditions.add('Id IN (\'' + String.join(new List<String>(ids), '\', \'') + '\')');
        }

        if (this.sObjectType == null) {
            throw new vertic_Structs.InitException('SObjectType is required.');
        }
    }

    /**
     * ==============================================================================================================
     *                                             EXECUTE
     * ==============================================================================================================
     */


    global void run() {
        Database.executeBatch(this);
    }

    global void run(Integer batchSize) {
        Database.executeBatch(this, batchSize);
    }

    /**
     * ==============================================================================================================
     *                                        BATCHABLE METHODS
     * ==============================================================================================================
     */

    global Database.QueryLocator start(Database.BatchableContext BC) {
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(this.sObjectType);
        if (this.conditions != null && this.conditions.size() > 0) {
            queryFactory.setCondition(String.join(this.conditions, ' AND '));
        }
        return Database.getQueryLocator(queryFactory.toSOQL());
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        try {

            if (this.disabledDomains != null) {
                for (Type domainTypeVar : this.disabledDomains) {
                    fflib_SObjectDomain.getTriggerEvent(domainTypeVar).disableAll();
                }
            }

            Map<Id, SObject> recordsToUpdate = new Map<Id, SObject>();
            for (SObject sObj : scope) {
                if (this.recordsMap != null && this.recordsMap.containsKey(sObj.Id)) {
                    SObject record = this.recordsMap.get(sObj.Id);
                    recordsToUpdate.put(record.Id, record);
                } else {
                    recordsToUpdate.put(sObj.Id, sObj);
                }
            }

            Database.DMLOptions dmlOptions = new Database.DMLOptions();
            dmlOptions.OptAllOrNone = this.optAllOrNone;
            dmlOptions.AllowFieldTruncation = true;

            List<Database.SaveResult> saveResults = Database.update(recordsToUpdate.values(), dmlOptions);
            for (Database.SaveResult saveResult : saveResults) {
                if (!saveResult.isSuccess()) {
                    System.debug(saveResult);
                    hey.Logger.debug(saveResult);
                }
            }

        } catch (Exception ex) {
            hey.Logger.exception(ex);
            throw ex;
        } finally {
            hey.Logger.publish();
        }
    }

    global void finish(Database.BatchableContext BC) {}

    /**
     * ==============================================================================================================
     *                                             SETTERS
     * ==============================================================================================================
     */

    global vertic_UpdateRecordsBatch setDisabledDomains(Set<Type> disabledDomains) {
        this.disabledDomains = disabledDomains;
        return this;
    }

    global vertic_UpdateRecordsBatch addDisabledDomain(Type disabledDomain) {
        this.disabledDomains = this.disabledDomains != null ? this.disabledDomains : new Set<Type>();
        this.disabledDomains.add(disabledDomain);
        return this;
    }

    global vertic_UpdateRecordsBatch setOptAllOrNone(Boolean optAllOrNone) {
        this.optAllOrNone = optAllOrNone == true;
        return this;
    }

    global vertic_UpdateRecordsBatch setConditions(List<String> conditions) {
        this.conditions = conditions;
        return this;
    }

    global vertic_UpdateRecordsBatch addCondition(String condition) {
        this.conditions = this.conditions != null ? this.conditions : new List<String>();
        this.conditions.add(condition);
        return this;
    }
}