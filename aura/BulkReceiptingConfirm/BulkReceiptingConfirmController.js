({
    handleInit: function(cmp, event, helper){

    },

    handleConfirmClick: function(cmp, event, helper){

        helper.execute(
            cmp,
            cmp.get('v.processor'),
            cmp.get('v.payload'),
            function (response) {
                var asyncJobId = response.dto.asyncJobId;
                var receiptLinks = response.dto.receiptLinks;

                cmp.set('v.meta.dto.asyncJobId', asyncJobId);
                cmp.set('v.meta.dto.receiptLinks', receiptLinks);

                cmp.set('v.meta.dto.showResults', true);

                if (asyncJobId) {
                    cmp.find('batchProgress').showProgress(asyncJobId);
                }
            }
        );
    },

    handleBatchProgressComplete: function (cmp, event, helper) {
        cmp.set('v.meta.dto.isEmailsSent', true);
    },

    handleCancelClick: function(cmp, event, helper){
        cmp.cancelModal();
    }
})