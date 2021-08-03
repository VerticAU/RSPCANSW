({
    handleInit: function(cmp, event, helper){
        var request = {};

        var pageReference = cmp.get('v.pageReference');
        var filterRecordId;
        if(!$A.util.isUndefinedOrNull(pageReference)){
            filterRecordId = pageReference.state.c__filterRecordId;
            if(!$A.util.isEmpty(filterRecordId)){
                request.filterRecordId = filterRecordId;
            }
        }

        helper.execute(cmp, 'ClientNotesSearchMetaProc', request).then(function (response) {
            if (response.isValid) {
                cmp.set('v.meta', response);
                var curr = new Date;
                var firstDayOfWeek = new Date(curr.setDate(curr.getDate() - curr.getDay()+ (curr.getDay() === 0 ? -6:1) ));
                var lastDayOfWeek = new Date(curr.setDate(curr.getDate() - curr.getDay() +7));
                cmp.set('v.meta.dto.filter.startDate', $A.localizationService.formatDate(firstDayOfWeek, 'yyyy-MM-dd'));
                cmp.set('v.meta.dto.filter.endDate', $A.localizationService.formatDate(lastDayOfWeek, 'yyyy-MM-dd'));


                if(!$A.util.isEmpty(filterRecordId)){
                    helper.searchNotes(cmp, event, helper, cmp.get('v.meta.dto.filter'));
                }
            }
        })
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;
        helper.searchNotes(cmp, event, helper, filter);
    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },

    handleAllExpandedChange: function (cmp, event, helper) {
        var table = cmp.find('table');
        table.сhangeAllExpanded();
    },
})