public without sharing class ReservationDomain extends fflib_SObjectDomain{
    public ReservationDomain(List<Task> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ReservationDomain(sObjectList);
        }
    }

    public override void onBeforeInsert(){
        someMethod(this.Records, null);
    }

    private void someMethod(List<B25__Reservation__c> records, Map<Id, SObject> existingRecords){
        Id outreachEventRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(pmdm__Program__c.SObjectType, 'Outreach Event');
        Set<Id> sessionIds = vertic_Utils.sObjects.getIdFieldValues(records, B25__Reservation__c.Service_Session__c);

//        Map<Id, pmdm__ServiceSession__c> serviceSessionList = new Map<Id, pmdm__ServiceSession__c>([
//            SELECT Id, RecordTypeId
//            FROM pmdm__ServiceSession__c
//            WHERE Id IN :sessionIds
//        ]);

        for(B25__Reservation__c reservation: records){
//            if(reservation.Service_Session__c != null && outreachEventRecordType.equals(serviceSessionList.get(reservation?.Service_Session__c)?.RecordTypeId)){
//
//            }
        }
    }
}