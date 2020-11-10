({


    handleNewAffiliationClick: function (cmp, event, helper){
        helper.addNewAffiliation(cmp)
    },

    handleDeleteAffiliationEvent: function (cmp, event, helper) {
        helper.deleteAffiliation(cmp, event)
    },


    handleNewPartnerClick: function (cmp, event, helper){
        helper.addNewPartner(cmp)
    },

    handleDeletePartnerEvent: function (cmp, event, helper) {
        helper.deletePartner(cmp, event)
    },

})