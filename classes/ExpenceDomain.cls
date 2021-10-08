public without sharing class ExpenceDomain extends fflib_SObjectDomain{

    public ExpenceDomain(List<Task> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ExpenceDomain(sObjectList);
        }
    }
    public override void onBeforeInsert() {
        someMethod(this.Records,null);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        someMethod(this.Records, existingRecords);
    }

    private void someMethod(List<Expense__c> expenses, Map<Id, SObject> existingExpenses){
        List<Funding_Allocation__c> fundingAllocations = [
            SELECT Id, Service_Session__c, Funds_Remaining__c, CreatedDate
            FROM Funding_Allocation__c
            WHERE Status__c = 'Active'
            ORDER BY CreatedDate DESC
        ];

        List<Funding_Allocation__c> parentFundingAllocations = new List<Funding_Allocation__c>();

        for(Expense__c expenseRecord: expenses){
            Boolean expenseToBeProcessed = (expenseRecord.Status__c == 'Planning' ||  expenseRecord.Status__c == 'Paid') && expenseRecord.Program_Budget_Allocation__c == null && expenseRecord.Funding_Allocation__c == null;
            Boolean serviceSessionIsNotNull = expenseRecord.Service_Session__c != null;

            if(expenseToBeProcessed && serviceSessionIsNotNull){
                for(Funding_Allocation__c fundingAllocation: fundingAllocations){
                    if(fundingAllocation.Service_Session__c == expenseRecord.Service_Session__c &&
                        (fundingAllocation.Funds_Remaining__c > expenseRecord.Expense_Amount__c || expenseRecord.Expense_Amount__c == null)){
                        parentFundingAllocations.add(fundingAllocation);
                    }
                }
            }

            Funding_Allocation__c fundingAllocation = (Funding_Allocation__c)vertic_Utils.arrays.firstOrNull(parentFundingAllocations);
            expenseRecord.Funding_Allocation__c = fundingAllocation?.Id;
        }
    }
}