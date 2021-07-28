({

    handleInit: function(cmp, event, helper){

    },

    handleProcess: function(cmp, event, helper){

    },

    handleCloseClick: function(cmp, event, helper){
        $A.get('e.force:refreshView').fire();
        cmp.find('modal').close();
    },

    handleFilesChange: function(cmp, event, helper){

        var sObjectName = cmp.get('v.sObjectName') ? cmp.get('v.sObjectName') : null;
        var recordName = cmp.get('v.recordName') ? cmp.get('v.recordName') : null;

        var files = event.getSource().get('v.files');

        if(!files || !files.length){
            return;
        }

        cmp.set('v.isBusy', true);
        // var oneDriveUtils = cmp.find("OneDriveUtils");
        // oneDriveUtils.upload(files, sObjectName, recordName).then(responses => {
            files[0].text().then(markup => {
                var el = new DOMParser().parseFromString(markup, "text/html");
                var table = el.getElementsByTagName('table')[2];
                console.log(table);
                console.log(helper.parseTable(table));
            });
            cmp.set('v.isBusy', false);
        // });
    },
});