({
    filterChange: function(cmp, helper){
        if(!cmp.get('v.meta.dto.filter')){ return; }

        helper.execute(cmp, 'CreateOppAndPaymentsWizardSelectStepMetaProc',
            {
                filter: cmp.get('v.meta.dto.filter')
            }
        ).then(function (response) {
            if (response.isValid) {

            }
        })
    },

});