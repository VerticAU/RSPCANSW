public without sharing class BulkContributionManagementMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;
        this.request.fields = new Set<SObjectField>{
            Opportunity.Donor_Type__c,
            Opportunity.npsp__Acknowledgment_Status__c,
            Opportunity.Receipt_Preference__c
        };

        super.process(this.request);

        this.intSelectOptions();
        this.mapContributions();
//        this.mapHasBatchApprovePermission();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */


    private void intSelectOptions() {
        this.response.selectOptions.put('paymentMethodOptions', vertic_Utils.arrays.stringsToSelectOptions(new List<String>{
            'Cash', 'Cheque', 'Credit Card'
        }));

        List<vertic_Structs.SelectOption> monthsOptions = new List<vertic_Structs.SelectOption>{
            new vertic_Structs.SelectOption(null, 'Month')
        };

        for (Integer i = 1; i <= 12; i++) {
            String counter = String.valueOf(i);
            monthsOptions.add(new vertic_Structs.SelectOption(('00' + i).substring(counter.length())));
        }
        this.response.selectOptions.put('monthsOptions', monthsOptions);

        List<vertic_Structs.SelectOption> yearsOptions = new List<vertic_Structs.SelectOption>{
            new vertic_Structs.SelectOption(null, 'Year')
        };
        for (Integer i = Date.today().year(); i < Date.today().year() + 15; i++) {
            yearsOptions.add(new vertic_Structs.SelectOption(i + ''));
        }
        this.response.selectOptions.put('yearsOptions', yearsOptions);

        this.response.getMapper().mapFromListSObjects('contributions', new List<Opportunity>{
        });
    }


    private void mapContributions() {
        String batchId = this.request.getString('batchId');
        if (String.isBlank(batchId)) {
            return;
        }

        List<Opportunity> contributions = new List<Opportunity>([
            SELECT Id,
                BSB__c,
                Amount,
                AccountId,
                CloseDate,
                CampaignId,
                Narrative__c,
                Donor_Type__c,
                isCompleted__c,
                Batch__c,
                Bank_Account_Number__c,
                Cheque_Number__c,
                Name_on_Cheque__c,
                Payment_Method__c,
                Stripe_Payment_Id__c,
                Stripe_Customer_Id__c,
                Campaign.Stripe_Account_Id__c,
                npsp__Acknowledgment_Status__c,
                npsp__Primary_Contact__c,
                Receipt_Preference__c
            FROM Opportunity
            WHERE Batch__c = :batchId
        ]);

        this.response.getMapper().mapFromListSObjects('contributions', contributions);
        this.response.getMapper().mapAnyValue('batchId', batchId);
    }


    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */
}