({
    handleInit: function(cmp, event, helper){

    },

    handleBatchProgressComplete: function (cmp, event, helper) {
        helper.showMessage(cmp, 'Success', 'Synchronization completed!');
        helper.closeModal(cmp);
    },

    handleRequestSyncClick: function (cmp, event, helper) {
        helper.syncMembers(cmp, helper);
    },

    handleCancelClick: function(cmp, event, helper){
        helper.closeModal(cmp);
    }
})