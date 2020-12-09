public without sharing class UpdateCampaignMemberStatusInvocable {

    public class Request{
        @InvocableVariable(label = 'Member Id' required = true)
        public String memberId;
        @InvocableVariable(label = 'Status' required = true)
        public String status;
    }

    @InvocableMethod(label='Update Campaign Member Status')
    public static List<SObject> updateCampaignMemberStatus(List<Request> requests) {
        List<CampaignMember> results = new List<CampaignMember>();

        for (Request requestVar : requests) {
            results.add(new CampaignMember(
                Id = requestVar.memberId,
                Status = requestVar.status
            ));
        }

        System.debug('Campaign Member results: ' + results);
        update results;
        return results;
    }

}