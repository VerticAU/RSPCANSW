({
	doInit : function(cmp, event, helper) {
        var reservation = {
            sobjectType: 'B25__Reservation__c',
            Service_Session__c: cmp.get('v.recordId')
        };

        helper.execute(cmp, 'vertic_SOQLProc',
            {
                SOQL: 'SELECT Id, pmdm__SessionStart__c, pmdm__ServiceSchedule__r.pmdm__Service__r.pmdm__Program__c FROM pmdm__ServiceSession__c WHERE Id = \'' + cmp.get('v.recordId') + '\' LIMIT 1'
            }
        ).then(function (response) {
            var startDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if (response.isValid) {
                try {
                    var session = response.dto.records[0];
                    var timezone = $A.get("$Locale.timezone");
                    var dateTimeUTC = $A.localizationService.parseDateTimeUTC(session.pmdm__SessionStart__c);
                    $A.localizationService.UTCToWallTime(dateTimeUTC, timezone, function (wallTime) {
                        startDate = wallTime.toISOString().slice(0, 10);
                    });
                    reservation.Program__c = session.pmdm__ServiceSchedule__r.pmdm__Service__r.pmdm__Program__c;
                } catch (e) {
                    console.log(e.message);
                }
            }
            cmp.set('v.meta.dto.startDate', startDate);
            cmp.set("v.myPrototypeReservation", reservation);
        });
    }
})