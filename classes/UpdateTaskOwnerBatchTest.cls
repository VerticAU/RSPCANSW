@IsTest
public class UpdateTaskOwnerBatchTest {

    @IsTest static void test(){
        Contact contact = new Contact(
            LastName='test',
            Email='test@test.test'
        );
        insert contact;

        Task task = new Task(
            WhoId = contact.Id,
            Owner__c = 'amyb'
        );
        insert task;

        Test.startTest();
        Database.executeBatch(new UpdateTaskOwnerBatch(), 2000);
        Test.stopTest();

        System.assertEquals('Amy Brown', [SELECT Id, Owner__c FROM Task LIMIT 1].Owner__c);
    }
}