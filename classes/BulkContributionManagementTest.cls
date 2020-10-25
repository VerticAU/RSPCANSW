@isTest
public class BulkContributionManagementTest {
    @isTest
    private static void test() {
        Opportunity opp = new Opportunity(Name = 'test', StageName = 'Enquiry', CloseDate = Date.today());
        insert opp;
        String jSonString = JSON.serialize(new Map<String, Object>{
        });

        vertic_Response response = new BulkContributionManagementMetaProc().process(new vertic_MetadataProcessor.MetadataRequest(jSonString));

        new BulkContributionManagementSubmitProc().process(new vertic_Request(new Map<String, Object>{
            'contributions' => new List<Map<String, Object>>{
                new Map<String, Object>{
                    'contribution' => opp,
                    'paymentMethod' => 'Credit Card',
                    '' +
                            'stripePaymentId' => 'test'
                }
            }
        }));
    }

}