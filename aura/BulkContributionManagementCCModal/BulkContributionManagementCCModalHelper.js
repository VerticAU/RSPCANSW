({
    getExistingStripeCustomer: function(cmp, event, helper){

        var request;

        var contactId = cmp.get('v.contribution.npsp__Primary_Contact__c');
        var accountId = cmp.get('v.contribution.AccountId');

        if(!$A.util.isUndefinedOrNull(accountId)){
            request = { accountId: accountId }
        } else if(!$A.util.isUndefinedOrNull(contactId)) {
            request = { contactId: contactId }
        }

        if(!cmp.get('v.stripeCustomerId')){
            helper.execute(cmp, 'GetExistingOrCreateStripeCustomerWrapper',
                request,
                function () {},
                function () {}
            ).then(function (response) {

                cmp.set('v.stripeCustomerId', response.dto.stripeCustomerId);


            }).catch(function (errors) {
                var errorMessagesCmp = cmp.find('modal').find('errorMessages');
                errorMessagesCmp.showErrors(errors, true);
            });
        }
    }
});