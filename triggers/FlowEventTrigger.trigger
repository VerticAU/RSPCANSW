trigger FlowEventTrigger on Flow_Event__e (after insert) {

    try {

        List<Flow_Event__e> events = (List<Flow_Event__e>)Trigger.new;

        List<Vertic_Async_Process__c> failedProcesses = new List<Vertic_Async_Process__c>();

        for (Flow_Event__e eventVar : events) {
            vertic_Response response;
            Map<String, Object> requestMap;
            Map<String, Object> payloadMap;
            Exception exceptionVar;

            try {
                payloadMap = (Map<String, Object>) JSON.deserializeUntyped(eventVar.Payload__c);
            } catch (Exception e) {
                payloadMap = new Map<String, Object>{
                    'INVALID_PAYLOAD_JSON' => eventVar.Payload__c
                };
            }

            hey.Logger.debug(payloadMap);

            try {
                requestMap = new Map<String, Object>{
                    'settingName' => eventVar.Flow_Setting__c,
                    'inputs' => payloadMap
                };
                response = new vertic_FlowSettingProc2().process(requestMap);
            } catch (Exception e) {
                hey.Logger.exception(e);
                exceptionVar = e;
            } finally {
                if(response == null || response.isValid != true){
                    System.debug('save VAP');
                    failedProcesses.add(new Vertic_Async_Process__c(
                        Processor__c = '' + vertic_FlowSettingProc2.class,
                        Payload__c = JSON.serialize(requestMap),
                        Details__c = exceptionVar != null ?
                            exceptionVar.getMessage() :
                            response == null ?
                                null :
                                JSON.serializePretty(response.errors),
                        Autorun__c = false,
                        Status__c = 'Failed'
                    ));
                }
            }
        }

        hey.Logger.debug(failedProcesses);

        insert failedProcesses;

    } catch (Exception e) {

    } finally {
        hey.Logger.publish();
    }

}