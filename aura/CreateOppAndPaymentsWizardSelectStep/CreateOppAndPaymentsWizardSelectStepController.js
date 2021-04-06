({
    handleInit: function(cmp, event, helper){
        cmp.set('v.columns',[
            {label: 'Product', fieldName: 'name', type: 'text', editable: false},
            {label: 'Quantity', fieldName: 'quantity', type: 'number', editable: true, typeAttributes: { maximumFractionDigits: 2}},
            {label: 'Price', fieldName: 'price', type: 'currency', editable: true, typeAttributes: { currencyCode: 'USD', maximumFractionDigits: 2}},
        ]);
    },

    handleFilterChange: function(cmp, event, helper){
        helper.filterChange(cmp, helper);
    },
});