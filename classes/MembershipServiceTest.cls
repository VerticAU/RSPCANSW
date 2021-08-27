@isTest
public with sharing class MembershipServiceTest {
    @isTest
    static void test() {

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

    @isTest
    static void test2() {

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

        Id membershipRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Membership').getRecordTypeId();
        Id donationRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId();

        Opportunity opp = new Opportunity(
            Name = 'test',
            Amount = 123,
            StageName = 'Pending',
            CloseDate = Date.today(),
            RecordTypeId = membershipRecordTypeId,
            npsp__Primary_Contact__c = cnt.Id);
        insert opp;

        Opportunity opp2 = new Opportunity(
            Name = 'test2',
            Amount = 1234,
            RecordTypeId = donationRecordTypeId,
            StageName = 'Enrolled',
            CloseDate = Date.today(),
            npsp__Primary_Contact__c = cnt.Id,
            Linked_Opportunity__c = opp.Id
        );
        insert opp2;

        opp.npsp__Acknowledgment_Status__c = 'Email Acknowledgment Now';
        update opp;

        opp.npsp__Acknowledgment_Status__c = 'Email Renewal Now';
        update opp;
    }
}