({
    handleFilterChange: function(cmp, event, helper){

        // var filter = cmp.get('v.meta.dto.filter');

        cmp.set('v.columns', [
            {
                changeAction: 'add', label: '', type: 'button-icon', initialWidth: 50, firstPosition: true,
                typeAttributes: {
                    name: 'Add', iconName: 'utility:add',
                    doAction: function (row) {
                        helper.handleAction(cmp, helper, row);
                    }
                }
            }
        ]);

        // cmp.set('v.condition', 'Id IN (\'' + teamVolunteerIds.join('\',\'') + '\')');
    },

});