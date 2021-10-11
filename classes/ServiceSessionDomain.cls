public without sharing class ServiceSessionDomain extends fflib_SObjectDomain{
    public ServiceSessionDomain(List<Task> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ServiceSessionDomain(sObjectList);
        }
    }

    public override void onBeforeInsert() {
        populateProgramEngagementForEducation(this.Records, null);
    }

    private void populateProgramEngagementForEducation(List<pmdm__ServiceSession__c> records, List<pmdm__ServiceSession__c> existingRecords){
        Id educationRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(pmdm__ServiceSession__c.SObjectType, 'Education');
        Set<Id> programIds = vertic_Utils.sObjects.getIdFieldValues(records, pmdm__ServiceSession__c.Program__c);
        List<Program__c> programs = [
            SELECT Id
            FROM Program__c
            WHERE Id IN :programIds
        ];

        for(pmdm__ServiceSession__c serviceSession : records){

        }
    }
}