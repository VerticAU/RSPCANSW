public without sharing class BulkContributionManagementSubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(
        new List<SObjectType>{
//            Contact.SObjectType,
//            Account.SObjectType,
            Opportunity.SObjectType,
            npe01__OppPayment__c.SObjectType
        },
        new vertic_UnitOfWork.DatabaseDMLIml()
    );


    private void doSubmit() {
        List<ContributionWrapper> contributionWrappers = (List<ContributionWrapper>) this.request.get('contributions', List<ContributionWrapper>.class);

        for (ContributionWrapper contributionWrapper : contributionWrappers) {

            Opportunity contribution = contributionWrapper.contribution;

            Boolean isCreditCardPayment = 'Credit Card'.equalsIgnoreCase(contributionWrapper.paymentMethod);

            contribution.StageName = isCreditCardPayment ? 'Pending' : 'Processed';

            this.uow.registerUpsert(contribution, false);

            if (isCreditCardPayment) {

            }

        }

        uow.commitWork();
    }


    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response

    private class ContributionWrapper {
        public Opportunity contribution;
        public String paymentMethod;
        public String stripePaymentId;
    }


}