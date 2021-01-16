@IsTest
public class AnnualReceiptMetaProcTest {
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


        npe03__Recurring_Donation__c recurringDonation = new npe03__Recurring_Donation__c(
            Name = 'test',
            npsp__RecurringType__c = 'Open',
            npe03__Amount__c = (Decimal) 5,
            npe03__Installment_Period__c = 'Monthly',
            npsp__InstallmentFrequency__c = 5,
            npe03__Date_Established__c = Date.today(),
            npsp__StartDate__c = Date.today(),
            npsp__Status__c = 'Active',
            npe03__Contact__c = contact.Id
        );
        insert recurringDonation;

        Opportunity opp = new Opportunity(
            Name = 'test',
            Amount = 123,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            npsp__Primary_Contact__c = contact.Id,
            CampaignId = campaign.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged',
            npe03__Recurring_Donation__c = recurringDonation.Id
        );
        insert opp;

        Test.startTest();
        vertic_Response response = new AnnualReceiptMetaProc().process(new Map<String, Object>{
            'donorIds' => contact.Id,
            'startDate' => Date.today(),
            'endDate' => Date.today(),
            'renderAs' => 'html'
        });
        Test.stopTest();

        System.assert(response.isValid);
    }
}