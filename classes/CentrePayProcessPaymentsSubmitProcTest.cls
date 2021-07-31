@IsTest
private class CentrePayProcessPaymentsSubmitProcTest {
    @IsTest
    static void testBehavior() {
        Batch__c batch = new Batch__c(
            Batch_Status__c = 'In Progress'
        );
        insert batch;

        List<Map<String, Object>> paymentRows = new List<Map<String, Object>>{
            new Map<String, Object>{

            }
        };

        vertic_Response response = new CentrePayProcessPaymentsSubmitProc().process(
            new Map<String, Object>{
                'recordId' => batch.Id,
                'payments' => paymentRows
            }
        );

        System.assert(response.getString('batchId') != null, true);
    }
}