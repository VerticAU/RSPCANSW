({
    handleInit: function(cmp, event, helper){
        helper.getExistingStripeCustomer(cmp, event, helper);
    },

    handleStripePaymentMethodChange: function(cmp, event, helper){
        if(event.getParams().index !== 'stripePaymentMethodId'){
            return;
        }
        var errorMessagesCmp = cmp.find('modal').find('errorMessages');
        errorMessagesCmp.showErrors([], false);
    },

    handleSaveClick: function (cmp, event, helper) {
        cmp.closeModal({
            stripeCustomerId: cmp.get('v.stripeCustomerId'),
            stripePaymentMethodId: cmp.get('v.stripePaymentMethodId')
        });
    },

    handleCancelClick: function(cmp, event, helper){
        cmp.closeModal();
    }
})