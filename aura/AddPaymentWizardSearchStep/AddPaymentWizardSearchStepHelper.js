({
    handleOpportunityAction: function (cmp, helper, opp) {
        if($A.util.isUndefinedOrNull(opp)){ return; }

        cmp.set('v.meta.dto.payment', null);
        cmp.set('v.meta.dto.opportunity', {
            Id: opp.id,
            Name: opp.name
        });

        cmp.set('v.meta.dto.batch', {
            Id: cmp.get('v.batchId')
        });
    },

    filterChange: function(cmp, helper){
        if(!cmp.get('v.meta.dto.filter')){ return; }

        helper.execute(cmp, 'AddPaymentWizardSearchStepMetaProc',
            {
                filter: cmp.get('v.meta.dto.filter')
            }
        ).then(function (response) {
            if (response.isValid) {
                if(response.dto.ids && response.dto.ids.length > 0){
                    cmp.set('v.oppCondition', 'Id IN (\'' + response.dto.ids.join('\',\'') + '\')');
                } else {
                    cmp.set('v.oppCondition', null);
                }
            }
        })
    },

});