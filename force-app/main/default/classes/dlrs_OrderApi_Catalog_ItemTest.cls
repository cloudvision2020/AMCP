/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_OrderApi_Catalog_ItemTest
{
    @IsTest
    private static void testTrigger()
    {
        // Force the dlrs_OrderApi_Catalog_ItemTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new OrderApi__Catalog_Item__c());
    }
}