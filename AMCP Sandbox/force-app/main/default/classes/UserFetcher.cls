/**
 * Created by ashwinireddy on 4/30/23.
 */

public with sharing class UserFetcher {

  public List<User> getUserWithContact(String userId) {
    System.debug('Get userId in UserRepo:' + userId);
    SObjectAccessDecision decision = Security.stripInaccessible(
      AccessType.READABLE,
      [
        SELECT IsProfilePhotoActive, ContactId, Contact.Directory_Photo__c
        FROM User
        WHERE Id = :userId
        WITH SECURITY_ENFORCED
        LIMIT 1
      ]
    );
    return (List<User>) decision.getRecords();
  }

}