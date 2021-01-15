({
    handleInit: function(cmp, event, helper){
        cmp.set('v.meta.dto.filter', {
            acknowledgmentStatus: 'unreceipted'
        });
    },

    handleSearch: function(cmp, event, helper){
        var filter = event.getParams().payload.filter;

        console.log('filter: ', JSON.stringify(filter));

        helper.search(cmp, event, helper, filter).then(function (response) {
            var table = cmp.find('table');
            table.set('v.items', response.dto.donors.records);
            table.set('v.hasMore', response.dto.donors.hasMore);
            table.set('v.limit', response.dto.donors.limit);
            table.selectAll();
            helper.calculateTotals(cmp, event, helper, response.dto.donors.records);
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

        var emailIds = selected.filter(function (item) {
            return item.channel === 'Email Receipt';
        }).map(function (item) {
            return item.Id;
        });

        var mailIds = selected.filter(function (item) {
            return item.channel === 'Postal Receipt';
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
                    filter: cmp.get('v.meta.dto.filter')
                }
            },
            {
                header: 'Receipting',
                cssClass: 'slds-modal-small'
            }
        ).then($A.getCallback(function (closeResult) {}), function (error) {});

    },

    handleToggleSearchClick : function (cmp, event, helper) {
        event.getSource().set('v.selected', !event.getSource().get('v.selected'));
    },

    handleTableSettingSelect: function(cmp, event, helper){
        var selectedMenuItemValue = event.getParam("value");

        var table = cmp.find('table');
        var items = table.get('v.items') || [];

        if(selectedMenuItemValue === 'Select Only Email'){
            items.forEach(function (item) {
                item.selected = item.channel === 'Email Receipt';
            });
        } else if(selectedMenuItemValue === 'Select Only Postal'){
            items.forEach(function (item) {
                item.selected = item.channel === 'Postal Receipt';
            });
        } else if(selectedMenuItemValue === 'Set Postal Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Postal Receipt') !== -1) {
                    item.channel = 'Postal Receipt';
                }
            });
        } else if(selectedMenuItemValue === 'Set Email Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Email Receipt') !== -1){
                    item.channel = 'Email Receipt';
                }
            });
        }

        table.set('v.items', items);
    },

})