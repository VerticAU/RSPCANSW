@isTest
public class EzidebitTest {
    @isTest
    static void testCRNBatch() {

        EzidebitPaymentProcessor.GetBPayCRNResponse_element element = new EzidebitPaymentProcessor.GetBPayCRNResponse_element();

        element.GetBPayCRNResult = new EzidebitPaymentProcessor.EziResponseOfDataTHgMB7oL();
        element.GetBPayCRNResult.Error = 0;
        element.GetBPayCRNResult.Data = new EzidebitPaymentProcessor.Data();
        element.GetBPayCRNResult.Data.BPayCRN = 'test';

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();

        EzidebitStructs.BPayCRN bPayCRN = new EzidebitPaymentProcessor(payment_ProcessorFactory.getGatewayCredentials('EziDebit')).getCRN(
            'test', 'Vertic'
        );

        Test.stopTest();

        System.assertEquals('test', bPayCRN.BPayCRN);
    }

    @isTest
    static void testGetPayments() {

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

        List<EzidebitStructs.Payment> payments = new EzidebitPaymentProcessor(payment_ProcessorFactory.getGatewayCredentials('EziDebit')).getPayments(
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

        Account account = new Account(
            Name = 'testName'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id
        );
        insert contact;

        CampaignMember campaignMember = new CampaignMember(
            CampaignId = campaign.Id,
            ContactId = contact.Id
        );
        insert campaignMember;

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

        Account account = new Account(
                Name = 'testName'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            BPAY_CRN__c = 'test',
            AccountId = account.Id
        );
        insert contact;

        CampaignMember campaignMember = new CampaignMember(
            CampaignId = campaign.Id,
            ContactId = contact.Id
        );
        insert campaignMember;

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

    @IsTest
    static void testAddBankDebitProc(){

        Account account = new Account(
            Name = 'test'
        );

        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id
        );
        insert contact;

        npe03__Recurring_Donation__c recurringDonation = new npe03__Recurring_Donation__c(
            Name = 'test',
            npsp__RecurringType__c = 'Open',
            npe03__Amount__c = (Decimal) 5,
            npe03__Installment_Period__c = 'Monthly',
            npsp__InstallmentFrequency__c = 5,
            npe03__Date_Established__c = Date.today(),
            npsp__StartDate__c = Date.today(),
            npsp__Status__c = 'Active',
            npe03__Contact__c = contact.Id
        );
        insert recurringDonation;

        System.debug(recurringDonation);

        Opportunity opp = new Opportunity(
            Name = 'test',
            Amount = 123,
            CloseDate = Date.today(),
            StageName = 'Pledged',
            npe03__Recurring_Donation__c = recurringDonation.Id
        );
        insert opp;

        System.debug(opp);


        npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(
            npe01__Opportunity__c = opp.Id
        );
        insert oppPayment;

        Map<String, Object> request = new Map<String, Object>{
            'recordId' => oppPayment.Id
        };

        new EzidebitAddBankDebitProc().process(request);

    }

    @IsTest
    static void testGetPaymentsScheduledProc(){
        Opportunity opportunity = new Opportunity(
            Name = 'test',
            CloseDate = Date.today(),
            StageName = 'Pledged'
        );
        insert opportunity;

        npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(
            npe01__Payment_Method__c = 'EziDebit',
            npe01__Paid__c = false,
            npsp_plus__Status__c = 'Pending',
            EziDebit_Transaction_ID__c = 'test',
            npe01__Written_Off__c = false,
            npe01__Opportunity__c = opportunity.Id
        );
        insert oppPayment;

        EzidebitGetDDPaymentsScheduledProc scheduledProc = new EzidebitGetDDPaymentsScheduledProc(
            new Set<Id>{
                oppPayment.Id
            }
        );

        Test.startTest();
        vertic_Response response = scheduledProc.process(new Map<String, Object>{});
        Test.stopTest();

        System.assertEquals(false, response.get('apexJobId').equals(null));
        System.assertEquals('EziDebit Get Scheduled Payments - Every Day at 9AM and 4PM', scheduledProc.getScheduledJobName());
        System.assertEquals('0 0 9,16 * * ? *', scheduledProc.getScheduledCRON());
        System.assertEquals(EzidebitGetDDPaymentsScheduledProc.class, scheduledProc.getScheduledProcType());
        System.assertEquals(true, scheduledProc.isQueueable());
    }

    @IsTest
    static void testEzidebitGetPaymentDetailsProc(){
        Opportunity opportunity = new Opportunity(
            Name = 'test',
            CloseDate = Date.today(),
            StageName = 'Pledged'
        );
        insert opportunity;

        npe01__OppPayment__c oppPayment = new npe01__OppPayment__c(
            npe01__Payment_Method__c = 'EziDebit',
            npsp_plus__Status__c = 'Processed',
            EziDebit_Transaction_ID__c = 'test',
            npe01__Payment_Date__c = Date.today(),
            npe01__Opportunity__c = opportunity.Id
        );
        insert oppPayment;

        EzidebitPaymentProcessor.EziResponseOfPaymentDetailTHgMB7oL element = new EzidebitPaymentProcessor.EziResponseOfPaymentDetailTHgMB7oL();

        EzidebitPaymentProcessor.PaymentDetail paymentDetail = new EzidebitPaymentProcessor.PaymentDetail();
        paymentDetail.PaymentStatus ='asd';

        element.Data = paymentDetail;
        element.Error = 0;

//        EzidebitPaymentProcessor.Payment payment = new EzidebitPaymentProcessor.Payment();
//        payment.PaymentID = 'test';
//        payment.PaymentAmount = 10;
//        payment.SettlementDate = Datetime.now();
//
//        element.GetPaymentsResult.Data.Payment = new List<EzidebitPaymentProcessor.Payment>{payment};

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Test.setMock(WebServiceMock.class, generator);

        Map<String, Object> request = new Map<String, Object>{
            'recordId' => oppPayment.Id
        };

        Test.startTest();
        new EzidebitGetPaymentDetailsProc().process(request);
        Test.stopTest();
    }
}