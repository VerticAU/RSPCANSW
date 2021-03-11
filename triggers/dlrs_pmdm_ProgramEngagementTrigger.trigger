/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_pmdm_ProgramEngagementTrigger on pmdm__ProgramEngagement__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(pmdm__ProgramEngagement__c.SObjectType);
}