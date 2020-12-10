@IsTest
private class ContactDomainTest {
    @IsTest
    static void testBehavior() {
        Account account = new Account(Name = 'test');
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id,
            MailingCity = 'test' ,
            MailingState = 'vic'
        );
        insert contact;

        contact.MailingCity = 'testCity';
        update contact;

        Test.startTest();
        Contact testContact = [SELECT Id, MailingState, MailingCity from Contact where Id =:contact.Id LIMIT 1][0];
        System.assertEquals('VIC', testContact.MailingState);
        System.assertEquals('TestCity', testContact.MailingCity);
        Test.stopTest();

    }
}