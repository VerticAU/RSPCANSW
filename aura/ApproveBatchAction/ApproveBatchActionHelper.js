({
    approve: function (cmp, helper) {
        cmp.set('v.message', 'Processing...');
        cmp.set('v.disabled', true);

        helper.execute(cmp, 'vertic_DMLProc', {
            sObjectType: 'Batch__c',
            upsert: [{
                Id: cmp.get('v.recordId'),
                Approved_By__c: $A.get("$SObjectType.CurrentUser.Id")
            }]
        }).then(function (response) {
            cmp.set('v.message', 'Batch was approved!');
            $A.get('e.force:refreshView').fire();
        }).catch(function (reason) {
            cmp.set('v.message', 'Something\'s gone wrong! Please contact your Salesforce admin!');
        });
    },

    closeModal: function(cmp){
        $A.get('e.force:refreshView').fire();
        var closeAction = $A.get("e.force:closeQuickAction");
        if(closeAction) { closeAction.fire(); }
    },

    showMessage: function(cmp, variant, message){
        cmp.find('notifyLib').showToast({
            variant: variant,
            message:  message
        });
    },
})