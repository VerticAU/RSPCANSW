global without sharing class UpdateAccountsBatch implements Database.Batchable<SObject> {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Account.SObjectType);
        Set<String> fields = Account.SObjectType.getDescribe().fields.getMap().keySet().clone();
        queryFactory.selectFields(fields);
        queryFactory.setCondition('BillingCity != \'\' AND BillingPostalCode != \'\' AND LGA__c = \'\' ');
        return Database.getQueryLocator(queryFactory.toSOQL());
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        updateAccounts(scope);
    }

    global void finish(Database.BatchableContext BC) {
    }

    global static void updateAccounts(List<Account> accounts) {

        Set<String> cityValues = vertic_Utils.sObjects.getStringFieldValues(accounts, 'BillingCity');
        Set<String> postcodeValues = vertic_Utils.sObjects.getStringFieldValues(accounts, 'BillingPostalCode');

        List<Postcode__c> postcodes = [
            SELECT Suburb__c, Postcode__c, LGA__c
            FROM Postcode__c
            WHERE Suburb__c IN :cityValues AND Postcode__c IN :postcodeValues AND LGA__c != '' AND Suburb__c != '' AND Postcode__c != ''
        ];

        for(Account account: accounts){
            for(Postcode__c postcode: postcodes){
                if(account.BillingCity == postcode.Suburb__c && account.BillingPostalCode == postcode.Postcode__c){
                    account.LGA__c = postcode.LGA__c;
                    continue;
                }
            }
        }

        update accounts;

    }
}