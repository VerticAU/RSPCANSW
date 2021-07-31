@IsTest
private class UpdateContactsBatchTest {

    @IsTest static void test() {
        Contact contact = new Contact(
            LastName = 'test',
            Email = 'test@test.test',
            MailingCity = '1',
            MailingPostalCode = '1'
        );
        insert contact;

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
        Database.executeBatch(new UpdateContactsBatch(), 2000);
        Test.stopTest();

        Contact contact2 = (Contact) vertic_Utils.arrays.firstOrNull([
            SELECT LGA__c FROM Contact
        ]);

        System.assertNotEquals(contact2.LGA__c, null);

    }
}