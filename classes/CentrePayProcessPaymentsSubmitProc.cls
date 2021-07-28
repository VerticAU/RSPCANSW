public without sharing class CentrePayProcessPaymentsSubmitProc extends vertic_AbstractProcessor {
    /**
    * ==============================================================================================================
    *                                              PROCESS
    * ==============================================================================================================
    */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.matchPayments();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        String recordId = this.request.getRequiredString('recordId');

        this.paymentWrappers = new List<PaymentWrapper>();
        for(Map<String, Object> item: this.request.getListAsMap('payments')){
            try {
                this.paymentWrappers.add(new PaymentWrapper(item,recordId));
            } catch (Exception e){

            }
        }
    }

    private void matchPayments(){
        String batchId = Database.executeBatch(new CentrePayProcessPaymentsBatch(this.paymentWrappers), 1);
        this.response.getMapper().mapAnyValue('batchId', batchId);
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private List<PaymentWrapper> paymentWrappers;


    public class PaymentWrapper {

        public String batchId;

        public String centrelink_crn;
        public String customer_name;
        public Decimal deduction_amount;
        public Decimal fee_amount;

        public PaymentWrapper(Map<String, Object> item, String batchId){
            this.batchId = batchId;

            vertic_DTO dto = new vertic_DTO(item);
            this.centrelink_crn = dto.getRequiredString('centrelink_crn');
            this.customer_name = dto.getRequiredString('customer_name');
            this.deduction_amount = dto.getDecimal('deduction_amount');
            this.fee_amount = dto.getDecimal('fee_amount');
        }
    }

}