({
    priceBookChange: function(cmp, helper){
        helper.execute(cmp, 'CreateOppAndPaymentsWizardSelectMetaProc',
            {
                recordId: cmp.get('v.meta.dto.engagementId'),
                pricebookId: cmp.get('v.meta.dto.pricebookId')
            }
        ).then(function (response) {
            if (response.isValid) {
                cmp.set('v.meta.dto.pricebookId', response.dto.pricebookId);
                cmp.set('v.meta.dto.productItems', response.dto.productItems);
                cmp.set('v.meta.dto.payments', []);
            }
        })
    },

    populateChangedProperties: function (originValue, draftValue) {
        if(originValue && draftValue) {
            Object.getOwnPropertyNames(draftValue).forEach(
                function (propertyName, idx, array) {
                    if (originValue.hasOwnProperty(propertyName)) {
                        originValue[propertyName] = draftValue[propertyName];
                    }
                }
            );
        }
    },

    getItemById: function (originalValues, id) {
        return originalValues.find(item => {
            return item.id === id
        })
    }
});