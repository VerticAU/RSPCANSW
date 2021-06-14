({
	doInit : function(cmp, event, helper) {
	    var reservation = {
            sobjectType: 'B25__Reservation__c',
            Service_Delivery__c: cmp.get('v.recordId')
            // B25__Staff__c: cmp.get('v.recordId')
        };
        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT Id, pmdm__Contact__c, pmdm__DeliveryDate__c FROM pmdm__ServiceDelivery__c WHERE Id = \'' + cmp.get('v.recordId') + '\' LIMIT 1'
            }
        ).then(function (response) {

            var deliveryDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if (response.isValid) {
                let delivery = response.dto.records[0];
                if(!$A.util.isUndefinedOrNull(delivery)) {
                    if(!$A.util.isUndefinedOrNull(delivery.pmdm__DeliveryDate__c)){
                        var timezone = $A.get("$Locale.timezone");
                        var dateTimeUTC = $A.localizationService.parseDateTimeUTC(delivery.pmdm__DeliveryDate__c);
                        $A.localizationService.UTCToWallTime(dateTimeUTC, timezone, function (wallTime) {
                            deliveryDate = wallTime.toISOString().slice(0, 10)
                        });
                    }
                    if(!$A.util.isUndefinedOrNull(delivery.pmdm__Contact__c)) {
                        reservation.B25__Contact__c = delivery.pmdm__Contact__c;
                    }
                }
            }
            cmp.set('v.meta.dto.deliveryDate', deliveryDate);
        });
        cmp.set("v.myPrototypeReservation", reservation);
    }
})