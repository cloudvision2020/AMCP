@IsTest
private class EthosSettingsTest {

  private static final EthosSettings testObj = new EthosSettings();
  @IsTest
  public static void baseUrl() {

    Assert.isNotNull(
      testObj.getBaseUrl()
    );
  }

  @IsTest
  public static void endpoint() {

    String expected;

    if ([SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
      expected = 'callout:Ethos_Integration_Sandbox';
    } else{
      expected = 'callout:Ethos_Integration_Production';
    }

    Assert.areEqual(
      expected, testObj.getEndpoint()
    );

  }

}