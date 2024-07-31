public inherited sharing class BatchableProfilePhotoSetter implements Database.Batchable<SObject>{
  public static BatchableProfilePhotoSetter getInstanceForUsers(List<User> users, String communityName){

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

    return new BatchableProfilePhotoSetter(query, communityId);
  }

  public static BatchableProfilePhotoSetter getInstanceForProfile(String profileName, String communityName){

    Id communityId = [SELECT Id FROM Network WHERE Name = :communityName].Id;
    String query = 'SELECT Id,ContactId FROM User WHERE Profile.Name = \''+profileName+'\'';

    return new BatchableProfilePhotoSetter(query, communityId);
  }

  private final String userQuery;
  private final Id communityId;

  public BatchableProfilePhotoSetter(String userQuery, Id communityId){
    this.userQuery = userQuery;
    this.communityId = communityId;
  }

  public Database.QueryLocator start(Database.BatchableContext param1) {
    return Database.getQueryLocator(userQuery);
  }

  public void execute(Database.BatchableContext param1, List<User> users) {
    CommunityProfilePhotoSetter setter = new CommunityProfilePhotoSetter();
    setter.set(communityId, users);
  }

  public void finish(Database.BatchableContext param1) {
  }

}