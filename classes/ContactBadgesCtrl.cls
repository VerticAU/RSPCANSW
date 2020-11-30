public class ContactBadgesCtrl extends BadgesBaseCtrl {

    @AuraEnabled
    public static String getBadges(Id recordId) {
        try {
            return JSON.serialize(new BadgesProcessor(recordId).process());
        } catch (Exception ex) {
            throw new AuraHandledException(ex.getMessage() + ' ' + ex.getStackTraceString());
        }
    }

    public class BadgesProcessor {

        private Id recordId;
        private Contact contactVar;
        private Contact contact;
        private List<Animal__c> animals = new List<Animal__c>();
        private List<Opportunity> oppGiWDonors = new List<Opportunity>();
        private List<Opportunity> oppMajorGifDonors = new List<Opportunity>();
        private List<Opportunity> oppRecurrings = new List<Opportunity>();
        private List<Opportunity> oppMemberships = new List<Opportunity>();
        private List<Opportunity> oppRaffleTickets = new List<Opportunity>();

        private BadgesResponse response = new BadgesResponse();

        public BadgesProcessor(Id recordId) {
            this.recordId = recordId;
        }

        public BadgesResponse process() {

            retrieveContact();
            populateBadges();

            return this.response;
        }

        private void retrieveContact() {
            List<Contact> contacts = [SELECT Id, AccountId FROM Contact WHERE Id = :this.recordId];
            if (!contacts.isEmpty()) {
                this.contactVar = contacts.get(0);
            }
        }

        private void populateBadges() {
            initMetaData();
            populateGiWDonorIcon();
            populateMajorGifDonorIcon();
            populateRecurringIcon();
            populateAnimalRecordIcon();
            populateMembershipIcon();
            populateRaffleTicketDeceasedIcon();
            populateDeceasedIcon();
            populateActiveMembershipIcon();
        }

        private void initMetaData() {
            this.contact = (Contact) vertic_Utils.arrays.firstOrNull([
                SELECT Id, Active_Membership__c, npsp__Deceased__c
                FROM Contact
                WHERE Id = :this.recordId
            ]);

            this.animals = [
                SELECT Id
                FROM Animal__c
                WHERE Contact__c = :this.recordId
            ];

            for (Opportunity opp : [SELECT Amount, StageName, RecordType.DeveloperName, npe03__Recurring_Donation__c, npe03__Recurring_Donation__r.npsp__Status__c FROM Opportunity WHERE npsp__Primary_Contact__c = :this.recordId]) {
                if (opp.RecordType != null && opp.RecordType.DeveloperName == 'Bequest' && opp.StageName == 'Pledged') {
                    this.oppGiWDonors.add(opp);
                }
                if (opp.RecordType != null && opp.RecordType.DeveloperName == 'MajorGift' && opp.StageName == 'Closed Won') {
                    this.oppMajorGifDonors.add(opp);
                }
                if (opp.npe03__Recurring_Donation__c != null && opp.npe03__Recurring_Donation__r.npsp__Status__c == 'Active') {
                    this.oppRecurrings.add(opp);
                }
                if (opp.RecordType != null && opp.RecordType.DeveloperName == 'Membership' && opp.StageName == 'Enrolled') {
                    this.oppMemberships.add(opp);
                }
                if (opp.RecordType != null && opp.RecordType.DeveloperName == 'Raffle_Ticket') {
                    this.oppRaffleTickets.add(opp);
                }
            }
        }

        private void populateGiWDonorIcon() {
            Decimal total = calcTotal(this.oppGiWDonors);
            if (this.oppGiWDonors.size() > 0) {
                this.response.badges.add(new Badge(
                    'custom:custom18',
                    String.format(
                        'Gift In Will Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(this.oppGiWDonors.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateMajorGifDonorIcon() {
            Decimal total = calcTotal(this.oppMajorGifDonors);
            if (this.oppMajorGifDonors.size() > 0) {
                this.response.badges.add(new Badge(
                    'custom:custom17',
                    String.format(
                        'Major Gift Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(this.oppMajorGifDonors.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }

        private void populateRecurringIcon() {
            Decimal total = calcTotal(this.oppRecurrings);
            if (this.oppRecurrings.size() > 0) {
                this.response.badges.add(new Badge(
                    'standard:client',
                    String.format(
                        'Recurring Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(this.oppRecurrings.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }

        private void populateAnimalRecordIcon() {
            if (this.animals.size() > 0) {
                this.response.badges.add(new Badge(
                    'custom:custom1',
                    String.format(
                        'Animal Record Count: {0}',
                        new List<String>{
                            String.valueOf(this.animals.size())
                        }
                    )
                ));
            }
        }

        private void populateMembershipIcon() {
            Decimal total = calcTotal(this.oppMemberships);
            if (this.oppMemberships.size() > 0) {
                this.response.badges.add(new Badge(
                    'custom:custom15',
                    String.format(
                        'Membership Active Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(this.oppMemberships.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }

        private void populateRaffleTicketDeceasedIcon() {
            Decimal total = calcTotal(this.oppRaffleTickets);

            if (this.oppRaffleTickets.size() > 0) {
                this.response.badges.add(new Badge(
                    'custom:custom48',
                    String.format(
                        'Raffle Ticket Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(this.oppRaffleTickets.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateDeceasedIcon() {
            if (this.contact != null && this.contact.npsp__Deceased__c == true) {
                this.response.badges.add(new Badge(
                    'standard:default',
                    'Deceased donor'
                ));
            }
        }

        private void populateActiveMembershipIcon() {
            if (this.contact != null && this.contact.Active_Membership__c != null) {
                this.response.badges.add(new Badge(
                    'custom:custom73',
                    'Active membership'
                ));
            }
        }

        private Decimal calcTotal(List<Opportunity> opportunities) {
            Decimal total = 0;
            for (Opportunity opp : opportunities) {
                total += opp.Amount == null ? 0 : opp.Amount;
            }
            return total;
        }
    }
}