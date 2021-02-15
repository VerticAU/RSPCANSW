public without sharing class EzidebitAddBankDebitProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private npe01__OppPayment__c payment;


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.initData();
        this.createPaymentRequest();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void initData() {
        String recordId = this.request.getRequiredString('recordId');

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(npe01__OppPayment__c.SObjectType);
        queryFactory.selectFields(npe01__OppPayment__c.SObjectType.getDescribe().fields.getMap().keySet().clone());
        queryFactory.selectFields(new List<String> {
            'npe01__Opportunity__r.StageName',
            'npe01__Opportunity__r.Bank_Account_Name__c',
            'npe01__Opportunity__r.BSB__c',
            'npe01__Opportunity__r.Bank_Account_Number__c',
            'npe01__Opportunity__r.npe03__Recurring_Donation__r.Name',
            'npe01__Opportunity__r.npe03__Recurring_Donation__r.Account_Name__c',
            'npe01__Opportunity__r.npe03__Recurring_Donation__r.Account_Number__c',
            'npe01__Opportunity__r.npe03__Recurring_Donation__r.BSB__c',
            'npe01__Opportunity__r.npe03__Recurring_Donation__r.npsp__Status__c',
            'npe01__Opportunity__r.npsp__Primary_Contact__r.LastName',
            'npe01__Opportunity__r.npsp__Primary_Contact__r.FirstName',
            'npe01__Opportunity__r.npsp__Primary_Contact__r.Email',
            'npe01__Opportunity__r.npsp__Primary_Contact__r.MobilePhone',
            'npe01__Opportunity__r.npsp__Primary_Contact__r.LastName'
        });
        queryFactory.setCondition('Id = :recordId');
        this.payment = (npe01__OppPayment__c) vertic_Utils.arrays.firstOrException(Database.query(
            queryFactory.toSOQL()),
            'No Payment with Id: ' + recordId
        );

        if (!shouldBeProcessed(this.payment, this.payment.npe01__Opportunity__r)) {
            throw new vertic_Structs.ProcessException('The record does not meet the conditions and can\'t be processed. Contact your Administrator for more details.');
        }
    }

    private void createPaymentRequest() {
        String accountName = vertic_Utils.strings.defaultIfBlank(this.payment.npe01__Opportunity__r.Bank_Account_Name__c, this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__r.Account_Name__c);
        String accountNumber = vertic_Utils.strings.defaultIfBlank(this.payment.npe01__Opportunity__r.Bank_Account_Number__c, this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__r.Account_Number__c);
        String bsb = vertic_Utils.strings.defaultIfBlank(this.payment.npe01__Opportunity__r.BSB__c, this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__r.BSB__c);
        String customerId = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        ).addBankDebit(
            this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__c,
            this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__r.Name,
            this.payment.npe01__Opportunity__r.npsp__Primary_Contact__r.LastName,
            this.payment.npe01__Opportunity__r.npsp__Primary_Contact__r.FirstName,
            this.payment.npe01__Opportunity__r.npsp__Primary_Contact__r.Email,
            this.payment.npe01__Opportunity__r.npsp__Primary_Contact__r.MobilePhone,
            this.payment.Id,
            accountName,
            bsb,
            accountNumber,
            this.payment.npe01__Payment_Amount__c,
            this.payment.npe01__Scheduled_Date__c
        );

        if (!Test.isRunningTest()) {
            new EzidebitGetPaymentDetailsProc().process(new Map<String, Object>{
                'payment' => this.payment
            });
        }

        update new npe03__Recurring_Donation__c(Id = this.payment.npe01__Opportunity__r.npe03__Recurring_Donation__c, EziDebit_Customer_ID__c = customerId);

        this.response.put('EziDebitCustomerId', customerId);
        this.response.put('EziDebitPaymentId', this.payment.EziDebit_Transaction_ID__c);
    }

    /**
     * ==============================================================================================================
     *                                             PUBLIC METHODS
     * ==============================================================================================================
     */

    public static Boolean shouldBeProcessed(npe01__OppPayment__c payment, Opportunity opportunityVar) {
        if (payment != null && opportunityVar != null && !'true'.equalsIgnoreCase(vertic_SettingService.getValue('EZIDEBIT_PROCESSING_DISABLED'))) {
            Boolean isPaid = payment.npe01__Paid__c == true;
            Boolean isEziDebit = 'EziDebit'.equals(payment.npe01__Payment_Method__c);
            Boolean wasNotRequested = payment.EziDebit_Transaction_ID__c == null;
            Boolean isPledged = 'Pledged'.equals(opportunityVar.StageName);
            Boolean isRecurringDonation = opportunityVar.npe03__Recurring_Donation__c != null;
            Boolean isRecurringActive = isRecurringDonation && 'Active'.equals(opportunityVar.npe03__Recurring_Donation__r.npsp__Status__c);

            return !isPaid && isEziDebit && wasNotRequested && isPledged && isRecurringDonation && isRecurringActive;
        }
        return false;
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties: 
    // vertic_request
    // vertic_response

}