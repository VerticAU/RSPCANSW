@isTest
public class EzidebitTest {
    @isTest
    static void testCRNBatch() {

        insert new Payment_Gateway_Credentials__c(
            Name = 'EZIDEBIT_SANDBOX',
            API_Key__c = 'test',
            API_Password__c = 'test',
            API_Signature__c = 'test',
            API_Username__c = 'test',
            Is_Active__c = true,
            Is_Test__c = true,
            URL__c = 'https://api.demo.ezidebit.com.au/v3-5/nonpci'
        );

        EzidebitPaymentProcessor.GetBPayCRNResponse_element element = new EzidebitPaymentProcessor.GetBPayCRNResponse_element();

        element.GetBPayCRNResult = new EzidebitPaymentProcessor.EziResponseOfDataTHgMB7oL();
        element.GetBPayCRNResult.Error = 0;
        element.GetBPayCRNResult.Data = new EzidebitPaymentProcessor.Data();
        element.GetBPayCRNResult.Data.BPayCRN = 'test';

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();

        EzidebitStructs.BPayCRN bPayCRN = new EzidebitPaymentProcessor(PaymentGatewayCredentialsProvider.getGatewayCredentials(
            PaymentGatewayCredentialsProvider.PAYMENT_TRANSACTION_PAYMENT_METHOD_EZIDEBIT
        )).getCRN(
            'test', 'Vertic'
        );

        Test.stopTest();

        System.assertEquals('test', bPayCRN.BPayCRN);
    }

    @isTest
    static void testGetPayments() {

        insert new Payment_Gateway_Credentials__c(
            Name = 'EZIDEBIT_SANDBOX',
            API_Key__c = 'test',
            API_Password__c = 'test',
            API_Signature__c = 'test',
            API_Username__c = 'test',
            Is_Active__c = true,
            Is_Test__c = true,
            URL__c = 'https://api.demo.ezidebit.com.au/v3-5/nonpci'
        );

        EzidebitPaymentProcessor.GetPaymentsResponse_element element = new EzidebitPaymentProcessor.GetPaymentsResponse_element();

        element.GetPaymentsResult = new EzidebitPaymentProcessor.EziResponseOfArrayOfPaymentTHgMB7oL();
        element.GetPaymentsResult.Data = new EzidebitPaymentProcessor.ArrayOfPayment();
        element.GetPaymentsResult.Error = 0;

        EzidebitPaymentProcessor.Payment payment = new EzidebitPaymentProcessor.Payment();
        payment.PaymentAmount = 10;

        element.GetPaymentsResult.Data.Payment = new List<EzidebitPaymentProcessor.Payment>{payment};

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();

        List<EzidebitStructs.Payment> payments = new EzidebitPaymentProcessor(PaymentGatewayCredentialsProvider.getGatewayCredentials(
            PaymentGatewayCredentialsProvider.PAYMENT_TRANSACTION_PAYMENT_METHOD_EZIDEBIT
        )).getPayments(
            'SUCCESSFUL',
            'ALL',
            'BPAY',
            'test',
            null,
            String.valueOf(Date.today()),
            'PAYMENT',
            null,
            null
        );

        Test.stopTest();

        System.assertEquals(1, payments.size());
    }

    @isTest
    static void testEzidebitGenerateCRNBatch() {

        Campaign campaign = new Campaign(
            Name='test'
        );
        insert campaign;

        Contact contact = new Contact(
            LastName = 'test'
        );
        insert contact;

        CampaignMember campaignMember = new CampaignMember(
            CampaignId = campaign.Id,
            ContactId = contact.Id
        );
        insert campaignMember;

        insert new Payment_Gateway_Credentials__c(
            Name = 'EZIDEBIT_SANDBOX',
            API_Key__c = 'test',
            API_Password__c = 'test',
            API_Signature__c = 'test',
            API_Username__c = 'test',
            Is_Active__c = true,
            Is_Test__c = true,
            URL__c = 'https://api.demo.ezidebit.com.au/v3-5/nonpci'
        );

        EzidebitPaymentProcessor.GetBPayCRNResponse_element element = new EzidebitPaymentProcessor.GetBPayCRNResponse_element();

        element.GetBPayCRNResult = new EzidebitPaymentProcessor.EziResponseOfDataTHgMB7oL();
        element.GetBPayCRNResult.Error = 0;
        element.GetBPayCRNResult.Data = new EzidebitPaymentProcessor.Data();
        element.GetBPayCRNResult.Data.BPayCRN = 'test';

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();

        Database.executeBatch(new EzidebitGenerateCRNBatch(campaign.Id), 200);

        Test.stopTest();

        System.assertEquals('test', [SELECT Id, BPAY_CRN__c FROM Contact LIMIT 1].BPAY_CRN__c);
    }

    @isTest
    static void testGetPaymentsBatch() {

        Campaign campaign = new Campaign(
            Name='test'
        );
        insert campaign;

        Contact contact = new Contact(
            LastName = 'test',
            BPAY_CRN__c = 'test'
        );
        insert contact;

        CampaignMember campaignMember = new CampaignMember(
            CampaignId = campaign.Id,
            ContactId = contact.Id
        );
        insert campaignMember;

        insert new Payment_Gateway_Credentials__c(
            Name = 'EZIDEBIT_SANDBOX',
            API_Key__c = 'test',
            API_Password__c = 'test',
            API_Signature__c = 'test',
            API_Username__c = 'test',
            Is_Active__c = true,
            Is_Test__c = true,
            URL__c = 'https://api.demo.ezidebit.com.au/v3-5/nonpci'
        );

        EzidebitPaymentProcessor.GetPaymentsResponse_element element = new EzidebitPaymentProcessor.GetPaymentsResponse_element();

        element.GetPaymentsResult = new EzidebitPaymentProcessor.EziResponseOfArrayOfPaymentTHgMB7oL();
        element.GetPaymentsResult.Data = new EzidebitPaymentProcessor.ArrayOfPayment();
        element.GetPaymentsResult.Error = 0;

        EzidebitPaymentProcessor.Payment payment = new EzidebitPaymentProcessor.Payment();
        payment.PaymentID = 'test';
        payment.PaymentAmount = 10;
        payment.SettlementDate = Datetime.now();

        element.GetPaymentsResult.Data.Payment = new List<EzidebitPaymentProcessor.Payment>{payment};

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();

        EzidebitGetPaymentsScheduleProc proc = new EzidebitGetPaymentsScheduleProc();
        proc.process(new Map<String, Object>());

        Test.stopTest();

        System.assertEquals(1, [SELECT COUNT() FROM Opportunity]);
        System.assertEquals('0 0 20 1/1 * ? *', proc.getScheduledCRON());
        System.assertEquals('Ezidebit Get Payments - Every Day at 8 PM', proc.getScheduledJobName());
        System.assertEquals(EzidebitGetPaymentsScheduleProc.class, proc.getScheduledProcType());
        System.assertEquals(true, proc.isQueueable());
    }
}