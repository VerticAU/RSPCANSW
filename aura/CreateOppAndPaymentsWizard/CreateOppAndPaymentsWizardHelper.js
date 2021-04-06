({
    submit: function(cmp, helper) {
        return new Promise($A.getCallback(function (resolve, reject) {

            var payment = cmp.get('v.meta.dto.payment');
            payment.Batch__c = cmp.get('v.recordId');

            helper.execute(cmp, 'CreateOppAndPaymentsWizardSubmitProc',
                { payment: payment },
                function(response) {
                    helper.utils(cmp).showToast({
                        type: 'success',
                        message: 'Opportunity and Payments successfully created.'
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
    },

    closeModal: function(cmp){
        $A.get('e.force:refreshView').fire();
        var closeAction = $A.get("e.force:closeQuickAction");
        if(closeAction) { closeAction.fire(); }
    },
});