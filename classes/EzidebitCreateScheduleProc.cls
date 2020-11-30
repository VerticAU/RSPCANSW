public without sharing class EzidebitCreateScheduleProc extends vertic_AbstractProcessor {

    /**
     * ==============================================================================================================
     *                                              ATTRIBUTES
     * ==============================================================================================================
     */

    private Direct_Debit_Schedule__c schedule;


    /**
     * ==============================================================================================================
     *                                              PROCESS
     * ==============================================================================================================
     */

    public override vertic_Response process(vertic_Request request) {
        this.request = request;

        this.initData();
        this.createSchedule();

        return this.response;
    }


    /**
     * ==============================================================================================================
     *                                             PRIVATE METHODS
     * ==============================================================================================================
     */

    private void initData() {
        String recordId = this.request.getRequiredString('recordId');
        fflib_QueryFactory queryFactory = new fflib_QueryFactory(Direct_Debit_Schedule__c.SObjectType);
        queryFactory.selectFields(Direct_Debit_Schedule__c.SObjectType.getDescribe().fields.getMap().keySet().clone());
        queryFactory.setCondition('Id = :recordId');
        this.schedule = (Direct_Debit_Schedule__c) vertic_Utils.arrays.firstOrException(
            Database.query(queryFactory.toSOQL()),
            'No DD Schedule with Id: ' + recordId
        );
    }

    private void createSchedule() {
        SObject credentials = payment_ProcessorFactory.getGatewayCredentials('EziDebit');
        if ('Pending'.equals(this.schedule.Status__c)) {
            Boolean success = new EzidebitPaymentProcessor(credentials).changeCustomerStatus(
                this.schedule.EziDebit_Customer_ID__c,
                'H'
            );

            if (success == true) {
                success = new EzidebitPaymentProcessor(credentials).createSchedule(
                    this.schedule.EziDebit_Customer_ID__c,
                    '',
                    String.valueOf(this.schedule.Start_Date__c > Date.today() ? this.schedule.Start_Date__c : Date.today()),
                    this.schedule.Period_Type__c,
                    this.schedule.Day_Of_Week__c,
                    String.isNotBlank(this.schedule.Day_Of_Month__c) ? Integer.valueOf(this.schedule.Day_Of_Month__c) : 0,
                    this.schedule.Week_Of_Month__c != null && this.schedule.Week_Of_Month__c.contains('First'),
                    this.schedule.Week_Of_Month__c != null && this.schedule.Week_Of_Month__c.contains('Second'),
                    this.schedule.Week_Of_Month__c != null && this.schedule.Week_Of_Month__c.contains('Third'),
                    this.schedule.Week_Of_Month__c != null && this.schedule.Week_Of_Month__c.contains('Fourth'),
                    this.schedule.Amount__c,
                    0,
                    0,
                    true
                );

                if (success == true) {
                    update new Direct_Debit_Schedule__c(Id = this.schedule.Id, Status__c = 'Under Review');
                }
            }
        } else if ('Under Review'.equals(this.schedule.Status__c)) {
            Boolean success = new EzidebitPaymentProcessor(credentials).changeCustomerStatus(
                this.schedule.EziDebit_Customer_ID__c,
                'A'
            );

            if (success == true) {
                update new Direct_Debit_Schedule__c(Id = this.schedule.Id, Status__c = 'Active');
            }
        } else if ('Cancel'.equals(this.schedule.Status__c)) {
            Boolean success = new EzidebitPaymentProcessor(credentials).clearSchedule(
                this.schedule.EziDebit_Customer_ID__c,
                '',
                true
            );

            if (success == true) {
                update new Direct_Debit_Schedule__c(Id = this.schedule.Id, Status__c = 'Inactive');
            }
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