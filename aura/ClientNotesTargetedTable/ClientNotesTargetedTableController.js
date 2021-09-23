({
    handleInit: function(cmp, event, helper){
        if($A.util.isEmpty(cmp.get('v.contactRelation')) && $A.util.isEmpty(cmp.get('v.targetRelation'))) {
            return;
        }
        helper.searchNotes(cmp, event, helper).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.notes.records);
            table.set('v.limit', response.dto.notes.limit);
            cmp.set('v.hasMore', response.dto.notes.hasMore);
            table.сhangeAllExpanded();
            helper.calculateTotals(cmp, event, helper, response.dto.notes.records);
        });
    },

    handleAllExpandedChange: function (cmp, event, helper) {
        var table = cmp.find('table');
        table.сhangeAllExpanded();
    },

    handleViewAll: function (cmp, event, helper) {
        var navService = cmp.find('navService');
        var pageRef = {
            type: 'standard__component',
            attributes: {
                componentName: 'c:ClientNotesSearch'
            }
        }

        var filterRecordId = helper.getFilterRecordId(cmp, helper)
        if(!$A.util.isUndefinedOrNull(filterRecordId)){
            pageRef.state = {
                c__filterRecordId: filterRecordId
            };
        }

        navService.navigate(pageRef);
    },

    newClientNote: function (cmp, event, helper) {
        cmp.find('modalService').show(
            'c:ClientNotesCreateRecord',
            {
                recordId: cmp.get('v.recordId'),
                sObjectName: cmp.get('v.sObjectName'),
                contactRelation: cmp.get('v.contactRelation')
            },
            {
                header: 'Create New Client Note',
                cssClass: 'slds-modal_small',
                showfooter: true
            }
        );
    }
})