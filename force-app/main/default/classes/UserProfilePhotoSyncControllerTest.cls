/**
 * Created by ashwinireddy on 5/1/23.
 */

@IsTest
public with sharing class UserProfilePhotoSyncControllerTest {
  @IsTest
  static void testSyncUserProfilePhoto() {
    User communityUser = makeCommunityUser();
    Site community = getCommunitySite();

    Test.startTest();
    System.runAs(communityUser) {
      UserProfilePhotoSyncController.syncUserProfilePhoto(
        communityUser.Id,
        community.Id
      );
    }
    Test.stopTest();

    Contact userContact = [
      SELECT Directory_Photo__c
      FROM Contact
      WHERE Id = :communityUser.ContactId
    ];
    System.assertEquals('http://test.pic', userContact.Directory_Photo__c);
  }

  public static Account makeAccount() {
    Account result = new Account(Name = 'Test');
    insert result;
    return result;
  }

  private static Contact makeContact() {
    Account contactAccount = makeAccount();
    Contact result = new Contact(
      LastName = 'Test',
      AccountId = contactAccount.Id
    );
    insert result;
    return result;
  }

  private static User makeCommunityUser() {
    Contact userContact = makeContact();
    Profile communityProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = 'Fonteva Customer Community Login'
    ];
    String username =
      'test' +
        Datetime.now().getTime() +
        Crypto.getRandomInteger() +
        '@testorg.com';
    User result = new User(
      Username = username,
      LastName = userContact.LastName,
      Email = 'test@domain.org',
      Alias = 'test',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ContactId = userContact.Id,
      ProfileId = communityProfile.Id
    );
    System.runAs(new User(Id = UserInfo.getUserId())) {
      insert result;
    }
    return result;
  }

  private static Site getCommunitySite() {
    return [SELECT Id FROM Site WHERE Name = 'LightningCommunityPortal'];
  }
}