({
    searchNotes: function(cmp, event, helper, filter){
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'ClientNotesSearchProc',
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