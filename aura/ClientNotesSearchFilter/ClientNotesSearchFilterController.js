({
    handleFilterChange: function(cmp, event, helper){

        console.log(JSON.stringify(cmp.get('v.meta')));
        var filter = cmp.get('v.meta.dto.filter');

        if( filter.startDate === null &&
            filter.endDate === null &&
            (filter.contactId === undefined || filter.contactId === '') &&
            (filter.userId === undefined || filter.userId === '') &&
            (filter.caseId === undefined || filter.caseId === '') &&
            (filter.programEngagementId === undefined || filter.programEngagementId === '') &&
            (filter.typeOfInteraction === undefined || filter.typeOfInteraction === ''))
        {
            helper.utils(cmp).showToast({
                message: 'At least 1 filter condition is required before searching',
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