({

    handleSubmit: function (cmp, event, helper) {

        var affiliations = cmp.get('v.affiliations') || []

        cmp.set('v.meta.dto.affiliations', affiliations);
        var request = cmp.get('v.meta.dto') || {};

        helper.execute(
            cmp,
            'EstateManagementQASubmitProc',
            request,
            $A.getCallback(function (response) {

                // var toastEvent = $A.get("e.force:showToast");
                // toastEvent.setParams({
                //     "message": '',
                //     "type": "success"
                // });
                // toastEvent.fire();

                $A.get("e.force:closeQuickAction").fire();
            }),
            function (errors) {
                var errorMessages = errors.map(function (error) {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "message": error.message,
                        "type": "error"
                    });
                    toastEvent.fire();

                    return error.message;


                })
                throw errors;
            }
        );

    },

    handleIsShowNextEvent: function (cmp, event, helper) {

        var isShowNext = cmp.get('v.meta.dto.createEstate');
        cmp.set('v.isShowNext', isShowNext);
    },

    handleExitClick: function (cmp, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },

    handleNextClick: function (cmp, event, helper) {
        if(!cmp.validate()){
            return;
        }

        cmp.set('v.step', 2);
    },

    handlePreviousClick: function (cmp, event, helper) {
        cmp.set('v.step', 1);
    }

})