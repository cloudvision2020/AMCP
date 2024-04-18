public inherited sharing class ItemFetcherImpl implements ItemFetcher{
  public List<OrderApi__Item__c> fetchByIds(List<Id> recordIds){

    if(recordIds == null || recordIds.isEmpty()){
      return new List<OrderApi__Item__c>();
    }

    String whereClause = 'Ethos_Id__c != NULL AND Id IN (';
    for(Id recordId :recordIds){
      whereClause += '\''+recordId +'\',';
    }
    whereClause = whereClause.removeEnd(',');
    whereClause += ')';
    return query(whereClause);
  }

  public List<OrderApi__Item__c> fetchByEthosId(List<String> ethosIds) {

    if(ethosIds == null || ethosIds.isEmpty()){
      return new List<OrderApi__Item__c>();
    }

    String whereClause = 'Ethos_Id__c IN (';
    for(String ethosId :ethosIds){
      whereClause += '\''+ethosId +'\',';
    }
    whereClause = whereClause.removeEnd(',');
    whereClause += ')';
    return query(whereClause);
  }
  private List<OrderApi__Item__c> query(String whereClause){
    String query = 'SELECT Id, Ethos_Id__c FROM OrderApi__Item__c WHERE '+whereClause;
    System.debug(query);
    return Database.query(query);
  }

}