public without sharing class ContactMakeDeceasedActionCtrl {

    @AuraEnabled
    public static String initContactStatus(String recordId) {
        Contact contact = (Contact) vertic_Utils.arrays.firstOrNull([
            SELECT Id, Status__c
            FROM Contact
            WHERE Id = :recordId
        ]);
        return contact.Status__c;
    }

    @AuraEnabled
    public static void optOutEmailContact(String recordId) {
        Contact contact = new Contact(
            Id = recordId,
            HasOptedOutOfEmail = true
        );
        update contact;
    }

    @AuraEnabled
    public static void makeDeceasedContact(String recordId, Date deceasedDate, Date activityDate) {
        try {
            Contact contact = new Contact(
                Id = recordId,
                Status__c = 'Deceased',
                npsp__Deceased__c = TRUE,
                npsp__Do_Not_Contact__c = TRUE,
                HasOptedOutOfEmail = TRUE,
                Do_Not_Contact_Reason__c = 'Deceased Donor',
                Deceased_Date__c = deceasedDate,
                Date_Notified_of_Death__c = activityDate
            );
            update contact;

            User user = (User) vertic_Utils.arrays.firstOrException([SELECT Id FROM User WHERE Name = 'Vertic Developer'], 'Vertic Developer is not found');

            List<Opportunity> opportunities = new List<Opportunity>([SELECT Id, RecordType.Name, AccountId FROM Opportunity WHERE npsp__Primary_Contact__c = :recordId AND RecordType.DeveloperName = 'Bequest']);

            for (Opportunity opportunity : opportunities) {
                Task task = new Task(
                    Subject = 'Bequestor Marked Deceased',
                    ActivityDate = activityDate,
                    WhoId = recordId,
                    OwnerId = user.Id,
                    Status = 'Not started',
                    Description='{"Group_Name__c": "Estate Administration Team", "Activity_Days__c": "5", "Description": ""}'
                );
                insert task;
                break;
            }

            List<AccountContactRelation> accountContactRelations = new List<AccountContactRelation>([SELECT AccountId, Roles FROM AccountContactRelation WHERE ContactId = :recordId]);
            List<Account> accounts = new List<Account>();

            for (AccountContactRelation accountContactRelation : accountContactRelations) {
                if (accountContactRelation.Roles != null) {
                    if (accountContactRelation.Roles.contains('Executor') || accountContactRelation.Roles.contains('Solicitor')) {
                        accounts.add(new Account(Id = accountContactRelation.AccountId, Deceased_Donor__c = recordId));
                    }
                }
            }
            update accounts;


            List<npe03__Recurring_Donation__c> recurringDonations = new List<npe03__Recurring_Donation__c>([
                SELECT Id, npsp__Status__c, npsp__ClosedReason__c
                FROM npe03__Recurring_Donation__c
                WHERE npe03__Contact__c = :recordId
            ]);

            if (recurringDonations.size() > 0) {
                for (npe03__Recurring_Donation__c recurringDonation : recurringDonations) {
                    recurringDonation.npsp__Status__c = 'Cancelled';
                    recurringDonation.npsp__ClosedReason__c = 'Deceased Donor';
                }
                update recurringDonations;
            }


            List <CampaignMember> campaignsMemberToDelete = new List<CampaignMember>();
            List<CampaignMember> campaignMembers = new List<CampaignMember>([SELECT Id, CampaignId, Status FROM CampaignMember WHERE ContactId = :recordId]);
            for (CampaignMember campaignMember : campaignMembers) {
                if (campaignMember.Status.equalsIgnoreCase('Sent')) {
                    campaignsMemberToDelete.add(campaignMember);
                }
            }
            if (campaignsMemberToDelete.size() > 0) {
                delete campaignsMemberToDelete;
            }


        } catch (Exception e) {
            throw new AuraHandledException(e.getTypeName() == 'System.DmlException' ? e.getDmlMessage(0) : e.getMessage());
        }
    }

}