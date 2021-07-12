({
    handleInit: function(cmp, event, helper){
        cmp.set('v.meta.dto.filter', {
            startDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd'),
            endDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd')
        });
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;

        helper.searchNotes(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.notes.records);
            table.set('v.hasMore', response.dto.contributions.hasMore);
            table.set('v.limit', response.dto.notes.limit);
            table.selectAll();
            // helper.calculateTotals(cmp, event, helper, response.dto.contributions.records);
        });
    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },
})