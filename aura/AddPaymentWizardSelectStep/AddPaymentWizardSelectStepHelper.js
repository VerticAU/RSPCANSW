({
    updatePaymentTableCondition: function(cmp){
        if(cmp.get('v.meta.dto.opportunity')){
            cmp.set('v.payCondition', 'npe01__Opportunity__c = \'' + cmp.get('v.meta.dto.opportunity.Id') + '\'');
        }
    },

    handlePaymentAction: function (cmp, helper, payment) {
        if($A.util.isUndefinedOrNull(payment)){ return; }

        cmp.set('v.meta.dto.payment', {
            Id: payment.id,
            Name: payment.name,
            npe01__Scheduled_Date__c: payment.npe01__scheduled_date__c,
            npe01__Payment_Date__c: payment.npe01__payment_date__c,
            npe01__Payment_Amount__c: payment.npe01__payment_amount__c,
            npe01__Payment_Method__c: payment.npe01__payment_method__c
        });
    },
});