({
    handleInit: function(cmp, event, helper){
        cmp.set('v.columns',[
            {label: 'Product', fieldName: 'name', type: 'text', editable: false},
            {label: 'Quantity', fieldName: 'quantity', type: 'number', editable: true, typeAttributes: { maximumFractionDigits: 2}},
            {label: 'Price', fieldName: 'price', type: 'currency', editable: true, typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2}},
        ]);

        if(!cmp.get('v.meta.dto.productItems')){
            helper.priceBookChange(cmp, helper);
        }
    },

    handlePriceBookChange: function(cmp, event, helper){
        if(cmp.get('v.meta.dto.pricebookId')){
            helper.priceBookChange(cmp, helper);
        }
    },

    handleSave : function( cmp, event, helper ) {

        var draftValues = cmp.find('productTable').get('v.draftValues') || [];
        var originalValues = cmp.get('v.meta.dto.productItems') || [];

        draftValues.forEach(draft => {
            helper.populateChangedProperties(
                helper.getItemById(originalValues, draft.id), draft
            );
        });

        cmp.set('v.meta.dto.productItems', []);
        cmp.set('v.meta.dto.productItems', originalValues);
    }
});