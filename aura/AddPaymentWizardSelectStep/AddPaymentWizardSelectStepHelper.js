({
    updatePaymentTableCondition: function(cmp){
        if(cmp.get('v.meta.dto.opportunity')){
            cmp.set('v.payCondition', 'npe01__Paid__c = FALSE AND npe01__Opportunity__c = \'' + cmp.get('v.meta.dto.opportunity.Id') + '\'');
        }
    },

    handlePaymentAction: function (cmp, helper, payment) {
        if($A.util.isUndefinedOrNull(payment)){ return; }

        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT Id, Name, npe01__Payment_Method__c, npe01__Payment_Date__c, ' +
                    'npe01__Scheduled_Date__c, npe01__Payment_Amount__c, Cheque_Number__c, ' +
                    'BSB__c, Bank_Account_Number__c, Name_on_Cheque__c, Stripe_Customer_Id__c, ' +
                    'Stripe_Payment_Id__c, npsp__Payment_Acknowledgment_Status__c FROM npe01__OppPayment__c WHERE Id = \'' + payment.id + '\' LIMIT 1'
            }
        ).then(function (response) {
            if (response.isValid) {
                if(response.dto.records[0]) {
                    cmp.set('v.meta.dto.payment', response.dto.records[0]);
                    cmp.set('v.meta.dto.payment.npe01__Opportunity__c', cmp.get('v.meta.dto.opportunity.Id'));
                }
            }
        });
    },
});