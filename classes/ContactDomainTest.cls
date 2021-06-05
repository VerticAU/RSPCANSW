@IsTest
private class ContactDomainTest {
    @IsTest
    static void testBehavior() {
        Account account = new Account(Name = 'test');
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id,
            MailingStreet = 'test1\ntest2' ,
            MailingCity = 'test' ,
            MailingState = 'vic'
        );
        insert contact;

        contact.MailingCity = 'testCity';
        update contact;

        Test.startTest();
        Contact testContact = [SELECT Id, MailingState, MailingCity, Mailing_Street_Line_1__c, Mailing_Street_Line_2__c FROM Contact WHERE Id =:contact.Id LIMIT 1][0];
        System.assertEquals('VIC', testContact.MailingState);
        System.assertEquals('TestCity', testContact.MailingCity);
        System.assertEquals('test1', testContact.Mailing_Street_Line_1__c);
        System.assertEquals('test2', testContact.Mailing_Street_Line_2__c);
        Test.stopTest();
    }

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

        Contact contact = new Contact(
            LastName = 'Test',
            MailingCity = 'Test',
            MailingPostalCode = '1111'
        );
        insert contact;

        System.assertEquals(lga1.Id, [SELECT Id, LGA__c FROM Contact WHERE Id =: contact.Id].LGA__c);

        contact.MailingPostalCode = '2222';
        update contact;

        System.assertEquals(lga2.Id, [SELECT Id, LGA__c FROM Contact WHERE Id =: contact.Id].LGA__c);
    }
}