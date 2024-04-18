@IsTest
public class TestFontevaObjectFactory {

  private static OrderApi__Business_Group__c businessGroup;
  private static OrderApi__Item__c item;
  private static OrderApi__Receipt__c receipt;

  public static OrderApi__Receipt_Line__c createReceiptLine(){
    createItem();
    createReceipt();

    OrderApi__Receipt_Line__c receiptLine = new OrderApi__Receipt_Line__c();
    receiptLine.OrderApi__Receipt__c = receipt.Id;
    receiptLine.OrderApi__Item__c = item.Id;
    insert receiptLine;
    return receiptLine;
  }

  public static OrderApi__Receipt__c createReceipt() {
    if (receipt == null) {
      receipt = new OrderApi__Receipt__c();
      insert receipt;
    }
    return receipt;
  }

  public static OrderApi__Item__c createItem() {
    createBusinessGroup();
    if (item == null) {
      item = new OrderApi__Item__c();
      item.Ethos_Id__c = 'ETHOS';
      item.OrderApi__Business_Group__c = businessGroup.Id;
      insert item;
    }
    return item;
  }

  public static OrderApi__Business_Group__c createBusinessGroup() {

    if (businessGroup == null) {
      businessGroup = new OrderApi__Business_Group__c();
      insert businessGroup;
    }
    return businessGroup;
  }
}