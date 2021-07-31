({
    parseTable: function (cmp, markup) {
        var el = new DOMParser().parseFromString(markup, "text/html");
        var table = el.getElementsByTagName('table')[2];

        var data = [];
        var headers = [];
        for (let i = 0; i < table.rows[0].cells.length; i++) {
            headers[i] = table.rows[0].cells[i].innerHTML.toLowerCase()
                .replace(' ','_')
                .replace('<br>', '_')
                .replace('<b>','')
                .replace('</b>','')
        }
        // go through cells
        for (let i = 1; i < table.rows.length; i++) {
            var tableRow = table.rows[i];
            var rowData = {};
            for (let j = 0; j < tableRow.cells.length; j++) {
                rowData[headers[j]] = tableRow.cells[j].innerHTML.replace('$','');
            }
            rowData['delivery_date'] = cmp.get('v.meta.dto.paymentDate');
            data.push(rowData);
        }

        data.pop(); // remove totals

        console.log(data);

        cmp.set('v.meta.dto.payments', data);
    },

    parsePaymentDate: function (cmp, markup) {
        var index = markup.indexOf('<b>Payment Delivery Date </b>');
        var paymentDateString = markup.substring(index + 29, index + 40);
        cmp.set('v.meta.dto.paymentDate', $A.localizationService.formatDate(paymentDateString, "yyyy-MM-dd"));
    },

    processPayments: function (cmp, helper) {
        return new Promise($A.getCallback(function (resolve, reject) {
            helper.execute(cmp, 'CentrePayProcessPaymentsSubmitProc',
                {
                    recordId: cmp.get('v.recordId'),
                    payments: cmp.get('v.meta.dto.payments')
                }
            ).then(function (response) {
                var batchId = response.dto.batchId;
                if (!$A.util.isEmpty(batchId)) {
                    cmp.set('v.step', 'batch');
                    cmp.find('batchProgress').showProgress(batchId);
                } else {
                    helper.showMessage(cmp, 'Error', 'Batch job failed. Please contact your Salesforce Admin.');
                }
                resolve(response);
            }).catch(function (reason) {
                reject(reason);
            });
        }));
    },

    calculateTotals: function (cmp, helper, results) {
        console.log('results', results);

        cmp.set('v.meta.dto.totals.failedCount', results.filter((row) => row.status__c === 'Failed').length);
        cmp.set('v.meta.dto.totals.completedCount', results.filter((row) => row.status__c === 'Completed').length);
    },

    showMessage: function(cmp, variant, message){
        cmp.find('notifyLib').showToast({
            variant: variant,
            message:  message
        });
    },
});