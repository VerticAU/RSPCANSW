({
    handleInit: function(cmp, event, helper){
        console.log('dto', JSON.stringify(cmp.get('v.meta.dto')));

        cmp.set('v.payColumns', [
            {
                changeAction: 'add', label: '', type: 'button-icon', initialWidth: 50, firstPosition: true,
                typeAttributes: {
                    name: 'Add', iconName: 'utility:add',
                    doAction: function (row) {
                        helper.handlePaymentAction(cmp, helper, row);
                    }
                }
            }
        ]);

        helper.updatePaymentTableCondition(cmp);
        cmp.find('pay-data-table').refresh();

    },

    handleNewPayment: function(cmp, event, helper){
        cmp.set('v.meta.dto.payment', {
            npe01__Opportunity__c: cmp.get('v.meta.dto.opportunity.Id'),
            Batch__c: cmp.get('v.meta.dto.batch.Id'),
            npe01__Payment_Date__c: new Date().toISOString()
        });
    },
});