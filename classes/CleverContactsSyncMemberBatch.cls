public class CleverContactsSyncMemberBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{

    private String campaignId;
    private String queryString;

    public CleverContactsSyncMemberBatch(String campaignId){
        this.campaignId = campaignId;

        Campaign campaign = (Campaign) vertic_Utils.arrays.firstOrNull([SELECT Id, Clever_Contacts_Type__c FROM Campaign WHERE Id = :campaignId]);

        Map<String, Object> mapping = CleverContactsSyncMemberProc.retrieveMapping(campaign.Clever_Contacts_Type__c);
        if(mapping == null) { throw new vertic_Structs.MissingDataException('Mapping is missing for Campaign!'); }
        SObjectType sObjectType = Schema.getGlobalDescribe().get(mapping.get('object').toString());

        this.queryString = 'SELECT Id, ContactId, Clever_Contacts_Sync_Status__c, Clever_Contacts_Sync_Details__c FROM CampaignMember WHERE CampaignId = \'' + this.campaignId + '\'';
        if(sObjectType == Contact.SObjectType){
            this.queryString += ' AND ContactId != NULL';
        } else if(sObjectType == Lead.SObjectType) {
            this.queryString += ' AND LeadId != NULL';
        }
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(this.queryString);
    }

    public void execute(Database.BatchableContext context, List<SObject> scope) {
        CampaignMember member = (CampaignMember) scope[0];
//        try {
            new CleverContactsSyncMemberProc().process(new Map<String, Object>{
                'recordId' => member.Id
            });
//        } catch (Exception e){
//            member.Clever_Contacts_Sync_Status__c = 'Failed';
//            member.Clever_Contacts_Sync_Details__c = e.getMessage();
//            update member;
//        }
    }

    public void finish(Database.BatchableContext context) {
        System.debug('CleverContactsSyncMemberBatch finished!');
    }
}