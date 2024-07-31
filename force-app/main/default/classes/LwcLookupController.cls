global without sharing class LwcLookupController {  
    
    @AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKeyWord, String ObjectName, String strAccType, String strParentId) {  
      
        String searchKey = searchKeyWord + '%';
        List<sObject> returnList = new List<sObject>();
        
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5   
        String sQuery =  'select id, Name from ' +ObjectName + ' where';
        
        sQuery += ' Id != null';
        
        if(String.isNotBlank(searchKeyWord)){
            sQuery += ' AND Name LIKE: searchKey';
        }
        
        sQuery += ' order by createdDate DESC limit 10';
        
        List<sObject> lstOfRecords = Database.query(sQuery);
          
        
        return lstOfRecords;
    }  
}