trigger ServiceSessionTrigger on pmdm__ServiceSession__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    fflib_SObjectDomain.triggerHandler(ServiceSessionDomain.class);
}