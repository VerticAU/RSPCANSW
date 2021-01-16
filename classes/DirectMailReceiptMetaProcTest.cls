@IsTest
public class DirectMailReceiptMetaProcTest {
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
            Amount = 10,
            StageName = 'Closed Won',
            CloseDate = Date.today(),
            RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Donation').getRecordTypeId(),
            npsp__Primary_Contact__c = contact.Id,
            CampaignId = campaign.Id,
            npsp__Acknowledgment_Status__c = 'To Be Acknowledged'
        );
        insert opp;

        Direct_Mail_Receipt_Template__c template = new Direct_Mail_Receipt_Template__c(
            Envelope_Type__c = 'DLX',
            Header_Image__c = 'https://rspcansw--developer--c.documentforce.com/servlet/servlet.FileDownload?file=0151y000000VIsS',
            Receipt_Body_Text__c = '&lt;c:DirectMailReceiptAddress/&gt; &lt;c:DirectMailReceiptImage/&gt; {!today} Dear {!recipient.FirstName} &lt;c:DirectMailReceiptTable/&gt;',
            Minimum_Donation__c = 0,
            Maximum_Donation__c = 99999999,
            Campaign__c = campaign.Id
        );
        insert template;

        DirectMailReceiptMetaProc metaProc = new DirectMailReceiptMetaProc();

        vertic_Response response = metaProc.process(new Map<String, Object>{
            'ids' => opp.Id,
            'renderAs' => 'html',
            'afterProc' => true
        });

        metaProc.getMergeFieldSets();
        metaProc.getSObjectType();

        System.assert(response.isValid);
    }
}