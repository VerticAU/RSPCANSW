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
        //someMethod(this.Records, null);
    }

    public override void onAfterInsert(){
        someMethod(this.Records, null);
    }

    private void someMethod(List<B25__Reservation__c> records, Map<Id, SObject> existingRecords){
        Id outreachEventRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(pmdm__ServiceSession__c.SObjectType, 'Outreach Event');
        Set<Id> sessionIds = vertic_Utils.sObjects.getIdFieldValues(records, B25__Reservation__c.Service_Session__c);
        Set<Id> reservationTypeIds = vertic_Utils.sObjects.getIdFieldValues(records, B25__Reservation__c.B25__Reservation_Type__c);

        Map<Id, B25__Reservation_Type__c>  reservationTypeList = new Map<Id, B25__Reservation_Type__c>([
            SELECT Id, Name
            FROM B25__Reservation_Type__c
            WHERE Id IN :reservationTypeIds
        ]);

        Map<Id, pmdm__ServiceSession__c> serviceSessionList = new Map<Id, pmdm__ServiceSession__c>([
            SELECT Id, RecordTypeId
            FROM pmdm__ServiceSession__c
            WHERE Id IN :sessionIds
        ]);

        Map<Id,pmdm__ServiceDelivery__c> serviceDeliveryList = new Map<Id,pmdm__ServiceDelivery__c>([
            SELECT Id, Reservation__c
            FROM pmdm__ServiceDelivery__c
            WHERE Reservation__c IN :records
        ]);

        Map<B25__Reservation__c, Map<Id, pmdm__ServiceDelivery__c>> reservationServiceDeliveryMap = new Map<B25__Reservation__c, Map<Id, pmdm__ServiceDelivery__c>>();

        for(B25__Reservation__c reservation: records){
            if(reservation.Service_Session__c != null && outreachEventRecordType.equals(serviceSessionList.get(reservation?.Service_Session__c)?.RecordTypeId)
                && ((reservationTypeList.get(reservation.B25__Reservation_Type__c)?.Name == 'Partner' || reservationTypeList.get(reservation.B25__Reservation_Type__c)?.Name == 'RSPCA Staff'))){
                if(reservation.Create_Program_Engagement__c == true){

                    System.debug(reservation.Service_Delivery__r);
//                    pmdm__ProgramEngagement__c programEngagement = new pmdm__ProgramEngagement__c();
//                    programEngagement.pmdm__Program__c = hui;
                }
            }
        }
    }
}