/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_OrderApi_Receipt_LineTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_OrderApi_Receipt_LineTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new OrderApi__Receipt_Line__c());
    }
}