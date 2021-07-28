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

});