public without sharing class CreateOppAndPaymentsWizardSubmitProc extends vertic_AbstractProcessor {

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



    private void doSubmit() {

        Opportunity opp = new Opportunity();
        this.request.getMapper().mapToSObject('opportunity', opp);

        pmdm__ProgramEngagement__c programEngagement = (pmdm__ProgramEngagement__c) vertic_Utils.arrays.firstOrException([
            SELECT Id, pmdm__Contact__c
            FROM pmdm__ProgramEngagement__c
            WHERE Id = :opp.Program_Engagement__c
        ]);

        opp.Name = 'Donation';
        opp.StageName = 'Closed Won';
        opp.isCompleted__c = true;
        opp.RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.getSObjectType(), 'Donation');
        opp.CloseDate = Date.today();
        opp.ContactId = programEngagement.pmdm__Contact__c;
        opp.npe01__Do_Not_Automatically_Create_Payment__c = true;

        System.debug(opp);
        this.uow.registerNew(opp);

        List<npe01__OppPayment__c> payments = this.request.getMapper().mapToListSObjects('payments', npe01__OppPayment__c.SObjectType);
        for(npe01__OppPayment__c oppPayment : payments){

            oppPayment.npe01__Payment_Date__c = Date.today();
            oppPayment.npe01__Paid__c = true;
            oppPayment.npe01__Written_Off__c = false;

            this.uow.registerNew(oppPayment);
            this.uow.registerRelationship(oppPayment, npe01__OppPayment__c.npe01__Opportunity__c, opp);
        }

        this.uow.commitWork();
        this.response.put('opportunityId', opp.Id);
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType> {
        Opportunity.SObjectType,
        npe01__OppPayment__c.SObjectType
    });

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response

}