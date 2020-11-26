@isTest
public with sharing class MembershipServiceTest {
    @isTest
    private static void test() {

        Account account = new Account(
                Name = 'testName'
        );
        insert account;

        Contact cnt = new Contact(
                LastName = 'test',
                Email = 'test@test.test',
                AccountId = account.Id
        );
        insert cnt;

        Id devRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();


        Opportunity opp = new Opportunity(
                Name = 'test',
                Amount = 123,
                StageName = 'Pending',
                CloseDate = Date.today(),
                RecordTypeId = devRecordTypeId,
                npsp__Primary_Contact__c = cnt.Id);
        insert opp;

        cnt.Active_Membership__c = opp.Id;
        update cnt;

        Opportunity opp2 = new Opportunity(
                Name = 'test2',
                Amount = 1234,
                RecordTypeId = devRecordTypeId,
                StageName = 'Pending',
                CloseDate = Date.today(),
                npsp__Primary_Contact__c = cnt.Id);
        insert opp2;

        List<Opportunity> opplist = new  List<Opportunity>();
        opplist.add(opp2);

        MembershipService.updateActiveMembership(opplist);
    }
}