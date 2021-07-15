({
    handleInit: function(cmp, event, helper){
        helper.searchNotes(cmp, event, helper).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.notes.records);
            table.set('v.hasMore', response.dto.notes.hasMore);
            table.set('v.limit', response.dto.notes.limit);
            table.сhangeAllExpanded();
            helper.calculateTotals(cmp, event, helper, response.dto.notes.records);
        });
    },

    handleAllExpandedChange: function (cmp, event, helper) {
        var table = cmp.find('table');
        table.сhangeAllExpanded();
    },
});