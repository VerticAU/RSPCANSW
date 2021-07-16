({
    searchNotes: function(cmp, event, helper, filter){
        helper.executeSearchRequest(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.notes.records);
            table.set('v.hasMore', response.dto.notes.hasMore);
            table.set('v.limit', response.dto.notes.limit);
            table.сhangeAllExpanded();
            helper.calculateTotals(cmp, event, helper, response.dto.notes.records);
        });
    },

    executeSearchRequest: function(cmp, event, helper, filter){
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'ClientNotesSearchSubmitProc',
                {
                    filter: filter
                },
                resolve,
                reject
            );
        }));
    },

    calculateTotals: function (cmp, event, helper, records) {
        records = records || [];
        var totals = {
            total: records.length,
        };
        cmp.set('v.meta.dto.totals', totals);
    }
})