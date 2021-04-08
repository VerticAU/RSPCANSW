({
    submit: function(cmp, helper, meta) {
        return new Promise($A.getCallback(function (resolve, reject) {

            if(!helper.isConfirmStepValid(cmp, meta)){ return; }

            meta.dto.opportunity.Program_Engagement__c = cmp.get('v.recordId');
            helper.execute(cmp, 'CreateOppAndPaymentsWizardSubmitProc',
                {
                    opportunity: meta.dto.opportunity,
                    payments: meta.dto.payments
                },
                function(response) {
                    cmp.find('notifLib').showToast({
                        variant: 'success',
                        message: 'Opportunity and Payments successfully created.'
                    });
                    resolve(response);
                },
                function(errors) {
                    cmp.find('notifLib').showToast({
                        message: errors[0].message,
                        variant: 'error'
                    });
                    reject(errors);
                }
            );
        }));
    },

    isSelectStepValid: function(cmp, meta){
        if($A.util.isUndefinedOrNull(meta.dto.productItems) || meta.dto.productItems.length === 0){
            cmp.find('notifLib').showToast({
                variant: 'error',
                message: 'Please select Products!'
            });
            return false;
        }
        return true;
    },

    isConfirmStepValid: function(cmp, meta){
        if(meta.dto.opportunity.Amount !== meta.dto.paidAmount){
            cmp.find('notifLib').showToast({
                variant: 'error',
                message: 'Amount is not paid!'
            });
            return false;
        }
        return true;
    },

    closeModal: function(cmp){
        $A.get('e.force:refreshView').fire();
        var closeAction = $A.get("e.force:closeQuickAction");
        if(closeAction) { closeAction.fire(); }
    },
});