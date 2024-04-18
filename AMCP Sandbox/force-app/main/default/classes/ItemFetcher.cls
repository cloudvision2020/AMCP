public interface ItemFetcher {

  List<OrderApi__Item__c> fetchByIds(List<Id> recordIds);

  List<OrderApi__Item__c> fetchByEthosId(List<String> ethosIds);

}