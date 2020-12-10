@IsTest
public class MigrateContactIdBatchScriptTest {
    static testMethod void test(){

        Contact contact = new Contact(
            LastName = 'test',
            External_ID__c = 'test'
        );
        insert contact;

        Test.startTest();
        Database.executeBatch(new MigrateContactIdBatchScript(), 200);
        Test.stopTest();

        System.assertEquals('test', [SELECT Id, Contact_ID__c FROM Contact LIMIT 1].Contact_ID__c);
    }
}