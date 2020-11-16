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
            populateGiWDonorIcon();
            populateMajorGifDonorIcon();
            populateRecurringIcon();
            populateAnimalRecordIcon();
            populateMembershipIcon();
            populateRaffleTicketDeceasedIcon();
            populateDeceasedIcon();


        }

//        private void populateAlertIcons() {
//
//            List<Alert__c> alerts = [
//                SELECT Id, Alert_Type__c, Alert_Detail__c
//                FROM Alert__c
//                WHERE Contact__c = :this.recordId
//                AND Status__c = 'Active'
//            ];
//
//            Map<String, Alert__c> alertsByTypes = new Map<String, Alert__c>();
//            for (Alert__c alert : alerts) {
//                alertsByTypes.put(
//                    alert.Alert_Type__c,
//                    alert
//                );
//            }
//
//            if (alertsByTypes.containsKey('Danger')) {
//                this.response.badges.add(new Badge(
//                    'custom:custom82',
//                    alertsByTypes.get('Danger').Alert_Detail__c,
//                    'error',
//                    alertsByTypes.get('Danger').Id
//                ));
//            }
//
//            if (alertsByTypes.containsKey('Warning')) {
//                this.response.badges.add(new Badge(
//                    'custom:custom53',
//                    alertsByTypes.get('Warning').Alert_Detail__c,
//                    'warning',
//                    alertsByTypes.get('Warning').Id
//                ));
//            }
//
//            if (alertsByTypes.containsKey('Info')) {
//                this.response.badges.add(new Badge(
//                    'custom:custom26',
//                    alertsByTypes.get('Info').Alert_Detail__c,
//                    'info',
//                    alertsByTypes.get('Info').Id
//                ));
//            }
//        }


        private void populateGiWDonorIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :this.recordId
                AND
                RecordType.DeveloperName = 'Bequest'
                AND StageName = 'Pledged'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom17',
                    String.format(
                        'Gift In Will Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateMajorGifDonorIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :this.recordId
                AND
                RecordType.DeveloperName = 'MajorGift'
                AND StageName = 'Closed Won'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'standard:client',
                    String.format(
                        'Major Gift Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }

        private void populateRecurringIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :this.recordId
                AND npe03__Recurring_Donation__r.npsp__Status__c = 'Active'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom1',
                    String.format(
                        'Recurring Donation Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateAnimalRecordIcon() {

            List<Animal__c> animals = [
                SELECT Id
                FROM Animal__c
                WHERE Contact__c = :this.recordId
            ];


            if (!animals.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom15',
                    String.format(
                        'Animal Record Count: {0}',
                        new List<String>{
                            String.valueOf(animals.size())
                        }
                    )
                ));
            }
        }

        private void populateMembershipIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :this.recordId
                AND
                RecordType.DeveloperName = 'Membership'
                AND StageName = 'Active Raffle'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom48',
                    String.format(
                        'Membership Active Raffle Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateRaffleTicketDeceasedIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE npsp__Primary_Contact__c = :this.recordId
                AND
                RecordType.DeveloperName = 'Raffle_Ticket'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom48',
                    String.format(
                        'Raffle Ticket Deceased Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }


        private void populateDeceasedIcon() {
            List<Contact> contacts = [
                SELECT Id, npsp__Deceased__c
                FROM Contact
                WHERE Id = :this.recordId
            ];

            if (contacts.size() > 0 && contacts[0].npsp__Deceased__c == true) {
                this.response.badges.add(new Badge(
                    'standard:default',
                    'Deceased donor'
                ));
            }

        }
    }
}