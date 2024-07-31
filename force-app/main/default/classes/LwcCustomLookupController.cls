public without sharing class LwcCustomLookupController {
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName, String rtName) {
      	Id rtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
        string searchText = '\'%' + String.escapeSingleQuotes(searchKey) + '%\'';
        string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+ ' AND recordtypeid = \''+ rtId + '\'';
      
        query += ' limit 10';
        return Database.query(query);  
    }  

   @AuraEnabled
    public static Account createAccount(Account acnt,String rtName){
        try{
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
            System.debug(acnt);
            Account ac = new Account();
            ac.Name = acnt.Name;
            ac.RecordTypeId = accRecordTypeId;
            insert ac;
            return ac;
        }
        catch(exception e){
            return null;
        }
    }
}