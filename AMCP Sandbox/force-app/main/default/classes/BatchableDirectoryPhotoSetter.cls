public inherited sharing class BatchableDirectoryPhotoSetter implements Database.Batchable<SObject> {

  public static BatchableDirectoryPhotoSetter getInstanceForUsers(List<User> users, String communityName){

    String query = 'SELECT Id, ContactId FROM User WHERE Id IN (';
    for(User u : users){
      query+='\'';
      query += u.Id;
      query+='\'';
      query +=',';
    }
    query = query.removeEnd(',');
    query += ')';

    Id communityId = [SELECT Id FROM Network WHERE Name = :communityName].Id;

    return new BatchableDirectoryPhotoSetter(query, communityId);
  }

  public static BatchableDirectoryPhotoSetter getInstanceForProfile(String profileName, String communityName){

    Id communityId = [SELECT Id FROM Network WHERE Name = :communityName].Id;
    String query = 'SELECT Id,ContactId FROM User WHERE Profile.Name = \''+profileName+'\'';

    return new BatchableDirectoryPhotoSetter(query, communityId);
  }
  private final String userQuery;
  private final Id communityId;

  public BatchableDirectoryPhotoSetter(String userQuery, Id communityId) {
    this.userQuery = userQuery;
    this.communityId = communityId;
  }

  public Iterable<SObject> start(Database.BatchableContext param1) {
    return Database.getQueryLocator(userQuery);
  }

  public void execute(Database.BatchableContext param1, List<User> users) {

    Map<Id, String> photoUrlByContactId = new Map<Id, String>();

    for (User user : users) {
      String photoUrl;
      if (Test.isRunningTest() == false) {
        ConnectApi.Photo userPhoto = ConnectApi.UserProfiles.getPhoto(
          communityId,
          user.Id
        );
        photoUrl = userPhoto.largePhotoUrl;
      } else{
        photoUrl = 'http://test.pic';
      }

      photoUrlByContactId.put(user.ContactId, photoUrl);
    }

    List<Contact> contacts = new List<Contact>();

    for (Id contactId : photoUrlByContactId.keySet()) {

      Contact contact = new Contact();
      contact.Id = contactId;
      contact.Directory_Photo__c = photoUrlByContactId.get(contactId);
      contacts.add(contact);
    }

    update contacts;

  }

  public void finish(Database.BatchableContext param1) {
  }
}