/**
 * Created by golub on 24.11.2020.
 */

@IsTest
private class ContactBadgesCtrlTest {
    @IsTest
    static void test() {
        Account account = new Account(Name = 'test');
        insert account;

        Contact contact = new Contact(
                AccountId = account.id,
                LastName = 'testName',
                npsp__Deceased__c = true
        );
        insert contact;

        List<Opportunity> opportunities = new List<Opportunity>();

        Opportunity opp = new Opportunity(
                Name = 'test',
                StageName = 'Pledged',
                CloseDate = Date.today(),
                npsp__Primary_Contact__c = contact.Id,
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Bequest')
        );
        opportunities.add(opp);

        Opportunity opp1 = new Opportunity(
                Name = 'test',
                StageName = 'Closed Won',
                npsp__Primary_Contact__c = contact.Id,
                CloseDate = Date.today(),
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'MajorGift')
        );
        opportunities.add(opp1);

//        npe03__Recurring_Donation__c recurringDonation = new npe03__Recurring_Donation__c(
//                npsp__Status__c = 'Active',
//                npe03__Contact__c = contact.Id);
//        insert recurringDonation;
//
//        Opportunity opp2 = new Opportunity(
//                Name = 'test',
//                StageName = 'Closed Won',
//                CloseDate = Date.today(),
//                npsp__Primary_Contact__c = contact.Id,
//                npe03__Recurring_Donation__c = recurringDonation.Id
//        );
//        opportunities.add(opp2);

        Opportunity opp3 = new Opportunity(
                Name = 'test',
                StageName = 'Active Raffle',
                npsp__Primary_Contact__c = contact.Id,
                CloseDate = Date.today(),
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership')
        );
        opportunities.add(opp3);

        Opportunity opp4 = new Opportunity(
                Name = 'test',
                StageName = 'Active Raffle',
                npsp__Primary_Contact__c = contact.Id,
                CloseDate = Date.today(),
                RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Raffle_Ticket')
        );
        opportunities.add(opp4);

        insert opportunities;

        Animal__c animal = new Animal__c(
                Name = 'test',
                Contact__c = contact.Id
        );
        insert animal;

        String response = ContactBadgesCtrl.getBadges(contact.Id);
        BadgesBaseCtrl.BadgesResponse badgesResponse = (BadgesBaseCtrl.BadgesResponse)JSON.deserializeStrict(response, BadgesBaseCtrl.BadgesResponse.class);
        System.assertEquals(true, badgesResponse.badges.size() > 0);

    }
}