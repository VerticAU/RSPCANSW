@IsTest
public class BulkDonationReceiptingSearchProcTest {
    @IsTest static void test(){
        Account account = new Account(
            Name = 'testName'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            Email = 'test@test.test',
            AccountId = account.Id
        );
        insert contact;

        Campaign campaign = new Campaign(
            Name = 'test'
        );
        insert campaign;

        Opportunity opp = new Opportunity(
            Name = 'test',
            Amount = 123,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            npsp__Primary_Contact__c = contact.Id,
            CampaignId = campaign.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged'
        );
        insert opp;

        Opportunity opp2 = new Opportunity(
            Name = 'test',
            Amount = 123,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            AccountId = account.Id,
            CampaignId = campaign.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged'
        );
        insert opp2;

        System.debug([SELECT Id FROM Opportunity]);

        vertic_Response response = new BulkDonationReceiptingSearchProc().process(new Map<String, Object>{
            'filter' => new Map<String, Object>{
                'startDate' => Date.today(),
                'endDate' => Date.today(),
                'contactId' => contact.Id,
                'accountId' => account.Id,
                'campaignId' => campaign.Id
            }
        });

        System.debug(response);

        System.assertEquals(2, ((Map<String,Object>)response.get('contributions')).size());
    }
}