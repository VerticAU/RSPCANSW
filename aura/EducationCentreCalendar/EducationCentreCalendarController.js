({
  doInit: function (cmp, event, helper) {
    var recordId = cmp.get('v.recordId');
    cmp.set('v.myFilters', [
        { 'fieldName': 'B25__Is_Active__c', 'operator': '=', 'value': 'true'},
        {
            type: 1,
            logicalOperator: 'OR',
            subFilters: [
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a301y0000001PK7AAM'},
                { 'fieldName': 'B25__Parent__c', 'operator': '=', 'value': 'a301y0000001PrwAAE'}       
            ]
        }
    ]);
  }
})