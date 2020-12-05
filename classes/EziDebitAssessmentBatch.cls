global class EziDebitAssessmentBatch implements Database.Batchable<SObject>, Database.AllowsCallouts, Database.Stateful {

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id FROM Contact WHERE LastName LIKE \'EziDebit%\' AND Id NOT IN (SELECT npe03__Contact__c FROM npe03__Recurring_Donation__c)');
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        List<npe03__Recurring_Donation__c> recDons = new List<npe03__Recurring_Donation__c>();
        for (SObject record : scope) {
            recDons.add(new npe03__Recurring_Donation__c(
                npsp__PaymentMethod__c = 'EziDebit',
                npe03__Installment_Period__c = 'Monthly',
                npsp__InstallmentFrequency__c = 1,
                npsp__Status__c = 'Active',
                npe03__Date_Established__c = Date.today(),
                npsp__Day_of_Month__c = '4',
                npe03__Amount__c = 4,
                Account_Number__c = '1234',
                BSB__c = '064001',
                Account_Name__c = 'EziDebit Test ' + BC.getChildJobId(),
                Bank_Name__c = 'EziDebit Test ' + BC.getChildJobId(),
                Name = 'EziDebit Test ' + BC.getChildJobId(),
                npe03__Contact__c = record.Id
            ));
        }
        insert recDons;
    }

    global void finish(Database.BatchableContext BC) {
    }

}