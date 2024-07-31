@IsTest
private class CustomAttributeLoaderTest {

  private static CustomAttributeLoader testObj;

  @IsTest
  public static void getInstance() {

    Test.startTest();

    Assert.isNotNull(CustomAttributeLoader.getInstance(null,null,null));

    Test.stopTest();

  }

  @IsTest
  public static void augmentCustomAttributes() {

    User user = TestUserFactory.createCommunityUser('Fonteva Customer Community Login');

    testObj = CustomAttributeLoader.getInstance(user.Id,null,null);

    Test.startTest();

    Map<String, String> result = testObj.augmentCustomAttributes(new Map<String, String>());

    Test.stopTest();

  }
}