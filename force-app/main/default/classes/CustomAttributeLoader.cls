public inherited sharing class CustomAttributeLoader {

  public static CustomAttributeLoader getInstance(Id userId, Id connectedAppId, Auth.InvocationContext context){
    return new CustomAttributeLoader(new SSOMetadataFetcherImpl(), userId);
  }

  private SSOMetadataFetcher metadataFetcher;
  private Id userId;
  public CustomAttributeLoader(SSOMetadataFetcher metadataFetcher, Id userId){
    this.metadataFetcher = metadataFetcher;
    this.userId = userId;
  }

  public Map<String, String> augmentCustomAttributes(Map<String, String> formulaDefinedAttributes){
    List<SSOCustomFields__mdt> ssoCustomFieldsByIds = metadataFetcher.getSSOCustomFieldsByIds();

    User user = fetchUser(ssoCustomFieldsByIds);

    Contact contact = fetchContact(ssoCustomFieldsByIds, user);

    for(SSOCustomFields__mdt customField : ssoCustomFieldsByIds){
      if(customField.ObjectName__c == 'User'){
        formulaDefinedAttributes.put(customField.AttributeKey__c, String.valueOf(user.get(customField.FieldApiName__c)));
      } else if(customField.ObjectName__c == 'Contact'){
        formulaDefinedAttributes.put(customField.AttributeKey__c, String.valueOf(contact.get(customField.FieldApiName__c)));
      }
    }

    return formulaDefinedAttributes;
  }

  private User fetchUser(List<SSOCustomFields__mdt> ssoCustomFieldsByIds) {
    String userQuery = 'SELECT Id, ContactId,';
    String userFields = '';

    for (SSOCustomFields__mdt customField : ssoCustomFieldsByIds) {
      if (customField.ObjectName__c == 'User') {
        userFields += customField.FieldApiName__c + ',';
      }
    }
    userQuery += userFields;
    userQuery = userQuery.removeEnd(',');
    userQuery += ' FROM User WHERE Id = \'' + userId + '\'';

    User user = Database.query(userQuery);
    return user;
  }

  private Contact fetchContact(List<SSOCustomFields__mdt> ssoCustomFieldsByIds, User user) {
    String contactFields = '';

    for (SSOCustomFields__mdt customField : ssoCustomFieldsByIds) {
      if (customField.ObjectName__c == 'Contact') {
        contactFields += 'Contact.' + customField.FieldApiName__c + ',';
      }
    }

    String contactQuery = 'SELECT Id,';
    contactQuery += contactFields;
    contactQuery = contactQuery.removeEnd(',');
    contactQuery += ' FROM Contact WHERE Id = \'' + user.ContactId + '\'';

    Contact contact = Database.query(contactQuery);
    return contact;
  }

}