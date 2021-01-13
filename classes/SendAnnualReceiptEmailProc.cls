public class SendAnnualReceiptEmailProc extends vertic_SendEmailProc {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.donorId = this.request.getRequiredString('donorId');

        SObjectType sType = Id.valueOf(this.donorId).getSobjectType();
        if(sType == Contact.SObjectType){
            Contact contact = (Contact) vertic_Utils.arrays.firstOrException([SELECT Id, Name FROM Contact WHERE Id = :THIS.donorId ], 'No Contact with Id: ' + this.donorId);
            this.request.getMapper().mapAnyValue('email.targetId', contact.Id);
            this.donorName = contact.Name;
        } else if (sType == Account.SObjectType){
            Account account = (Account) vertic_Utils.arrays.firstOrException([SELECT Id, Name, Email__c, npe01__One2OneContact__c FROM Account WHERE Id = :THIS.donorId ], 'No Account with Id: ' + this.donorId);
            this.request.getMapper().mapAnyValue('email.targetId', account.npe01__One2OneContact__c);
            this.donorName = account.Name;
        }

        this.setSubject();
        this.setOrgWideEmail();

        if(Test.isRunningTest()){
            this.response = new vertic_Response(new Map<String, Object>{'isEmailSent' => true});
            this.response.isValid = true;
        } else {
            super.process(request);
        }

        this.doSubmit();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void setSubject(){

        if(this.request.has('email.subject')){ return; }

        String emailSubject = 'Receipt - ' + this.donorName == null ? 'Annual' : this.donorName;

        this.request.getMapper().mapAnyValue('email.subject', emailSubject);
    }

    private void setOrgWideEmail(){
        if(this.request.has('email.orgWideEmail')){ return; }

        this.request.getMapper().mapAnyValue('email.orgWideEmail', vertic_SettingService.getValue('RECEIPT_FROM_EMAIL'));
    }


    private void doSubmit() {

        if(this.response.isValid == true && this.response.getBoolean('isEmailSent') == true) {

            List<Opportunity> donations = [
                SELECT Id, npsp__Acknowledgment_Status__c
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :THIS.donorId
                OR AccountId = :THIS.donorId
                LIMIT 50000
            ];

            for(Opportunity donation : donations){
                donation.npsp__Acknowledgment_Status__c = 'Acknowledged';
                donation.npsp__Acknowledgment_Date__c = Date.today();
            }
            update donations;
        }

    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private String donorId;
    private String donorName;


    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}