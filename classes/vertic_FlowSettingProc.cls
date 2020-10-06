public class vertic_FlowSettingProc extends vertic_FlowProc {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private Flow_Setting__mdt csvFlowSetting;
    private Map<Id, Flow_Input_Format__mdt> csvFlowInputFormatMap = new Map<Id, Flow_Input_Format__mdt>();

    private void doSubmit() {

        if(this.request.has('setting')){
            this.csvFlowSetting = new Flow_Setting__mdt();
            this.request.getMapper().mapToSObject('setting', this.csvFlowSetting);
        } else {
            this.retrieveCSVFlowSetting();
        }

        this.mapInputs();
        this.mapOutputs();

        this.request.put('flow', this.csvFlowSetting.Flow_API_Name__c);

        Boolean isCheckOnly = this.request.getBoolean('checkOnly') == true;
        Savepoint checkOnlySavepoint = isCheckOnly ? Database.setSavepoint() : null;

        try {
            super.process(request);
            System.debug('RESPONSE: ' + this.response);
        } catch (Exception ex) {
            throw ex;
        } finally {
            if (checkOnlySavepoint != null){
                Database.rollback(checkOnlySavepoint);
            }
        }

    }

    private void retrieveCSVFlowSetting() {

        String CSVFlowSettingId = this.request.getString('settingId');
        String FlowSettingName = this.request.getString('settingName');

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Flow_Setting__mdt.SObjectType);
        queryFactory.selectFields(new Set<SObjectField>{
            Flow_Setting__mdt.Flow_API_Name__c
        });
        fflib_QueryFactory mappingsSubQuery = queryFactory.subselectQuery('Flow_Mappings__r');
        mappingsSubQuery.selectFields(new Set<SObjectField>{
            Flow_Mapping__mdt.Source_Path__c,
            Flow_Mapping__mdt.Flow_Input_Name__c,
            Flow_Mapping__mdt.Default__c,
            Flow_Mapping__mdt.Flow_Input_Format__c,
            Flow_Mapping__mdt.Flow_Variable_Type__c,
            Flow_Mapping__mdt.Trim_Value__c,
            Flow_Mapping__mdt.Disregard_Blank_Value__c
        });
        mappingsSubQuery.setCondition('Active__c = true');

        if (String.isNotBlank(CSVFlowSettingId)) {
            queryFactory.setCondition('Id = :CSVFlowSettingId');
            this.csvFlowSetting = (Flow_Setting__mdt) vertic_Utils.arrays.firstOrException(
                Database.query(queryFactory.toSOQL()),
                'No Flow_Setting__mdt with Id: ' + CSVFlowSettingId
            );
        } else if (String.isNotBlank(FlowSettingName)) {
            queryFactory.setCondition('DeveloperName = :FlowSettingName');
            this.csvFlowSetting = (Flow_Setting__mdt) vertic_Utils.arrays.firstOrException(
                Database.query(queryFactory.toSOQL()),
                'No Flow_Setting__mdt with API Name: ' + FlowSettingName
            );
        } else {
            throw new vertic_Structs.MissingDataException('No Flow Setting parameter. Please use the "settingId" or "setting" to setup the Flow_Setting__mdt for processing.');
        }

        Set<Id> flowInputFormatIds = vertic_Utils.sObjects.getIdFieldValues(this.csvFlowSetting.Flow_Mappings__r, Flow_Mapping__mdt.Flow_Input_Format__c);
        this.csvFlowInputFormatMap = new Map<Id, Flow_Input_Format__mdt>([
            SELECT Id, DeveloperName, Type__c, Format__c, True_Values__c
            FROM Flow_Input_Format__mdt
            WHERE Id IN :flowInputFormatIds
        ]);

    }

    private void mapInputs(){
        Map<String, Object> inputsMap = (Map<String, Object>) this.request.get('inputs');
        List<Flow_Mapping__mdt> csvFlowMappings = this.csvFlowSetting.Flow_Mappings__r;
        if(csvFlowMappings == null){
            csvFlowMappings = new List<Flow_Mapping__mdt>();
        }

        Map<String, Object> mappedInputs = mapFlowInputs(inputsMap, csvFlowMappings, this.csvFlowInputFormatMap);


        System.debug('inputsMap: ' + inputsMap);
        System.debug('csvFlowMappings: ' + csvFlowMappings);
        System.debug('mappedInputs: ' + mappedInputs);

//        hey.Logger.debug('mappedInputs');
//        hey.Logger.debug(mappedInputs);

        this.request.put('inputs', mappedInputs);
    }

    private void mapOutputs(){
        List<Flow_Mapping__mdt> csvFlowMappings = this.csvFlowSetting.Flow_Mappings__r;
        if(csvFlowMappings == null){
            csvFlowMappings = new List<Flow_Mapping__mdt>();
        }

        List<String> outputVariables = new List<String>();
        for (Flow_Mapping__mdt csvFlowMappingVar : csvFlowMappings) {
            if('Output'.equalsIgnoreCase(csvFlowMappingVar.Flow_Variable_Type__c)){
                outputVariables.add(csvFlowMappingVar.Flow_Input_Name__c);
            }
        }

        System.debug('outputVariables');
        System.debug(outputVariables);

        this.request.put('outputFields', outputVariables);
    }

    @TestVisible
    private static Map<String, Object> mapFlowInputs(Map<String, Object> inputsMap, List<Flow_Mapping__mdt> csvFlowMappings, Map<Id, Flow_Input_Format__mdt> csvFlowInputFormatMap){

        vertic_DTO inputDTO = new vertic_DTO(inputsMap);
        Map<String, Object> mappedInputsMap = new Map<String, Object>();

        for (Flow_Mapping__mdt csvFlowMappingVar : csvFlowMappings) {
            String columnName = csvFlowMappingVar.Source_Path__c;
            String inputName = csvFlowMappingVar.Flow_Input_Name__c;
            Flow_Input_Format__mdt inputFormat = csvFlowInputFormatMap.get(csvFlowMappingVar.Flow_Input_Format__c);

            Object value = inputDTO.get(columnName);
            //inputsMap.remove(columnName);

            if(vertic_Utils.objects.isBlankValue(value) && String.isNotBlank(csvFlowMappingVar.Default__c)){
                value = csvFlowMappingVar.Default__c;
            }

            if(value instanceof String && value != null && csvFlowMappingVar.Trim_Value__c == true){
                value = ((String)value).trim();
            }

            if(csvFlowMappingVar.Disregard_Blank_Value__c == true && vertic_Utils.objects.isBlankValue(value)){
                continue;
            }

            if (inputFormat != null) {

                if ('Date'.equalsIgnoreCase(inputFormat.Type__c)) {
                    String valueStr = value instanceof String ? (String) value : null;
                    Date dateVar = String.isBlank(valueStr) ? null :
                        String.isBlank(inputFormat.Format__c) ?
                            vertic_Utils.dates.parseDateAusFormat(valueStr) :
                            vertic_Utils.dates.parseDateAnyFormat(valueStr, inputFormat.Format__c);

                    value = dateVar == null ? null : vertic_Utils.dates.dateToDateTime(dateVar).format('YYYY-MM-dd');
                } else if ('Datetime'.equalsIgnoreCase(inputFormat.Type__c)) {
                    String valueStr = value instanceof String ? (String) value : null;
                    DateTime dateTimeVar = String.isBlank(valueStr) ? null :
                        String.isBlank(inputFormat.Format__c) ?
                            vertic_Utils.dates.parseDatetimeAusFormat(valueStr) :
                            vertic_Utils.dates.parseDatetimeAnyFormat(valueStr, inputFormat.Format__c);

                    value = dateTimeVar == null ? null : dateTimeVar.format('YYYY-MM-dd');
                } else if ('Boolean'.equalsIgnoreCase(inputFormat.Type__c)){

                    String valueStr = value instanceof String ? (String) value : null;

                    if(valueStr != null){
                        String trueValuesStr = vertic_Utils.objects.defaultIfNull(inputFormat.True_Values__c, 'true,yes,1');
                        List<String> trueValues = trueValuesStr.split(',');
                        Set<String> trueValuesFormatted = new Set<String>();
                        for (String val : trueValues) {
                            trueValuesFormatted.add(val.trim().toUpperCase());
                        }
                        value = String.isBlank(valueStr) ? false : trueValuesFormatted.contains(valueStr.trim().toUpperCase());
                    } else if (!(value instanceof Boolean)){
                        value = false;
                    }
                }
            }

            mappedInputsMap.put(inputName, value);
        }
        return mappedInputsMap;
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties: 
    // vertic_request
    // vertic_response


}