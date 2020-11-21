({
    makePayment: function (cmp) {
        return new Promise($A.getCallback(function (resolve, reject) {

            var contribution = cmp.get('v.contribution');

            if (contribution.isCompleted__c || contribution.Payment_Method__c !== 'Credit Card') { return resolve(cmp); }

            cmp.utils.execute(cmp, 'BulkContributionManagementPaymentProc', {

                'amount': contribution.Amount,
                'stripeCustomerId': contribution.Stripe_Customer_Id__c,
                'stripePaymentMethodId': contribution.Stripe_Payment_Id__c,
                'stripeAccountId': contribution.Campaign.Stripe_Account_Id__c

            }).then($A.getCallback(function (response) {
                    if (!response.error && response.errors.length === 0 && response.isValid) {
                        cmp.set('v.contribution.paymentIntentId', response.dto.paymentIntentId);
                        return resolve(cmp);
                    } else {
                        cmp.set('v.errorMessage', response.errors[0].message);
                        return reject(response.errors);
                    }
                }))
                .catch($A.getCallback(function (errors) {
                    console.log('makePayment catch', errors[0].message);
                    cmp.set('v.errorMessage', errors[0].message);
                    return reject(errors);
                }));
        }));
    },

    updateOrSubmitOpportunity: function (cmp) {
        return new Promise($A.getCallback(function (resolve, reject) {

            var contribution = cmp.get('v.contribution');

            if (contribution.isCompleted__c) { return resolve(cmp); }

            cmp.utils.execute(cmp, 'BulkContributionManagementSubmitProc', {

                'contribution': contribution

            }).then($A.getCallback(function (response) {
                    if (!response.error && response.errors.length === 0 && response.isValid) {
                        cmp.set('v.contribution.isCompleted__c', true);
                        return resolve(cmp);
                    } else {
                        cmp.set('v.errorMessage', response.errors[0].message);
                        return reject(response.errors);
                    }
                }))
                .catch($A.getCallback(function (errors) {
                    console.log('submitOpportunity catch', errors[0].message);
                    cmp.set('v.errorMessage', errors[0].message);
                    return reject(errors);
                }));
        }));
    },

    queryCampaign: function (cmp, helper, identifier) {
        return new Promise($A.getCallback(function (resolve, reject) {
            cmp.utils.execute(cmp, 'vertic_SOQLProc',
                {
                    SOQL: 'SELECT Id FROM Campaign WHERE Campaign_ID__c = \'CAM - ' + identifier + '\''
                }
            ).then(function (response) {
                if (response.dto && response.dto.records && response.dto.records.length) {
                    cmp.set('v.contribution.Campaign', response.dto.records[0].Id);
                } else {
                    cmp.find('notificationLib').showToast({
                        variant: 'warning',
                        message: 'Campaign not found!'
                    });
                }
            }).finally(function () {
                resolve();
            })
        }));
    },

    queryContact: function (cmp, helper, identifier) {
        return new Promise($A.getCallback(function (resolve, reject) {
            cmp.utils.execute(cmp, 'vertic_SOQLProc',
                {
                    SOQL: 'SELECT Id FROM Contact WHERE Contact_Identifier__c = \'CID-' + identifier + '\''
                }
            ).then(function (response) {
                if (response.dto && response.dto.records && response.dto.records.length) {
                    cmp.set('v.contribution.npsp__Primary_Contact__c', response.dto.records[0].Id);
                } else {
                    cmp.find('notificationLib').showToast({
                        variant: 'warning',
                        message: 'Contact not found!'
                    });
                }
            }).finally(function () {
                resolve();
            })
        }));
    }

});