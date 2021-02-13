@IsTest
private class AddPaymentWizardSearchStepMetaProcTest {
    static testMethod void testBehavior() {
        Account account = new Account(
            Name = 'testName'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'Test Name',
            Email = 'test.name@email.com',
            AccountId = account.Id
        );
        insert contact;

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Open',
            CloseDate = Date.today(),
            npsp__Primary_Contact__c = contact.Id,
            AccountId = account.Id,
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Donation'));
        insert opp;

        vertic_Response response = new AddPaymentWizardSearchStepMetaProc().process(new Map<String, Object>{
            'filter' => new Map<String, Object>{
                'contactId' => contact.Id,
                'accountId' => account.Id
            }
        });

        System.assertNotEquals(null, response.get('ids'));
    }
}