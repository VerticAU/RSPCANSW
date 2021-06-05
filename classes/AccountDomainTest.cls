@IsTest
public class AccountDomainTest {
    @IsTest static void testLGA(){
        LGA__c lga1 = new LGA__c(
            Name = 'Test'
        );
        insert lga1;

        LGA__c lga2 = new LGA__c(
            Name = 'Test'
        );
        insert lga2;

        Postcode__c postcode1 = new Postcode__c(
            Postcode__c = '1111',
            Suburb__c = 'Test',
            LGA__c = lga1.Id
        );
        insert postcode1;

        Postcode__c postcode2 = new Postcode__c(
            Postcode__c = '2222',
            Suburb__c = 'Test',
            LGA__c = lga2.Id
        );
        insert postcode2;

        Account account = new Account(
            Name = 'Test',
            BillingCity = 'Test',
            BillingPostalCode = '1111'
        );
        insert account;

        System.assertEquals(lga1.Id, [SELECT Id, LGA__c FROM Account WHERE Id =: account.Id].LGA__c);

        account.BillingPostalCode = '2222';
        update account;

        System.assertEquals(lga2.Id, [SELECT Id, LGA__c FROM Account WHERE Id =: account.Id].LGA__c);
    }
}