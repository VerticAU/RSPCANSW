public without sharing class BulkDonationReceiptingGenerateProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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
        this.processEmailIds();
    }

    private void processEmailIds() {
        List<String> emailIds = this.request.getListAsStrings('emailIds');
        Map<String, Object> filters = (Map<String, Object>) this.request.get('filter');
        if (emailIds != null && !emailIds.isEmpty()) {
            vertic_AsyncProcess emailAsyncProcess = getEmailsAsyncProc(
                new Set<String>(emailIds),
                filters
            );
            this.response.getMapper().mapAnyValue('asyncJobId', emailAsyncProcess.enqueueAndRun());
        }
    }

    public static vertic_AsyncProcess getEmailsAsyncProc(Set<String> emailIds, Map<String, Object> params) {

        vertic_AsyncProcess asyncProcess = new vertic_AsyncProcess();

        for (String recordId : emailIds) {
            asyncProcess.add(new Vertic_Async_Process__c(
                Autorun__c = false,
                Processor__c = '' + vertic_DMLProc.class,
                Payload__c = JSON.serialize(new Map<String, Object>{
                    'sObjectType' => '' + Opportunity.SObjectType,
                    'upsert' => new List<Object>{
                        new Opportunity(
                            Id = recordId,
                            npsp__Acknowledgment_Status__c = 'Email Acknowledgment Now'
                        )
                    }
                })
            ));
        }

        return asyncProcess;
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