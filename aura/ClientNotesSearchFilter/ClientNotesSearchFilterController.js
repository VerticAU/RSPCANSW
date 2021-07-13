({
    handleFilterChange: function(cmp, event, helper){

        console.log(JSON.stringify(cmp.get('v.meta')));
        var filter = cmp.get('v.meta.dto.filter');
        if(!filter.startDate){
            helper.utils(cmp).showToast({
                message: 'Start Date is required',
                type: 'warning'
            });
            return;
        }

        if(!filter.endDate){
            helper.utils(cmp).showToast({
                message: 'End Date is required',
                type: 'warning'
            });
            return;
        }

        var onSearchEvt = cmp.getEvent('onSearch');
        onSearchEvt.setParams({
            payload: {
                filter: cmp.get('v.meta.dto.filter')
            }
        });
        onSearchEvt.fire();
    },

})