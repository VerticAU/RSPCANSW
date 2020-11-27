({
    handleInit: function(cmp, event, helper){
        cmp.set('v.meta.dto.filter', {
            // startDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd'),
            // endDate: $A.localizationService.formatDate(new Date(), 'yyyy-MM-dd'),
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
        if(!table.validate()){
            return;
        }

        var selected = table.getSelected() || [];
        if(!selected.length){
            helper.utils(cmp).showToast({
                type: 'warning',
                message: 'No Selected Recurring Donations'
            });
            return;
        }

        var emailIds = selected.filter(function (item) {
            return item.channel == 'Email';
        }).map(function (item) {
            return item.Id;
        });;

        var mailIds = selected.filter(function (item) {
            return item.channel == 'Letter';
        }).map(function (item) {
            return item.Id;
        });

        console.log(emailIds, mailIds);

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingConfirm',
            {
                processor: 'BulkAnnualReceiptingGenerateProc',
                payload: {
                    emailIds: emailIds,
                    mailIds: mailIds,
                    filter: cmp.get('v.meta.dto.filter'),
                }
            },
            {
                header: 'Receipting',
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

    handleTableSettingSelect: function(cmp, event, helper){
        var selectedMenuItemValue = event.getParam("value");

        var table = cmp.find('table');
        var items = table.get('v.items') || [];

        if(selectedMenuItemValue === 'Select Only Email'){
            items.forEach(function (item) {
                item.selected = item.channel === 'Email';
            });
        } else if(selectedMenuItemValue === 'Select Only Letter'){
            items.forEach(function (item) {
                item.selected = item.channel === 'Letter';
            });
        } else if(selectedMenuItemValue === 'Set Email Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Email') !== -1) {
                    item.channel = 'Email';
                }
            });
        } else if(selectedMenuItemValue === 'Set Letter Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Letter') !== -1){
                    item.channel = 'Letter';
                }
            });
        }

        table.set('v.items', items);
    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },


    handleExportClick: function(cmp, event, helper){

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingCSVExport',
            {
                filter: cmp.get('v.meta.dto.filter')
            },
            {
                header: 'Recurring List Export',
                cssClass: 'slds-modal-small'
            }
        ).then($A.getCallback(function (closeResult) {
        }), function (error) {
        });
    }
})