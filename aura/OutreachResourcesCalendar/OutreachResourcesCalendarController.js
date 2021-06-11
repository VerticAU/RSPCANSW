({
	doInit : function(cmp, event, helper) {
        cmp.set("v.myPrototypeReservation", {
            sobjectType: 'B25__Reservation__c'
        });

        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT Id, pmdm__SessionStart__c FROM pmdm__ServiceSession__c WHERE Id = \'' + cmp.get('v.recordId') + '\' LIMIT 1'
            }
        ).then(function (response) {
            if (response.isValid) {
                let session = response.dto.records[0];
                if(!$A.util.isUndefinedOrNull(session) && !$A.util.isUndefinedOrNull(session.pmdm__SessionStart__c)) {
                    var timezone = $A.get("$Locale.timezone");
                    var dateTimeUTC = $A.localizationService.parseDateTimeUTC(session.pmdm__SessionStart__c);
                    $A.localizationService.UTCToWallTime(dateTimeUTC, timezone, function (wallTime) {
                        cmp.set('v.meta.dto.startDate', wallTime.toISOString().slice(0, 10));
                    });
                } else {
                    cmp.set('v.meta.dto.startDate', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
                }
            } else {
                cmp.set('v.meta.dto.startDate', $A.localizationService.formatDate(new Date(), "YYYY-MM-DD"));
            }
        });
	}
})