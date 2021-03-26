public class RecurringReceiptTemplateQAMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new vertic_MetadataProcessor.MetadataRequest() : (vertic_MetadataProcessor.MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.init();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {

        String recordId = this.request.getRequiredString('recordId');

        Campaign campaignVar = (Campaign) vertic_Utils.arrays.firstOrException([
            SELECT Id, Recurring_Acknowledgement_Template_Name__c
            FROM Campaign
            WHERE Id = :recordId
        ],
            'No Campaign with Id: ' + recordId
        );

        if(String.isNotBlank(campaignVar.Recurring_Acknowledgement_Template_Name__c)){
            EmailTemplate emailTemplateVar = (EmailTemplate) vertic_Utils.arrays.firstOrNull(
                [SELECT Id FROM EmailTemplate WHERE DeveloperName = :campaignVar.Recurring_Acknowledgement_Template_Name__c]
            );

            if(emailTemplateVar != null){
                this.response.put('recurringAcknowledgementTemplateId', emailTemplateVar.Id);
            }
        }

    }


    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_meta_request
    // vertic_meta_response

}