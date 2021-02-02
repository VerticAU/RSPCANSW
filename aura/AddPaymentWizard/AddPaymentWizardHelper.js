({
    submit: function(cmp) {
        var helper = this;

        helper.execute(cmp, 'AddPaymentWizardSubmitProc',
            {

            },
            function(response) {
                helper.utils(cmp).showToast({
                    type: 'success',
                    message: 'Payment successfully added.'
                });

                cmp.closeModal(response);
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