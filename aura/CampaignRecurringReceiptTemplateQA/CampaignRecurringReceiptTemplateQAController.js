({
    handleSubmitClick: function (cmp, event, helper) {

        if (!cmp.find('modal').validate()) { return; }

        helper.execute(
            cmp,
            'RecurringReceiptTemplateQASubmitProc',
            {
                campaignId: cmp.get('v.recordId'),
                recurringAcknowledgementTemplateId: cmp.get('v.meta.dto.recurringAcknowledgementTemplateId')
            },
            function () {},
            function () {}
        ).then(function (response) {

            cmp.find('modal').close();
            cmp.find('notifLib').showToast({
                variant: 'success',
                message: 'The Campaign Recurring Donation Acknowledgement Template was updated!'
            });

        }).catch(function (errors) {
            var errorMessagesCmp = cmp.find('modal').find('errorMessages');
            errorMessagesCmp.showErrors(errors, true);
        });
    }
});