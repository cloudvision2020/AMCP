@IsTest
private class CartClearingControllerTest {
  @IsTest
  public static void integrationTestForCartClearing() {

    OrderApi__Receipt__c receipt = insertTestData();

    User communityUser = TestUserFactory.createCommunityUser('Fonteva Customer Community');
    Test.startTest();
    Test.setMock(HttpCalloutMock.class,TestMockFactory.getGetUserSuccessAndEnrollSuccess());

    CartClearingController.clearCart(receipt.Name);

    Test.stopTest();

  }

  private static OrderApi__Receipt__c insertTestData() {

    OrderApi__Receipt_Line__c ethosReceiptLine = TestFontevaObjectFactory.createReceiptLine();
    return [SELECT Name FROM OrderApi__Receipt__c WHERE Id = :ethosReceiptLine.OrderApi__Receipt__c];
  }
}