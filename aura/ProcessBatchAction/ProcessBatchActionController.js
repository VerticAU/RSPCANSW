({
    handleInit: function(cmp, event, helper){

    },

    handleBatchProgressComplete: function (cmp, event, helper) {
        helper.showMessage(cmp, 'Success', 'Processing completed!');
        helper.closeModal(cmp);
    },

    handleProcessClick: function (cmp, event, helper) {
        helper.process(cmp, helper);
    },

    handleCancelClick: function(cmp, event, helper){
        helper.closeModal(cmp);
    }
})