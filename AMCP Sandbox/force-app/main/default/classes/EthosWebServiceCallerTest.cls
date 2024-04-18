@IsTest
private class EthosWebServiceCallerTest {

  private static EthosWebServiceCaller testObj;

  private static void setupTestObject() {
    testObj = EthosWebServiceCaller.getInstance();
  }
  @IsTest
  public static void getInstance() {

    setupTestObject();
    Assert.isNotNull(testObj);
  }

  @IsTest
  public static void getUser_whenEmailIsPassed_ethosUserWithSameEmailIsReturned() {

    String email = 'test@test.com';

    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getGetUserSuccessWithSpecificEmail(email));

    Test.startTest();

    EthosUser ethosUser = testObj.getUser(email);

    Test.stopTest();

    Assert.areEqual(email, ethosUser.mail);

  }

  @IsTest
  public static void getAllUsers() {

    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getGetUser());

    Test.startTest();

    List<EthosUser> ethosUsers = testObj.getAllUsers();

    Test.stopTest();

    Assert.areEqual(1, ethosUsers.size());
  }

  @IsTest
  public static void getCart_whenEthosIdIsPassed_cartIsReturned() {

    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getGetCart());

    Test.startTest();

    EthosCart cart = testObj.getCart(null);

    Test.stopTest();

    Assert.isNotNull(cart);

  }

  @IsTest
  public static void enroll() {
    List<String> courseNodeIds = new List<String>();
    courseNodeIds.add('76');

    String ethosUserId = '200';

    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getEnroll());

    Test.startTest();

    testObj.enroll(courseNodeIds, ethosUserId);

    Test.stopTest();

  }

  @IsTest
  public static void clearCart() {
    List<String> cartItemIds = new List<String>();
    cartItemIds.add('76');


    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getClearCart());

    Test.startTest();

    testObj.clearCart(cartItemIds);

    Test.stopTest();
  }

  @IsTest
  public static void whenResponseIsNotSuccess_thenExceptionIsThrown() {

    setupTestObject();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getFailureCall());

    Test.startTest();

    try {
      testObj.getAllCourses();
      Assert.fail();
    } catch (EthosException.FailedApiCallException e) {

    }

    Test.stopTest();


  }

}