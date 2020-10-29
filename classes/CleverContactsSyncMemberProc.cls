public class CleverContactsSyncMemberProc extends vertic_AbstractProcessor {

    private static String ENDPOINT = 'callout:Clever_Contacts/';

    private static final String POST = 'POST';

    private static final String CONTENT_TYPE_HEADER = 'Content-Type';
    private static final String ACCEPT_HEADER = 'Accept';
    private static final String APP_JSON_TYPE = 'application/json';

    private Map<String, Object> FIELD_MAPPING;

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
                Campaign.Name,
                ContactId
            FROM CampaignMember
            WHERE Id =: THIS.request.getRequiredString('recordId')
        ]);

        this.retrieveMapping();

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Contact.SObjectType);
        queryFactory.selectFields(getListObjectAsStrings(this.FIELD_MAPPING.values()));
        queryFactory.setCondition('Id = \'' + this.campaignMember.ContactId + '\'');
        queryFactory.setLimit(1);

        this.contactVar = Database.query(queryFactory.toSOQL());
    }

    private List<String> getListObjectAsStrings(List<Object> objects){
        List<String> strings = new List<String>();
        for(Object obj : objects){
            strings.add(obj.toString());
        }
        return strings;
    }

    private void retrieveMapping(){
        if(Test.isRunningTest()){
            this.FIELD_MAPPING = new Map<String, String>{
                'first_name' => 'FirstName',
                'last_name' => 'LastName'
            };
            return;
        }

        SObject setting = vertic_SettingService.getMetadataType(Schema.getGlobalDescribe().get('Vertic_Setting__mdt'), 'Clever_Contacts_Campaign_Fields_Mapping');

        if(setting == null){ return; }

        Map<String, Object> valueMap = (Map<String, Object>) JSON.deserializeUntyped((String) setting.get('Value__c'));
        this.FIELD_MAPPING = (Map<String, Object>) valueMap.get(this.campaignMember.Campaign.Name);

        if(this.FIELD_MAPPING == null){ this.FIELD_MAPPING = (Map<String, Object>) valueMap.get('default'); }
    }

    private void sync() {

        Map<String, Object> data = new Map<String, Object>{
            'APIUser' => vertic_SettingService.getValue('Clever_Contacts_API_User'),
            'APIKey' => vertic_SettingService.getValue('Clever_Contacts_API_Key'),
            'campaign_id' => this.campaignMember.Campaign.Name,
            'api_source' => 'salesforce'
        };

        vertic_DTO contactDTO = new vertic_DTO(new Map<String, Object> {
            'contact' => new vertic_AutoMapper().getSObjectAsMap(this.contactVar)
        });

        for(String key : this.FIELD_MAPPING.keySet()){
            data.put(key, contactDTO.get((String) this.FIELD_MAPPING.get(key)));
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


    private Contact contactVar;
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