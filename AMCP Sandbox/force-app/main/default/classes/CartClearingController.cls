public inherited sharing class CartClearingController {

  private static final EthosWebServiceCaller caller = EthosWebServiceCaller.getInstance();
  private static final ReceiptFetcher receiptFetcher = new ReceiptFetcherImpl();
  @AuraEnabled
  public static void clearCart(String receiptName){
    List<String> ethosCartItemIds = new List<String>();

    OrderApi__Receipt__c receipt = receiptFetcher.fetchByName(receiptName);

    for(OrderApi__Receipt_Line__c receiptLine :receipt.OrderApi__Receipt_Lines__r){
      if(receiptLine.OrderApi__Sales_Order_Line__r.Ethos_Cart_Item_Id__c != null){
        ethosCartItemIds.add(receiptLine.OrderApi__Sales_Order_Line__r.Ethos_Cart_Item_Id__c);
      }
    }

    if(ethosCartItemIds.isEmpty() == false){
      caller.clearCart(ethosCartItemIds);
    }
  }
}