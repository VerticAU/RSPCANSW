({
    handleFileChange: function(cmp, event, helper) {
        var fileInput = cmp.find('file').getElement();

        var file = fileInput.files[0];

        if (file.size > 4194304) { // Max file size 4 MB
            helper.utils(cmp).showToast({
                type: 'error',
                message: 'File size cannot exceed 4 MB. Selected file size is ' + (file.size / 1024 / 1024).toFixed(1) + ' MB.'
            });
            return;
        }

        var reader = new FileReader();
        reader.onload = function (e) {
            var binaryString = reader.result;
            binaryString = binaryString.substring(binaryString.indexOf('base64,') + 7);

            cmp.set('v.meta.dto.photoUrl_old', cmp.get('v.meta.dto.photoUrl'));
            cmp.set('v.meta.dto.photoUrl', null);

            helper.execute(
                cmp,
                'ProfilePhotoUploadProc',
                {
                    recordId: cmp.get('v.recordId'),
                    base64Data: encodeURIComponent(binaryString),
                    fileName: file.name,
                    contentType: file.type
                },
                function(response) {
                    cmp.set('v.isBusy', true);
                    setTimeout($A.getCallback(function() {
                        cmp.set('v.meta.dto.photoUrl', response.dto.photoUrl);
                        cmp.set('v.isBusy', false);
                    }), 2000);
                }
            )
        };
        reader.readAsDataURL(file);
    },

    handlePhotoClick: function(cmp, event, helper) {
        cmp.find('file').getElement().click();
    }
});