public without sharing class SearchCommunityUserController {
    public SearchCommunityUserController() {

    }
    @AuraEnabled(cacheable=true)
    public static List<Contact> fetchContactWithEmail(String email){
        List<Contact> conObjList = new List<Contact> ();
       if(email!=null) {
            conObjList = [Select 
                          id, Name, Email, MailingState, Account.Name, 
                          (Select id, name, Username, LastLoginDate from Users ) 
                          from Contact 
                          where Email=: email
                          ORDER BY LastName ASC];
        }
        return conObjList;        
    } 

    @AuraEnabled(cacheable=true) //get Contact ContactType Picklist Values
    public static Map<String, String> getRoles(){
        
        String objectName = 'Contact';
        String fieldName ='Account_Creation_Role__c';
        Map<String, String> options = new Map<String, String>();  
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.put(pickListVal.getValue(),pickListVal.getLabel());
        }   
        return options;
    }
    
    @AuraEnabled(cacheable=true) //get Contact ContactType Picklist Values
    public static Map<String, String> getESDValues(){
        
        String objectName = 'Contact';
        String fieldName ='ESD__c';
        Map<String, String> options = new Map<String, String>();  
        Schema.SObjectType s = Schema.getGlobalDescribe().get(objectName) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String,Schema.SObjectField> fields = r.fields.getMap() ;
        Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            options.put(pickListVal.getValue(),pickListVal.getLabel());
        }   
        return options;
    }

    @Auraenabled
    public static string activateUser(Id contactId){  
        try{
            List<Contact> cont = [Select Id, FirstName, LastName, Email from Contact where id=:contactId Limit 1];
            if(cont.size()>0){  
                createUser(contactId, cont[0].FirstName, cont[0].LastName, cont[0].email);
            } 
            return 'success';
        }
        catch(exception e){
            return e.getmessage();
        }
    }

    @AuraEnabled
    public static string saveContact(Contact con){
        try{
            insert con;
            createUser(con.id, con.firstname, con.lastname, con.email);
            return 'success';
        }
        catch(exception e){
            return e.getmessage();
        }
    }

    @future
    public static void createUser(String contId, String firstname, String lastname, String EmailAddress) {
        //Profile profileList = [SELECT Id FROM Profile WHERE Name = 'Fonteva Customer Community Login User' LIMIT 1];
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
        
        User newUser = new User();
        newUser.contactid = contId;
        newUser.alias =  (firstname!=Null?firstname.substring(1,1):'')+ (lastname.length()>6?lastname.substring(1,6):lastname);
        newUser.username = EmailAddress; 
        newUser.firstname = firstname;
        newUser.lastname = lastname;
        //newUser.profileid = Label.Profile_Id;
        newUser.email = EmailAddress; 
        newUser.emailencodingkey = 'ISO-8859-1';             
        newUser.languagelocalekey='en_US'; 
        newUser.localesidkey = 'en_US';
        newUser.timezonesidkey =  'America/Denver';
        newUser.CommunityNickname = (EmailAddress + Math.random()).LEFT(40);    
        newUser.setOptions(dmo);  
        insert newUser;
    }
    
    @AuraEnabled
    public static Account getAccountRecord(Id accId){
        Account ac = [select Id,Name from Account where id =: accId];
        return ac;
    }
    
    @AuraEnabled
    public static Account createOrganization(Account acc, string rtName){ 
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(rtName).getRecordTypeId();
        Account ac = new Account();
        ac.RecordTypeId = accRecordTypeId;
        ac.Name = acc.name;
        ac.Phone = acc.phone;
        ac.OrderApi__Account_Email__c = acc.OrderApi__Account_Email__c;
        insert ac;
        return ac;
    }
}