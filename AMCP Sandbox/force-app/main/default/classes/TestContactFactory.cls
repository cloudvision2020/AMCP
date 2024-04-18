@IsTest
public class TestContactFactory {

  public static Contact createContact(){
    Account account = TestAccountFactory.createAccount();
    Contact contact = buildContact('Tester', account);
    insert contact;
    return contact;
  }

  public static Contact buildContact(String lastName, Account account){
    Contact contact = new Contact();
    contact.LastName = 'McTestface';
    contact.FirstName = lastName;
    contact.AccountId = account.Id;
    return contact;
  }

}