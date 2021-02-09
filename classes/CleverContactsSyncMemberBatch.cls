public class CleverContactsSyncMemberBatch implements Database.Batchable<SObject>, Database.AllowsCallouts{

    private String campaignId;

    public CleverContactsSyncMemberBatch(String campaignId){
        this.campaignId = campaignId;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator('SELECT Id, ContactId, Clever_Contacts_Sync_Status__c, Clever_Contacts_Sync_Details__c FROM CampaignMember' +
                                        ' WHERE CampaignId = \'' + this.campaignId + '\'');
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