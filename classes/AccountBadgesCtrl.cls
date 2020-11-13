public class AccountBadgesCtrl extends BadgesBaseCtrl {

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
        private Account accountVar;
        private BadgesResponse response = new BadgesResponse();

        public BadgesProcessor(Id recordId) {
            this.recordId = recordId;
        }

        public BadgesResponse process() {

            retrieveAccount();
            populateBadges();

            return this.response;
        }

        private void retrieveAccount(){
            this.accountVar = (Account)vertic_Utils.arrays.firstOrException(
                [SELECT Id, npo02__OppAmountThisYear__c, RecordType.DeveloperName FROM Account WHERE Id = :this.recordId],
                'No Account with Id: ' + this.recordId
            );
        }

        private void populateBadges() {

            populateAlertIcons();
            populateCarsIcon();
            populateMajorDonorIcon();
            populateIndividualDonorIcon();
            populateRecurringIcon();
//            populateBequestorIcon();
            populateInKindGiftIcon();
            populateWorkplaceGivingIcon();

        }

        private void populateAlertIcons() {

            List<Alert__c> alerts = [
                SELECT Id, Alert_Type__c, Alert_Detail__c
                FROM Alert__c
                WHERE Organisation__c = :this.recordId
                AND Status__c = 'Active'
            ];

            Map<String, Alert__c> alertsByTypes = new Map<String, Alert__c>();
            for (Alert__c alert : alerts) {
                alertsByTypes.put(
                    alert.Alert_Type__c,
                    alert
                );
            }

            if (alertsByTypes.containsKey('Danger')) {
                this.response.badges.add(new Badge(
                    'custom:custom82',
                    alertsByTypes.get('Danger').Alert_Detail__c
                ));
            }

            if (alertsByTypes.containsKey('Warning')) {
                this.response.badges.add(new Badge(
                    'custom:custom53',
                    alertsByTypes.get('Warning').Alert_Detail__c
                ));
            }

            if (alertsByTypes.containsKey('Info')) {
                this.response.badges.add(new Badge(
                    'custom:custom26',
                    alertsByTypes.get('Info').Alert_Detail__c
                ));
            }
        }

        private void populateCarsIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE AccountId = :this.recordId
                AND
                RecordType.DeveloperName = 'Car_Donation'
                AND StageName = 'Closed Won'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom31',
                    String.format(
                        'Number of cars donated: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }

        }

        private void populateMajorDonorIcon() {
//            List<Opportunity> opportunities = [
//                SELECT Amount
//                FROM Opportunity
//                WHERE AccountId = :this.recordId
//                AND
//                RecordType.DeveloperName = 'MajorGift'
//                AND StageName = 'Closed Won'
//            ];
//
//            Decimal total = 0;
//            for (Opportunity opportunityVar : opportunities) {
//                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
//            }

            Boolean isHousehold = this.accountVar.RecordTypeId != null && 'HH_Account'.equalsIgnoreCase(this.accountVar.RecordType.DeveloperName);

            if(isHousehold && this.accountVar.npo02__OppAmountThisYear__c != null && this.accountVar.npo02__OppAmountThisYear__c > 500){
                this.response.badges.add(new Badge(
                    'custom:custom17',
                    String.format(
                        'Major Donation. Total value: {0}',
                        new List<String>{
                            String.valueOf(this.accountVar.npo02__OppAmountThisYear__c)
                        }
                    )
                ));
            }

//            if (!opportunities.isEmpty()) {
//                this.response.badges.add(new Badge(
//                    'custom:custom17',
//                    String.format(
//                        'Major Donation Count: {0} Total value: {1}',
//                        new List<String>{
//                            String.valueOf(opportunities.size()),
//                            String.valueOf(total)
//                        }
//                    )
//                ));
//            }
        }

//        private void populateMajorGiftIcon() {
//            List<Opportunity> opportunities = [
//                SELECT Amount
//                FROM Opportunity
//                WHERE AccountId = :this.recordId
//                AND
//                RecordType.DeveloperName = 'MajorGift'
//                AND StageName = 'Closed Won'
//            ];
//
//            Decimal total = 0;
//            for (Opportunity opportunityVar : opportunities) {
//                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
//            }
//
//            if (!opportunities.isEmpty()) {
//                this.response.badges.add(new Badge(
//                    'custom:custom17',
//                    String.format(
//                        'Major Donation Count: {0} Total value: {1}',
//                        new List<String>{
//                            String.valueOf(opportunities.size()),
//                            String.valueOf(total)
//                        }
//                    )
//                ));
//            }
//        }

        private void populateIndividualDonorIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE AccountId = :this.recordId
                AND
                RecordType.DeveloperName = 'Donation'
                AND StageName = 'Closed Won'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'standard:opportunity',
                    String.format(
                        'Individual Donation Count: {0} Total value: {1}',
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
                WHERE AccountId = :this.recordId
                AND
                RecordType.DeveloperName = 'Recurring_Donation'
                AND StageName = 'Closed Won'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'custom:custom41',
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

//        private void populateBequestorIcon() {
//            List<Opportunity> opportunities = [
//                SELECT Amount
//                FROM Opportunity
//                WHERE AccountId = :this.recordId
//                AND StageName = 'Bequestor'
//            ];
//
//            Decimal total = 0;
//            for (Opportunity opportunityVar : opportunities) {
//                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
//            }
//
//            if (!opportunities.isEmpty()) {
//                this.response.badges.add(new Badge(
//                    'custom:custom1',
//                    String.format(
//                        'Bequest Opportunity Amount: {1}',
//                        new List<String>{
//                            String.valueOf(opportunities.size()),
//                            String.valueOf(total)
//                        }
//                    )
//                ));
//            }
//        }

        private void populateInKindGiftIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE AccountId = :this.recordId
                AND
                RecordType.DeveloperName = 'In_Kind_Gift'
                AND StageName = 'Received'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'standard:thanks',
                    String.format(
                        'In Kind Opportunity Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }

        private void populateWorkplaceGivingIcon() {
            List<Opportunity> opportunities = [
                SELECT Amount
                FROM Opportunity
                WHERE AccountId = :this.recordId
                AND
                RecordType.DeveloperName = 'Workplace_Giving'
                AND StageName = 'Closed Won'
            ];

            Decimal total = 0;
            for (Opportunity opportunityVar : opportunities) {
                total += opportunityVar.Amount == null ? 0 : opportunityVar.Amount;
            }

            if (!opportunities.isEmpty()) {
                this.response.badges.add(new Badge(
                    'standard:person_account',
                    String.format(
                        'Workplace Giving Count: {0} Total value: {1}',
                        new List<String>{
                            String.valueOf(opportunities.size()),
                            String.valueOf(total)
                        }
                    )
                ));
            }
        }
    }

}