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

    public static List<Opportunity> filterEnrolledMemberships(List<Opportunity> opportunities, Map<Id ,Opportunity> oldOpportunityMap){
        List<Opportunity> memberships = new List<Opportunity>();

        String membershipRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership');
        for(Opportunity opportunity : opportunities){
            Opportunity oldOpportunity = oldOpportunityMap.get(opportunity.Id);
            if(opportunity.RecordTypeId == membershipRecordType && opportunity.StageName == 'Enrolled' && oldOpportunity.StageName != 'Enrolled'){
                memberships.add(opportunity);
            }
        }
        return memberships;
    }

    // Acknowledgement Emails --------------------------------------------------------------------------------------------------------------

    public static void sendMembershipReceipts(List<Opportunity> memberships){
        if(memberships == null || memberships.isEmpty()){ return; }

        Set<Id> membershipIds = (Set<Id>) vertic_Utils.sObjects.getIdFieldValues(memberships, 'Id');
        List<Opportunity> donations = [ SELECT Id, Linked_Opportunity__c, npsp__Primary_Contact__c, npsp__Acknowledgment_Status__c, npsp__Acknowledgment_Date__c FROM Opportunity WHERE Linked_Opportunity__c IN :membershipIds ];

        Map<String, SObject> opportunityIdDonationMap = vertic_Utils.sObjects.getSObjectsByAnyFieldMap(donations, Opportunity.Linked_Opportunity__c);

        String receiptWithDonationName = getReceiptWithDonationName();
        String receiptWithoutDonationName = getReceiptWithoutDonationName();

        String fromEmailAddress = getFromEmail();

        if(fromEmailAddress == null){ return; }

        List<npsp_plus.SendEmailTemplateInvocable.EmailRequest> emailRequests = new List<npsp_plus.SendEmailTemplateInvocable.EmailRequest>();
        for(Opportunity membership : memberships){
            npsp_plus.SendEmailTemplateInvocable.EmailRequest emailRequest = new npsp_plus.SendEmailTemplateInvocable.EmailRequest();
            emailRequest.fromEmailAddress = fromEmailAddress;

            if(opportunityIdDonationMap.keySet().contains(membership.Id)){
                if(receiptWithDonationName == null){ continue; }

                Opportunity donation = (Opportunity) opportunityIdDonationMap.get(membership.Id);
                emailRequest.whatId = donation.Id;
                emailRequest.targetId = donation.npsp__Primary_Contact__c;
                emailRequest.emailName = receiptWithDonationName;

                donation.npsp__Acknowledgment_Status__c = 'Acknowledged';
                donation.npsp__Acknowledgment_Date__c = Date.today();
            } else {
                if(receiptWithoutDonationName == null){ continue; }

                emailRequest.whatId = membership.Id;
                emailRequest.targetId = membership.npsp__Primary_Contact__c;
                emailRequest.emailName = receiptWithoutDonationName;
            }
            emailRequests.add(emailRequest);

            membership.npsp__Acknowledgment_Status__c = 'Acknowledged';
            membership.npsp__Acknowledgment_Date__c = Date.today();
        }

        npsp_plus.SendEmailTemplateInvocable.sendEmail(emailRequests);
    }

    private static String getFromEmail(){

        SObject setting = vertic_SettingService.getMetadataType(Schema.getGlobalDescribe().get('npsp_plus__Settings__mdt'), 'Settings');

        if(setting == null){ return null; }

        return (String) setting.get('npsp_plus__Default_Org_Wide_Email__c');
    }

    private static String getReceiptWithDonationName(){
        EmailTemplate emailTemplate = (EmailTemplate) vertic_Utils.arrays.firstOrNull([
            SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE Name = 'Membership New With Donation'
        ]);

        return emailTemplate == null ? null : emailTemplate.DeveloperName;
    }

    private static String getReceiptWithoutDonationName(){
        EmailTemplate emailTemplate = (EmailTemplate) vertic_Utils.arrays.firstOrNull([
            SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE Name = 'Membership New Without Donation'
        ]);

        return emailTemplate == null ? null : emailTemplate.DeveloperName;
    }

    public static List<Opportunity> filterAcknowledgementNowMemberships(List<Opportunity> opportunities){
        List<Opportunity> memberships = new List<Opportunity>();

        String membershipRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership');
        for(Opportunity opportunity : opportunities){
            if(opportunity.RecordTypeId == membershipRecordType && opportunity.npsp__Acknowledgment_Status__c == 'Email Acknowledgment Now'){
                memberships.add(opportunity);
            }
        }
        return memberships;
    }

    // Renewal Emails --------------------------------------------------------------------------------------------------------------

    public static void sendMembershipRenewalReceipts(List<Opportunity> memberships){
        if(memberships == null || memberships.isEmpty()){ return; }

        String renewalReceipt = getRenewalReceiptName();
        String fromEmailAddress = getFromEmail();

        if(fromEmailAddress == null || renewalReceipt == null){ return; }

        List<npsp_plus.SendEmailTemplateInvocable.EmailRequest> emailRequests = new List<npsp_plus.SendEmailTemplateInvocable.EmailRequest>();
        for(Opportunity membership : memberships){
            npsp_plus.SendEmailTemplateInvocable.EmailRequest emailRequest = new npsp_plus.SendEmailTemplateInvocable.EmailRequest();
            emailRequest.fromEmailAddress = fromEmailAddress;
            emailRequest.whatId = membership.Id;
            emailRequest.targetId = membership.npsp__Primary_Contact__c;
            emailRequest.emailName = renewalReceipt;
            emailRequests.add(emailRequest);

            membership.npsp__Acknowledgment_Status__c = 'Acknowledged';
            membership.npsp__Acknowledgment_Date__c = Date.today();
        }

        npsp_plus.SendEmailTemplateInvocable.sendEmail(emailRequests);
    }

    private static String getRenewalReceiptName(){
        EmailTemplate emailTemplate = (EmailTemplate) vertic_Utils.arrays.firstOrNull([
            SELECT Id, Name, DeveloperName FROM EmailTemplate WHERE Name = 'Membership Renewal'
        ]);

        return emailTemplate == null ? null : emailTemplate.DeveloperName;
    }

    public static List<Opportunity> filterRenewalNowMemberships(List<Opportunity> opportunities, Map<Id, Opportunity> oldOpportunityMap){
        List<Opportunity> memberships = new List<Opportunity>();

        String membershipRecordType = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership');

        for(Opportunity opportunity : opportunities){
            Opportunity oldOpportunity = oldOpportunityMap.get(opportunity.Id);
            if(opportunity.RecordTypeId == membershipRecordType
                && opportunity.npsp__Acknowledgment_Status__c == 'Email Renewal Now'
                && oldOpportunity.npsp__Acknowledgment_Status__c != 'Email Renewal Now'){

                memberships.add(opportunity);
            }
        }
        return memberships;
    }
}