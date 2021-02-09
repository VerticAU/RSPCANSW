({
    getExistingStripeCustomer: function(cmp, event, helper){

        var request;

        var contactId = cmp.get('v.contribution.npsp__Primary_Contact__c');
        var accountId = cmp.get('v.contribution.AccountId');

        console.log('getExistingStripeCustomer', cmp.get('v.contribution'));

        if(!$A.util.isUndefinedOrNull(accountId)){
            request = { accountId: accountId }
        } else if(!$A.util.isUndefinedOrNull(contactId)) {
            request = { contactId: contactId }
        }

        if(!cmp.get('v.stripeCustomerId')){
            helper.execute(cmp, 'GetExistingOrCreateStripeCustomerWrapper',
                request
            ).then(function (response) {
                console.log('response.dto.stripeCustomerId ' + response.dto.stripeCustomerId);
                cmp.set('v.stripeCustomerId', response.dto.stripeCustomerId);
            }).catch(function (errors) {
                var errorMessagesCmp = cmp.find('modal').find('errorMessages');
                errorMessagesCmp.showErrors(errors, true);
            });
        }
    },
});