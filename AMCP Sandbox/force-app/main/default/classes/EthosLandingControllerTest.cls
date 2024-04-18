@IsTest
private class EthosLandingControllerTest {
  @IsTest
  public static void initiateCheckout() {

    TestFontevaObjectFactory.createItem();


    User user = TestUserFactory.createCommunityUser('Fonteva Customer Community');

    Test.setMock(HttpCalloutMock.class,TestMockFactory.getGetUserAndGetCart());
    Test.startTest();

    EthosLandingController.initiateCheckout(user.Id);

    Test.stopTest();
  }
}