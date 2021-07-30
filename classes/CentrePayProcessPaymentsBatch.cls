public without sharing class CentrePayProcessPaymentsBatch implements Database.Batchable<Map<String, Object>>, Database.Stateful {

    private String batchId;
    private List<Map<String, Object>> paymentRows;

    public CentrePayProcessPaymentsBatch(List<Map<String, Object>> paymentRows, String batchId){
        this.batchId = batchId;
        this.paymentRows = paymentRows;
    }

    public Iterable<Map<String, Object>> start(Database.BatchableContext context) {
        return paymentRows;
    }

    public void execute(Database.BatchableContext context, List<Map<String, Object>> scope) {

        Batch_Line_Item__c lineItem = new Batch_Line_Item__c(
            Batch__c = this.batchId,
            Status__c = 'Completed'
        );
        try {
            if(scope[0] == null){
                throw new vertic_Structs.MissingDataException('Row is empty...');
            }
            vertic_Response response = new CentrePayPaymentMatchProc().process(scope[0]);
            lineItem.Payment__c = response.getRequiredString('paymentId');
        } catch (Exception e){
            lineItem.Status__c = 'Failed';
            lineItem.Details__c = e.getMessage();
        } finally {
            lineItem.Payload__c = scope[0] != null ? JSON.serialize(scope[0]) : '{}';
            insert lineItem;
        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('CentrePayProcessPaymentsBatch finished!');
    }

}