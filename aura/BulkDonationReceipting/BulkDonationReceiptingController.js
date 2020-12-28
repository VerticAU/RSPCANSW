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

        var emailIds = selected.filter(function (item) {
            return item.channel === 'Email';
        }).map(function (item) {
            return item.Id;
        });

        var mailIds = selected.filter(function (item) {
            return item.channel === 'Mail';
        }).map(function (item) {
            return item.Id;
        });

        console.log(emailIds, mailIds);

        var modalService = cmp.find('modalService');
        modalService.show(
            'c:BulkReceiptingConfirm',
            {
                processor: 'BulkDonationReceiptingGenerateProc',
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
                item.selected = item.channel === 'Email';
            });
        } else if(selectedMenuItemValue === 'Select Only Mail'){
            items.forEach(function (item) {
                item.selected = item.channel === 'Mail';
            });
        } else if(selectedMenuItemValue === 'Set Mail Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Mail') !== -1) {
                    item.channel = 'Mail';
                }
            });
        } else if(selectedMenuItemValue === 'Set Email Channel'){
            items.forEach(function (item) {
                if(item.channels && item.channels.indexOf('Email') !== -1){
                    item.channel = 'Email';
                }
            });
        }

        table.set('v.items', items);
    },
})