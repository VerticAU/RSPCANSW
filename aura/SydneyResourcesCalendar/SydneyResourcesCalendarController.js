({
	doInit : function(cmp, event, helper) {
        cmp.set("v.SydneyResourcesCalendar", {
            sobjectType: 'B25__Reservation__c',
            B25__Staff__c: cmp.get('v.recordId')
        });

        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT Id, pmdm__DeliveryDate__c FROM pmdm__ServiceDelivery__c WHERE Id = \'' + cmp.get('v.recordId') + '\' LIMIT 1'
            }
        ).then(function (response) {
            if (response.isValid) {
                let delivery = response.dto.records[0];
                if(!$A.util.isUndefinedOrNull(delivery) && !$A.util.isUndefinedOrNull(delivery.pmdm__DeliveryDate__c)) {
                    var timezone = $A.get("$Locale.timezone");
                    var dateTimeUTC = $A.localizationService.parseDateTimeUTC(delivery.pmdm__DeliveryDate__c);
                    $A.localizationService.UTCToWallTime(dateTimeUTC, timezone, function (wallTime) {
                        cmp.set('v.meta.dto.deliveryDate', wallTime.toISOString().slice(0, 10));
                    });
                } else {
                    cmp.set('v.meta.dto.deliveryDate', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                }
            } else {
                cmp.set('v.meta.dto.deliveryDate', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
            }
        });
	}
})