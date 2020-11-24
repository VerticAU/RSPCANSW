public without sharing class EzidebitGetDDPaymentsProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.initData();
        this.getPayments();

        this.uow.commitWork();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private Contact contactVar;
    private npe03__Recurring_Donation__c recurringDonation;
    private Date lastPaymentDate;

    private void getPayments() {
        List<EzidebitStructs.Payment> payments = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        ).getPayments(
            'SUCCESSFUL',
            'ALL',
            'SCHEDULED',
            null,
            this.lastPaymentDate == null ? null : String.valueOf(this.lastPaymentDate),
            String.valueOf(Date.today()),
            'PAYMENT',
            null,
            this.recurringDonation.Id
        );

        this.savePayments(payments);
    }

    private void savePayments(List<EzidebitStructs.Payment> payments) {
        Opportunity opp;
        npe01__OppPayment__c oppPayment;
        for (EzidebitStructs.Payment payment : payments) {
            opp = new Opportunity(
                Name = payment.PaymentID,
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Donation'),
                Amount = payment.PaymentAmount,
                CloseDate = payment.SettlementDate.date(),
                StageName = 'Closed Won',
                npe01__Do_Not_Automatically_Create_Payment__c = true,
                npe03__Recurring_Donation__c = this.recurringDonation.Id
            );
            oppPayment = new npe01__OppPayment__c(
                npe01__Payment_Method__c = 'Direct Debit',
                npsp_plus__Status__c = payment.PaymentStatus,
                npe01__Paid__c = true,
                EziDebit_Transaction_ID__c = payment.PaymentID,
                npe01__Payment_Date__c = payment.SettlementDate.date(),
                npe01__Payment_Amount__c = payment.PaymentAmount
            );

            this.uow.registerNew(opp);
            this.uow.registerNew(oppPayment);
            this.uow.registerRelationship(oppPayment, npe01__OppPayment__c.npe01__Opportunity__c, opp);
            this.uow.registerRelationship(opp, Opportunity.npsp__Primary_Contact__c, this.contactVar);
        }
    }

    private void initData() {
        String recordId = this.request.getRequiredString('recordId');
        this.recurringDonation = (npe03__Recurring_Donation__c) vertic_Utils.arrays.firstOrException([
            SELECT Id,
                npe03__Last_Payment_Date__c
            FROM npe03__Recurring_Donation__c
            WHERE Id = :recordId
        ],
            'No Recurring Donation with Id: ' + recordId
        );

        this.lastPaymentDate = this.recurringDonation.npe03__Last_Payment_Date__c == null ? this.recurringDonation.CreatedDate.date() : this.recurringDonation.npe03__Last_Payment_Date__c;
    }

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType>{
        Opportunity.SObjectType,
        npe01__OppPayment__c.SObjectType
    });

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

}