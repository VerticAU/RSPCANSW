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
        EzidebitPaymentProcessor.NewCustomer newCustomer = new EzidebitPaymentProcessor.NewCustomer();
        newCustomer.CustomerRef = 1;

        EzidebitPaymentProcessor.EziResponseOfNewCustomerXcXH3liW newCustomerXcXH3liW = new EzidebitPaymentProcessor.EziResponseOfNewCustomerXcXH3liW();
        newCustomerXcXH3liW.Error = 0;
        newCustomerXcXH3liW.Data = newCustomer;

        EzidebitPaymentProcessor.AddBankDebitResponse_element element = new EzidebitPaymentProcessor.AddBankDebitResponse_element();
        element.AddBankDebitResult = newCustomerXcXH3liW;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

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

        Opportunity opportunity = (Opportunity)vertic_Utils.arrays.firstOrException(
        [SELECT Id FROM Opportunity WHERE npe03__Recurring_Donation__c =:recurringDonation.Id]
        );
        opportunity.Name = 'test';
        opportunity.Amount = 123;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Pledged';

        update opportunity;

        npe01__OppPayment__c oppPayment = (npe01__OppPayment__c)vertic_Utils.arrays.firstOrException(
        [SELECT Id FROM npe01__OppPayment__c WHERE npe01__Opportunity__c =:opportunity.Id]
        );
        oppPayment.npe01__Paid__c = false;
        oppPayment.npe01__Payment_Method__c = 'EziDebit';

        update oppPayment;
        System.debug('oppPayment' + oppPayment);

        Map<String, Object> request = new Map<String, Object>{
            'recordId' => oppPayment.Id
        };

        Test.startTest();
        vertic_Response response = new EzidebitAddBankDebitProc().process(request);
        Test.stopTest();

        System.assertEquals(true, response.get('EziDebitCustomerId')!=null);
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
    static void testGetPaymentDetailsProc(){
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

        EzidebitPaymentProcessor.EziResponseOfPaymentDetailTHgMB7oL paymentDetailTHgMB7oL = new EzidebitPaymentProcessor.EziResponseOfPaymentDetailTHgMB7oL();
        EzidebitPaymentProcessor.PaymentDetail paymentDetail = new EzidebitPaymentProcessor.PaymentDetail();
        paymentDetail.PaymentReference = String.valueOf(oppPayment.Id);
        paymentDetailTHgMB7oL.Data = paymentDetail;
        paymentDetailTHgMB7oL.Error = 0;

        EzidebitPaymentProcessor.GetPaymentDetailResponse_element element = new EzidebitPaymentProcessor.GetPaymentDetailResponse_element();
        element.GetPaymentDetailResult = paymentDetailTHgMB7oL;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitGetPaymentDetailsProc detailsProc = new EzidebitGetPaymentDetailsProc();

        Test.startTest();
        vertic_Response response = detailsProc.process(new Map<String, Object>{
                'recordId' => oppPayment.Id
            });
        Test.stopTest();

        System.assertEquals(true, response.get('details')!=null);
    }

    @IsTest
    static void testGetPaymentsScheduleProc(){
        EzidebitGetPaymentsScheduleProc ScheduleProc = new EzidebitGetPaymentsScheduleProc();

        System.assertEquals('Ezidebit Get Payments - Every Day at 8 PM', ScheduleProc.getScheduledJobName());
        System.assertEquals('0 0 20 1/1 * ? *', ScheduleProc.getScheduledCRON());
        System.assertEquals(true, ScheduleProc.isQueueable());
        System.assertEquals(EzidebitGetPaymentsScheduleProc.class, ScheduleProc.getScheduledProcType());
    }

    @IsTest
    static void testGetPaymentsProc(){
        EzidebitPaymentProcessor.GetPaymentsResponse_element element = new EzidebitPaymentProcessor.GetPaymentsResponse_element();

        element.GetPaymentsResult = new EzidebitPaymentProcessor.EziResponseOfArrayOfPaymentTHgMB7oL();
        element.GetPaymentsResult.Data = new EzidebitPaymentProcessor.ArrayOfPayment();
        element.GetPaymentsResult.Error = 0;

        EzidebitPaymentProcessor.Payment payment = new EzidebitPaymentProcessor.Payment();
        payment.PaymentAmount = 10;
        payment.SettlementDate = Datetime.now();
        payment.PaymentStatus = 'W';
        payment.PaymentID = 'test';

        element.GetPaymentsResult.Data.Payment = new List<EzidebitPaymentProcessor.Payment>{payment};
        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);

        Account account = new Account(Name = 'test');
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            CreatedDate = Date.newInstance(2020, 12, 6),
            Last_Payment_Date__c = Date.today(),
            BPAY_CRN__c = 'test',
            AccountId = account.Id
        );
        insert contact;

        Map<String, Object> request = new Map<String, Object>{
            'recordId' => contact.Id
        };

        Test.setMock(WebServiceMock.class, generator);

        Test.startTest();
        new EzidebitGetPaymentsProc().process(request);
        Test.stopTest();

        System.assertEquals(Date.today(), [SELECT ID, Last_Payment_Date__c FROM Contact WHERE Id=:contact.Id].Last_Payment_Date__c);
    }

    @IsTest
    static void testPaymentProcessor(){
        //EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor();
        EzidebitPaymentProcessor.NewCustomer newCustomer = new EzidebitPaymentProcessor.NewCustomer();
        EzidebitPaymentProcessor.AddCustomerResponse_element addCustomerResponseElement = new EzidebitPaymentProcessor.AddCustomerResponse_element();
        EzidebitPaymentProcessor.AddCustomer_element addCustomerElement = new EzidebitPaymentProcessor.AddCustomer_element();
        EzidebitPaymentProcessor.CreateScheduleResponse_element cResponseElement = new EzidebitPaymentProcessor.CreateScheduleResponse_element();
        EzidebitPaymentProcessor.CreateSchedule_element cElement = new EzidebitPaymentProcessor.CreateSchedule_element();
        EzidebitPaymentProcessor.EziResponseOfCustomerDetailsTHgMB7oL eziResponseOfCustomerDetailsTHgMB7oL = new EzidebitPaymentProcessor.EziResponseOfCustomerDetailsTHgMB7oL();
        EzidebitPaymentProcessor.CustomerDetails customerDetails = new EzidebitPaymentProcessor.CustomerDetails();
        EzidebitPaymentProcessor.GetCustomerDetails_element gDetailsElement = new EzidebitPaymentProcessor.GetCustomerDetails_element();
        EzidebitPaymentProcessor.GetCustomerDetailsResponse_element gCustomerDetailsResponseElement = new EzidebitPaymentProcessor.GetCustomerDetailsResponse_element();
        EzidebitPaymentProcessor.ChangeCustomerStatus_element changeCustomerStatusElement = new EzidebitPaymentProcessor.ChangeCustomerStatus_element();
        EzidebitPaymentProcessor.ChangeCustomerStatusResponse_element changeCustomerStatusResponseElement = new EzidebitPaymentProcessor.ChangeCustomerStatusResponse_element();
        EzidebitPaymentProcessor.ClearSchedule_element clearScheduleElement = new EzidebitPaymentProcessor.ClearSchedule_element();
        EzidebitPaymentProcessor.ClearScheduleResponse_element clearScheduleResponseElement = new EzidebitPaymentProcessor.ClearScheduleResponse_element();
        EzidebitPaymentProcessor.AddBankDebit_element addBankDebitElement = new EzidebitPaymentProcessor.AddBankDebit_element();
        EzidebitPaymentProcessor.AddBankDebitResponse_element addBankDebitResponseElement = new EzidebitPaymentProcessor.AddBankDebitResponse_element();
        EzidebitPaymentProcessor.EziResponseOfRefundPaymentTHgMB7oL eziResponseOfRefundPaymentTHgMB7oL = new EzidebitPaymentProcessor.EziResponseOfRefundPaymentTHgMB7oL();
        EzidebitPaymentProcessor.RefundPayment refundPayment = new EzidebitPaymentProcessor.RefundPayment();
        EzidebitPaymentProcessor.ProcessRefund_element processRefundElement = new EzidebitPaymentProcessor.ProcessRefund_element();
        EzidebitPaymentProcessor.ProcessRefundResponse_element processRefundResponseElement = new EzidebitPaymentProcessor.ProcessRefundResponse_element();

    }

    @IsTest
    static void testPaymentProcGetCustomerDetails(){
        EzidebitPaymentProcessor.CustomerDetails customerDetails = new EzidebitPaymentProcessor.CustomerDetails();
        customerDetails.Email = 'test';

        EzidebitPaymentProcessor.EziResponseOfCustomerDetailsTHgMB7oL customerDetailsTHgMB7oL = new EzidebitPaymentProcessor.EziResponseOfCustomerDetailsTHgMB7oL();
        customerDetailsTHgMB7oL.Error = 0;
        customerDetailsTHgMB7oL.Data = customerDetails;

        EzidebitPaymentProcessor.GetCustomerDetailsResponse_element element = new EzidebitPaymentProcessor.GetCustomerDetailsResponse_element();
        element.GetCustomerDetailsResult = customerDetailsTHgMB7oL;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        );

        Test.startTest();
        EzidebitStructs.CustomerDetails response = ezidebitPaymentProcessor.getCustomerDetails('test');
        Test.stopTest();

        System.assertEquals(true, response!=null);
    }

    @IsTest
    static void testPaymentProcChangeCustomerStatus(){
        EzidebitPaymentProcessor.EziResponseOfstring eziResponseOfstring = new EzidebitPaymentProcessor.EziResponseOfstring();
        eziResponseOfstring.Error =0;
        eziResponseOfstring.Data = 'test';

        EzidebitPaymentProcessor.ChangeCustomerStatusResponse_element element = new EzidebitPaymentProcessor.ChangeCustomerStatusResponse_element();
        element.ChangeCustomerStatusResult = eziResponseOfstring;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        );

        Test.startTest();
        Boolean testBool = ezidebitPaymentProcessor.changeCustomerStatus('test', 'test');
        Test.stopTest();

        System.assertEquals(false, testBool);
    }

    @IsTest
    static void testPaymentProcCreateSchedule(){
        EzidebitPaymentProcessor.EziResponseOfstring eziResponseOfstring = new EzidebitPaymentProcessor.EziResponseOfstring();
        eziResponseOfstring.Error =0;
        eziResponseOfstring.Data = 'test';

        EzidebitPaymentProcessor.CreateScheduleResponse_element element = new EzidebitPaymentProcessor.CreateScheduleResponse_element();
        element.CreateScheduleResult = eziResponseOfstring;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        );

        Test.startTest();
        Boolean testBool = ezidebitPaymentProcessor.createSchedule('test', 'test', '2020-08-11', 'test', 'test', 3, true, false, false, false, 5, 2, 10, true);
        Test.stopTest();

        System.assertEquals(false, testBool);
    }

    @IsTest
    static void testPaymentProcClearSchedule(){
        EzidebitPaymentProcessor.EziResponseOfstring eziResponseOfstring = new EzidebitPaymentProcessor.EziResponseOfstring();
        eziResponseOfstring.Error =0;
        eziResponseOfstring.Data = 'test';

        EzidebitPaymentProcessor.ClearScheduleResponse_element element = new EzidebitPaymentProcessor.ClearScheduleResponse_element();
        element.ClearScheduleResult = eziResponseOfstring;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        );

        Test.startTest();
        Boolean testBool = ezidebitPaymentProcessor.clearSchedule('test', 'test', true);
        Test.stopTest();

        System.assertEquals(false, testBool);
    }

    @IsTest
    static void testPaymentProcProcessRefund(){
        EzidebitPaymentProcessor.RefundPayment payment = new EzidebitPaymentProcessor.RefundPayment();
        payment.RefundResult = 'W';

        EzidebitPaymentProcessor.EziResponseOfRefundPaymentTHgMB7oL refundPaymentTHgMB7oL = new EzidebitPaymentProcessor.EziResponseOfRefundPaymentTHgMB7oL();
        refundPaymentTHgMB7oL.Error = 0;
        refundPaymentTHgMB7oL.Data = payment;

        EzidebitPaymentProcessor.ProcessRefundResponse_element element = new EzidebitPaymentProcessor.ProcessRefundResponse_element();
        element.ProcessRefundResult = refundPaymentTHgMB7oL;

        MockWebServiceResponseGenerator generator = new MockWebServiceResponseGenerator(element);
        Test.setMock(WebServiceMock.class, generator);

        EzidebitPaymentProcessor ezidebitPaymentProcessor = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        );

        Test.startTest();
        EzidebitStructs.RefundPayment response = ezidebitPaymentProcessor.processRefund('test', 5);
        Test.stopTest();

        System.assertEquals('Pending', response.RefundResult);
    }
}