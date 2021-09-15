@IsTest
public class OpportunityNaming_TDTM_Test {
    @IsTest
    public static void testBehavior() {
        // Retrieve default NPSP Trigger Handlers
        List<npsp__Trigger_Handler__c> triggerHandlers = npsp.TDTM_Config_API.getCachedRecords();

        // Add our Trigger Handler to cached Trigger Handlers
        npsp__Trigger_Handler__c th = new npsp__Trigger_Handler__c();
        th.Name = 'OpportunityNaming_TDTM';
        th.npsp__Class__c = 'OpportunityNaming_TDTM';
        th.npsp__Object__c = 'Opportunity';
        th.npsp__Trigger_Action__c = 'BeforeInsert;BeforeUpdate;';
        th.npsp__Active__c = true;
        th.npsp__Load_Order__c = 5;
        th.npsp__Asynchronous__c = false;

        triggerHandlers.add(th);

        Contact contact = new Contact(
            LastName = 'Test Contact Name',
            Email = 'test@test.test'
        );
        insert contact;

        Campaign campaign = new Campaign(
            Name = 'Test'
        );
        insert campaign;

        Account account = new Account(
            Name = 'Test Account Name'
        );
        insert account;

        Opportunity opp = new Opportunity(
            Name = 'Donation',
            Amount = 10,
            StageName = 'Closed Won',
            CloseDate = Date.newInstance(2021, 8, 20),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            npsp__Primary_Contact__c = contact.Id,
            CampaignId = campaign.Id,
            AccountId = account.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged'
        );
        insert opp;

        System.Test.startTest();
        System.assertEquals('Test Contact Name  $10 20/08/2021', [SELECT Id, Name FROM Opportunity LIMIT 1].Name);
        System.Test.stopTest();
    }
}