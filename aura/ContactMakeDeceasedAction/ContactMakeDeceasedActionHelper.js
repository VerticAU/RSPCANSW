({
    initContactStatus : function(cmp, event, helper) {
        var that = this;

        cmp.utils.callApex(
            cmp.get('c.initContactStatus'),
            {
                recordId: cmp.get('v.recordId')
            },
            function (response) {
                response = response || {};
                cmp.set('v.contactStatus', response);
            },
            function(errors) {
                that.showErrors(cmp, errors);
            }
        );
    },

    doMakeDeceased: function (cmp) {
        var that = this;
        var recordId = cmp.get('v.recordId');
        var deceasedDate = cmp.get('v.deceasedDate');
        var activityDate = cmp.get('v.activityDate');
        cmp.set('v.isBusy', true);

        cmp.utils.callApexPromise(
            cmp.get("c.optOutEmailContact"), {"recordId": recordId})
            .then($A.getCallback(function (response) {
                return cmp.utils.callApexPromise(cmp.get("c.makeDeceasedContact"),
                    {
                        "recordId": recordId,
                        "deceasedDate": deceasedDate,
                        "activityDate": activityDate
                    });
            })).then($A.getCallback(function (response) {
            cmp.utils.showToast(
                {
                    "message": "Status is successfully changed to Deceased.",
                    "type": "success"
                }
            );
        })).catch($A.getCallback(function (error) {
            cmp.utils.showToast({
                title: "Error!",
                message: error ? error.message : 'Unknown error',
                type: 'error'
            });
        })).finally(function () {
            that.closeQuickActionAndRefreshView();
            cmp.set('v.isBusy', false);
        });
    },

    closeQuickActionAndRefreshView: function () {
        var closeAction = $A.get("e.force:closeQuickAction");
        closeAction.fire();

        var refreshAction = $A.get("e.force:refreshView");
        refreshAction.fire();
    }
})