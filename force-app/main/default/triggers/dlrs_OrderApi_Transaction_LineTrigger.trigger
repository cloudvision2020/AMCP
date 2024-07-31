/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_OrderApi_Transaction_LineTrigger on OrderApi__Transaction_Line__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(OrderApi__Transaction_Line__c.SObjectType);
}