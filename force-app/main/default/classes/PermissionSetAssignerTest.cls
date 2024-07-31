@IsTest
private class PermissionSetAssignerTest {

  private static final String permsetName = 'Ethos_Checkout';

  private static PermissionSetAssigner testObj;
  @IsTest
  public static void assign() {
    User u = new User();
    u.Id = UserInfo.getUserId();

    Test.startTest();

    testObj = new PermissionSetAssigner(permsetName);
    testObj.assign(new List<User>{u});

    Test.stopTest();
  }
}