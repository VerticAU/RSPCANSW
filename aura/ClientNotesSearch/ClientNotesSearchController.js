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
                var today = new Date();
                cmp.set('v.meta.dto.filter.endDate', $A.localizationService.formatDate(today, 'yyyy-MM-dd'));
                cmp.set('v.meta.dto.filter.startDate', $A.localizationService.formatDate(today.setFullYear(today.getFullYear() - 1), 'yyyy-MM-dd'));

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