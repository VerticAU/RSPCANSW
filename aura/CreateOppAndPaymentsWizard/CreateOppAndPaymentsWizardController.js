({
    handleInitStep: function (cmp, event, helper) {
        cmp.set('v.meta.dto.engagementId', cmp.get('v.recordId'))

        var payload = event.getParam('payload');
        cmp.set('v.stepFooter', payload.footer);
    },

    handleNextStep: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        var nextCMP;

        if (payload.step === 'select') {
            if(!helper.isSelectStepValid(cmp, payload.meta)){ return; }
            nextCMP = 'c:CreateOppAndPaymentsWizardConfirmStep';
        } else if (payload.step === 'confirm') {
            helper.submit(cmp, helper, payload.meta).then(function (response) {
                helper.closeModal();
            })
            return;
        }
        helper.renderStep(cmp, event, helper, nextCMP, {meta: payload.meta});
    },

    handlePreviousStep: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        var prevCMP;

        if (payload.step === 'confirm') {
            prevCMP = 'c:CreateOppAndPaymentsWizardSelectStep';
        }
        helper.renderStep(cmp, event, helper, prevCMP, {meta: payload.meta});
    },

    handleNavigate: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        helper.renderStep(cmp, event, helper, 'c:' + payload.target, {meta: payload.meta});
    }
});