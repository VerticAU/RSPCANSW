public without sharing class EzidebitGetPaymentDetailsProc extends vertic_AbstractProcessor {

    private npe01__OppPayment__c payment;

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.initData();
        this.getPaymentDetails();

        this.uow.commitWork();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void initData() {
        String recordId = this.request.getString('recordId');
        if (String.isBlank(recordId)) {
            if (this.request.has('payment')) {
                this.payment = (npe01__OppPayment__c) this.request.get('payment');
            } else {
                throw new vertic_Structs.ProcessException('"recordId" parameter is missing.');
            }
        } else {
            this.payment = (npe01__OppPayment__c) vertic_Utils.arrays.firstOrException([
                SELECT Id
                FROM npe01__OppPayment__c
                WHERE Id = :recordId
            ],
                'No Payment with Id: ' + recordId
            );
        }
    }

    private void getPaymentDetails() {
        EzidebitStructs.Payment payment = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        ).getPaymentDetail(
            this.payment.Id
        );

        savePayment(payment);
    }

    private void savePayment(EzidebitStructs.Payment payment) {

        this.payment.npsp_plus__Status__c = payment.PaymentStatus;
        this.payment.npe01__Paid__c = 'Processed'.equals(payment.PaymentStatus);
        if (this.payment.npe01__Paid__c) {
            this.payment.npe01__Written_Off__c = false;
        }
        this.payment.EziDebit_Transaction_ID__c = payment.PaymentID;
        this.payment.npe01__Payment_Date__c = payment.SettlementDate == null ? null : payment.SettlementDate.date();

        this.uow.registerDirty(this.payment);

        this.response.put('details', payment);
    }

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType>{
        npe01__OppPayment__c.SObjectType
    });

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

}