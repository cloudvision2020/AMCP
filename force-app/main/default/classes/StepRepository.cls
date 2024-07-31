public inherited sharing class StepRepository {
  public joinapi__Step__c getStep(String stepId) {
    return [
      SELECT
        Id,
        joinapi__Instructions__c,
        joinapi__Login_Header__c,
        joinapi__Login_Instructions__c,
        joinapi__New_User_Button_Label__c,
        joinapi__New_User_Header__c,
        joinapi__New_User_Instructions__c,
        joinapi__Next_Step__c,
        joinapi__Order__c,
        joinapi__Page_Title__c,
        joinapi__Visual_Force_Page_API_Name__c
      FROM joinapi__Step__c
      WHERE Id = :stepId
      LIMIT 1
    ];
  }
}