@IsTest
public class BulkAnnualReceiptingGenerateProcTest {
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

        Test.startTest();
        new BulkAnnualReceiptingGenerateProc().process(new Map<String, Object>{
            'emailIds' => new List<String>{contact.Id},
            'mailIds' => new List<String>{contact.Id},
            'filter' => new Map<String, Object>{
                'startDate' => Date.today(),
                'endDate' => Date.today()
            }
        });
        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Vertic_Async_Process__c]);
    }
}