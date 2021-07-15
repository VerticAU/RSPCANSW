({
    searchNotes: function(cmp, event, helper){
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'ClientNotesTargetedTableMetaProc',
                {
                    recordId: cmp.get('v.recordId'),
                    sObjectName: cmp.get('v.sObjectName'),
                    contactRelation: cmp.get('v.contactRelation'),
                    targetRelation: cmp.get('v.targetRelation'),
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
});