({
    handleInit: function(cmp, event, helper){
        cmp.set('v.meta.dto.filter', {
            acknowledgmentStatus: 'unreceipted'
        });
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;

        helper.search(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.contacts.records);
            table.set('v.hasMore', response.dto.contacts.hasMore);
            table.set('v.limit', response.dto.contacts.limit);
            table.selectAll();
            //helper.calculateTotals(cmp, event, helper, response.dto.contacts.records);
        }).then(function () {
            //cmp.set('v.meta.dto.filter', filter);
        });
    },

    handleReceipt: function(cmp, event, helper){

        var table = cmp.find('table');
        if(!table.validate()){ return; }

        var selected = table.getSelected() || [];
        if(!selected.length){
            helper.utils(cmp).showToast({
                type: 'warning',
                message: 'No Selected Recurring Donations'
            });
            return;
        }

        var emailIds = selected.map(function (item) {
            return item.Id;
        });

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingConfirm',
            {
                processor: 'BulkAnnualReceiptingGenerateProc',
                payload: {
                    emailIds: emailIds,
                    filter: cmp.get('v.meta.dto.filter'),
                }
            },
            {
                header: 'Receipting',
                cssClass: 'slds-modal-small'
            }
        ).then(
            $A.getCallback(function (closeResult) {}),
            $A.getCallback(function (error) {})
        );

    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },

    handleExportClick: function(cmp, event, helper){

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkAnnualReceiptingCSVExport',
            {
                filter: cmp.get('v.meta.dto.filter')
            },
            {
                header: 'Recurring List Export',
                cssClass: 'slds-modal-small'
            }
        ).then(
            $A.getCallback(function (closeResult) {}),
            $A.getCallback(function (error) {})
        );
    }
})