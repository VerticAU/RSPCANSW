@IsTest
public class OpportunityNaming_TDTM_Test {
    @IsTest
    public static void testBehavior() {
        Contact contact = new Contact(
            LastName = 'Test',
            Email = 'test@test.test'
        );
        insert contact;

        Campaign campaign = new Campaign(
            Name = 'Test'
        );
        insert campaign;

        Opportunity opp = new Opportunity(
            Name = 'Donation',
            Amount = 10,
            StageName = 'Closed Won',
            CloseDate = Date.newInstance(2021, 8, 20),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            npsp__Primary_Contact__c = contact.Id,
            CampaignId = campaign.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged'
        );
        insert opp;

        System.assertEquals('Test Donation 20/08/2021 Test', [SELECT Id, Name FROM Opportunity LIMIT 1].Name);
    }
}