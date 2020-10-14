({
    submit: function (cmp) {
        var self = this;
        return new Promise(function (resolve, reject) {

            var request = {
                contributions: [cmp.get('v.contribution')],
                ccNumber: cmp.get('v.creditCard.cardNumber')
            };

            if (cmp.get('v.contribution.isCompleted')) {
                return resolve();
            }

            cmp.set('v.errorMessage', undefined);

            cmp.utils.execute(
                cmp,
                'BulkContributionManagementSubmitProc',
                request,
                function (response) {
                    if (!response.error && response.errors.length === 0) {
                        cmp.set('v.contribution', response.dto.contribution);
                        return self.makePayment(cmp).then(resolve, reject);
                    } else {
                        cmp.set('v.errorMessage', response.errors[0].message);
                        return reject(response.errors);
                    }
                },
                function (errors) {
                    cmp.set('v.errorMessage', errors[0].message);
                    return reject(errors);
                }
            );
        });
    },

    makePayment: function (cmp) {
        var self = this;
        return new Promise($A.getCallback(function (resolve, reject) {
            // todo: add npsp payment logic
            // var paymentTransactionId = cmp.get('v.paymentTransaction.Id');
            // if (!paymentTransactionId) {
            //     cmp.set('v.contribution.isCompleted', true);
            //     return resolve(cmp);
            // }
            //
            // var request = {
            //     'paymentTransactionId': paymentTransactionId,
            //     'creditCardData': cmp.get('v.creditCard') || {},
            //     'action': 'processCCPayment',
            //     'gatewayAccountNumber': 'bfoneoff'
            // };
            //
            // cmp.utils.execute(
            //     cmp,
            //     'payment_CommonProcessor',
            //     request,
            //     function () {},
            //     function () {}
            // ).then($A.getCallback(function (response) {
            //         if (response.isValid) {
            //             cmp.set('v.contribution.isCompleted', true);
            //             return resolve(cmp);
            //         } else {
            //             return reject(response);
            //         }
            //     }),
            //     $A.getCallback(function (errors) {
            //         cmp.set('v.errorMessage', errors[0].message);
            //         return reject(errors);
            //     }));

            resolve(); //test line
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