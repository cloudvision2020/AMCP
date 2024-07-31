/**
 * Created by ashwinireddy on 4/30/23.
 */

public without sharing class UserProfilePhotoSync {

  private final UserFetcher userFetcher;

  public UserProfilePhotoSync() {
    this.userFetcher = new UserFetcher();
  }

  public void syncUserProfilePhoto(String userId, String communityId) {
    String photoUrl;
    if (Test.isRunningTest()) {
      photoUrl = 'http://test.pic';
    } else {
      ConnectApi.Photo userPhoto = ConnectApi.UserProfiles.getPhoto(
        communityId,
        userId
      );
      photoUrl = userPhoto.largePhotoUrl;
    }
    List<User> user = this.userFetcher.getUserWithContact(userId);
    if (
      (Test.isRunningTest() || user[0].IsProfilePhotoActive) &&
        user[0].Contact.Directory_Photo__c != photoUrl
    ) {
      Contact updatedContact = new Contact(
        Id = user[0].ContactId,
        Directory_Photo__c = photoUrl
      );
      update updatedContact;

    }
  }
}