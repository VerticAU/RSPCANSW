({
    handlePaymentMethodChange: function(cmp, event, helper){
        console.log('->', cmp.get('v.contribution.Payment_Method__c'));
        if(cmp.get('v.contribution.Payment_Method__c') === 'Credit Card'){
            cmp.find('modalService').show(
                'c:BulkContributionManagementCCModal',
                {
                    contribution: cmp.get('v.contribution')
                },
                {
                    header: 'One-Off Donation | Credit Card'
                }
            ).then($A.getCallback(function (response) {
                if(!$A.util.isUndefinedOrNull(response)){
                    debugger
                    cmp.set('v.contribution.stripeCustomerId', response.stripeCustomerId);
                    cmp.set('v.contribution.stripePaymentMethodId', response.stripePaymentMethodId);
                }
            }));
        }
    },

    //----------------------------------------------------------------------------

    handleContributionDeleteClick: function (cmp, event, helper) {
        var event = cmp.getEvent('onContributionDelete');
        event.setParams({
            "payload": {
                index: cmp.get('v.index')
            }
        });
        event.fire();
    },

    handleContactChange: function (cmp, event, helper) {

        var eventParams = event.getParams();
        if (!eventParams.expression || eventParams.expression.toLowerCase() != 'v.contribution.npsp__Primary_Contact__c'.toLowerCase()) {
            return;
        }

        var contribution = cmp.get('v.contribution');
        if (contribution && contribution.Payment_Method__c) {
            cmp.set('v.contribution.Payment_Method__c', null);
        }

        contribution.AccountId = null;
        contribution.Account = null;

        if (!$A.util.isUndefinedOrNull(contribution.npsp__Primary_Contact__c)) {
            var request = {
                'SOQL': 'SELECT ' +
                    'Name, ' +
                    'MailingCity, ' +
                    'MailingCountry, ' +
                    'MailingPostalCode, ' +
                    'MailingState, ' +
                    'MailingStreet, ' +
                    'HomePhone, ' +
                    'MobilePhone, ' +
                    // 'Receipt_Frequency__c, ' +
                    // 'Receipt_Preference__c, ' +
                    'Email ' +
                    'FROM Contact ' +
                    'WHERE Id = \'' + contribution.npsp__Primary_Contact__c + '\''
            };
            cmp.utils.execute(
                cmp,
                'vertic_SOQLProc',
                request,
                function (response) {
                    contribution.npsp__Primary_Contact__r = response.dto.records[0];
                    cmp.set('v.contribution', contribution);
                    console.log('response.dto.records[0]', response.dto.records[0]);
                }
            );
        } else {
            contribution.npsp__Primary_Contact__c = null;
            contribution.npsp__Primary_Contact__r = null;
            cmp.set('v.contribution', contribution);
        }
    },

    handleOrganisationChange: function (cmp, event, helper) {
        var eventParams = event.getParams();
        if (!eventParams.expression || eventParams.expression.toLowerCase() != 'v.contribution.AccountId'.toLowerCase()) {
            return;
        }
        var contribution = cmp.get('v.contribution');

        contribution.npsp__Primary_Contact__c = null;
        contribution.npsp__Primary_Contact__r = null;

        if (!$A.util.isUndefinedOrNull(contribution.AccountId)) {
            var request = {
                'SOQL': 'SELECT ' +
                    'Name, ' +
                    'ShippingCity, ' +
                    'ShippingCountry, ' +
                    'ShippingPostalCode, ' +
                    'ShippingState, ' +
                    'ShippingStreet, ' +
                    'Phone, ' +
                    'npe01__One2OneContact__c, ' +
                    'Email__c ' +
                    'FROM Account ' +
                    'WHERE Id = \'' + contribution.AccountId + '\''
            };
            cmp.utils.execute(
                cmp,
                'vertic_SOQLProc',
                request,
                function (response) {
                    contribution.Account = response.dto.records[0];
                    console.log('response.dto.records[0]', response.dto.records[0]);
                    cmp.set('v.contribution', contribution);
                }
            );
        } else {
            contribution.AccountId = null;
            contribution.Account = null;
            cmp.set('v.contribution', contribution);
        }
    },

    handleCampaignChange: function (cmp, event, helper) {
        var eventParams = event.getParams();
        if (!eventParams.expression || eventParams.expression.toLowerCase() != 'v.contribution.CampaignId'.toLowerCase()) {
            return;
        }
        var contribution = cmp.get('v.contribution');
        if (!$A.util.isUndefinedOrNull(contribution.CampaignId)) {
            var request = {
                'SOQL': 'SELECT ' +
                    'Name, Stripe_Account_Id__c ' +
                    'FROM Campaign ' +
                    'WHERE Id = \'' + contribution.CampaignId + '\''
            };
            cmp.utils.execute(
                cmp,
                'vertic_SOQLProc',
                request,
                function (response) {
                    contribution.Campaign = response.dto.records[0];
                    console.log('response.dto.records[0]', response.dto.records[0]);
                    cmp.set('v.contribution', contribution);
                }
            );
        } else {
            contribution.CampaignId = null;
            contribution.Campaign = null;
            cmp.set('v.contribution', contribution);
        }
    },

    handleLookupNewRecordContact: function (cmp, event, helper) {

        var sourceCmp = event.getSource();

        cmp.find('modalService').show(
            'c:vertic_RecordEditForm',
            {
                sObjectName: sourceCmp.get('v.object'),
                recordId: sourceCmp.get('v.value'),
                sections: [{
                    title: 'Personal Information',
                    columns: [
                        {fields: [{name: 'Name'}]}, {fields: [{name: 'AccountId'}, {name: 'Birthdate'}]}
                    ]
                }, {
                    title: 'Contact Information',
                    columns: [
                        {fields: [{name: 'npe01__PreferredPhone__c'}, {name: 'MobilePhone'}, {name: 'HomePhone'}, {name: 'npe01__WorkPhone__c'}, {name: 'OtherPhone'}]},
                        {fields: [{name: 'npe01__Preferred_Email__c'}, {name: 'npe01__HomeEmail__c'}, {name: 'npe01__AlternateEmail__c'},  {name: 'npe01__WorkEmail__c'}]}
                    ]
                }, {
                    title: 'Address Information',
                    columns: [
                        {fields: [{name: 'MailingAddress'}]}
                    ]
                }]
            },
            {
                header: 'New ' + sourceCmp.get('v.label'),
                cssClass: 'slds-modal_medium'
            }
        ).then($A.getCallback(function (response) {
            var recordId = response.id;
            sourceCmp.set('v.value', recordId);
        }));

    },

    handleLookupNewRecordOrganisation: function (cmp, event, helper) {

        var sourceCmp = event.getSource();

        cmp.find('modalService').show(
            'c:vertic_RecordEditForm',
            {
                sObjectName: sourceCmp.get('v.object'),
                recordId: sourceCmp.get('v.value'),
                sections: [
                    {
                        title: 'Organisation Information',
                        columns: [
                            {fields: [{name: 'Name'}], class: 'slds-size_1-of-2'},
                            {fields: [{name: 'Type'}], class: 'slds-size_1-of-2'}
                        ]
                    },
                    {
                        title: 'Contact Information',
                        columns: [
                            {fields: [{name: 'Phone'}], class: 'slds-size_1-of-2'},
                            {fields: [{name: 'Email__c'}], class: 'slds-size_1-of-2'}
                        ]
                    },
                    {
                        title: 'Address Information',
                        columns: [
                            {fields: [{name: 'BillingAddress'}]}
                        ]
                    }
                ]
            },
            {
                header: 'New ' + sourceCmp.get('v.label'),
                cssClass: 'slds-modal_small'
            }
        ).then($A.getCallback(function (response) {
            var recordId = response.id;
            sourceCmp.set('v.value', recordId);
        }));

    },

    handleContributionChange: function (cmp, event, helper) {
        var event = cmp.getEvent('onChange');
        event.setParams({
            payload: {
                index: cmp.get('v.index'),
                contribution: cmp.get('v.contribution')
            }
        });
        event.fire();
    },

    handleQRScan: function (cmp, event, helper) {
        cmp.find('modalService').show(
            'c:QRCodeScannerModal',
            {},
            {
                header: 'Scan contribution',
                cssClass: 'slds-modal_small'
            }
        ).then($A.getCallback(function (response) {
            console.log('response', JSON.stringify(response));
            if (response) {
                cmp.set('v.isBusy', true);

                var promises = [];
                promises.push(helper.queryCampaign(cmp, helper, response.CAM));
                promises.push(helper.queryContact(cmp, helper, response.CID));

                Promise.all(promises).finally(function () {
                    cmp.set('v.isBusy', false);
                })
            }
        }));
    },

    handleQRScanReady: function (cmp, event, helkper) {
        console.log(JSON.stringify(event.getParams("payload")));
    },

    handleEditClick: function (cmp, event, helper) {
        var selectedRowIndex = cmp.get('v.selectedRowIndex');
        var index = cmp.get('v.index');
        if (selectedRowIndex === index) {
            cmp.set('v.selectedRowIndex', null);
            cmp.set('v.isEditFormVisible', false);
        } else {
            cmp.set('v.selectedRowIndex', index);
            cmp.set('v.isEditFormVisible', true);
        }
    },

    cleanUpSelectedRowIndex: function (cmp, helper, event) {
        if (!cmp.get('v.isEditFormVisible')) {
            cmp.set('v.selectedRowIndex', null);
        }
    },

    doSubmit: function (cmp, event, helper) {
        return helper.makePayment(cmp).then(
            $A.getCallback(function (cmp) {
                return helper.submitOpportunity(cmp)
            }))
    },

    handleNumericOnly: function (cmp, event, helper) {
        var sourceCmp = event.getSource();
        var value = sourceCmp.get('v.value');
        if (value) {
            value = value.replace(new RegExp('[^0-9]', 'g'), '');
            sourceCmp.set('v.value', value);
        }
    },

});