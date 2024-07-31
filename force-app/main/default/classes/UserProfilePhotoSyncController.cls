public with sharing class UserProfilePhotoSyncController {
  private final static UserProfilePhotoSync photoService = new UserProfilePhotoSync();

  @AuraEnabled
  public static void syncUserProfilePhoto(String userId, String communityId) {
    try {
      photoService.syncUserProfilePhoto(userId, communityId);
    } catch (Exception e) {
      System.debug(e);
    }
  }
}