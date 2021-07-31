public without sharing class CentrePayPaymentMatchProc extends vertic_AbstractProcessor {


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.match();

        return this.response;
    }

    private void match(){
        String centrelinkCRN = this.request.getRequiredString('centrelink_crn');
        Decimal deductionAmount = this.request.getDecimal('deduction_amount');
        Date paymentDate = this.request.getISODate('delivery_date');

        Contact contact = (Contact) vertic_Utils.arrays.firstOrException([
            SELECT Id
            FROM Contact
            WHERE Centrelink_Reference_Number_CRN__c =: centrelinkCRN
        ], 'Contact with CRN = ' + centrelinkCRN + ' does not exists.');

        List<npe01__OppPayment__c> payments = [
            SELECT Id
            FROM npe01__OppPayment__c
            WHERE npe01__Opportunity__r.npsp__Primary_Contact__c =: contact.Id
            AND npe01__Opportunity__r.StageName NOT IN ('Closed Won', 'Closed Lost')
            AND npe01__Payment_Amount__c =: deductionAmount
            AND (
                npe01__Payment_Date__c =: paymentDate
                OR npe01__Scheduled_Date__c =: paymentDate
            )
            AND npe01__Paid__c = FALSE
            AND npe01__Written_Off__c = FALSE
        ];

        if(payments.isEmpty()){
            throw new vertic_Structs.MissingDataException('Payment is not found.');
        } else if (payments.size() > 1){
            throw new vertic_Structs.MissingDataException('Several Payments were found: ' + String.join(
                new List<String>(vertic_Utils.sObjects.getStringFieldValues(payments, 'Id')), ', '
            ));
        } else {
            npe01__OppPayment__c payment = payments[0];
            payment.npe01__Paid__c = true;
            if(payment.npe01__Payment_Date__c == null){
                payment.npe01__Payment_Date__c = paymentDate;
            }
            update payment;
            this.response.put('paymentId', payment.Id);
        }
    }

}