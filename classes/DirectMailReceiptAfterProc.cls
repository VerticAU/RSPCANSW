public class DirectMailReceiptAfterProc  extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.init();
        this.doSubmit();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void init() {
        String recordIdsStr = this.request.getRequiredString('ids');
        this.donationIds = new Set<String>(recordIdsStr.split(','));
    }

    private void doSubmit() {
        Database.DMLOptions dmlOptionsVar = new Database.DMLOptions();
        dmlOptionsVar.OptAllOrNone = false;
        vertic_UnitOfWork uow = new vertic_UnitOfWork(
            new List<SObjectType>{
                Opportunity.SObjectType,
                Task.SObjectType
            },
            new vertic_UnitOfWork.DatabaseDMLIml(dmlOptionsVar)
        );

        Datetime dateTimeVar = Datetime.now();

        for (String donationId : this.donationIds) {

            Task newTask = new Task(
                Subject = 'Donation Receipt',
                Description = String.format('The Donation Receipt was generated on {0}', new List<String>{
                    dateTimeVar.format()
                }),
                WhatId = donationId,
                OwnerId = UserInfo.getUserId(),
                ActivityDate = dateTimeVar.date(),
                Status = 'Completed'
            );
            uow.registerUpsert(newTask);
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

    private Set<String> donationIds;
    private Date startDate;
    private Date endDate;

}