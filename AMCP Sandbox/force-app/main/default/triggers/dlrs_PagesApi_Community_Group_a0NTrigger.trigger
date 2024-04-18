/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_PagesApi_Community_Group_a0NTrigger on PagesApi__Community_Group_Member__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(PagesApi__Community_Group_Member__c.SObjectType);
}