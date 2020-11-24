public class EzidebitGetPaymentsProc extends vertic_AbstractProcessor{

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
    private Date lastPaymentDate;

    private void getPayments() {
        System.debug('EzidebitGetPaymentsProc -> doSync');

        List<EzidebitStructs.Payment> payments = new EzidebitPaymentProcessor(
            payment_ProcessorFactory.getGatewayCredentials('EziDebit')
        ).getPayments(
            'SUCCESSFUL',
            'ALL',
            'BPAY',
            this.contactVar.BPAY_CRN__c,
            this.lastPaymentDate == null ? null : String.valueOf(this.lastPaymentDate),
            String.valueOf(Date.today()),
            'PAYMENT',
            null,
            null
        );

        this.savePayments(payments);
    }

    private void savePayments(List<EzidebitStructs.Payment> payments) {
        Opportunity opp;
        npe01__OppPayment__c oppPayment;
        for(EzidebitStructs.Payment payment : payments){
            opp = new Opportunity(
                Name = payment.PaymentID,
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Donation'),
                Amount = payment.PaymentAmount,
                CloseDate = payment.SettlementDate.date(),
                StageName = 'Closed Won',
                npe01__Do_Not_Automatically_Create_Payment__c = true
            );
            oppPayment = new npe01__OppPayment__c(
                npe01__Payment_Method__c = payment.PaymentSource,
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

        if(payments.size() > 0){
            updateContact();
        }
    }

    private void updateContact() {
        this.contactVar.Last_Payment_Date__c = Date.today();
        this.uow.registerDirty(this.contactVar);
    }

    private void initData(){
        this.contactVar = (Contact) vertic_Utils.arrays.firstOrException([
            SELECT Id,
                BPAY_CRN__c,
                Last_Payment_Date__c,
                CreatedDate
            FROM Contact
            WHERE Id = :THIS.request.getRequiredString('recordId')
        ],
            'No Contact with Id: ' + this.request.getRequiredString('recordId')
        );

        this.lastPaymentDate = this.contactVar.Last_Payment_Date__c == null ? this.contactVar.CreatedDate.date() : this.contactVar.Last_Payment_Date__c;
    }

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType>{
        Contact.SObjectType,
        Opportunity.SObjectType,
        npe01__OppPayment__c.SObjectType
    });

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

}