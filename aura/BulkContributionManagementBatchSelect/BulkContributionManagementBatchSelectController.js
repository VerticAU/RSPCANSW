({
    handleInit: function(cmp, event, helper){

    },

    handleSelect: function(cmp, event, helper){
        cmp.set('v.meta.dto.batchId', null);
    },

    handleNextClick: function (cmp, event, helper) {

        var isValid = helper.validateForm(cmp, 'form');

        if(isValid !== true){ return; }

        cmp.closeModal({ batchId: cmp.get('v.meta.dto.batchId') || null });
    },

    handleCancelClick: function(cmp, event, helper){
        cmp.cancelModal();
    }
})