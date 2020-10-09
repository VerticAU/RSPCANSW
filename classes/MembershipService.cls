public without sharing class MembershipService {

    public static void updateActiveMembership(List<Opportunity> memberships){

        if(memberships == null || memberships.isEmpty()){ return; }

        Set<Id> contactIds = (Set<Id>) vertic_Utils.sObjects.getIdFieldValues(memberships, 'npsp__Primary_Contact__c');
        Map<Id, Contact> contactMap = new Map<Id, Contact>([
            SELECT Id, Active_Membership__c
            FROM Contact
            WHERE Id IN :contactIds
        ]);

        List<Opportunity> lastActiveMemberships = new List<Opportunity>();
        for(Opportunity renewalMembership : memberships){
            Contact contact = contactMap.get(renewalMembership.npsp__Primary_Contact__c);

            if(contact == null) { continue; }

            if(contact.Active_Membership__c != null){
                lastActiveMemberships.add(new Opportunity(
                    Id = contact.Active_Membership__c,
                    StageName = 'Closed Won'
                ));
            }

            contact.Active_Membership__c = renewalMembership.Id;
        }

        update contactMap.values();
        update lastActiveMemberships;
    }

    public static List<Opportunity> filterMemberships(List<Opportunity> opportunities, Map<Id ,Opportunity> oldOpportunityMap){
        List<Opportunity> memberships = new List<Opportunity>();

        String membershipRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership');
        for(Opportunity opportunity : opportunities){
            Opportunity oldOpportunity = oldOpportunityMap.get(opportunity.Id);
            if(opportunity.RecordTypeId == membershipRecordType && opportunity.StageName == 'Enrolled' && oldOpportunity.StageName == 'Pending'){
                memberships.add(opportunity);
            }
        }
        return memberships;
    }
}