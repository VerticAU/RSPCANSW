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

        Opportunity opp2 = new Opportunity(
            Name = 'test',
            StageName = 'Enquiry',
            CloseDate = Date.today(),
            Batch__c = batch.Id
        );
        insert opp2;

        npe01__OppPayment__c payment = new npe01__OppPayment__c(
            npe01__Opportunity__c = opp.Id
        );
        insert payment;

        Map<String, Object> request = new Map<String, Object>{
            'batchId' => String.valueOf(batch.Id)
        };

        new vertic_AutoMapper(request).mapFromListSObjects(
            'contributions',
            new List<Opportunity>{
                opp
        });

        vertic_Response response = new BulkContributionManagementSaveRecProc().process(request);

        System.assertEquals(batch.Id, response.getMap().get('batchId'));
    }

    @IsTest
    static void testBulkContributionManagementPaymentProc(){
        Account account = new Account(Name = 'test');
        insert account;

        Map<String, Object> request = new Map<String, Object>{
            'amount' => (Decimal)5.5,
            'stripeCustomerId' => 'test',
            'stripePaymentMethodId' => 'test',
            'stripeAccountId' => String.valueOf(account.Id)
        };

        Test.startTest();
        vertic_Response response = new BulkContributionManagementPaymentProc().process(request);
        Test.stopTest();

        System.assertEquals('test', response.getMap().get('paymentIntentId'));
    }

}