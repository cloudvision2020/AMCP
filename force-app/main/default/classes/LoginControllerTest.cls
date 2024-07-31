@IsTest
public without sharing class LoginControllerTest {
  
   @TestSetup
  static void setUp() {
    FontevaTestUtilities.initializeFonteva();
  }

  @IsTest
  static void testRedirectOnUserLoggedIn() {
    try{
        User communityUser = UserTestFactory.makeCommunityUser(null);
       
        SiteTestFactory.makeSite();
        joinapi__Join_Process__c process = JoinProcessTestFactory.makeJoinProcess();
        joinapi__Step__c step = StepTestFactory.makeStep(process, 1, null);
        PageReference pr = Page.AMCPLogin;
        Test.setCurrentPageReference(pr);
        pr.getParameters().put('id', step.Id);
        pr.getParameters().put('order', step.joinapi__Order__c.intValue().format());
    
        PageReference redirect;
    
        Test.startTest();
        System.runAs(communityUser) {
          AMCPLoginController controller = new AMCPLoginController();
          redirect = controller.checkSession();
        }
        Test.stopTest();
    }catch(Exception ex){
    
    }
  }

  @IsTest
  static void testRedirectOnUserNotLoggedIn() {
    SiteTestFactory.makeSite();
    joinapi__Join_Process__c process = JoinProcessTestFactory.makeJoinProcess();
    joinapi__Step__c step = StepTestFactory.makeStep(process, 1, null);
    PageReference pr = Page.AMCPLogin;
    Test.setCurrentPageReference(pr);
    pr.getParameters().put('id', step.Id);
    pr.getParameters().put('order', step.joinapi__Order__c.intValue().format());

    PageReference redirect;

    Test.startTest();
    AMCPLoginController controller = new AMCPLoginController();
    redirect = controller.checkSession();
    JoinProcessService jp = new JoinProcessService();
    redirect = jp.cancel();
    Test.stopTest();

  }
}