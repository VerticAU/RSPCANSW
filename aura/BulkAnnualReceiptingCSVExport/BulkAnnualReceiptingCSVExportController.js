({

    handleFYLoad: function(cmp, event, helper){

        cmp.set('v.filter.financialYear', null);

        helper.execute(cmp, 'GetFinancialYearsMetaProc', {},
            function (response) {
                cmp.set('v.financialYearsMeta', response);
                setTimeout(function () {
                    cmp.set('v.filter.financialYear', response.dto.currentFinancialYear);
                });
            }
        );

    },

    handleConfirmClick: function (cmp, event, helper) {

        if(!cmp.validate()){ return; }

        var financialYear = cmp.get('v.filter.financialYear');
        var financialYearsMeta = cmp.get('v.financialYearsMeta');
        var year = financialYearsMeta.dto.yearMap[financialYear];

        cmp.set('v.isBusy', true);

        helper.produceFile(cmp, event, helper, new Date(year.startDate), new Date(year.endDate)).then(function (csv) {

            var fileName = 'Recurring List (' +
                $A.localizationService.formatDate(new Date(year.startDate)) +
                '-' +
                $A.localizationService.formatDate(new Date(year.endDate)) +
                ') - ' + $A.localizationService.formatDate(new Date()) + '.csv';

            cmp.set('v.csv', csv);
            cmp.set('v.meta.fileName', fileName);

            cmp.find('csvUtils').download(
                cmp.get('v.csv'),
                fileName
            );

        }).catch(function (errors) {
            var errorMessagesCmp = cmp.find('modal').find('errorMessages');
            errorMessagesCmp.showErrors(errors, true);
            cmp.find('modal').set('v.heightPX', 300);
        }).finally(function () {
            cmp.set('v.isBusy', false);
        });

    },

    handleDownloadFile: function(cmp, event, helper){

        cmp.find('csvUtils').download(
            cmp.get('v.csv'),
            cmp.get('v.meta.fileName')
        );
    },

    handleProgress: function (cmp, event, helper) {
        var payload = event.getParams().payload;
        cmp.set('v.meta.dto.progress', payload.progress || 0);
    },

    handleCancel: function(cmp, event, helper){
        cmp.cancelModal();
    }
})