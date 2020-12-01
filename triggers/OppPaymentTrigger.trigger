trigger OppPaymentTrigger on npe01__OppPayment__c (before insert, before update, before delete, after insert, after update, after delete) {
    fflib_SObjectDomain.triggerHandler(OppPaymentDomain.class);
}