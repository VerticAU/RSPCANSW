public class BulkContributionManagementPaymentProc extends vertic_AbstractProcessor {

    /**
      * ==============================================================================================================
      *                                              PROCESS
      * ==============================================================================================================
      */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void doSubmit() {

        Map<String, String> paymentIntentRequest =  new Map<String, String>{
            'amount' => '' + npsp_plus.Stripe.formatAmount(this.request.getDecimal('amount')),
            'currency' => 'aud',
            'confirm' => String.valueOf(true),
            'customer' => this.request.getRequiredString('stripeCustomerId'),
            'payment_method' => this.request.getRequiredString('stripePaymentMethodId')
        };

        if(this.request.getString('stripeAccountId') != null){
            paymentIntentRequest.put('on_behalf_of', this.request.getString('stripeAccountId'));
        }

        npsp_plus.vertic_DTO paymentIntentResponse;
        try{
            if(Test.isRunningTest()){
                paymentIntentResponse = new npsp_plus.vertic_DTO(new Map<String, Object>{ 'id' => 'test' });
            } else {
                paymentIntentResponse = new npsp_plus.Stripe().paymentIntents.create(paymentIntentRequest);
            }
        } catch (npsp_plus.Stripe.StripeException ex) {
            throw new vertic_Structs.ProcessException(ex.response.getRequiredString('error.message'));
        }

        String paymentIntentId = paymentIntentResponse.getRequiredString('id');

        this.response.put('paymentIntentId', paymentIntentId);

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