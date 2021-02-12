({
    handleInit: function(cmp, event, helper){
        console.log(JSON.stringify(cmp.get('v.meta')));
        cmp.set('v.oppColumns', [
            {
                changeAction: 'add', label: '', type: 'button-icon', initialWidth: 50, firstPosition: true,
                typeAttributes: {
                    name: 'Add', iconName: 'utility:add',
                    doAction: function (row) {
                        helper.handleOpportunityAction(cmp, helper, row);
                    }
                }
            }
        ]);

        helper.filterChange(cmp, helper);
    },

    handleFilterChange: function(cmp, event, helper){
        helper.filterChange(cmp, helper);
    },
});