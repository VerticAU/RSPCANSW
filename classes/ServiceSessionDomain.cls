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

    public override void onAfterInsert() {
        populateProgramEngagementForEducation(this.Records, null);
    }

    private void populateProgramEngagementForEducation(List<pmdm__ServiceSession__c> records, Map<Id, SObject> existingRecords){
        Id educationRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(pmdm__Program__c.SObjectType, 'Education');
        Set<Id> programIds = vertic_Utils.sObjects.getIdFieldValues(records, pmdm__ServiceSession__c.Program__c);

        Map<Id, pmdm__Program__c> programs = new Map<Id, pmdm__Program__c>([
            SELECT Id, RecordTypeId, Default_Price_Book__c
            FROM pmdm__Program__c
            WHERE Id IN :programIds
        ]);

        List<pmdm__ProgramEngagement__c> programEngagements = new List<pmdm__ProgramEngagement__c>();

        for(pmdm__ServiceSession__c serviceSession : records){
            if(educationRecordType.equals(programs.get(serviceSession.Program__c).RecordTypeId)) {
                pmdm__ProgramEngagement__c programEngagement = new pmdm__ProgramEngagement__c();
                programEngagement.Service_Session__c = serviceSession.Id;
                programEngagement.pmdm__Program__c = serviceSession.Program__c;
                programEngagement.pmdm__StartDate__c = serviceSession?.pmdm__SessionStart__c?.date();
                programEngagement.pmdm__EndDate__c = serviceSession?.pmdm__SessionEnd__c?.date();
                programEngagement.Price_Book__c = programs.get(serviceSession.Program__c)?.Default_Price_Book__c;
                programEngagement.pmdm__Stage__c = 'Active';
                //programEngagement.Name = serviceSession.Primary_Service_Organisation__r.Name != null ? serviceSession.Primary_Service_Organisation__r.Name + ' ' : '' + serviceSession.pmdm__SessionStart__c != null ? serviceSession.pmdm__SessionStart__c : '';
                if(''.equals(programEngagement.Name)){
                    programEngagement.pmdm__AutoName_Override__c = true;// string.valueof
                }
                programEngagements.add(programEngagement);
            }
        }

        insert programEngagements;
    }
}