({



    addNewAffiliation: function (cmp) {
        var affiliations = cmp.get('v.affiliations') || []
        affiliations.push(this.newAffiliation())
        cmp.set('v.affiliations', affiliations)
    },

    newAffiliation: function () {
        return {
            isValid: false
        }
    },

    deleteAffiliation: function (cmp, event) {

        var payload = event.getParam('payload')

        console.log('payload', payload, payload.index)

        if (payload && payload.index != undefined) {
            var affiliations = cmp.get('v.affiliations') || [];
            affiliations.splice(payload.index, 1);
            cmp.set('v.affiliations', affiliations);
        }
    },

})