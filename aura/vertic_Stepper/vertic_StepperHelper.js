({
    renderStep: function(cmp, event, helper, screenComponent, params){
        params = params || {};
        params.isModal = cmp.get('v.isModal');
        params.modalInstance = cmp.get('v.modalInstance');

        var stepComponent = cmp.getStepComponent();
        if(stepComponent){
            stepComponent.set('v.isBusy', true);
        }
        console.log(screenComponent);
        helper.utils(cmp).createComponent(screenComponent, params).then(function (newCmp) {
            cmp.set('v.step', newCmp);
        }).finally(function () {
            if(stepComponent){
                stepComponent.set('v.isBusy', false);
            }
        });
    },

})