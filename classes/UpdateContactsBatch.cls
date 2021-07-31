global without sharing class UpdateContactsBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        Set<String> fields = Contact.SObjectType.getDescribe().fields.getMap().keySet().clone();
        queryFactory.selectFields(fields);
        queryFactory.setCondition('MailingCity != \'\' AND MailingPostalCode != \'\' AND LGA__c = \'\'');
        return Database.getQueryLocator(queryFactory.toSOQL());
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        updateContacts(scope);
    }

    global void finish(Database.BatchableContext BC) {}

    global static void updateContacts(List<Contact> contacts) {

        Set<String> cityValues = vertic_Utils.sObjects.getStringFieldValues(contacts, 'MailingCity');
        Set<String> postcodeValues = vertic_Utils.sObjects.getStringFieldValues(contacts, 'MailingPostalCode');

        List<Postcode__c> postcodes = [
            SELECT Suburb__c, Postcode__c, LGA__c
            FROM Postcode__c
            WHERE Suburb__c IN :cityValues AND Postcode__c IN :postcodeValues AND LGA__c != '' AND Suburb__c != '' AND Postcode__c != ''
        ];

        for(Contact contact: contacts){
            for(Postcode__c postcode: postcodes){
                if(contact.MailingCity == postcode.Suburb__c && contact.MailingPostalCode == postcode.Postcode__c){
                    contact.LGA__c = postcode.LGA__c;
                    continue;
                }
            }
        }
        update contacts;
    }
}