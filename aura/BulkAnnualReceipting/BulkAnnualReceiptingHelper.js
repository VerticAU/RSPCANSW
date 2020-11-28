({
    search: function(cmp, event, helper, filter){
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'BulkAnnualReceiptingSearchProc',
                {
                    filter: filter
                },
                resolve, reject
            );
        }));
    },

    calculateTotals: function (cmp, event, helper, contributions) {
        contributions = contributions || [];
        var totals = {
            total: contributions.length
        };
        cmp.set('v.meta.dto.totals', totals);
    }
})