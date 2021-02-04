({
    handleInit: function(cmp, event, helper){
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
});