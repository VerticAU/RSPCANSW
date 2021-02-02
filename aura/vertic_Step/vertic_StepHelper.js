({
    next: function (cmp) {
        if (!cmp.find('modal').validate()) {
            return;
        }

        var onNextEvent = cmp.getEvent('onNext');
        onNextEvent.setParams({
            payload: {
                step: cmp.get('v.name'),
                meta: cmp.get('v.meta')
            }
        })
        onNextEvent.fire();
    },

    previous: function (cmp) {
        var onNextEvent = cmp.getEvent('onPrevious');
        onNextEvent.setParams({
            payload: {
                step: cmp.get('v.name'),
                meta: cmp.get('v.meta')
            }
        })
        onNextEvent.fire();
    }
});