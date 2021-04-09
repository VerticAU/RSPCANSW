@IsTest
private class ContactBadgesCtrlTest {
    @IsTest
    static void test() {
        Account account = new Account(Name = 'test');
        insert account;

        Contact contact = new Contact(
            AccountId = account.Id,
            LastName = 'testName',
            npsp__Deceased__c = true,
            Philanthropy_Level__c = 'Major Donor Affiliated'
        );
        insert contact;

        List<Opportunity> opportunities = new List<Opportunity>();

        Opportunity opp = new Opportunity(
            Name = 'test',
            StageName = 'Pledged',
            CloseDate = Date.today().addDays(5),
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

        Opportunity opp3 = new Opportunity(
            Name = 'test',
            StageName = 'Active Raffle',
            npsp__Primary_Contact__c = contact.Id,
            CloseDate = Date.today().addDays(5),
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Membership')
        );
        opportunities.add(opp3);

        Opportunity opp4 = new Opportunity(
            Name = 'test',
            StageName = 'Active Raffle',
            npsp__Primary_Contact__c = contact.Id,
            CloseDate = Date.today().addDays(5),
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Raffle_Ticket')
        );
        opportunities.add(opp4);

        Opportunity opp5 = new Opportunity(
            Name = 'test',
            StageName = 'Pledged',
            npsp__Primary_Contact__c = contact.Id,
            CloseDate = Date.today().addDays(5),
            RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Home_Ever_After')
        );
        opportunities.add(opp5);

        insert opportunities;

        Animal__c animal = new Animal__c(
            Contact__c = contact.Id
        );
        insert animal;

        String response = ContactBadgesCtrl.getBadges(contact.Id);
        BadgesBaseCtrl.BadgesResponse badgesResponse = (BadgesBaseCtrl.BadgesResponse)JSON.deserializeStrict(response, BadgesBaseCtrl.BadgesResponse.class);
        System.assertEquals(true, badgesResponse.badges.size() > 0);
    }
}