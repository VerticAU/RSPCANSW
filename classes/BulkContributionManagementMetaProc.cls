public without sharing class BulkContributionManagementMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;
        this.request.fields = new Set<SObjectField>{
            
        };

        super.process(this.request);

        this.init();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {

        this.response.selectOptions.put('paymentMethodOptions', vertic_Utils.arrays.stringsToSelectOptions(new List<String>{
            'Cash', 'Cheque',  'Credit Card'
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

        this.response.selectOptions.put('donationTypeOptions', new List<vertic_Structs.SelectOption>{
            new vertic_Structs.SelectOption('Contact', 'Contact'),
            new vertic_Structs.SelectOption('Organisation', 'Organisation')
        });

        this.response.getMapper().mapFromListSObjects('contributions', new List<Opportunity>{});
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_meta_request
    // vertic_meta_response

}