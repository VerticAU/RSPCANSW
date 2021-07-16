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
    },

    getFilterRecordId: function (cmp, helper) {
        if(!$A.util.isEmpty(cmp.get('v.contactRelation'))) {
            var items = cmp.find('table').get('v.items');
            if(items && items.length > 0){
                return items[0].caseman__Client__c;
            }
        } else if (!$A.util.isEmpty(cmp.get('v.targetRelation'))){
            return cmp.get('v.recordId');
        }
        return null;
    }
});