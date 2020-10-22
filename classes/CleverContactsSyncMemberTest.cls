@isTest
private class CleverContactsSyncMemberTest {
 @testSetup
 static void setup(){

 }
    @isTest
    static void test(){
        Account acc = new Account(Name='test');
        insert acc;
        Campaign cmp = new Campaign(Name='test');
        insert cmp;
        Contact cnt = new Contact(LastName='test', Email='test@test.test', AccountId=acc.Id);
        insert cnt;
        CampaignMember cmpMember = new CampaignMember(
            ContactId=cnt.Id,
            CampaignId = cmp.Id,
            Clever_Contacts_Sync_Status__c = 'Failed'

        );
        insert cmpMember;
        Test.startTest();
        CleverContactsSyncMemberBatch ccsmb = new CleverContactsSyncMemberBatch(cmp.Id);
        Id batchId = Database.executeBatch(ccsmb);
        Test.stopTest();
    }
}