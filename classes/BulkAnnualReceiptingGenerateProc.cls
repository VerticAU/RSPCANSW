public without sharing class BulkAnnualReceiptingGenerateProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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
        Map<String, Object> filters = (Map<String, Object>) this.request.get('filter');

        Date startDate = this.request.getISODate('filter.startDate');
        Date endDate = this.request.getISODate('filter.endDate');

        if (mailIds == null || mailIds.isEmpty()) {
            return;
        }

        List<vertic_Structs.SelectOption> links = new List<vertic_Structs.SelectOption>();
        List<List<Object>> mailIdsChunks = vertic_Utils.arrays.split(
            mailIds,
            DEFAULT_RECEIPT_CHUNK_SIZE,
            List<String>.class
        );

        String formattedFY = String.format('Annual Donation Receipts - {0}.pdf', new List<String>{GetFinancialYearsMetaProc.formatFinancialYear(startDate, endDate)});

        for (List<Object> mailIdsChunk : mailIdsChunks) {
            PageReference pageRef = Page.vertic_Content;

            Map<String, String> pageRefParams = pageRef.getParameters();
            pageRefParams.put('proc', 'AnnualReceipt');
            pageRefParams.put('ids', String.join((List<String>) mailIdsChunk, ','));
            pageRefParams.put('afterProc', 'false'); // creates task

            for (String filterKey : filters.keySet()) {
                pageRefParams.put(filterKey, '' + filters.get(filterKey));
            }

            links.add(new vertic_Structs.SelectOption(pageRef.getUrl(), formattedFY));
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

        for (String donorId : emailIds) {
            Map<String, Object> contentParams = new Map<String, Object>{
                'donorIds' => donorId,
                'renderAs' => 'html'
            };

            contentParams.putAll(params);

            vertic_SendEmailProc.EmailAsyncProcess emailAsyncProcess = new vertic_SendEmailProc.EmailAsyncProcess(
                'AnnualReceipt',
                contentParams
            ).setSaveAsActivity(true).setPayloadParam('donorId', donorId);

            Vertic_Async_Process__c emailAsyncProcessVar = emailAsyncProcess.toAsyncProcess(SendAnnualReceiptEmailProc.class);
            emailAsyncProcessVar.Autorun__c = false;

            asyncProcess.add(emailAsyncProcessVar);
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