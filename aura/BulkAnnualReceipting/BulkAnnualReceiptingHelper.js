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
            total: contributions.length,
            totalMail: 0,
            totalEmail: 0
        };

        contributions.map(function (contribution) {
            if(contribution.channel === 'Mail'){
                totals.totalMail++;
            } else if (contribution.channel === 'Email'){
                totals.totalEmail++;
            }
        });

        cmp.set('v.meta.dto.totals', totals);
    }
})