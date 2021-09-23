({
    handleInit: function(cmp, event, helper){
        var request = {};
        cmp.set('v.meta.dto.filter.contactId', null);

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
                var curr = new Date();
                var startDate;
                var endDate;
                if(pageReference.state.c__filterRecordId != null){
                    startDate = new Date( curr.getFullYear(), 0 , 1);
                    endDate = new Date( curr.getFullYear(), 11, 31);
                } else {
                    startDate = new Date(curr.setDate(curr.getDate() - curr.getDay()+ (curr.getDay() === 0 ? -6:1) ));
                    endDate = new Date(curr.setDate(curr.getDate() - curr.getDay() +7));
                }

                cmp.set('v.meta.dto.filter.startDate', $A.localizationService.formatDate(startDate, 'yyyy-MM-dd'));
                cmp.set('v.meta.dto.filter.endDate', $A.localizationService.formatDate(endDate, 'yyyy-MM-dd'));

                console.log('ClientNotesSearch v.meta.dto.filter == >> ' + JSON.stringify(cmp.get('v.meta.dto.filter')));

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