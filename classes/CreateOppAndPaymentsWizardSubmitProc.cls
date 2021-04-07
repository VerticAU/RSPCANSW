public without sharing class CreateOppAndPaymentsWizardSubmitProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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

        Opportunity opportunity = new Opportunity();
        this.request.getMapper().mapToSObject('opportunity', opportunity);

        pmdm__ProgramEngagement__c programEngagement = (pmdm__ProgramEngagement__c) vertic_Utils.arrays.firstOrException([
            SELECT Id, pmdm__Contact__c
            FROM pmdm__ProgramEngagement__c
            WHERE Id = :opportunity.Program_Engagement__c
        ]);

        opportunity.Name = 'Donation';
        opportunity.StageName = 'Closed Won';
        opportunity.isCompleted__c = true;
        opportunity.RecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.getSObjectType(), 'Donation');
        opportunity.CloseDate = Date.today();
        opportunity.ContactId = programEngagement.pmdm__Contact__c;

        this.uow.registerNew(opportunity);

        List<npe01__OppPayment__c> payments = this.request.getMapper().mapToListSObjects('payments', npe01__OppPayment__c.SObjectType);
        for(npe01__OppPayment__c oppPayment : payments){

            oppPayment.npe01__Payment_Date__c = Date.today();
            oppPayment.npe01__Paid__c = true;
            oppPayment.npe01__Written_Off__c = false;

            this.uow.registerNew(oppPayment);
            this.uow.registerRelationship(oppPayment, npe01__OppPayment__c.npe01__Opportunity__c, opportunity);
        }

        this.uow.commitWork();
        this.response.put('opportunityId', opportunity.Id);
    }

    /**
     * ==============================================================================================================
     *                                               STRUCTURES
     * ==============================================================================================================
     */

    private vertic_UnitOfWork uow = new vertic_UnitOfWork(new List<SObjectType> {
        npe01__OppPayment__c.SObjectType,
        Opportunity.SObjectType
    });

    // Proposed Live Templates to override Super properties:
    // vertic_request
    // vertic_response

}