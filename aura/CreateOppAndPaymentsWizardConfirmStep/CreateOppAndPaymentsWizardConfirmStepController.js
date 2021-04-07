({
    handleInit: function(cmp, event, helper){
        console.log(JSON.stringify(cmp.get('v.meta')));
        helper.calculateOpportunityAmount(cmp, helper);
        helper.calculatePaidAmount(cmp, helper);

        cmp.set('v.columns',[
            {label: 'Payment Method', fieldName: 'npe01__Payment_Method__c', type: 'text', editable: false},
            {label: 'Payment Amount', fieldName: 'npe01__Payment_Amount__c', type: 'currency', editable: true, typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2}},
            {label: 'Status', fieldName: 'npsp_plus__Status__c', type: 'text', editable: false},
            {type: 'button-icon', initialWidth: 50, typeAttributes: {
                    iconName: 'utility:close',
                    name: 'delete',
                    disabled: false
                }
            }
        ]);
    },

    handleRowAction: function (cmp, event, helper) {
        var row = event.getParam('row');
        var filteredPayments = helper.filterArray(cmp.get('v.meta.dto.payments'), 'creationDate', row.creationDate, 'delete')
        cmp.set('v.meta.dto.payments', filteredPayments);
        helper.calculatePaidAmount(cmp, helper);
    },

    handleAddPayment : function (cmp, event, helper) {
        cmp.set('v.paymentValidationEnabled', true)
        if(cmp.validate()){
            var payments = cmp.get('v.meta.dto.payments') || [];

            var draft = cmp.get('v.meta.dto.draftPayment');
            draft.creationDate = Date.now();
            payments.push(draft);

            cmp.set('v.meta.dto.payments', payments);
            cmp.set('v.meta.dto.draftPayment', {});
            helper.calculatePaidAmount(cmp, helper);
        } else{
            cmp.set('v.paymentValidationEnabled', false)
        }
    },

});