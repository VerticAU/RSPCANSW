public without sharing class BulkDonationReceiptingSearchProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private List<Opportunity> contributions;
    public static final Integer SEARCH_LIMIT = 1000;

    private void doSubmit() {

        this.retrieveRecords();
        this.mapRecords();

    }

    private void retrieveRecords() {

        Date startDate = this.request.getISODate('filter.startDate');
        Date endDate = this.request.getISODate('filter.endDate');
        String campaignId = this.request.getString('filter.campaignId');
        String batchId = this.request.getString('filter.batchId');
        String contactId = this.request.getString('filter.contactId');
        String accountId = this.request.getString('filter.accountId');
        Boolean isIndividualOnly = this.request.getBoolean('filter.isIndividualOnly');
        Boolean isOrganisationOnly = this.request.getBoolean('filter.isOrganisationOnly');
        String acknowledgmentStatus = this.request.getString('filter.acknowledgmentStatus');

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Opportunity.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'Name',
            'npsp__Primary_Contact__c',
            'npsp__Primary_Contact__r.Name',
            'npsp__Primary_Contact__r.Email',
            'npsp__Primary_Contact__r.IsEmailBounced',
            'npsp__Primary_Contact__r.Receipt_Preference__c',
            'AccountId',
            'Account.Name',
            'Account.npe01__One2OneContact__c',
            'Account.npe01__One2OneContact__r.Email',
            'Account.npe01__One2OneContact__r.IsEmailBounced',
            'Account.npe01__One2OneContact__r.Receipt_Preference__c',
            'CloseDate',
            'Amount',
            'CampaignId',
            'Campaign.Name',
            'npsp__Acknowledgment_Date__c',
            'Receipt_Preference__c'
        });

        List<String> conditions = new List<String>{
            'npe03__Recurring_Donation__c = null',
            'IsWon = true',
            'npsp__Acknowledgment_Status__c != \'Do Not Acknowledge\''
        };

        if (startDate != null) { conditions.add('CloseDate >= :startDate'); }
        if (endDate != null) { conditions.add('CloseDate <= :endDate'); }

        if (String.isNotBlank(campaignId)) { conditions.add('CampaignId = :campaignId'); }
        if (String.isNotBlank(batchId)) { conditions.add('Batch__c = :batchId'); }
        if (String.isNotBlank(contactId)) { conditions.add('npsp__Primary_Contact__c = :contactId'); }
        if (String.isNotBlank(accountId)) { conditions.add('AccountId = :accountId'); }

        if(isIndividualOnly == true){ conditions.add('npsp__Primary_Contact__c != null'); }
        if(isOrganisationOnly == true){
            conditions.add('AccountId != null');
            conditions.add('npsp__Primary_Contact__c = null');
        }

        if ('receipted'.equalsIgnoreCase(acknowledgmentStatus)) { conditions.add('npsp__Acknowledgment_Date__c != null'); }
        if ('unreceipted'.equalsIgnoreCase(acknowledgmentStatus)) { conditions.add('npsp__Acknowledgment_Date__c = null'); }

        queryFactory.setCondition(String.join(conditions, ' AND '));

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Opportunity.npsp__Acknowledgment_Date__c, fflib_QueryFactory.SortOrder.ASCENDING, false);
        queryFactory.addOrdering(Opportunity.CloseDate, fflib_QueryFactory.SortOrder.ASCENDING, true);

        queryFactory.setLimit(SEARCH_LIMIT + 1);

        this.contributions = Database.query(queryFactory.toSOQL());
    }

    private void mapRecords() {
        System.debug(this.contributions);

        this.response.getMapper().mapFromListSObjects(
            'contributions',
            this.contributions,
            new vertic_AutoMapper.BinderQueue(new DonationBinder()),
            SEARCH_LIMIT
        );
    }

    public class DonationBinder extends vertic_AutoMapper.AbstractBinder {

        public void bind(SObject record, Map<String, Object> dataMap) {
            Opportunity donationVar = (Opportunity) record;

            dataMap.put('isDisabled', false);

            String email;
            Boolean isEmailBounced;
            Boolean hasEmail;

            List<String> channels = new List<String>();

            Boolean isIndividual = donationVar.npsp__Primary_Contact__c != null;
            Boolean isDisabled = false;

            if(isIndividual){
                dataMap.put('donorId', donationVar.npsp__Primary_Contact__c);
                dataMap.put('donorName', donationVar.npsp__Primary_Contact__r.Name);

                email = donationVar.npsp__Primary_Contact__r.Email;
                isEmailBounced = donationVar.npsp__Primary_Contact__r.IsEmailBounced == true;
            } else if (donationVar.AccountId != null){
                dataMap.put('donorId', donationVar.AccountId);
                dataMap.put('donorName', donationVar.Account.Name);

                if(donationVar.Account.npe01__One2OneContact__c != null){
                    email = donationVar.Account.npe01__One2OneContact__r.Email;
                    isEmailBounced = donationVar.Account.npe01__One2OneContact__r.IsEmailBounced == true;
                } else {
                    isDisabled = true;
                }
            }

            hasEmail = String.isNotBlank(email);

            if(!isDisabled) {
                channels.add('Postal Receipt');
                if (hasEmail && !isEmailBounced) {
                    channels.add('Email Receipt');
                }

                switch on donationVar.Receipt_Preference__c {
                    when 'Email Receipt' {
                        if (hasEmail && !isEmailBounced) {
                            dataMap.put('channel', 'Email Receipt');
                        } else {
                            dataMap.put('channel', 'Postal Receipt');
                        }
                    }
                    when 'Postal Receipt' {
                        dataMap.put('channel', 'Postal Receipt');
                    }
                    when 'No Receipt' {
                        dataMap.put('channel', 'No Receipt');
                    }
                    when else {
                        if(hasEmail && !isEmailBounced){
                            dataMap.put('channel', 'Email Receipt');
                        } else {
                            dataMap.put('channel', 'Postal Receipt');
                        }
                    }
                }
            }

            dataMap.put('isIndividual', isIndividual);
            dataMap.put('email', email);
            dataMap.put('hasEmail', hasEmail);
            dataMap.put('isEmailBounced', isEmailBounced);
            dataMap.put('channels', channels);
            dataMap.put('isDisabled', isDisabled);
        }
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response


}