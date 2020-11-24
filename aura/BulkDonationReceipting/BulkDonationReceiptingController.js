({
    handleInit: function(cmp, event, helper){
        cmp.set('v.meta.dto.filter', {
            startDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd'),
            endDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd'),
            acknowledgmentStatus: 'unreceipted'
        });
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;

        helper.searchContributions(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.contributions.records);
            table.set('v.hasMore', response.dto.contributions.hasMore);
            table.set('v.limit', response.dto.contributions.limit);
            table.selectAll();
            // helper.calculateTotals(cmp, event, helper, response.dto.contributions.records);
        });
    },

    handleReceipt: function(cmp, event, helper){

        var table = cmp.find('table');
        if(!table.validate()){
            return;
        }

        var selected = table.getSelected() || [];
        if(!selected.length){
            helper.utils(cmp).showToast({
                type: 'warning',
                message: 'No Selected Donations'
            });
            return;
        }

        var emailIds = selected.map(function (item) {
            return item.Id;
        });;

        console.log('emailIds', emailIds);

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingConfirm',
            {
                processor: 'BulkDonationReceiptingGenerateProc',
                payload: {
                    emailIds: emailIds,
                    filter: cmp.get('v.meta.dto.filter')
                }
            },
            {
                header: 'Email Receipts',
                cssClass: 'slds-modal-small'
            }
        ).then($A.getCallback(function (closeResult) {
            // cmp.find('filter').refresh();
            // helper.getBaseCmp(cmp).utils.showToast(
            //     {
            //         message: 'User creation is in progress.',
            //         type: 'success'
            //     }
            // );
            // helper.refresh(cmp, event, helper);
        }), function (error) {

        });

    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },

    handleExportClick: function(cmp, event, helper){

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingDonationsCSVExport',
            {
                filter: cmp.get('v.meta.dto.filter')
            },
            {
                header: 'Donations Export',
                cssClass: 'slds-modal-small'
            }
        ).then($A.getCallback(function (closeResult) {
        }), function (error) {
        });
    }
})