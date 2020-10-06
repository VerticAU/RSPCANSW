({
    calculateContentHeight: function (component) {
        component.set('v.contentHeightPX', component.get('v.heightPX') - 120)
    },

    cancel: function (cmp) {
        cmp.set('v.isClosed', true);

        var closeAction = $A.get("e.force:closeQuickAction");
        if (closeAction) closeAction.fire();

        if (cmp.get('v.refreshOnCancel') === true) {
            var refreshAction = $A.get("e.force:refreshView");
            if (refreshAction) refreshAction.fire();
        }
    }
})