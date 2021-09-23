({
    handleInit: function(cmp, event, helper){
        helper.execute(cmp, 'ClientNotesCreateRecordMetaProc',
            {
                recordId: cmp.get('v.recordId'),
                sObjectName: cmp.get('v.sObjectName'),
                contactRelation: cmp.get('v.contactRelation')
            }
        ).then(function (response) {
            if (response.isValid) {
                cmp.set('v.meta', response);
            }
            cmp.set('v.meta.dto.clientNote.date', $A.localizationService.formatDate(Date.now(), 'yyyy-MM-dd'));
            cmp.set('v.meta.dto.clientNote.time',  new Date().toLocaleTimeString());
        });
    },

    handleCancelClick: function (cmp, event, helper) {
        cmp.cancelModal();
    },

    handleSubmit: function (cmp, event, helper) {
        cmp.set('v.meta.dto.clientNote.caseman__Client__c', cmp.get('v.meta.dto.client.Id'));
        var request = cmp.get('v.meta.dto');

        helper.execute(cmp, 'ClientNotesCreateRecordSubmitProc',
            request,
            function (response) {
                helper.utils(cmp).showToast({
                    type: 'success',
                    message: 'Client Note successfully added'
                });
                cmp.cancelModal();
                resolve(response);
            },
            function(errors) {
                helper.utils(cmp).showToast({
                    title: "Error!",
                    message: errors[0].message,
                    type: 'error'
                });
                reject(errors);
            }
            );
    }

});