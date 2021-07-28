public without sharing class CentrePayProcessPaymentsBatch implements Database.Batchable<CentrePayProcessPaymentsSubmitProc.PaymentWrapper>, Database.Stateful {

    private List<CentrePayProcessPaymentsSubmitProc.PaymentWrapper> paymentWrappers;
    public CentrePayProcessPaymentsBatch(List<CentrePayProcessPaymentsSubmitProc.PaymentWrapper> paymentWrappers){
        this.paymentWrappers = paymentWrappers;
    }

    public Iterable<CentrePayProcessPaymentsSubmitProc.PaymentWrapper> start(Database.BatchableContext context) {
        return paymentWrappers;
    }

    public void execute(Database.BatchableContext context, List<CentrePayProcessPaymentsSubmitProc.PaymentWrapper> scope) {
        try {
            new CentrePayPaymentMatchProc().process(new Map<String, Object>{
                'wrapper' => scope[0]
            });
        } catch (Exception e){

        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('CentrePayProcessPaymentsBatch finished!');
    }

}