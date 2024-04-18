public inherited sharing class ReceiptFetcherImpl implements ReceiptFetcher{

  public OrderApi__Receipt__c fetchByName(String name) {
    OrderApi__Receipt__c receipt = [
      SELECT Id,
      (SELECT Id, OrderApi__Item__c,OrderApi__Item__r.Name, OrderApi__Item__r.Ethos_Id__c,
        OrderApi__Sales_Order_Line__c, OrderApi__Sales_Order_Line__r.Ethos_Cart_Item_Id__c
      FROM OrderApi__Receipt_Lines__r
      )
      FROM OrderApi__Receipt__c
      WHERE Name = :name];
    return receipt;
  }
}