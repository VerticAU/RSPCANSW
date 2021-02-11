({
    handleConfirmAndNew: function (cmp) {
        var onNextEvent = cmp.getEvent('onPrevious');
        onNextEvent.setParams({
            payload: {
                step: 'confirm&new',
                meta: cmp.get('v.meta')
            }
        })
        onNextEvent.fire();
    }
});