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

        npsp_plus.StripePaymentIntents.PaymentIntent paymentIntent = new npsp_plus.StripePaymentIntents.PaymentIntent(
            this.request.getDecimal('amount'),
            this.request.getRequiredString('stripeCustomerId'),
            this.request.getRequiredString('stripePaymentMethodId')
        );

        paymentIntent.setMOTO(true);

        npsp_plus.vertic_DTO paymentIntentResponse;
        try{
            paymentIntentResponse = new npsp_plus.Stripe().paymentIntents.create(paymentIntent);
        } catch (npsp_plus.Stripe.StripeException ex) {
            throw new vertic_Structs.ProcessException(ex.response.getRequiredString('error.message'));
        }

        String paymentIntentId = paymentIntentResponse.getRequiredString('id');

//        try{
//            paymentIntentResponse = new npsp_plus.Stripe().paymentIntents.send(
//                new Map<String, String>{
//                    'payment_method' => paymentIntent.paymentMethod
//                },
//                'payment_intents/' + paymentIntentId + '/confirm', 'POST'
//            );
//        } catch (npsp_plus.Stripe.StripeException ex) {
//            throw new vertic_Structs.ProcessException(ex.response.getRequiredString('error.message'));
//        }

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