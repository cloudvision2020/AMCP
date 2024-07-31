@IsTest
private class ItemFetcherImplTest {

  private static final ItemFetcherImpl testObj = new ItemFetcherImpl();

  @IsTest
  public static void fetchByIds_emptyListReturned() {

    List<Id> recordIds = new List<Id>();
    recordIds.add(UserInfo.getUserId());

    Test.startTest();

    List<OrderApi__Item__c> result = testObj.fetchByIds(recordIds);

    Test.stopTest();

    Assert.areEqual(0, result.size());
  }

  @IsTest
  public static void fetchByEthosIds_emptyListReturned() {

    List<String> ethosIds = new List<String>();
    ethosIds.add('1');
    Test.startTest();

    List<OrderApi__Item__c> result = testObj.fetchByEthosId(ethosIds);

    Test.stopTest();

    Assert.areEqual(0, result.size());
  }

}