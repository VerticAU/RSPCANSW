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
//        List<Funding_Allocation__c> fundingAllocations = [
//            SELECT Id
//            FROM Funding_Allocation__c
//            WHERE Funds_Remaining__c >:expenses[0].Expense_Amount__c AND  Service_Session__c IN (SELECT Id FROM pmdm__ServiceSession__c WHERE pmdm__Status__c = 'Active')
//        ];
        for(Expense__c expenseRecord: expenses){
            Boolean isPopulateRelationships = (expenseRecord.Status__c == 'Planning' ||  expenseRecord.Status__c == 'Paid') && expenseRecord.Program_Budget_Allocation__c == null && expenseRecord.Funding_Allocation__c == null;
            //Boolean isFundingAllocationExists =
        }
    }
}