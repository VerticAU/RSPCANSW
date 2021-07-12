({
    handleFilterChange: function(cmp, event, helper){

        // var filter = cmp.get('v.meta.dto.filter');
        // if(!filter.startDate){
        //     helper.utils(cmp).showToast({
        //         message: 'Start Date is required',
        //         type: 'warning'
        //     });
        //     return;
        // }
        //
        // if(!filter.endDate){
        //     helper.utils(cmp).showToast({
        //         message: 'End Date is required',
        //         type: 'warning'
        //     });
        //     return;
        // }

        var event = cmp.getEvent('onSearch');
        event.setParams({
            payload: {
                filter: cmp.get('v.meta.dto.filter')
            }
        });
        event.fire();
    },

})