@IsTest
public class RecurringReceiptTemplateQAMetaTest {
    @IsTest static void test(){
        Campaign campaign = new Campaign(
            Name = 'test'
        );
        insert campaign;

        new RecurringReceiptTemplateQAMetaProc().process(new Map<String, Object>{
            'recordId' => campaign.Id
        });
    }
}