@IsTest
public with sharing class JoinProcessTestFactory {
  public static joinapi__Join_Process__c makeJoinProcess() {
    joinapi__Join_Process__c result = new joinapi__Join_Process__c(
      joinapi__Is_Published__c = true
    );
    insert result;
    return result;
  }
}