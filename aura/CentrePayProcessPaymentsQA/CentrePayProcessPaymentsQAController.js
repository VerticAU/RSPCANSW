({
    handleInit: function(cmp, event, helper){},
    handleFilesChange: function(cmp, event, helper){

        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;

        var files = event.getSource().get('v.files');

        if(!files || !files.length){ return; }

        cmp.set('v.isBusy', true);
        cmp.set('v.meta.dto.fileName', files[0].name);
        // var oneDriveUtils = cmp.find("OneDriveUtils");
        // oneDriveUtils.upload(files, sObjectName, recordName).then(responses => {

            files[0].text().then(markup => {
                helper.parsePaymentDate(cmp, markup);
                helper.parseTable(cmp, markup);

                cmp.set('v.step', 'process');
            });
            cmp.set('v.isBusy', false);
        // });
    },

    handleProcess: function(cmp, event, helper){
        helper.processPayments(cmp, helper);
    },

    handleCloseClick: function(cmp, event, helper){
        $A.get('e.force:refreshView').fire();
        cmp.find('modal').close();
    },

    handleBatchProgressComplete: function (cmp, event, helper) {
        helper.showMessage(cmp, 'Success', 'Payment processing completed!');
        // helper.retrieveResults(cmp, helper).then(response => {
        //     cmp.set('v.step', 'results');
        // });
    },
});