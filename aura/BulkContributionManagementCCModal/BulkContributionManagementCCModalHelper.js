({
    getExistingStripeCustomer: function(cmp, event, helper){

        var stripeCustomerId = cmp.get('v.meta.dto.stripeCustomerId');

        var request;
        if(cmp.get('v.meta.dto.donationFromMode') === 'business'){
            request = {
                accountId: cmp.get('v.meta.dto.accountId')
            }
        } else {
            request = {
                contactId: cmp.get('v.meta.dto.recordId')
            }
        }

        if(!stripeCustomerId){
            helper.execute(
                cmp,
                'GetExistingOrCreateStripeCustomerProc',
                request,
                function () {},
                function () {}
            ).then(function (response) {

                cmp.set('v.meta.dto.stripeCustomerId', response.dto.stripeCustomerId);

            }).catch(function (errors) {
                var errorMessagesCmp = cmp.find('modal').find('errorMessages');
                errorMessagesCmp.showErrors(errors, true);
            });
        }
    }
});