({

    handleFileDelete: function (cmp, event, helper) {
        var onDelete = cmp.getEvent('onDelete');
        onDelete.setParams({
            payload: {
                file: cmp.get('v.file')
            }
        });
        onDelete.fire();
    },


    handleFileDownload: function (cmp, event, helper) {
        var onDownload = cmp.getEvent('onDownload');
        onDownload.setParams({
            payload: {
                file: cmp.get('v.file')
            }
        })
        onDownload.fire();
    },

    handleFileSendToEmail: function (cmp, event, helper) {
        var onSendEmail = cmp.getEvent('onSendEmail');
        onSendEmail.setParams({
            payload: {
                file: cmp.get('v.file')
            }
        })
        onSendEmail.fire();
    },

    handleFileView: function (cmp, event, helper) {
        var onFileView = cmp.getEvent('onFileView');
        onFileView.setParams({
            payload: {
                file: cmp.get('v.file')
            }
        })
        onFileView.fire();
    }

})