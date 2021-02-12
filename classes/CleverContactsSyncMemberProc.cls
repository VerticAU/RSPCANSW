public class CleverContactsSyncMemberProc extends vertic_AbstractProcessor {

    private static String ENDPOINT = 'callout:Clever_Contacts/';

    private static final String POST = 'POST';

    private static final String CONTENT_TYPE_HEADER = 'Content-Type';
    private static final String ACCEPT_HEADER = 'Accept';
    private static final String APP_JSON_TYPE = 'application/json';

    private Map<String, String> childRelationshipMapping;
    private Map<String, String> parentRelationshipMapping;
    private Map<String, Set<String>> childRelationshipFields;

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.sync();

        return this.response;
    }

    private void init() {
        this.campaignMember = (CampaignMember) vertic_Utils.arrays.firstOrException([
            SELECT Id,
                Campaign.Clever_Contacts_Type__c,
                Campaign.Name,
                ContactId,
                LeadId
            FROM CampaignMember
            WHERE Id =: THIS.request.getRequiredString('recordId')
        ]);

        this.retrieveMapping();

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(this.parentSObjectType);
        queryFactory
            .selectFields(this.parentRelationshipMapping.values())
            .setLimit(1);

        if(this.parentSObjectType == Contact.SObjectType){
            queryFactory.setCondition('Id = \'' + this.campaignMember.ContactId + '\'');
        } else if(this.parentSObjectType == Lead.SObjectType){
            queryFactory.setCondition('Id = \'' + this.campaignMember.LeadId + '\'');
        }

        for(String childRelationshipKey : this.childRelationshipFields.keySet()){

            String condition;
            String childRelationship = childRelationshipKey;
            if(childRelationshipKey.contains('(') && childRelationshipKey.contains(')')){
                condition = childRelationshipKey.substringBetween('(',')');
                childRelationship = childRelationshipKey.substringBefore('(') + childRelationshipKey.substringAfter(')');
            }

            System.debug('childRelationship: ' + childRelationship);
            fflib_QueryFactory subQueryFactory = queryFactory.subselectQuery(childRelationship);
            subQueryFactory
                .selectFields(this.childRelationshipFields.get(childRelationshipKey))
                .setOrdering('LastModifiedDate', fflib_QueryFactory.SortOrder.ASCENDING, true)
                .setLimit(1);

            if(condition != null){ subQueryFactory.setCondition(condition); }
        }

        System.debug(queryFactory.toSOQL());
        this.parentSObject = Database.query(queryFactory.toSOQL());
    }

    private void retrieveMapping(){
        Map<String, Object> mapping;
        Map<String, Object> fieldMapping;

        if(Test.isRunningTest()){
            mapping = new Map<String, Object>{
                'object' => 'Contact',
                'mapping' => new Map<String, String>{
                    'first_name' => 'FirstName',
                    'last_name' => 'LastName'
                }
            };
        } else {
            SObject setting = vertic_SettingService.getMetadataType(Schema.getGlobalDescribe().get('Vertic_Setting__mdt'), 'Clever_Contacts_Campaign_Fields_Mapping');

            if(setting == null){ return; }

            Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped((String) setting.get('Value__c'));
            mapping = (Map<String, Object>) valueMap.get(this.campaignMember.Campaign.Clever_Contacts_Type__c);

            if(mapping == null){ mapping = (Map<String, Object>) valueMap.get('default'); }
        }

        this.parentSObjectType = Schema.getGlobalDescribe().get(mapping.get('object').toString());
        fieldMapping = (Map<String, Object>) mapping.get('mapping');

        this.childRelationshipFields = new Map<String, Set<String>>();
        this.childRelationshipMapping = new Map<String, String>();
        this.parentRelationshipMapping = new Map<String, String>();

        for(String key : fieldMapping.keySet()){
            String value = fieldMapping.get(key).toString();
            if(value.contains('|')){
                this.childRelationshipMapping.put(key, value);

                String childRelationship = value.substringBefore('|');
                String childField = value.substringAfter('|');

                if(this.childRelationshipFields.containsKey(childRelationship)){
                    this.childRelationshipFields.get(childRelationship).add(childField);
                } else {
                    this.childRelationshipFields.put(childRelationship, new Set<String>{childField});
                }
            } else {
                this.parentRelationshipMapping.put(key, value);
            }
        }
    }

    private void sync() {

        Map<String, Object> data = new Map<String, Object>{
            'APIUser' => vertic_SettingService.getValue('Clever_Contacts_API_User'),
            'APIKey' => vertic_SettingService.getValue('Clever_Contacts_API_Key'),
            'campaign_id' => this.campaignMember.Campaign.Name,
            'api_source' => 'salesforce'
        };

        vertic_DTO objectDTO = new vertic_DTO(new Map<String, Object> {
            'object' => new vertic_AutoMapper().getSObjectAsMap(this.parentSObject)
        });

        for(String key : this.parentRelationshipMapping.keySet()){
            setValue(data, key, objectDTO.get('object.' + (String) this.parentRelationshipMapping.get(key)));
        }

        for(String key : this.childRelationshipMapping.keySet()){

            String childField = this.childRelationshipMapping.get(key).substringAfter('|');
            String childRelationship = this.childRelationshipMapping.get(key).substringBefore('|');

            if(childRelationship.contains('(') && childRelationship.contains(')')){
                childRelationship = childRelationship.substringBefore('(') + childRelationship.substringAfter(')'); // removing (condition) from childRelationship
            }

            List<SObject> childSObjects;
            if(this.parentSObjectType == Contact.SObjectType){
                childSObjects = ((Contact) this.parentSObject).getSObjects(childRelationship);
            } else if(this.parentSObjectType == Lead.SObjectType){
                childSObjects = ((Lead) this.parentSObject).getSObjects(childRelationship);
            }

            if(childSObjects != null && childSObjects.size() > 0){
                setValue(data, key, childSObjects[0].get(childField));
            } else {
                setValue(data, key, 'null');
            }
        }

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