public inherited sharing class SSOMetadataFetcherImpl implements SSOMetadataFetcher {
  public List< SSOCustomFields__mdt> getSSOCustomFieldsByIds() {
    return [select AttributeKey__c, FieldApiName__c, ObjectName__c from SSOCustomFields__mdt];
  }
}