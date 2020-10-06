@isTest
private class ContactMakeDeceasedActionCtrlTest {
    static testMethod void contactMakeDeceasedActionCtrlTest() {
        Contact newContact = new Contact(
            LastName = 'Test Name',
            Email = 'test.name@email.com'
        );
        insert newContact;

        Test.startTest();
        ContactMakeDeceasedActionCtrl.optOutEmailContact(newContact.Id);
        ContactMakeDeceasedActionCtrl.makeDeceasedContact(newContact.Id);
        try {
            ContactMakeDeceasedActionCtrl.makeDeceasedContact('123121');
        } catch(Exception e) {}

        Test.stopTest();
    }
}