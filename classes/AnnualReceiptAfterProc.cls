global class AnnualReceiptAfterProc extends vertic_AbstractProcessor implements vertic_Structs.IRollbackable {

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
        this.donorIds = new Set<String>(recordIdsStr.split(','));

        this.startDate = (Date) this.request.get('startDate');
        this.endDate = (Date) this.request.get('endDate');

    }

    private void doSubmit() {
        Database.DMLOptions dmlOptionsVar = new Database.DMLOptions();
        dmlOptionsVar.OptAllOrNone = false;
        vertic_UnitOfWork uow = new vertic_UnitOfWork(
            new List<SObjectType>{
                Contact.SObjectType,
                Task.SObjectType
            },
            new vertic_UnitOfWork.DatabaseDMLIml(dmlOptionsVar)
        );

        String FY = GetFinancialYearsMetaProc.formatFinancialYear(this.startDate, this.endDate);

        Datetime dateTimeVar = Datetime.now();

        for (String donorId : this.donorIds) {
            Task newTask = new Task(
                Subject = 'Annual Receipt for ' + FY,
                Description = String.format('The Annual Donation Receipt was generated for {0} on {1}', new List<String>{
                    FY, dateTimeVar.format()
                }),
                WhoId = donorId,
                OwnerId = UserInfo.getUserId(),
                ActivityDate = this.endDate,
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

    private Set<String> donorIds;
    private Date startDate;
    private Date endDate;

}