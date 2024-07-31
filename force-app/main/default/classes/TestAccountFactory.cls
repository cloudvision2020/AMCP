@IsTest
public class TestAccountFactory {

  public static Account createAccount(){
    Account account = buildAccount('Test');
    insert account;
    return account;
  }

  public static Account buildAccount(String name){
    Account account = new Account();
    account.Name = name;
    return account;
  }

}