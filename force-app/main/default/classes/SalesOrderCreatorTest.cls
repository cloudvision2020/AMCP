@IsTest
private class SalesOrderCreatorTest {

  private static SObjectInserterSpy inserterSpy = new SObjectInserterSpy();
  private static ItemFetcherStub fetcherStub = new ItemFetcherStub();

  private static final String NODE_ID = 'TEST_NODE_ID';
  private static EthosCart cart;
  private static Id contactId;

  private static OrderApi__Sales_Order__c result;

  private static void performTest() {
    SalesOrderCreator testObj = new SalesOrderCreator(inserterSpy, fetcherStub);
    result = testObj.create(cart, contactId);
  }
  @IsTest
  public static void whenItemIsReturned_soAndSOLAreCreated() {
    cart = TestEthosObjectGenerator.generateCartWithOneItem(NODE_ID);

    OrderApi__Item__c item = new OrderApi__Item__c();
    item.Ethos_Id__c = NODE_ID;

    fetcherStub.items.add(item);

    Test.startTest();

    performTest();

    Test.stopTest();

    Assert.areEqual(2, inserterSpy.records.size());
    OrderApi__Sales_Order__c salesOrder = (OrderApi__Sales_Order__c) inserterSpy.records[0];
    assertSalesOrderValues(salesOrder);
    OrderApi__Sales_Order_Line__c salesOrderLine =  (OrderApi__Sales_Order_Line__c)inserterSpy.records[1];

    assertSalesOrderLineValues(salesOrder, salesOrderLine, item);
  }

  private static void assertSalesOrderValues(OrderApi__Sales_Order__c salesOrder) {
    Assert.areEqual('Contact', salesOrder.OrderApi__Entity__c);
    Assert.areEqual(contactId, salesOrder.OrderApi__Contact__c);
  }

  private static void assertSalesOrderLineValues(OrderApi__Sales_Order__c salesOrder, OrderApi__Sales_Order_Line__c salesOrderLine, OrderApi__Item__c item) {
    Assert.areEqual(salesOrder.Id, salesOrderLine.OrderApi__Sales_Order__c);
    Assert.areEqual(item.Id, salesOrderLine.OrderApi__Item__c);
    Assert.areEqual(cart.cartItems[0].qty, salesOrderLine.OrderApi__Quantity__c);
    Assert.areEqual(cart.cartItems[0].cart_item_id, salesOrderLine.Ethos_Cart_Item_Id__c);
  }
}