({

    triggerDeleteAffiliationEvent: function (cmp, event) {

        var event = cmp.getEvent('deleteAffiliationEvent');
        event.setParams({
            "payload": {
                index: cmp.get('v.index')
            }
        })
        event.fire()

    },

})