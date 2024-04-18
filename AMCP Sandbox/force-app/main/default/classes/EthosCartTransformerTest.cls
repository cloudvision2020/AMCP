@IsTest
private class EthosCartTransformerTest {

  private static final EthosCartTransformer testObj = new EthosCartTransformer();
  private static String input;
  private static EthosCart result;


  private static void executeTest(){
    result = testObj.transform(input);
  }

  @IsTest
  public static void whenInputIsValid_cartObjectIsReturned() {
    input = TestMockFactory.GET_CART_SUCCESS_RESPONSE_BODY;

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