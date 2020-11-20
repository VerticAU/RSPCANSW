({
    submit: function (cmp, event, helper) {

        return new Promise(function (resolve, reject) {

            var validationResult = helper.getBaseCmp(cmp).utils.validate(
                cmp.find('form'),
                {
                    additionalComponentTypes: [
                        'c:strike_lookup_clickable',
                        'c:PaymentMethodLookup'
                    ]
                }
            );

            if(validationResult.allValid !== true){
                cmp.find('notificationLib').showToast({
                    variant: 'error',
                    message: 'Please complete the mandatory fields'
                });
                reject();
                return;
            }

            var request = cmp.get('v.meta.dto');

            request.batchId = cmp.get('v.batchId');

            console.log('submit: ', JSON.stringify(request));

            helper.execute(
                cmp,
                'BulkContributionManagementSubmitProc',
                request,
                function (response) {
                    resolve(response);
                },
                function(errors){
                    cmp.find('notificationLib').showToast({
                        variant: 'error',
                        message: errors[0].message
                    });
                    // helper.getBaseCmp(cmp).find('errorMessages').showErrors(errors);
                    reject(errors);
                }
            );

        });
    },


    // return new Promise(function (resolve, reject) {
        //
        //     cmp.set('v.meta.hasSubmitErrors', false);
        //
        //     var validationResult = helper.getBaseCmp(cmp).utils.validate(
        //         cmp.find('form'),
        //         {
        //             additionalComponentTypes: [
        //                 'c:strike_lookup_clickable',
        //                 'c:PaymentMethodLookup'
        //             ]
        //         }
        //     );
        //
        //     if(validationResult.allValid !== true){
        //         cmp.find('notificationLib').showToast({
        //             variant: 'error',
        //             message: 'Please complete the mandatory fields'
        //         });
        //         reject();
        //         return;
        //     }
        //
        //     var promises = [];
        //     var contributionItems = cmp.find('contributionItem');
        //     if (typeof contributionItems !== 'object' || contributionItems.constructor !== Array) {
        //         contributionItems = [contributionItems];
        //     }
        //     for (var index in contributionItems) {
        //         if(contributionItems[index]){
        //             promises.push(contributionItems[index].submit);
        //         }
        //     }
        //
        //     if(!promises.length){
        //         cmp.find('notificationLib').showToast({
        //             variant: 'error',
        //             message: 'No rows to submit'
        //         });
        //         reject();
        //         return;
        //     }
        //
        //     cmp.set('v.isBusy', true);
        //
        //     helper.sequencePromises(promises).then($A.getCallback(function (responses) {
        //
        //         var errors = responses.filter(function (response) {
        //             return response.success !== true;
        //         });
        //
        //         if(errors.length){
        //             reject(responses);
        //         } else {
        //             resolve(responses);
        //         }
        //
        //     })).finally(function () {
        //         cmp.set('v.isBusy', false);
        //     });
        //
        // });

    // },


    approve: function (cmp, event, helper, batchId) {

        return new Promise(function (resolve, reject) {

            helper.execute(
                cmp,
                'BatchApproveProc',
                {
                    batchId: batchId
                },
                function (response) {
                    resolve(response);
                },
                function(errors){
                    cmp.find('notificationLib').showToast({
                        variant: 'error',
                        message: errors[0].message
                    });
                    // helper.getBaseCmp(cmp).find('errorMessages').showErrors(errors);
                    reject(errors);
                }
            );

        });

    },


    // sequencePromises: function(promises){
    //     return new Promise(function (resolve, reject) {
    //
    //         var results = [];
    //
    //         promises.reduce(function (p, promise, index) {
    //
    //             return p.then($A.getCallback(function (){
    //                 var isLast = index == promises.length - 1;
    //                 return promise().then(function (response) {
    //                     results.push({
    //                         status: 'success',
    //                         value: response,
    //                         success: true
    //                     });
    //                     if(isLast) {
    //                         resolve(results);
    //                     }
    //                 }).catch(function (reason) {
    //                     results.push({
    //                         status: 'error',
    //                         error: reason,
    //                         success: false
    //                     });
    //                     if(isLast) {
    //                         resolve(results);
    //                     }
    //                 });
    //             }), reject);
    //
    //         }, Promise.resolve());
    //
    //     });
    // },

    newContribution: function (cmp, event, helper) {
        return {
            CloseDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd')
        };
    },

    deleteContribution: function (cmp, event, helper, contributionToDelete) {

        return new Promise(function (resolve, reject) {
            if(contributionToDelete.Id == undefined){
                resolve();
            } else if(confirm('Are you sure you want to Delete saved Contribution?')){
                helper.execute(
                    cmp,
                    'vertic_DMLProc',
                    {
                        sObjectType: 'Opportunity',
                        delete: [{Id: contributionToDelete.Id}]
                    },
                    resolve,
                    reject
                );
            } else {
                reject();
            }
        });
    },


    refresh: function (cmp, event, helper) {

        return new Promise(function (resolve, reject) {
            var batchId = cmp.get('v.batchId');

            helper.execute(
                cmp,
                cmp.get('v.processor'),
                {
                    batchId: batchId,
                    condition: cmp.get('v.pending') ? 'Status__c = \'Pending\'' : null
                },
                function (response) {
                    cmp.set('v.meta', response);

                    if(!batchId){
                        cmp.set('v.meta.dto.contributions', [helper.newContribution()]);
                    }

                    resolve(response);
                },
                reject
            );
        });

    },


    // refresh: function (cmp, event, helper) {
    //
    //     return new Promise(function (resolve, reject) {
    //         helper.execute(
    //             cmp,
    //             cmp.get('v.processor'),
    //             {},
    //             function (response) {
    //                 cmp.set('v.meta', response);
    //                 cmp.set('v.meta.dto.contributions', [helper.newContribution(cmp, event, helper)]);
    //                 resolve(response);
    //             },
    //             reject
    //         );
    //     });
    // },

    setBatch: function(cmp, event, helper, batchId){
        cmp.set('v.batchId', batchId);
    }

});