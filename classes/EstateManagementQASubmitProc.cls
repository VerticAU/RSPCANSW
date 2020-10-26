public class EstateManagementQASubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.mapSObjects();
        this.saveRecords();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private Account account = new Account();
    private Contact contact = new Contact();
    private Opportunity opportunity = new Opportunity();
    private List<npe5__Affiliation__c> affiliations = new List<npe5__Affiliation__c>();


    private void mapSObjects() {

        this.request.getMapper()
            .mapToSObject('opportunity', this.opportunity)
            .mapToSObject('account', this.account)
            .mapToSObject('opportunity.npsp__Primary_Contact__r', this.contact);

        this.affiliations = this.request.getMapper().mapToListSObjects('affiliations', npe5__Affiliation__c.SObjectType);
    }


    private void saveRecords() {

        if (this.account != null && String.isNotBlank(this.account.Name)) {
            this.account.npe01__One2OneContact__c = this.contact.Id;
            this.account.Bequest_Opportunity__c = this.opportunity.Id;
            this.account.RecordTypeId = vertic_Utils.sObjects.recordTypeIdByName(Schema.Account.SObjectType, 'Estate');
            insert this.account;

            this.contact.Date_Notified_of_Death__c = Date.today();
            this.contact.npsp__Primary_Affiliation__c = this.account.Id;
            update this.contact;

            for (npe5__Affiliation__c affiliation : this.affiliations) {
                affiliation.npe5__Organization__c = this.account.Id;
            }
            if (this.affiliations.size() > 0) {
                insert this.affiliations;
            }
            this.opportunity.AccountId = this.account.Id;
            update this.opportunity;

            AccountContactRelation accountContactRelation = new AccountContactRelation(AccountId = this.account.Id, ContactId = this.contact.Id);

            insert accountContactRelation;
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