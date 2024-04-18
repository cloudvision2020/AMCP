@IsTest
private class RedirectDisplayControllerTest {
  @IsTest
  public static void purchaseContainsEthosItems() {

    OrderApi__Receipt__c receipt = setupTestData();

    Test.startTest();

    Boolean containsEthosItem = RedirectDisplayController.purchaseContainsEthosItems(receipt.Name);

    Test.stopTest();

    Assert.isTrue(containsEthosItem);
  }

  @IsTest
  public static void getRedirectInformation() {

    OrderApi__Receipt__c receipt = setupTestData();


    Test.startTest();

    List<RedirectDisplayController.RedirectInformation> results = RedirectDisplayController.getRedirectInformation(receipt.Name);

    Test.stopTest();

    Assert.areEqual(1, results.size());

  }

  private static OrderApi__Receipt__c setupTestData() {

    OrderApi__Item__c item = new OrderApi__Item__c();
    item.Ethos_Id__c = 'test';
    insert item;

    OrderApi__Receipt__c receipt = new OrderApi__Receipt__c();
    insert receipt;

    OrderApi__Receipt_Line__c receiptLine = new OrderApi__Receipt_Line__c();
    receiptLine.OrderApi__Receipt__c = receipt.Id;
    receiptLine.OrderApi__Item__c = item.Id;
    insert receiptLine;

    receipt = [SELECT Id, Name FROM OrderApi__Receipt__c];

    return receipt;
  }

}