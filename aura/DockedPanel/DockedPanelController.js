({
    handleHide: function(cmp, event, helper){
        cmp.set('v.isVisible', false);
    },

    handleShow: function(cmp, event, helper){
        cmp.set('v.isVisible', true);
    },
})