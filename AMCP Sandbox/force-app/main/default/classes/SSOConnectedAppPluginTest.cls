@IsTest
private class SSOConnectedAppPluginTest {
  @IsTest
  static void customAttributes() {

    User user = TestUserFactory.createCommunityUser('Fonteva Customer Community Login');


    Map<String, String> attributes = new Map<String, String>();

    Test.startTest();

    SSOConnectedAppPlugin testObj = new SSOConnectedAppPlugin ();
    Map<String, String> customAttributeMap = testObj.customAttributes(user.Id, null, attributes, Auth.InvocationContext.OPENIDCONNECT);

    Test.stopTest();

    Map<String, String> mapstrempty = new Map<String, String>();
    System.debug(customAttributeMap);
    System.assertNotEquals(customAttributeMap, mapstrempty);
  }

}