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


    private void intSelectOptions(){
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



    private void mapContributions(){
        String batchId = this.request.getString('batchId');
        if(String.isBlank(batchId)){
            return;
        }

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Opportunity.SObjectType);
        queryFactory.selectFields(new Set<String>{
            'Id',
            'npsp__Primary_Contact__c',
            'CampaignId',
//            'npe01__OppPayment__c.Payment_Method__c',
            'CloseDate',
//            'Receipt_Type__c',
            'npsp__Batch__c',
//            'Receipt_Template__c',
//            'Is_Exempt_From_Receipting__c',
            'Amount'
        });

        List<String> conditions = new List<String>{ 'npsp__Batch__c = :batchId' };

        if(this.request.getString('condition') != null){
            conditions.add(this.request.getString('condition'));
        }

        queryFactory.setCondition(String.join(conditions, ' AND '));

        List<Opportunity> contributions = Database.query(queryFactory.toSOQL());

        this.response.getMapper().mapFromListSObjects('contributions', contributions);
        this.response.getMapper().mapAnyValue('batchId', batchId);
    }

//    final Set<String> BATCH_APPROVER_PROFILES = new Set<String>{
//        'Manager',
//        'System Administrator'
//    };





//    private void mapHasBatchApprovePermission(){
//
//        List<PermissionSetAssignment> permissionSetAssignments = [
//            SELECT
//                AssigneeId,
//                Id,
//                PermissionSetId,
//                PermissionSet.Name,
//                SystemModstamp
//            FROM PermissionSetAssignment
//            WHERE PermissionSet.Name = 'Batch_Approver' AND AssigneeId = :UserInfo.getUserId()
//            LIMIT 1
//        ];
//
//        Profile profileVar = (Profile)vertic_Utils.arrays.firstOrNull(
//        [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()]
//        );
//
//        Boolean hasAccessByProfile = profileVar != null && BATCH_APPROVER_PROFILES.contains(profileVar.Name);
//        Boolean hasAccessByPermissionSet = !permissionSetAssignments.isEmpty();
//
//        Boolean hasAccess = hasAccessByProfile || hasAccessByPermissionSet;
//
//        this.response.getMapper().mapAnyValue('hasBatchApprovePermission', hasAccess);
//    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_meta_request
    // vertic_meta_response

}