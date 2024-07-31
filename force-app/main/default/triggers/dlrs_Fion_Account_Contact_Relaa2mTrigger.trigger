/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
trigger dlrs_Fion_Account_Contact_Relaa2mTrigger on Fion_Account_Contact_Relationship__c
    (before delete, before insert, before update, after delete, after insert, after undelete, after update)
{
    dlrs.RollupService.triggerHandler(Fion_Account_Contact_Relationship__c.SObjectType);
}