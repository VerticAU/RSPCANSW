public class CleverContactsSyncMemberProc extends vertic_AbstractProcessor {

    private static String ENDPOINT = 'callout:Clever_Contacts/';

    private static final String POST = 'POST';

    private static final String CONTENT_TYPE_HEADER = 'Content-Type';
    private static final String ACCEPT_HEADER = 'Accept';
    private static final String APP_JSON_TYPE = 'application/json';

    private Map<String, String> ccKeyToChildRelationshipMapping = new Map<String, String>();
    private Map<String, String> ccKeyToParentFieldMapping = new Map<String, String>();
    private Map<String, Set<String>> childRelationshipToFields = new Map<String, Set<String>>();
    private Map<String, Object> data = new Map<String, Object>();

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.retrieveCampaignMember();
        this.retrieveCMDTMapping();
        this.parseCMDTMappingAndRetrieveParentObject();
        this.populateRequestMapWithAuthInfo();
        this.populateRequestMapFromParentObject();

        this.sync();

        return this.response;
    }

    private void retrieveCampaignMember(){
        this.campaignMember = (CampaignMember) vertic_Utils.arrays.firstOrException([
            SELECT Id,
                Campaign.Clever_Contacts_Type__c,
                Campaign.Name,
                ContactId,
                LeadId
            FROM CampaignMember
            WHERE Id =: THIS.request.getRequiredString('recordId')
        ]);
    }

    private String getParentObjectId(){
        if(this.parentSObjectType == Contact.SObjectType){
            return this.campaignMember.ContactId;
        } else if(this.parentSObjectType == Lead.SObjectType){
            return this.campaignMember.LeadId;
        }
        throw new vertic_Structs.MissingDataException('SObject Type is missing in mapping!');
    }

    private void parseCMDTMappingAndRetrieveParentObject() {
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(this.parentSObjectType);
        queryFactory
            .selectFields(this.ccKeyToParentFieldMapping.values())
            .setCondition('Id = \'' + getParentObjectId() + '\'')
            .setLimit(1);

        for(String childRelationshipKey : this.childRelationshipToFields.keySet()){

            if(childRelationshipKey.contains('*')){
                populateRequestMapFromSpecificChildObject(childRelationshipKey);
                continue;
            }

            String condition;
            String childRelationshipName = childRelationshipKey;
            if(childRelationshipKey.contains('(') && childRelationshipKey.contains(')')){
                condition = childRelationshipKey.substringBetween('(',')');
                childRelationshipName = childRelationshipKey.substringBefore('(') + childRelationshipKey.substringAfter(')');
            }

//            System.debug('childRelationship: ' + childRelationshipName);
            fflib_QueryFactory subQueryFactory = queryFactory.subselectQuery(childRelationshipName);
            subQueryFactory
                .selectFields(this.childRelationshipToFields.get(childRelationshipKey))
                .setOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, true)
                .setLimit(1);

            if(condition != null){ subQueryFactory.setCondition(condition); }
        }

        System.debug(queryFactory.toSOQL());
        this.parentSObject = Database.query(queryFactory.toSOQL());
    }

    private void populateRequestMapFromSpecificChildObject(String childRelationshipKey){ // requirement is to retrieve 2 related Opportunity with different condtion which is not possible in subqure
        String condition;
        String childRelationshipName = childRelationshipKey;
        if(childRelationshipKey.contains('(') && childRelationshipKey.contains(')')){
            condition = childRelationshipKey.substringBetween('(',')');
            childRelationshipName = childRelationshipKey.substringBefore('(') + childRelationshipKey.substringAfter(')');
        }
        childRelationshipName = childRelationshipName.remove('*');

        Schema.ChildRelationship childRelationship = getChildRelationship(childRelationshipName);

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(childRelationship.getChildSObject());
        queryFactory
            .selectFields(this.childRelationshipToFields.get(childRelationshipKey))
            .setOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.DESCENDING, true)
            .setLimit(1);

        if(condition != null){
            queryFactory.setCondition(condition + ' AND ' + childRelationship.getField() + ' = \'' + getParentObjectId() + '\'');
        } else {
            queryFactory.setCondition(childRelationship.getField() + ' = \'' + getParentObjectId() + '\'');
        }

        System.debug('queryFactory.toSOQL(): ' + queryFactory.toSOQL());
        List<SObject> childSObjects = Database.query(queryFactory.toSOQL());
        System.debug('chilfSObject: ' + childSObjects);

        if(childSObjects.size() == 0){ return; }

        for(String ccKey : this.ccKeyToChildRelationshipMapping.keySet()){

            if(childRelationshipKey != this.ccKeyToChildRelationshipMapping.get(ccKey).substringBefore('|')){
                continue; //skip ccKeys of other child objects
            }
            String childField = this.ccKeyToChildRelationshipMapping.get(ccKey).substringAfter('|');

            if(childSObjects[0].get(childField) != null){
                setValue(data, ccKey, childSObjects[0].get(childField));
            } else {
                setValue(data, ccKey, 'null');
            }
        }
    }

    private void populateRequestMapWithAuthInfo(){
        this.data.putAll(new Map<String, Object>{
            'APIUser' => vertic_SettingService.getValue('Clever_Contacts_API_User'),
            'APIKey' => vertic_SettingService.getValue('Clever_Contacts_API_Key'),
            'campaign_id' => this.campaignMember.Campaign.Name,
            'api_source' => 'salesforce'
        });
    }

    private void populateRequestMapFromParentObject(){
        vertic_DTO objectDTO = new vertic_DTO(new Map<String, Object> {
            'object' => new vertic_AutoMapper().getSObjectAsMap(this.parentSObject)
        });

        for(String ccKey : this.ccKeyToParentFieldMapping.keySet()){
            setValue(data, ccKey, objectDTO.get('object.' + (String) this.ccKeyToParentFieldMapping.get(ccKey)));
        }

        for(String ccKey : this.ccKeyToChildRelationshipMapping.keySet()){

            String childField = this.ccKeyToChildRelationshipMapping.get(ccKey).substringAfter('|');
            String childRelationshipKey = this.ccKeyToChildRelationshipMapping.get(ccKey).substringBefore('|');

            if(childRelationshipKey.contains('*')){ continue; }

            String childRelationshipName = childRelationshipKey;
            if(childRelationshipKey.contains('(') && childRelationshipKey.contains(')')){
                childRelationshipName = childRelationshipKey.substringBefore('(') + childRelationshipKey.substringAfter(')'); // removing (condition) from childRelationship
            }

            List<SObject> childSObjects;
            if(this.parentSObjectType == Contact.SObjectType){
                childSObjects = ((Contact) this.parentSObject).getSObjects(childRelationshipName);
            } else if(this.parentSObjectType == Lead.SObjectType){
                childSObjects = ((Lead) this.parentSObject).getSObjects(childRelationshipName);
            }

            if(childSObjects != null && childSObjects.size() > 0){
                setValue(data, ccKey, childSObjects[0].get(childField));
            } else {
                setValue(data, ccKey, 'null');
            }
        }
    }

    private void retrieveCMDTMapping(){
        Map<String, Object> mapping = retrieveMapping(this.campaignMember.Campaign.Clever_Contacts_Type__c);

        if(mapping == null) { return; }

        this.parentSObjectType = Schema.getGlobalDescribe().get(mapping.get('object').toString());
        Map<String, Object> fieldMapping = (Map<String, Object>) mapping.get('mapping');

        for(String key : fieldMapping.keySet()){
            String value = fieldMapping.get(key).toString();
            if(value.contains('|')){
                this.ccKeyToChildRelationshipMapping.put(key, value);

                String childRelationship = value.substringBefore('|');
                String childField = value.substringAfter('|');

                if(this.childRelationshipToFields.containsKey(childRelationship)){
                    this.childRelationshipToFields.get(childRelationship).add(childField);
                } else {
                    this.childRelationshipToFields.put(childRelationship, new Set<String>{childField});
                }
            } else {
                this.ccKeyToParentFieldMapping.put(key, value);
            }
        }
    }

    public static Map<String, Object> retrieveMapping(String campaignType){

        if(Test.isRunningTest()){
            return new Map<String, Object>{
                'object' => 'Contact',
                'mapping' => new Map<String, String>{
                    'custom_001' => 'FirstName',
                    'custom_002' => 'LastName',
                    'custom_003' => 'Animals__r|Name',
                    'custom_004' => '*npsp__Opportunities__r(RecordType.DeveloperName = \'Bequest\')|StageName',
                    'custom_005' => '*npsp__Opportunities__r(RecordType.DeveloperName = \'Home_Ever_After\')|StageName'
                }
            };
        } else {
            SObject setting = vertic_SettingService.getMetadataType(Schema.getGlobalDescribe().get('Vertic_Setting__mdt'), 'Clever_Contacts_Campaign_Fields_Mapping');

            if(setting == null){ return null; }

            Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped((String) setting.get('Value__c'));
            Map<String, Object> mapping = (Map<String, Object>) valueMap.get(campaignType);

            if(mapping == null){ mapping = (Map<String, Object>) valueMap.get('default'); }

            return mapping;
        }
    }

    private void sync() {
        HttpResponse response = this.doRequest(ENDPOINT, POST, JSON.serialize(data));

        Integer code = response.getStatusCode();
        String body = response.getBody();

        this.campaignMember.Clever_Contacts_Sync_Details__c = body;

        if(code == 200 && String.isNotBlank(body) && body == '"Success"'){
            this.campaignMember.Clever_Contacts_Sync_Status__c = 'Success';
        } else {
            this.campaignMember.Clever_Contacts_Sync_Status__c = 'Failed';
        }

        update this.campaignMember;

        this.response.put('campaignMember', this.campaignMember);
    }

    private void setValue(Map<String, Object> data, String key, Object fieldValue){
        if(fieldValue != null){
            data.put(key, String.valueOf(fieldValue));
        } else {
            data.put(key, 'null');
        }
    }

    private HttpResponse doRequest(String path, String method, String body){
        HttpRequest req = new HttpRequest();

        System.debug('SyncBCMembersProc -> doRequest: path ' + path);
        System.debug('SyncBCMembersProc -> doRequest: body ' + body);

        req.setEndpoint(path);
        req.setMethod(method);
        req.setTimeout(120000);

        req.setHeader(CONTENT_TYPE_HEADER, APP_JSON_TYPE);
        req.setHeader(ACCEPT_HEADER, APP_JSON_TYPE);

        if(body != null){ req.setBody(body); }

        return new Http().send(req);
    }

    private Schema.ChildRelationship getChildRelationship(String childRelationshipName){
        for(Schema.ChildRelationship relationship : Contact.SObjectType.getDescribe().getChildRelationships()){
            if(childRelationshipName == relationship.getRelationshipName()){
                return relationship;
            }
        }
        return null;
    }
    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */


    private SObject parentSObject;
    private SObjectType parentSObjectType;
    private CampaignMember campaignMember;

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

// Proposed Live Templates to override Super properties:
// vertic_request
// vertic_response


}