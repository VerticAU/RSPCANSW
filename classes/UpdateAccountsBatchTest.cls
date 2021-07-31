@IsTest
private class UpdateAccountsBatchTest {

    @IsTest static void test() {
        Account account = new Account(
            Name = 'test',
            BillingCity = '1',
            BillingPostalCode = '1'
        );
        insert account;

        LGA__c lga = new LGA__c(
            Name = '1'
        );
        insert lga;

        Postcode__c postcode = new Postcode__c(
            Suburb__c = '1',
            Postcode__c = '1',
            LGA__c = lga.Id
        );
        insert postcode;

        Test.startTest();
        Database.executeBatch(new UpdateAccountsBatch(), 2000);
        Test.stopTest();

        Account account2 = (Account) vertic_Utils.arrays.firstOrNull([
            SELECT LGA__c FROM Account
        ]);
        System.assertNotEquals(account2.LGA__c, null);

    }
}