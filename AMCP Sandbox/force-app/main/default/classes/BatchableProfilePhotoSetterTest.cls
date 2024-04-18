@IsTest
private class BatchableProfilePhotoSetterTest {

  private static String profileName = 'Fonteva Customer Community Login';
  private static String communityName = 'LightningCommunityPortal';

  @IsTest
  public static void factoryMethods() {

    Assert.isNotNull(
      BatchableProfilePhotoSetter.getInstanceForUsers(new List<User>(), communityName)
    );

    Assert.isNotNull(
      BatchableProfilePhotoSetter.getInstanceForProfile(profileName, communityName)
    );
  }

  @IsTest
  public static void integrationTest() {


    User communityUser = TestUserFactory.createCommunityUser(profileName);

    ContentVersion contentVersion = new ContentVersion();
    contentVersion.Title = 'User Profile Photo';
    contentVersion.PathOnClient = 'Test';
    contentVersion.VersionData = Blob.valueof('New Bitmap Image.bmp');
    insert contentVersion;

    Id contentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersion.Id].ContentDocumentId;

    ContentDocumentLink contentDocumentLink = new ContentDocumentLink();
    contentDocumentLink.LinkedEntityId = communityUser.ContactId;
    contentDocumentLink.ContentDocumentId = contentDocumentId;

    insert contentDocumentLink;

    Test.startTest();

    BatchableProfilePhotoSetter batchJob = BatchableProfilePhotoSetter.getInstanceForUsers(new List<User>{communityUser}, communityName);
    Database.executeBatch(batchJob);

    Test.stopTest();

  }
}