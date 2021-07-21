global class OpportunityNaming_TDTM extends npsp.TDTM_Runnable{
    global override npsp.TDTM_Runnable.DmlWrapper run(
        List<SObject> newlist,
        List<SObject> oldlist,
        npsp.TDTM_Runnable.Action triggerAction,
        Schema.DescribeSObjectResult objResult) {

        npsp.TDTM_Runnable.DmlWrapper dmlWrapper = new npsp.TDTM_Runnable.DmlWrapper();

        Map<Id, Contact> contactMap = new Map<Id, Contact>([SELECT Id, Name FROM Contact WHERE Id IN :vertic_Utils.sObjects.getStringFieldValues(newlist, 'npsp__Primary_Contact__c')]);
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Name FROM Account WHERE Id IN :vertic_Utils.sObjects.getStringFieldValues(newlist, 'AccountId')]);

        Id donationRecordTypeId = vertic_Utils.sObjects.recordTypeIdByAPIName(Opportunity.SObjectType, 'Donation');
        if (triggerAction == npsp.TDTM_Runnable.Action.BeforeInsert || triggerAction == npsp.TDTM_Runnable.Action.BeforeInsert) {
            for(Opportunity opportunity: (List<Opportunity>) newlist){
                if('Donation'.equalsIgnoreCase(opportunity.Name) && donationRecordTypeId == opportunity.RecordTypeId){
                    opportunity.Name = '';
                    if(String.isNotBlank(opportunity.npsp__Primary_Contact__c) && contactMap.containsKey(opportunity.npsp__Primary_Contact__c)){
                        opportunity.Name += contactMap.get(opportunity.npsp__Primary_Contact__c).Name + ' ';
                    } else if(String.isNotBlank(opportunity.AccountId) && accountMap.containsKey(opportunity.AccountId)){
                        opportunity.Name += accountMap.get(opportunity.AccountId).Name + ' ';
                    }
                    if(opportunity.Amount != null){
                        opportunity.Name += ' $' + opportunity.Amount.intValue();
                    }
                    if(opportunity.CloseDate != null){
                        opportunity.Name += ' ' + Datetime.newInstance(opportunity.CloseDate, Time.newInstance(0,0,0,0)).format('dd/MM/yyyy');
                    }
                    if(String.isNotBlank(opportunity.Primary_Campaign_Source_Code__c)){
                        opportunity.Name += ' ' + opportunity.Primary_Campaign_Source_Code__c;
                    }
                }
            }
        }
        return dmlWrapper;
    }
}