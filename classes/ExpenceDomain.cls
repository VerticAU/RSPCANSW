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
        populateExpenseRelationships(this.Records,null);
    }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        populateExpenseRelationships(this.Records, existingRecords);
    }

    private void populateExpenseRelationships(List<Expense__c> expenses, Map<Id, SObject> existingExpenses){

        Set<Id> relatedServiceSessionIds = vertic_Utils.sObjects.getIdFieldValues(expenses, Expense__c.Service_Session__c);
        Set<Id> relatedProgramIds = new Set<Id>();

        Map<Id, pmdm__ServiceSession__c> serviceSessions = new Map<Id, pmdm__ServiceSession__c>([
            SELECT Id,Name, Program__c
            FROM pmdm__ServiceSession__c
            WHERE Id IN :relatedServiceSessionIds
        ]);

        List<Funding_Allocation__c> fundingAllocations = [
            SELECT Id, Service_Session__c, Funds_Remaining__c, CreatedDate
            FROM Funding_Allocation__c
            WHERE Status__c = 'Active' AND Service_Session__c IN :serviceSessions.keySet()
            ORDER BY CreatedDate DESC
        ];

        relatedProgramIds = vertic_Utils.sObjects.getIdFieldValues(serviceSessions.values(), pmdm__ServiceSession__c.Program__c);

        List<Program_Budget_Allocation__c> programBudgetAllocations = [
            SELECT Id, Program__c, Funds_Remaining__c
            FROM Program_Budget_Allocation__c
            WHERE  Status__c = 'Active' AND Program__c IN :relatedProgramIds
            ORDER BY CreatedDate DESC
        ];

        List<Funding_Allocation__c> parentFundingAllocations = new List<Funding_Allocation__c>();
        List<Program_Budget_Allocation__c> parentProgramBudgetAllocations = new List<Program_Budget_Allocation__c>();

        for(Expense__c expenseRecord: expenses){
            Boolean expenseToBeProcessed = (expenseRecord.Status__c.equals('Planning') ||  expenseRecord.Status__c.equals('Paid'))
                && expenseRecord.Program_Budget_Allocation__c == null && expenseRecord.Funding_Allocation__c == null;

            if(expenseToBeProcessed && expenseRecord.Service_Session__c != null){
                for(Funding_Allocation__c fundingAllocation: fundingAllocations){
                    if(fundingAllocation.Service_Session__c.equals(expenseRecord.Service_Session__c)
                        && (fundingAllocation.Funds_Remaining__c > expenseRecord.Expense_Amount__c || expenseRecord.Expense_Amount__c == null)){
                        parentFundingAllocations.add(fundingAllocation);
                    }
                }
            }

            if(parentFundingAllocations.isEmpty() != true){
                Funding_Allocation__c fundingAllocation = (Funding_Allocation__c)vertic_Utils.arrays.firstOrNull(parentFundingAllocations);
                expenseRecord.Funding_Allocation__c = fundingAllocation?.Id;
                continue;
            }
            if(expenseToBeProcessed && expenseRecord.Service_Session__c != null) {
                for (Program_Budget_Allocation__c programBudgetAllocation : programBudgetAllocations) {
                    if (programBudgetAllocation.Program__c != null && serviceSessions.get(expenseRecord.Service_Session__c).Program__c != null
                        && programBudgetAllocation.Program__c.equals(serviceSessions.get(expenseRecord.Service_Session__c).Program__c)
                        && (programBudgetAllocation.Funds_Remaining__c > expenseRecord.Expense_Amount__c || expenseRecord.Expense_Amount__c == null)) {
                        parentProgramBudgetAllocations.add(programBudgetAllocation);
                    }
                }
            }

            if(parentProgramBudgetAllocations.isEmpty() != true){
                Program_Budget_Allocation__c programBudgetAllocation = (Program_Budget_Allocation__c)vertic_Utils.arrays.firstOrNull(parentProgramBudgetAllocations);
                expenseRecord.Program_Budget_Allocation__c = programBudgetAllocation?.Id;
                continue;
            }

            expenseRecord.addError('There are no funds available for this expense, please review the Funding Allocations assigned to the Service Session and the Program Budget Allocation assigned to the Program to ensure funds are available.');
        }
    }
}