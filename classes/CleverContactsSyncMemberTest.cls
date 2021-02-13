@isTest
private class CleverContactsSyncMemberTest {

    @isTest
    static void test(){
        Account acc = new Account(Name='test');
        insert acc;

        Campaign cmp = new Campaign(Name='test');
        insert cmp;

        Contact cnt = new Contact(LastName='test', Email='test@test.test', AccountId=acc.Id);
        insert cnt;

        CampaignMember cmpMember = new CampaignMember(
            ContactId = cnt.Id,
            CampaignId = cmp.Id,
            Clever_Contacts_Sync_Status__c = ''
        );
        insert cmpMember;

        insert new Opportunity(
            Name = 'test',
            npsp__Primary_Contact__c = cnt.Id,
            StageName = 'Open',
            CloseDate = Date.today(),
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Bequest')
        );

        insert new Opportunity(
            Name = 'test',
            npsp__Primary_Contact__c = cnt.Id,
            StageName = 'Open',
            CloseDate = Date.today(),
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Bequest')
        );

        insert new Animal__c(
            Contact__c = cnt.Id
        );

        MockHttpResponseGenerator responseGenerator = new MockHttpResponseGenerator(
            new Map<String, String>{
                'callout:Clever_Contacts/' => '"Success"'
            }, 'POST', 200
        );

        Test.setMock(HttpCalloutMock.class, responseGenerator);

        Test.startTest();

        new CleverContactsSyncMemberQASubmitProc().process(new Map<String, Object>{
            'recordId' => cmp.Id
        });

        Test.stopTest();

        System.assertEquals('Success', [SELECT Id, Clever_Contacts_Sync_Status__c FROM CampaignMember LIMIT 1].Clever_Contacts_Sync_Status__c);
    }
}