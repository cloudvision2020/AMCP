/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_OrderApi_Receipt_LineTrigger on OrderApi__Receipt_Line__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(OrderApi__Receipt_Line__c.SObjectType);
}