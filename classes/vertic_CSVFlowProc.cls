public class vertic_CSVFlowProc extends vertic_FlowProc {

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

    private CSV_Flow_Setting__mdt csvFlowSetting;
    private Map<Id, CSV_Flow_Input_Format__mdt> csvFlowInputFormatMap = new Map<Id, CSV_Flow_Input_Format__mdt>();

    private void doSubmit() {

        if(this.request.has('setting')){
            this.csvFlowSetting = new CSV_Flow_Setting__mdt();
            this.request.getMapper().mapToSObject('setting', this.csvFlowSetting);
        } else {
            this.retrieveCSVFlowSetting();
        }

        this.mapInputs();

        this.request.put('flow', this.csvFlowSetting.Flow_API_Name__c);

        Boolean isCheckOnly = this.request.getBoolean('checkOnly') == true;
        Savepoint checkOnlySavepoint = isCheckOnly ? Database.setSavepoint() : null;

        try {
            super.process(request);
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
        String CSVFlowSettingName = this.request.getString('settingName');

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(CSV_Flow_Setting__mdt.SObjectType);
        queryFactory.selectFields(new Set<SObjectField>{
            CSV_Flow_Setting__mdt.Flow_API_Name__c
        });
        fflib_QueryFactory mappingsSubQuery = queryFactory.subselectQuery('CSV_Flow_Mappings__r');
        mappingsSubQuery.selectFields(new Set<SObjectField>{
            CSV_Flow_Mapping__mdt.CSV_Column_Name__c,
            CSV_Flow_Mapping__mdt.Flow_Input_Name__c,
            CSV_Flow_Mapping__mdt.Default__c,
            CSV_Flow_Mapping__mdt.CSV_Flow_Input_Format__c,
            CSV_Flow_Mapping__mdt.Trim_Value__c,
            CSV_Flow_Mapping__mdt.Disregard_Blank_Value__c
        });
        mappingsSubQuery.setCondition('Active__c = true');

        if (String.isNotBlank(CSVFlowSettingId)) {
            queryFactory.setCondition('Id = :CSVFlowSettingId');
            this.csvFlowSetting = (CSV_Flow_Setting__mdt) vertic_Utils.arrays.firstOrException(
                Database.query(queryFactory.toSOQL()),
                'No CSV_Flow_Setting__mdt with Id: ' + CSVFlowSettingId
            );
        } else if (String.isNotBlank(CSVFlowSettingName)) {
            queryFactory.setCondition('DeveloperName = :CSVFlowSettingName');
            this.csvFlowSetting = (CSV_Flow_Setting__mdt) vertic_Utils.arrays.firstOrException(
                Database.query(queryFactory.toSOQL()),
                'No CSV_Flow_Setting__mdt with API Name: ' + CSVFlowSettingName
            );
        } else {
            throw new vertic_Structs.MissingDataException('No CSV Flow Setting parameter. Please use the "settingId" or "setting" to setup the CSV_Flow_Setting__mdt for processing.');
        }

        Set<Id> flowInputFormatIds = vertic_Utils.sObjects.getIdFieldValues(this.csvFlowSetting.CSV_Flow_Mappings__r, CSV_Flow_Mapping__mdt.CSV_Flow_Input_Format__c);
        this.csvFlowInputFormatMap = new Map<Id, CSV_Flow_Input_Format__mdt>([
            SELECT Id, DeveloperName, Type__c, Format__c, True_Values__c
            FROM CSV_Flow_Input_Format__mdt
            WHERE Id IN :flowInputFormatIds
        ]);

    }

    private void mapInputs(){
        Map<String, Object> inputsMap = (Map<String, Object>) this.request.get('inputs');
        List<CSV_Flow_Mapping__mdt> csvFlowMappings = this.csvFlowSetting.CSV_Flow_Mappings__r;
        if(csvFlowMappings == null){
            csvFlowMappings = new List<CSV_Flow_Mapping__mdt>();
        }

        Map<String, Object> mappedInputs = mapFlowInputs(inputsMap, csvFlowMappings, this.csvFlowInputFormatMap);
        this.request.put('inputs', mappedInputs);
    }

    @TestVisible
    private static Map<String, Object> mapFlowInputs(Map<String, Object> inputsMap, List<CSV_Flow_Mapping__mdt> csvFlowMappings, Map<Id, CSV_Flow_Input_Format__mdt> csvFlowInputFormatMap){
        for (CSV_Flow_Mapping__mdt csvFlowMappingVar : csvFlowMappings) {
            String columnName = csvFlowMappingVar.CSV_Column_Name__c;
            String inputName = csvFlowMappingVar.Flow_Input_Name__c;
            CSV_Flow_Input_Format__mdt inputFormat = csvFlowInputFormatMap.get(csvFlowMappingVar.CSV_Flow_Input_Format__c);

            Object value = inputsMap.remove(columnName);

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

            inputsMap.put(inputName, value);
        }
        return inputsMap;
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