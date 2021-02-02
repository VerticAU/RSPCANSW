({
    handleInit: function (cmp, event, helper) {
        var screen = cmp.get('v.quickActionScreen');
        if (cmp.get('v.isModal') == true) {
            screen = cmp.get('v.modalScreen');
        }
        cmp.set('v.screen', screen);
    },

    handleCancel: function (cmp, event, helper) {
        cmp.cancelModal();
    }
})