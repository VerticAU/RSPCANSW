({
    handleInit: function(cmp, event, helper){
        helper.execute(cmp, 'ClientNotesSearchMetaProc', {}).then(function (response) {
            if (response.isValid) {
                cmp.set('v.meta', response);
                cmp.set('v.meta.dto.filter', {
                    startDate: $A.localizationService.formatDate(new Date(2020,1,1), 'yyyy-MM-dd'),
                    endDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd')
                });
            }
        })
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;

        helper.searchNotes(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.notes.records);
            table.set('v.hasMore', response.dto.notes.hasMore);
            table.set('v.limit', response.dto.notes.limit);
            table.сhangeAllExpanded();
            helper.calculateTotals(cmp, event, helper, response.dto.notes.records);
        });
    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },

    handleAllExpandedChange: function (cmp, event, helper) {
        var table = cmp.find('table');
        table.сhangeAllExpanded();
    },
})