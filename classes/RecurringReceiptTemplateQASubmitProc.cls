public class RecurringReceiptTemplateQASubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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

        String recurringAcknowledgementTemplateAPIName;
        String recurringAcknowledgementTemplateId = this.request.getString('recurringAcknowledgementTemplateId');

        if(String.isNotBlank(recurringAcknowledgementTemplateId)){
            EmailTemplate emailTemplateVar = (EmailTemplate)vertic_Utils.arrays.firstOrNull(
                [SELECT Id, DeveloperName FROM EmailTemplate WHERE Id = :recurringAcknowledgementTemplateId]
            );
            if(emailTemplateVar != null){
                recurringAcknowledgementTemplateAPIName = emailTemplateVar.DeveloperName;
            }
        }

        update new Campaign(
            Id = this.request.getRequiredString('campaignId'),
            Recurring_Acknowledgement_Template_Name__c = recurringAcknowledgementTemplateAPIName
        );
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