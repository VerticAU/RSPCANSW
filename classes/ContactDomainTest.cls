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
}