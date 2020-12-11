global without sharing class MigrateContactIdBatchScript implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Contact_ID__c, External_ID__c FROM Contact');
    }

    global void execute(Database.BatchableContext BC, List<Contact> scope) {
        for(Contact contact : scope){
//            contact.Contact_ID__c = contact.External_ID__c;
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC) {
        System.debug('MigrateContactIdBatchScript finished!');
    }
}