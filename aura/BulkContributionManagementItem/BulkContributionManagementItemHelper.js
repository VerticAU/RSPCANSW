({
    makePayment: function (cmp) {
        return new Promise($A.getCallback(function (resolve, reject) {

            var contribution = cmp.get('v.contribution');

            if (contribution.isCompleted || contribution.Payment_Method__c !== 'Credit Card') { return resolve(cmp); }

            cmp.utils.execute(cmp, 'BulkContributionManagementPaymentProc', {

                'amount': contribution.Amount,
                'stripeCustomerId': contribution.stripeCustomerId,
                'stripePaymentMethodId': contribution.stripePaymentMethodId,
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

    submitOpportunity: function (cmp) {
        return new Promise($A.getCallback(function (resolve, reject) {

            // debugger
            // cmp.set('v.contribution.batchId', cmp.get('v.batchId'));
            var contribution = cmp.get('v.contribution');

            if (contribution.isCompleted) { return resolve(cmp); }

            cmp.utils.execute(cmp, 'BulkContributionManagementSubmitProc', {

                'contribution': contribution

            }).then($A.getCallback(function (response) {
                    if (!response.error && response.errors.length === 0 && response.isValid) {
                        // cmp.set('v.batchId', response.dto.batchId);
                        cmp.set('v.contribution.isCompleted', true);
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