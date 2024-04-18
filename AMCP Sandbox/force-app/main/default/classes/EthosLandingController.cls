public without sharing class EthosLandingController {

  @AuraEnabled
  public static OrderApi__Sales_Order__c initiateCheckout(Id userId){

    EthosWebServiceCaller webServiceCaller = EthosWebServiceCaller.getInstance();
    SalesOrderCreator salesOrderCreator = SalesOrderCreator.getInstance();

    User user = fetchUser(userId);
    String ethosId = webServiceCaller.getUser(user.Email).uid;
    EthosCart cart = webServiceCaller.getCart(ethosId);

    OrderApi__Sales_Order__c salesOrder = salesOrderCreator.create(cart, user.ContactId);

    return [SELECT Id, OrderApi__Encrypted_Id__c FROM OrderApi__Sales_Order__c WHERE Id = :salesOrder.Id];
  }

  private static User fetchUser(Id userId) {
    return [SELECT Id, Email, ContactId FROM User WHERE Id = :userId];
  }
}