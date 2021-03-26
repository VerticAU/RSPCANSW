@IsTest
public class RecurringReceiptTemplateQASubmitTest {
    @IsTest static void test(){

        System.runAs(new User(Id = UserInfo.getUserId())) {
            Campaign campaign = new Campaign(
                Name = 'test'
            );
            insert campaign;

            EmailTemplate testTemplate = new EmailTemplate(
                Name = 'Test template',
                DeveloperName = 'Vertic_Test',
                TemplateType = 'text',
                FolderId = UserInfo.getUserId()
            );
            insert testTemplate;

            new RecurringReceiptTemplateQASubmitProc().process(new Map<String, Object>{
                'recurringAcknowledgementTemplateId' => testTemplate.Id,
                'campaignId' => campaign.Id
            });
        }

    }
}