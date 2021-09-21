({
    handleInit: function(cmp, event, helper){
        console.log('handleInit client notes create record');
        if($A.util.isEmpty(cmp.get('v.contactRelation')) ) {
            return;
        } else {
            console.log(JSON.stringify( cmp.get('v.recordId')));
            console.log(JSON.stringify( cmp.get('v.sObjectName')));
            console.log(JSON.stringify( cmp.get('v.contactRelation')));

            helper.execute(cmp, 'ClientNotesCreateRecordMetaProc',
                {
                    recordId: cmp.get('v.recordId'),
                    sObjectName: cmp.get('v.sObjectName'),
                    contactRelation: cmp.get('v.contactRelation')
                }
            );
        }
        console.log(JSON.stringify(cmp.get('v.meta.dto')));
    },

    handleCancelClick: function (cmp, event, helper) {
        cmp.cancelModal();
    },

});