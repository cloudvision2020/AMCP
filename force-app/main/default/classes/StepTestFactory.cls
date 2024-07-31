@IsTest
public with sharing class StepTestFactory {
  public static joinapi__Step__c makeStep(
    joinapi__Join_Process__c process,
    Double order,
    joinapi__Step__c next
  ) {
    joinapi__Step__c result = new joinapi__Step__c(
      joinapi__Join_Process__c = process.Id,
      joinapi__Order__c = 1,
      joinapi__Is_Published__c = true,
      joinapi__Page_Title__c = 'Login',
      joinapi__Instructions__c = 'Instructions',
      joinapi__Is_First_Step__c = true,
      joinapi__Is_Custom_Page__c = true,
      joinapi__Login_Header__c = 'Login Header',
      joinapi__Login_Button_Label__c = 'Login Button',
      joinapi__Login_Instructions__c = 'Login Instructions',
      joinapi__New_User_Header__c = 'New User Header',
      joinapi__New_User_Button_Label__c = 'New User Button',
      joinapi__New_User_Instructions__c = 'New User Instructions',
      joinapi__Visual_Force_Page_API_Name__c = 'FionFontevaCustomLogin'
    );
    if (next != null) {
      result.joinapi__Next_Step__c = next.Id;
    }
    insert result;
    return result;
  }
}