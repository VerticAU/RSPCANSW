({
    handleAllExpandedChange: function (cmp, event, helper) {
        var allExpanded = cmp.get('v.allExpanded');
        var items = cmp.get('v.items') || [];
        if (items) {
            items.forEach(function (item) {
                item.expanded = allExpanded;
            });
            cmp.set('v.items', items);
        }
    },

    handleGetExpanded: function (cmp, event, helper) {
        var items = cmp.get('v.items') || [];
        return items.filter(function (item) {
            return item.expanded === true;
        })
    }
})