@IsTest
private class EthosUserFetcherTest {

  private static final EthosUserFetcher testObj = new EthosUserFetcher();
  private static String input;
  private static EthosUser result;


  private static void executeTest(){
    result = testObj.retrieveSingleUser(input);
  }

  @IsTest
  public static void whenOneUserIsExpected_oneUserIsReturned() {
    input = TestMockFactory.GET_USER_SUCCESS_RESPONSE_BODY;

    Test.startTest();

    executeTest();

    Test.stopTest();

    Assert.isNotNull(result);
  }

  @IsTest
  public static void whenInputIsNotTheRightFormat_exceptionIsThrown() {
    input = '{}';

    Test.startTest();

    try {
      executeTest();
      Assert.fail();
    } catch (EthosException.InvalidObjectFormatException e) {

    }

    Test.stopTest();

  }
}