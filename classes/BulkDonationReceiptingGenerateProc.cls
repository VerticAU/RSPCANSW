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

    private static final Integer DEFAULT_RECEIPT_CHUNK_SIZE = 100;

    private void doSubmit() {
        this.processMailIds();
        this.processEmailIds();
    }

    private void processMailIds() {
        List<String> mailIds = this.request.getListAsStrings('mailIds');

        if (mailIds == null || mailIds.isEmpty()) { return; }

        List<vertic_Structs.SelectOption> links = new List<vertic_Structs.SelectOption>();
        List<List<Object>> mailIdsChunks = vertic_Utils.arrays.split(
            mailIds,
            DEFAULT_RECEIPT_CHUNK_SIZE,
            List<String>.class
        );

        for (List<Object> mailIdsChunk : mailIdsChunks) {
            PageReference pageRef = Page.vertic_Content;

            Map<String, String> pageRefParams = pageRef.getParameters();
            pageRefParams.put('proc', 'DirectMailReceipt');
            pageRefParams.put('ids', String.join((List<String>) mailIdsChunk, ','));
            pageRefParams.put('afterProc', 'true');

            links.add(new vertic_Structs.SelectOption(pageRef.getUrl(), ContributionService.formatReceiptFileName()));
        }

        this.response.put('receiptLinks', links);
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