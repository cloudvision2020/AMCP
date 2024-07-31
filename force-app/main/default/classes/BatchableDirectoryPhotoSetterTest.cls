@IsTest
private class BatchableDirectoryPhotoSetterTest {

  private static String profileName = 'Fonteva Customer Community Login';
  private static String communityName = 'LightningCommunityPortal';

  @IsTest
  public static void factoryMethods() {

    Assert.isNotNull(
      BatchableDirectoryPhotoSetter.getInstanceForUsers(new List<User>(), communityName)
    );

    Assert.isNotNull(
      BatchableDirectoryPhotoSetter.getInstanceForProfile(profileName, communityName)
    );

  }
  @IsTest
  public static void setDirectoryPhotoField() {

    User communityUser = TestUserFactory.createCommunityUser(profileName);

    Test.startTest();

    BatchableDirectoryPhotoSetter batchJob = BatchableDirectoryPhotoSetter.getInstanceForUsers(new List<User>{communityUser}, communityName);

    Database.executeBatch(batchJob);

    Test.stopTest();

    Contact contact = [SELECT Id, Directory_Photo__c FROM Contact];
    System.debug('Contact is '+contact);

    Assert.areEqual('http://test.pic', contact.Directory_Photo__c);

  }
}