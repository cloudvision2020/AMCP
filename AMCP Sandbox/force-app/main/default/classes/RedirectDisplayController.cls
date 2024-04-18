public without sharing class RedirectDisplayController {

  private static final EthosSettings SETTINGS = new EthosSettings();
  private static final ReceiptFetcher receiptFetcher = new ReceiptFetcherImpl();

  @AuraEnabled
  public static Boolean purchaseContainsEthosItems(String receiptName){

    Boolean containsEthosItem = false;

    OrderApi__Receipt__c receipt = receiptFetcher.fetchByName(receiptName);

    for(OrderApi__Receipt_Line__c receiptLine :receipt.OrderApi__Receipt_Lines__r){
      if(receiptLine.OrderApi__Item__r.Ethos_Id__c != null){
        containsEthosItem = true;
      }
    }

    return containsEthosItem;
  }

  @AuraEnabled
  public static List<RedirectInformation> getRedirectInformation(String receiptName){

    List<RedirectInformation> redirects = new List<RedirectInformation>();
    OrderApi__Receipt__c receipt = receiptFetcher.fetchByName(receiptName);

    for(OrderApi__Receipt_Line__c receiptLine :receipt.OrderApi__Receipt_Lines__r){
      if(receiptLine.OrderApi__Item__r.Ethos_Id__c != null){
        RedirectInformation info = new RedirectInformation();
        info.name = receiptLine.OrderApi__Item__r.Name;
        info.ethosId = receiptLine.OrderApi__Item__r.Ethos_Id__c;
        info.url = SETTINGS.getBaseUrl()+'/node/'+receiptLine.OrderApi__Item__r.Ethos_Id__c;
        redirects.add(info);
      }
    }

    return redirects;
  }

  public class RedirectInformation{

    @AuraEnabled public String name;
    @AuraEnabled public String url;
    @AuraEnabled public String ethosId;
  }

}