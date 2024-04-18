@IsTest
public class TestUserFactory {

  public static User createCommunityUser(String profileName){
    Contact contact = TestContactFactory.createContact();

    User communityUser = buildCommunityUser(contact, profileName);
    insert communityUser;
    return communityUser;
  }

  public static User buildCommunityUser(Contact contact, String profileName){
    Profile communityProfile = fetchProfile(profileName);
    String username =
      'test' +
        Datetime.now().getTime() +
        Crypto.getRandomInteger() +
        '@testorg.com';
    User communityUser = new User();
    communityUser.Username = username;
    communityUser.LastName = contact.LastName;
    communityUser.Email = 'test@domain.org';
    communityUser.Alias = 'test';
    communityUser.TimeZoneSidKey = 'America/Los_Angeles';
    communityUser.LocaleSidKey = 'en_US';
    communityUser.EmailEncodingKey = 'UTF-8';
    communityUser.LanguageLocaleKey = 'en_US';
    communityUser.ContactId = contact.Id;
    communityUser.ProfileId = communityProfile.Id;
    return communityUser;
  }

  private static Profile fetchProfile(String profileName) {
    Profile communityProfile = [
      SELECT Id
      FROM Profile
      WHERE Name = :profileName
    ];
    return communityProfile;
  }
}