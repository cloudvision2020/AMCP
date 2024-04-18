public with sharing class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {
    String searchKeyword = '%' + searchTerm + '%';
    System.debug('Search keyword: ' + searchKeyword); 
    List<Account> accounts = [SELECT Id, Name, Industry, Type FROM Account WHERE Name LIKE :searchKeyword LIMIT 10];
    System.debug('Retrieved accounts: ' + accounts); 
    return accounts;
    }
}