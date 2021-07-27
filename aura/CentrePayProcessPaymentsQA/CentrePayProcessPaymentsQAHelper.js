({
    parseTable: function (table) {
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
                rowData[headers[j]] = tableRow.cells[j].innerHTML;
            }
            data.push(rowData);
        }

        data.pop(); // remove totals

        return data;
    },

    // readFile: function (file) {
    //
    //     return new Promise(function (resolve, reject) {
    //         var reader = new FileReader();
    //
    //         reader.onload = $A.getCallback(function () {
    //             resolve(reader.result);
    //         });
    //         reader.onerror = $A.getCallback(function (errors) {
    //             reject(errors);
    //         });
    //
    //         reader.readAsArrayBuffer(file);
    //     });
    // },

    // handleFilesChange: function (component, event, helper) {
    //     // This will contain the List of File uploaded data and status
    //     var uploadFile = event.getSource().get("v.files");
    //     var self = this;
    //     var file = uploadFile[0]; // getting the first file, loop for multiple files
    //     var reader = new FileReader();
    //     reader.onload =  $A.getCallback(function() {
    //         var dataURL = reader.result;
    //         var base64 = 'base64,';
    //         var dataStart = dataURL.indexOf(base64) + base64.length;
    //         dataURL= dataURL.substring(dataStart);
    //         helper.upload(component, file, dataURL)
    //     });
    //     reader.readAsDataURL(file);
    // }


});