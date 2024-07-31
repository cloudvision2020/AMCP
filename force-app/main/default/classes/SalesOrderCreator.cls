public inherited sharing class SalesOrderCreator {

  private final SObjectInserter inserter;
  private final ItemFetcher itemFetcher;

  private List<String> ethosItemIds;
  private Map<String, OrderApi__Item__c> itemByEthosNodeId;
  private OrderApi__Sales_Order__c salesOrder;

  public static SalesOrderCreator getInstance(){
    return new SalesOrderCreator(
      SObjectInserterImpl.getInstance(),
      new ItemFetcherImpl()
    );
  }

  public SalesOrderCreator(SObjectInserter inserter, ItemFetcher itemFetcher){
    this.inserter = inserter;
    this.itemFetcher = itemFetcher;
  }

  public OrderApi__Sales_Order__c create(EthosCart cart, Id contactId) {

    extractEthosItemIds(cart);
    buildItemByEthosIdMap();
    createSalesOrder(contactId);
    createSalesOrderLines(cart);

    return salesOrder;
  }

  private void extractEthosItemIds(EthosCart cart) {
    ethosItemIds = new List<String>();
    for (EthosCart.CartItem cartItem : cart.cartItems) {
      ethosItemIds.add(cartItem.nid);
    }
  }
  private void buildItemByEthosIdMap() {
    List<OrderApi__Item__c> items = itemFetcher.fetchByEthosId(ethosItemIds);

    itemByEthosNodeId = new Map<String, OrderApi__Item__c>();

    for(OrderApi__Item__c item : items){
      itemByEthosNodeId.put(item.Ethos_Id__c, item);
    }


  }

  private void createSalesOrder(Id contactId) {
    salesOrder = new OrderApi__Sales_Order__c();
    salesOrder.OrderApi__Entity__c = 'Contact';
    salesOrder.OrderApi__Contact__c = contactId;
    inserter.insertRecord(salesOrder);
  }

  private void createSalesOrderLines(EthosCart cart) {
    List<OrderApi__Sales_Order_Line__c> salesOrderLines = new List<OrderApi__Sales_Order_Line__c>();

    for (EthosCart.CartItem cartItem : cart.cartItems) {
      OrderApi__Item__c item = itemByEthosNodeId.get(cartItem.nid);
      OrderApi__Sales_Order_Line__c salesOrderLine = new OrderApi__Sales_Order_Line__c();
      salesOrderLine.OrderApi__Sales_Order__c = salesOrder.Id;
      salesOrderLine.OrderApi__Item__c = item.Id;
      salesOrderLine.OrderApi__Quantity__c = cartItem.qty;
      salesOrderLine.Ethos_Cart_Item_Id__c = cartItem.cart_item_id;
      salesOrderLines.add(salesOrderLine);
    }

    inserter.insertRecords(salesOrderLines);
  }
}