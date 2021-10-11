({
    doInit : function(cmp, event, helper) {
        cmp.set('v.myFilters', [{
            type: 1,
            logicalOperator: 'OR',
            subFilters: [
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a3g2x000000c5t0AAA'},
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a3g2x000000c5t5AAA'},
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a3g2x000000c5svAAA'},
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a3g2x000000c60QAAQ'},
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a3g2x000000c5t6AAA'}
            ]
        }]);

        var reservation = { sobjectType: 'B25__Reservation__c' };
        var startDate = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");

        var recordId = cmp.get('v.recordId');

        if(!$A.util.isUndefinedOrNull(recordId)){
            reservation.Service_Session__c = recordId;

            helper.execute(cmp, 'vertic_SOQLProc',
                {
                    SOQL: 'SELECT Id, pmdm__SessionStart__c FROM pmdm__ServiceSession__c WHERE Id = \'' + recordId + '\' LIMIT 1'
                }
            ).then(function (response) {
                if (response.isValid) {
                    try {
                        var session = response.dto.records[0];
                        var timezone = $A.get("$Locale.timezone");
                        var dateTimeUTC = $A.localizationService.parseDateTimeUTC(session.pmdm__SessionStart__c);
                        $A.localizationService.UTCToWallTime(dateTimeUTC, timezone, function (wallTime) {
                            startDate = wallTime.toISOString().slice(0, 10);
                        });
                    } catch (e) {}
                }
                cmp.set('v.meta.dto.startDate', startDate)
            });
        } else {
            cmp.set('v.meta.dto.startDate', startDate)
        }

        cmp.set("v.myPrototypeReservation", reservation);
    }
})