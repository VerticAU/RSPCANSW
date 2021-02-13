@IsTest
private class ProcessBatchActionSubmitProcTest {
    static testMethod void testBehavior() {
        Batch__c batch = new Batch__c();
        insert batch;

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Enquiry',
            CloseDate = Date.today(),
            Batch__c = batch.Id
        );
        insert opp;

        npe01__OppPayment__c payment = new npe01__OppPayment__c(
            npe01__Opportunity__c = opp.Id,
            npe01__Payment_Method__c = 'Credit Card',
            npe01__Paid__c = false,
            Batch__c = batch.Id,
            npe01__Payment_Amount__c = 10,
            Stripe_Payment_Id__c = 'test',
            Stripe_Customer_Id__c = 'test'
        );
        insert payment;

        vertic_Response response = new ProcessBatchActionSubmitProc().process(new Map<String, Object>{
            'recordId' => batch.Id
        });

        System.assertNotEquals(null, response.get('batchId'));
    }
}