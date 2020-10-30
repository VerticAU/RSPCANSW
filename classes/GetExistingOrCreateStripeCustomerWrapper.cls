public without sharing class GetExistingOrCreateStripeCustomerWrapper extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        vertic_Response response = new vertic_Response(
            new npsp_plus.GetExistingOrCreateStripeCustomerProc().process(
                new npsp_plus.vertic_Request(request.getMap())
            ).getMap()
        );

        return response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

}