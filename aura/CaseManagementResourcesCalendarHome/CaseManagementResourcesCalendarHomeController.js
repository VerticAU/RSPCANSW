({
	doInit : function(cmp, event, helper) {
        cmp.set("v.myPrototypeReservation", {
            sobjectType: 'B25__Reservation__c'
        });
        cmp.set('v.startDate', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
	}
})