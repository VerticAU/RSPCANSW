({
    refreshContribution : function (cmp, event, helper) {
        var contributions = cmp.get('v.meta.dto.contributions');
        var selectedRowIndex = cmp.get('v.selectedRowIndex');
        var contribution = contributions[selectedRowIndex];
        if (contribution) {
            cmp.set('v.contribution', contribution);
        }
    }
});