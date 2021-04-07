({
    calculateOpportunityAmount: function(cmp, helper){
        var amount = 0;

        var productItems = cmp.get('v.meta.dto.productItems') || [];
        productItems.forEach(item => {
            if(item.price && item.quantity){
                amount += item.price * item.quantity;
            }
        });

        cmp.set('v.meta.dto.opportunity.Amount', amount);
        cmp.set('v.meta.dto.paidAmount', 0);
    },

    calculatePaidAmount: function(cmp, helper){
        var amount = 0;

        var payments = cmp.get('v.meta.dto.payments') || [];
        payments.forEach(payment => {
            if(payment.npe01__Payment_Amount__c){
                amount = parseInt(amount) + parseInt(payment.npe01__Payment_Amount__c);
            }
        });
        cmp.set('v.meta.dto.paidAmount', amount);
    },

    filterArray: function (arr, filterKey, filterValue, mode) {
        return arr.filter(function(el) {
            switch (mode) {
                case 'find':
                    return el[filterKey] === filterValue;
                case 'delete':
                    return el[filterKey] !== filterValue;
            }
        });
    },
});