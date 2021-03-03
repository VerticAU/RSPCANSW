({
    handleInit: function(cmp, event, helper){
        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT CreatedById FROM Batch__c WHERE Id = \'' + cmp.get('v.recordId') + '\' LIMIT 1'
            }
        ).then(function (response) {
            if (response.isValid) {
                if($A.get("$SObjectType.CurrentUser.Id") === response.dto.records[0].CreatedById){
                    cmp.set('v.message', 'Batch can not be approved by user who has created it!');
                    cmp.set('v.disabled', true);
                } else {
                    cmp.set('v.message', 'Please note, this action will update Batch Approved By field. Press \'Approve\' to continue.');
                    cmp.set('v.disabled', false);
                }
            }
        })
    },

    handleApprove: function (cmp, event, helper) {
        helper.approve(cmp, helper);
    },

    handleCancelClick: function(cmp, event, helper){
        helper.closeModal(cmp);
    }
})