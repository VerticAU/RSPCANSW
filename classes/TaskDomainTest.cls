@IsTest
private class TaskDomainTest {
    static testMethod void testBehavior() {

        Contact contact = new Contact(
            LastName = 'test',
            Email = 'test@test.com'
        );
        insert contact;

        insert new Task(
            Group_Name__c = 'Support_Coordinator_Team',
            WhoId = contact.Id,
            Activity_Days__c = 5,
            Description = '{"Group_Name__c": "Estate Administration Team", "Activity_Days__c": "5", "Description": "test", "WhoId_Field": "npe01__One2OneContact__c"}'
        );

        
    }
}