public class AddPaymentWizardSearchStepMetaProc extends vertic_MetadataProcessor {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request == null ? new MetadataRequest() : (MetadataRequest) request;

        this.request.fields = new Set<SObjectField>{
            // SObject Fields, e.g. Contact.Salutation
        };

        super.process(this.request);

        this.retrieveRecords();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void retrieveRecords() {
        String accountId = this.request.getString('filter.accountId');
        String deceasedContactId = this.request.getString('filter.deceasedContactId');
        String primaryContactId = this.request.getString('filter.primaryContactId');

        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Opportunity.SObjectType);
        queryFactory.selectFields(new Set<String>{'Id'});

        List<String> conditions = new List<String>{};
        if (String.isNotBlank(accountId)) { conditions.add('AccountId = :accountId');  }
        if (String.isNotBlank(deceasedContactId)) { conditions.add('Account.Deceased_Donor__c = :deceasedContactId'); }
        if (String.isNotBlank(primaryContactId)) { conditions.add('npe01__One2OneContact__c = :primaryContactId'); }
        queryFactory.setCondition(String.join(conditions, ' OR '));

        queryFactory.getOrderings().clear();
        queryFactory.addOrdering(Opportunity.CloseDate, fflib_QueryFactory.SortOrder.ASCENDING, true);
        queryFactory.setLimit(50000);

        List<Opportunity> opportunities = Database.query(queryFactory.toSOQL());

        this.response.put('ids', vertic_Utils.sObjects.getIdFieldValues(opportunities, 'Id'));
    }

    /**
     * ==============================================================================================================
     *                                         STRUCTURES AND OVERRIDES
     * ==============================================================================================================
     */

}