public class FlowEventGetProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = (vertic_RestService.Request) request;
        this.response = (vertic_RestService.Response) super.response;

        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void doSubmit() {
        String flowSetting = this.request.params.get('flowSetting');
        vertic_Utils.objects.throwIfBlank(flowSetting, 'flowSetting URL param is required!');

//        hey.Logger.debug(JSON.serialize(this.request));

        Database.SaveResult saveResult = EventBus.publish(new Flow_Event__e(
            Flow_Setting__c = flowSetting,
            Payload__c = this.request.getJSON()
        ));

//        hey.Logger.debug(saveResult);
//        hey.Logger.debug('PE published');
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response

    /** ============================================================================================================= */

    private vertic_RestService.Response response;

    protected override vertic_Response getResponseInstance() {
        return new vertic_RestService.Response();
    }

    /** ============================================================================================================= */

    private vertic_RestService.Request request;

    public override Type getRequestType() {
        return vertic_RestService.Request.class;
    }

    public override vertic_Request getRequestInstance(String requestJSON) {
        return (vertic_RestService.Request) JSON.deserialize(requestJSON, this.getRequestType());
    }


}