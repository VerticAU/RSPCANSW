({
	doInit : function(component, event, helper) {
        component.set("v.AssetsCalendar", {
            sobjectType: 'B25__Reservation__c',
            B25__Staff__c: component.get('v.recordId')
        });
	}
})