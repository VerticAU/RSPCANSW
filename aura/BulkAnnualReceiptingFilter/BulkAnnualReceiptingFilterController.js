({
    handleFYLoad: function(cmp, event, helper){

        cmp.set('v.meta.dto.filter.financialYear', null);

        helper.execute(cmp, 'GetFinancialYearsMetaProc', {},
            function (response) {
                cmp.set('v.financialYearsMeta', response);
                setTimeout(function () {
                    cmp.set('v.meta.dto.filter.financialYear', response.dto.currentFinancialYear);
                });
            }
        );
    },

    handleFilterChange: function(cmp, event, helper){

        var filter = cmp.get('v.meta.dto.filter');

        if(!filter.financialYear){
            helper.utils(cmp).showToast({
                message: 'Tax year is required',
                type: 'warning'
            });
            return;
        }

        var financialYearsMeta = cmp.get('v.financialYearsMeta');
        var year = financialYearsMeta.dto.yearMap[filter.financialYear];

        filter.startDate = year.startDate;
        filter.endDate = year.endDate;

        var event = cmp.getEvent('onSearch');
        event.setParams({
            payload: { filter: filter }
        });
        event.fire();
    },

})