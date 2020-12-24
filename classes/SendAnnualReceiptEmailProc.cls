public class SendAnnualReceiptEmailProc extends vertic_SendEmailProc {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        String contactId = this.request.getRequiredString('contactId');
        this.contactVar = (Contact) vertic_Utils.arrays.firstOrException([
            SELECT Id, Name
            FROM Contact
            WHERE Id = :contactId
        ],
            'No Contact with Id: ' + contactId
        );

        if(!this.request.has('email.targetId')){
            this.request.put('email.targetId', contactVar.Id);
        }

        this.setOrgWideEmail();
        this.setSubject();

        super.process(request);

        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private Contact contactVar;

    private void setSubject(){
        if(this.request.has('email.subject')){ return; }

        this.request.getMapper().mapAnyValue('email.subject', 'Annual Receipt - ' + this.contactVar.Name);
    }

    private void setOrgWideEmail(){
        if(this.request.has('email.orgWideEmail')){ return; }

        this.request.getMapper().mapAnyValue(
            'email.orgWideEmail',
            vertic_SettingService.getValue('RECEIPT_FROM_EMAIL', 'donations@rspcansw.org.au')
        );
    }

    private void doSubmit() {

        if(this.response.isValid == true && this.response.getBoolean('isEmailSent') == true) {

            String contactId = this.request.getRequiredString('contactId');

            List<npe03__Recurring_Donation__c> recurringDonations = [SELECT Id, npsp_plus__Acknowledgment_Status__c FROM npe03__Recurring_Donation__c WHERE npe03__Contact__c =: contactId];
            for(npe03__Recurring_Donation__c recurringDonation : recurringDonations){
                recurringDonation.npsp_plus__Acknowledgment_Status__c = 'Acknowledged';
                recurringDonation.npsp_plus__Acknowledgment_Date__c = Date.today();
            }
            update recurringDonations;
        }

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