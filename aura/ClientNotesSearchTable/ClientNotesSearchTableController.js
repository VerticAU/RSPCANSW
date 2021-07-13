({
    handleSelectAll: function (cmp, event, helper) {
        cmp.set('v.allSelected', true);
        var items = cmp.get('v.items') || [];
        items.forEach(function (item) {
            item.selected = true;
        });
        cmp.set('v.items', items);
    },

    handleAllSelectedChange: function (cmp, event, helper) {
        var items = cmp.get('v.items') || [];
        var allSelected = cmp.get('v.allSelected');

        if (items) {
            items.forEach(function (item) {
                if (item.isDisabled !== true) {
                    item.selected = allSelected;
                }
            });

            cmp.set('v.items', items);
        }
    },

    handleSelectedChange: function (cmp, event, helper) {
        cmp.set('v.allSelected', false);
    },

    handleGetSelected: function (cmp, event, helper) {
        var items = cmp.get('v.items') || [];
        return items.filter(function (item) {
            return item.selected === true;
        })
    },

    handleResetSelection: function (cmp, event, helper) {
        cmp.set('v.allSelected', false);
        var items = cmp.get('v.items') || [];
        items.forEach(function (item) {
            item.selected = false;
        });
        cmp.set('v.items', items);
    }
})