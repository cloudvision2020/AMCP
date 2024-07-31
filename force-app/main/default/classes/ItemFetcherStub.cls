@IsTest
public inherited sharing class ItemFetcherStub implements ItemFetcher{


  public List<OrderApi__Item__c> items = new List<OrderApi__Item__c>();

  public List<OrderApi__Item__c> fetchByEthosId(List<String> ethosIds) {
    return items;
  }

  public List<OrderApi__Item__c> fetchByIds(List<Id> recordIds) {
    return items;
  }
}