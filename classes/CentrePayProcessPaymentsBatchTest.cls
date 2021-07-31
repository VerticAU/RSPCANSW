@IsTest
private class CentrePayProcessPaymentsBatchTest {
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

        Database.executeBatch(new CentrePayProcessPaymentsBatch(paymentRows, batch.Id));
    }
}