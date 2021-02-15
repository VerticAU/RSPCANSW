trigger RecurringDonationTrigger on npe03__Recurring_Donation__c (before insert, before update, before delete, after insert, after update, after delete) {
    fflib_SObjectDomain.triggerHandler(RecurringDonationDomain.class);
}