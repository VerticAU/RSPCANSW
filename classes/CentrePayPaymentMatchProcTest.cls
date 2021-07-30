@IsTest
private class CentrePayPaymentMatchProcTest {
    @IsTest
    static void testBehavior() {

        Contact contact = new Contact(
            LastName = 'test',
            Centrelink_Reference_Number_CRN__c = '1111'
        );
        insert contact;

        Opportunity opportunity = new Opportunity(
            Name = 'test',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            npsp__Primary_Contact__c = contact.Id
        );
        insert opportunity;
        System.debug('opportunity ==> ' + opportunity);

        npe01__OppPayment__c payment = new npe01__OppPayment__c(
            npe01__Opportunity__c = opportunity.Id,
            npe01__Payment_Amount__c = 10,
            npe01__Payment_Date__c = Date.today(),
            npe01__Paid__c = false,
            npe01__Written_Off__c = false
        );
        insert payment;
        System.debug('payment ==> ' + payment);

        Map<String, Object> request = new Map<String, Object>{
            'centrelink_crn' => '1111',
            'deduction_amount' => '10',
            'delivery_date' => Date.today()
        };


        new CentrePayPaymentMatchProc().process(request);
    }
}