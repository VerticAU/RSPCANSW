public class PopulateOpportunityCampaignScript extends vertic_AbstractProcessor {

    /**
       * ==============================================================================================================
       *                                              PROCESS
       * ==============================================================================================================
       */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.processData();

        return this.response;
    }

    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void processData(){

        List<Opportunity> opportunities = [
            SELECT Id, npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c
            FROM Opportunity
            WHERE npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c != NULL
            AND CampaignId = NULL
            AND Created_By_Recurring_Donation__c = TRUE
            AND Id IN :this.request.getListAsStrings('recordIds')
        ];

        for(Opportunity opp : opportunities){
            opp.CampaignId = opp.npe03__Recurring_Donation__r.npe03__Recurring_Donation_Campaign__c;
        }

        update opportunities;
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */
}