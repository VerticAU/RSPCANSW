({
    handleInitStep: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        cmp.set('v.stepFooter', payload.footer);
    },

    handleNextStep: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        var nextCMP;

        if (payload.step === 'search') {
            nextCMP = 'c:AddPaymentWizardSelectStep';
        } else if (payload.step === 'select') {
            nextCMP = 'c:AddPaymentWizardConfirmStep';
        } else if (payload.step === 'confirm') {
            cmp.set('v.meta', payload.meta);
            helper.submit(cmp);
            return;
        }
        helper.renderStep(cmp, event, helper, nextCMP, {meta: payload.meta});
    },

    handlePreviousStep: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        var prevCMP;

        if (payload.step === 'select') {
            prevCMP = 'c:AddPaymentWizardSearchStep';
        } else if (payload.step === 'confirm') {
            prevCMP = 'c:AddPaymentWizardSelectStep';
        }
        helper.renderStep(cmp, event, helper, prevCMP, {meta: payload.meta});
    },

    handleNavigate: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        helper.renderStep(cmp, event, helper, 'c:' + payload.target, {meta: payload.meta});
    }
});