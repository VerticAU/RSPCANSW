({
    submit: function(cmp, helper) {
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'AddPaymentWizardSubmitProc',
                {
                    payment: cmp.get('v.meta.dto.payment')
                },
                function(response) {
                    helper.utils(cmp).showToast({
                        type: 'success',
                        message: 'Payment successfully processed.'
                    });
                    resolve(response);
                },
                function(errors) {
                    helper.utils(cmp).showToast({
                        title: "Error!",
                        message: errors[0].message,
                        type: 'error'
                    });
                    reject(errors);
                }
            );
        }));
    }
});