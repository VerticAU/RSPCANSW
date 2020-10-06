({
    init: function(cmp, evt, helper) {
        helper.initContactStatus(cmp, evt, helper);
    },

    handleNextClick: function (cmp, event, helper) {
        cmp.set('v.step', 2);
    },

    handleSaveClick: function (cmp, event, helper) {
        helper.doMakeDeceased(cmp)
    }
})