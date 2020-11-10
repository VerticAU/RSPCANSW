({

    triggerDeletePartnerEvent: function (cmp, event) {

        var event = cmp.getEvent('deletePartnerEvent');
        event.setParams({
            "payload": {
                index: cmp.get('v.index')
            }
        })
        event.fire()

    },

})