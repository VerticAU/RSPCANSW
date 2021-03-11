/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_pmdm_ProgramEngagementTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_pmdm_ProgramEngagementTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new pmdm__ProgramEngagement__c());
    }
}