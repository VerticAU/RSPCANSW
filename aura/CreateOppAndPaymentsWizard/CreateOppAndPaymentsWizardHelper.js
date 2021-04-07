({
    submit: function(cmp, helper, meta) {
        return new Promise($A.getCallback(function (resolve, reject) {

            var opportunity = meta.dto.opportunity;
            opportunity.Program_Engagement__c = cmp.get('v.recordId');

            helper.execute(cmp, 'CreateOppAndPaymentsWizardSubmitProc',
                {
                    opportunity: opportunity
                },
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