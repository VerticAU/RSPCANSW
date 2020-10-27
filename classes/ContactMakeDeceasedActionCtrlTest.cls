@isTest
private class ContactMakeDeceasedActionCtrlTest {
    static testMethod void contactMakeDeceasedActionCtrlTest() {
        Contact contact = new Contact(
            LastName = 'Test Name',
            Email = 'test.name@email.com'
        );
        insert contact;

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Enquiry',
            CloseDate = Date.today(),
            npsp__Primary_Contact__c = contact.Id,
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByName(Opportunity.SObjectType, 'Bequest'));
        insert opp;

        ContactMakeDeceasedActionCtrl.optOutEmailContact(contact.Id);
        ContactMakeDeceasedActionCtrl.makeDeceasedContact(contact.Id, Date.today(), Date.today());

        try {
            ContactMakeDeceasedActionCtrl.makeDeceasedContact('123121', Date.today(), Date.today());
        } catch(Exception e) {
            System.assert(true);
        }

        System.assertEquals(Date.today(), [SELECT Id, Deceased_Date__c FROM Contact LIMIT 1].Deceased_Date__c);
    }
}