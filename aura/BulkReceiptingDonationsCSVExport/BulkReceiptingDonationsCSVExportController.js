({

    handleConfirmClick: function (cmp, event, helper) {

        if(!cmp.validate()){
            event.preventDefault();
            return false;
        }

    },

    handleCancel: function(cmp, event, helper){
        cmp.cancelModal();
    }
})