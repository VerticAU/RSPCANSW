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

        var isValid = helper.validateForm(cmp, 'form');

        if(isValid !== true){ return; }

        // cmp.closeModal({});
    },

    handleCancelClick: function(cmp, event, helper){
        cmp.closeModal();
    }
})