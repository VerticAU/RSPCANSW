@IsTest
public class UpdateCampaignMemberStatusInvocableTest {
    static testMethod void test(){
        Campaign campaign = new Campaign(
            Name = 'test'
        );
        insert campaign;

        Account account = new Account(
            Name = 'test'
        );
        insert account;

        Contact contact = new Contact(
            LastName = 'test',
            AccountId = account.Id
        );
        insert contact;

        CampaignMember member = new CampaignMember(
            ContactId = contact.Id,
            CampaignId = campaign.Id
        );
        insert member;

        UpdateCampaignMemberStatusInvocable.Request request = new UpdateCampaignMemberStatusInvocable.Request();
        request.memberId = member.Id;
        request.status = 'Responded';
        UpdateCampaignMemberStatusInvocable.updateCampaignMemberStatus(new List<UpdateCampaignMemberStatusInvocable.Request>{request});

        System.assertEquals('Responded', [SELECT Id, Status FROM CampaignMember LIMIT 1].Status);
    }
}