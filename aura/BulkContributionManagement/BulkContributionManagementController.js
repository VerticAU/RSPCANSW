({
    handleInit: function (cmp, event, helper) {
        cmp.find('modalService').show(
            'c:BulkContributionManagementBatchSelect', {},
            {
                header: 'Bulk Contribution Management',
                cssClass: 'slds-modal_small',
                showCloseButton: false
            }
        ).then($A.getCallback(function (response) {
            if(response.batchId){
                cmp.set('v.pending', true);
                helper.setBatch(cmp, event, helper, response.batchId);
            } else {
                helper.refresh(cmp, event, helper);
            }
        }));
    },

    handleNewContributionClick: function (cmp, event, helper) {
        var contributions = cmp.get('v.meta.dto.contributions') || [];
        contributions.unshift(helper.newContribution(cmp, event, helper));
        cmp.set('v.meta.dto.contributions', contributions);
    },

    handleContributionDelete: function (cmp, event, helper) {
        var payload = event.getParam('payload');

        if (payload && payload.index != undefined) {
            var contributions = cmp.get('v.meta.dto.contributions') || [];
            var contributionToDelete = contributions[payload.index];

            helper.deleteContribution(cmp, event, helper, contributionToDelete).then($A.getCallback(function () {
                contributions.splice(payload.index, 1);
                cmp.set('v.meta.dto.contributions', contributions);
            }), function (reason) {
            });
        }
    },

    handleSubmitClick: function (cmp, event, helper) {

        cmp.set('v.selectedRowIndex', null);
        cmp.set('v.isEditFormVisible', false);
        helper.submit(cmp, event, helper).then($A.getCallback(function (responses) {
            cmp.find('notificationLib').showToast({
                variant: 'success',
                mode: 'pester',
                message: responses.length == 1 ? 'The Donation has been successfully processed.' : 'The Donations have been successfully processed.',
            });
            cmp.set('v.meta.dto.contributions', [helper.newContribution(cmp, event, helper)]);
        }), $A.getCallback(function (responses) {

            var errors = responses.filter(function (response) {
                return response.success !== true;
            });

            cmp.find('notificationLib').showNotice({
                variant: 'warning',
                title: 'Please review the rows highlighted in red.',
                header: 'Save Failed',
                message: '\nSave Summary:\nTotal Rows: ' + responses.length +
                                         ' \nProcessed:  ' + (responses.length - errors.length) +
                                         ' \nFailed:     ' + errors.length,
                closeCallback: function () {
                }
            });

        }));
    },

    handleContributionChange: function (cmp, event, helper) {
        cmp.find('totals').recalculate();
        cmp.find('contributionDetails').refreshContribution(event.getParam('payload'));
    },

    handleScan: function (cmp, event, helper) {
        var payload = event.getParam('payload');
        if (payload) {
            var contribution = helper.newContribution(cmp, event, helper);
            try {
                payload = JSON.parse(payload);
                contribution.Campaign__c = payload.campaignId;
                contribution.Contact__c = payload.contactId;
                var contributions = cmp.get('v.meta.dto.contributions') || [];
                contributions.push(contribution);
                cmp.set('v.meta.dto.contributions', contributions);
            }
            catch (e) {
                console.log('Invalid Data');
            }
        }
    }
})