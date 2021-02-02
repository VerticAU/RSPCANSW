({

    handleInit: function (cmp, event, helper) {
        var onNextEvent = cmp.getEvent('onInit');
        onNextEvent.setParams({
            payload: {
                footer: cmp.get('v.footer')
            }
        });
        onNextEvent.fire();
    },

    handleNext: function (cmp, event, helper) {
        helper.next(cmp);
    },

    handleNextClick: function (cmp, event, helper) {
        helper.next(cmp);
    },

    handlePrevious: function (cmp, event, helper) {
        helper.previous(cmp);
    },

    handlePreviousClick: function (cmp, event, helper) {
        helper.previous(cmp);
    },

    handleNavigate: function (cmp, event, helper) {

        var params = event.getParam('arguments') || {};
        var target = params.target;

        var onNavigate = cmp.getEvent('onNavigate');
        onNavigate.setParams({
            payload: {
                target: target,
                source: cmp.get('v.name'),
                meta: cmp.get('v.meta')
            }
        })
        onNavigate.fire();
    },

    handleCancel: function (cmp, event, helper) {
        if (cmp.get('v.isModal') == true) {
            cmp.closeModal(cmp.get('v.meta.dto'));
        } else {
            var closeAction = $A.get("e.force:closeQuickAction");
            if (closeAction) closeAction.fire();
        }
    }

})