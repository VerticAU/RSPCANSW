@isTest
public class BulkContributionManagementTest {
    @isTest
    private static void test() {
        Batch__c batch = new Batch__c(
            Name = 'test'
        );
        insert batch;

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Enquiry',
            CloseDate = Date.today(),
            Batch__c = batch.Id
        );
        insert opp;

        npe01__OppPayment__c payment = new npe01__OppPayment__c(
            npe01__Opportunity__c = opp.Id
        );
        insert payment;

        new BulkContributionManagementMetaProc().process(new vertic_MetadataProcessor.MetadataRequest('{}'));

        Map<String, Object> request = new Map<String, Object>{
            'paymentMethod' => 'Credit Card',
            'stripePaymentId' => 'test'
        };
        new vertic_AutoMapper(request).mapFromSObject('contribution', opp);
        new BulkContributionManagementSubmitProc().process(request);
    }

    @IsTest
    static void testBulkContributionManagementSaveRecProc(){
        Batch__c batch = new Batch__c(
            Name = 'test',
            Batch_Status__c = 'Pending'
        );
        insert batch;

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Enquiry',
            CloseDate = Date.today(),
            Batch__c = batch.Id
        );
        insert opp;

        Map<String, Object> request = new Map<String, Object>{
            'batchId' => String.valueOf(batch.Id),
            'contributions' => opp
        };

        Test.startTest();
        new BulkContributionManagementSaveRecProc().process(request);
        Test.stopTest();
    }

}