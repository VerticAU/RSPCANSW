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

        var files = event.getSource().get('v.files');

        if(!files || !files.length){
            return;
        }

        files[0].text().then(markup => {
            var el = new DOMParser().parseFromString(markup, "text/html");
            var table = el.getElementsByTagName('table')[2];
            console.log(table);
            console.log(helper.parseTable(table));
        });

        // helper.readFile(files[0]).then(result => {
        //     console.log(result);
        // })

        // cmp.set('v.meta.dto.parsedData', null);
        // cmp.set('v.isBusy', true);
        //
        // helper.parseFile(cmp, files[0]).then(function (parsedData) {
        //
        //
        //     cmp.set('v.meta.dto.parsedData', parsedData);
        // }).catch(function (error) {
        //     helper.utils(cmp).showToast({
        //         message: JSON.stringify(error),
        //         type: 'error'
        //     });
        // }).finally(function () {
        //     cmp.set('v.isBusy', false);
        // });

    },
});