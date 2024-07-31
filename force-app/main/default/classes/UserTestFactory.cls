@IsTest
public with sharing class UserTestFactory {
  public static User makeCommunityUser(String externalId) {
    
    Account acnt = new Account();
    acnt.Name = 'Make new Account';
    insert acnt;
    
    Contact userContact = new Contact();
    userContact.accountId = acnt.id;
    userContact.lastname = 'Test Con';
    userContact.Email = 'tests@email2024.com';
    insert userContact;
    
    Profile communityProfile = [Select Id, Name from Profile where Name = 'Fonteva Customer Community Login User'];
    
    return createUser(communityProfile, userContact);
  }

  public static User makeCommunityPlusUser() {
    Account acnt = new Account();
    acnt.Name = 'Test New Account';
    insert acnt;
    
    Contact userContact = new Contact();
    userContact.accountId = acnt.id;
    userContact.lastname = 'Test Con';
    userContact.Email = 'test11@email2024.com';
    insert userContact;
    
    Profile communityProfile = [Select Id, Name from Profile where Name = 'Fonteva Customer Community Plus Login User'];

    return createUser(communityProfile, userContact);
  }

  private static User createUser(Profile userProfile, Contact userContact) {
    String username =
      'testass' +
      Datetime.now().getTime() +
      Crypto.getRandomInteger() +
      '@testorg.com';
    User result = new User(
      Username = username,
      LastName = 'TestNew',
      Email = 'tests@domain.org',
      Alias = 'tests',
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      LanguageLocaleKey = 'en_US',
      ProfileId = userProfile.Id
    );
    if (userContact != null) {
      result.ContactId = userContact.Id;
    }
    System.runAs(new User(Id = UserInfo.getUserId())) {
      insert result;
    }
    return result;
  }
}