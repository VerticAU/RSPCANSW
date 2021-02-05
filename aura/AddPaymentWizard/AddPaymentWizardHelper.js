({
    submit: function(cmp, helper) {
        helper.execute(cmp, 'AddPaymentWizardSubmitProc',
            {
                payment: cmp.get('v.meta.dto.payment')
            },
            function(response) {
                helper.utils(cmp).showToast({
                    type: 'success',
                    message: 'Payment successfully processed.'
                });
                // cmp.closeModal(response);
            },
            function(errors) {
                helper.utils(cmp).showToast({
                    title: "Error!",
                    message: errors[0].message,
                    type: 'error'
                });
            }
        );
    }
});