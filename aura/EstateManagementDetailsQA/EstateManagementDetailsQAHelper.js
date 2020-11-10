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

    addNewPartner: function (cmp) {
        var partners = cmp.get('v.partners') || []
        partners.push(this.newPartner())
        cmp.set('v.partners', partners)
    },

    newPartner: function () {
        return {
            isValid: false
        }
    },

    deleteAffiliation: function (cmp, event) {

        var payload = event.getParam('payload')
        if (payload && payload.index != undefined) {
            var affiliations = cmp.get('v.affiliations') || [];
            affiliations.splice(payload.index, 1);
            cmp.set('v.affiliations', affiliations);
        }
    },

    deletePartner: function (cmp, event) {

        var payload = event.getParam('payload')
        if (payload && payload.index != undefined) {
            var partners = cmp.get('v.partners') || [];
            partners.splice(payload.index, 1);
            cmp.set('v.partners', partners);
        }
    },

})