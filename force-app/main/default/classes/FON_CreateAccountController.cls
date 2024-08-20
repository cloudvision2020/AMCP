public without sharing class FON_CreateAccountController {
    
       @AuraEnabled
        public static Account getaccountId() {
                Account acclist = [Select Id,Name from Account where Id = '0018c00002kysa0' limit 1];
       
            return acclist;
    }
    
    @AuraEnabled
    public static List<String> getSalutationPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.Salutation.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }
    
    @AuraEnabled
    public static List<String> getSuffixPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.DonorApi__Suffix__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getEmailPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.OrderApi__Preferred_Email_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getPhonePicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.OrderApi__Preferred_Phone_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getEmployerPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.Employer_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getPrimaryPositionPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.Primary_Position__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getaddressPicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.Address_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }

    @AuraEnabled
    public static List<String> getJobRolePicklistValues(){
        List<String> optionlist = new List<String>();  
        Schema.DescribeFieldResult fieldResult = Contact.Job_Role__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        optionlist.add('-- None --');
        for(Schema.PicklistEntry f : ple){
            optionlist.add(f.getLabel());
        }
        return optionlist;
    }
    
    @AuraEnabled
    public static String registerUser(Contact oContact, String password, string confirmPassword,String accId, String startUrl, String username, String retURL) {
        Savepoint sp = Database.setSavepoint();
        try{
            boolean hasUser = false;
            system.debug('jmd accId--'+accId);
            oContact.AccountId = accId;
            
            Contact con = checkEmailExists(oContact.Email, oContact.FirstName, oContact.LastName);
            // commented by Abhishek 
            //if(con != null){
                User u = checkUserExists(oContact.Email);
                if(u != null){
                    if(u.IsActive){
                        hasUser = true;
                    }
                    else{
                        u.IsActive = true;
                        update u;
                        return Label.FON_DuplicateEmailErrorMessage;
                    }
                }
           // }
            
            if((con == null || con!=null) && !hasUser) {
                if(con == null){
                    insert oContact;
                }
                else if(con!=null){
                    oContact.Id = con.Id;
                    update oContact; 
                }
                Contact oCon = [SELECT Id, email,
                                AccountId, FirstName, LastName FROM Contact WHERE Id =: oContact.Id];
                system.debug('oContact'+oContact);
                User usr = createUser(Label.FON_Registration_Profile,
                                      oCon.email, 
                                      oCon.LastName, 
                                      oCon.FirstName, oCon.Id, username);
                if(!Test.isRunningTest()){
                    Site.validatePassword(usr, password, confirmPassword);  
                }
                String userId = Site.createPortalUser(usr, oCon.AccountId , Password);
                system.debug('jmd startUrl--'+startUrl);
                if(String.isBlank(startUrl)){
                    startUrl = System.Label.FON_ProfileUrl;
                }
                system.debug('jmd startUrl--11'+startUrl);
                ApexPages.PageReference login = Site.login(oCon.email, password,startUrl);
                if(retURL != null && retURL != ''){
                    login.getParameters().put('retURL',retURL);
                }
               
                Aura.redirect(login);

                system.debug('retURL 11 '+retURL);
                /*if(retURL != null){
                    String rsetURL = login.getUrl();
                    List<String> lsrsetURL = rsetURL.split('&retURL=');
                    rsetURL = lsrsetURL[0] + '&retURL=' + retURL;
                    
                    List<String> sid = lsrsetURL[1].split('&sid=');
                    
                    String finalURl = rsetURL + '&sid=' + sid[1];

                    system.debug('rsetURL 111 '+finalURl);
                    return finalURl;
                    //return 'Success';
                }
                */

                system.debug('jmd login.getUrl()--'+retURL);
                return login.getUrl();
                
            }
            else {
                throw new CustomException(Label.FON_DuplicateEmailErrorMessage);
            }
       }catch(SecurityException se){
            Database.rollback(sp);
            // throw new AuraHandledException(Label.FON_SignUp_passowrd_policy);
            throw new AuraHandledException(se.getMessage());
        }
        catch(CustomException ce){
            Database.rollback(sp);
            throw new AuraHandledException(Label.FON_DuplicateEmailErrorMessage);
            
        }
        catch(Exception ex){
            Database.rollback(sp);
            throw new AuraHandledException(ex.getLineNumber()+'=='+ex.getMessage());
        }
    }
    
    public static Contact checkEmailExists(String email, String fName, String lName) {
        system.debug('email===  '+ email);
        List<Contact> lContact = [SELECT Id FROM Contact 
                                  WHERE 
                                  (OrderApi__Work_Email__c =: email OR
                                   OrderApi__Personal_Email__c =: email OR
                                   OrderApi__Other_Email__c =: email OR
                                   Email =: email OR
                                   OrderApi__Preferred_Email__c =: email)
                                  //AND FirstName = :fName
                                  //AND LastName = :lName
                                 ];
        if(!lContact.isEmpty())
            return lContact[0];
        else
            return null;
    }
    
    //public static User checkUserExists(String contactId, String email) {
    public static User checkUserExists(String email) {
        // Ahishek: Salesforce will not allow to create users wuth duplicate username, no need to check contactId
        //List<User> u = [SELECT IsActive FROM User WHERE username =:email AND ContactId =: contactId];
        List<User> u = [SELECT IsActive FROM User WHERE username =:email];
        if(u.size()>0){
            return u[0];
        }
        return null;
    }
    
    public class CustomException extends Exception {}
    
    @AuraEnabled
    public static Map<String, List<String>> getDependentMap(sObject objDetail, string contrfieldApiName,string depfieldApiName) {
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        Map<String,List<String>> objResults = new Map<String,List<String>>();
        
        Schema.sObjectType objType = objDetail.getSObjectType();
        if (objType==null){
            return objResults;
        }
        
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return objResults;     
        }
        
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        
        for (Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            objResults.put(label, new List<String>());
            controllingValues.add(label);
        }
        
        for (PicklistEntryWrapper plew : depEntries) {
            String label = plew.label;
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    objResults.get(controllingValues.get(i)).add(label);
                }
            }
        }
        return objResults;
    }
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';    
    
    public static String decimalToBinary(Integer val) {
        String bits = '';
        while (val > 0) {
            Integer remainder = Math.mod(val, 2);
            val = Integer.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        return bits;
    }    
    
    public static String base64ToBits(String validFor) {
        if (String.isEmpty(validFor)) return '';
        
        String validForBits = '';
        
        for (Integer i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            Integer val = base64Chars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
        
        return validForBits;
    }  
    
    public class PicklistEntryWrapper {
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper() {  
            
        }
    }    
    
    public Static user createUser(String profileName, String email, String LastName, String FirstName, String ContactId, String username){
        User usr;
        try{
            Profile profile = [SELECT id FROM Profile WHERE id =: profileName];
            Date dt = System.today(); //current date
            Integer day = dt.Day(); //get day
            Integer month = dt.Month(); //get month
            Integer year = dt.Year(); //get year
            system.debug('profile'+profile);
            if(profile != null){
                usr = new User();
                usr.username = username ;
                usr.email = email;
                usr.TimeZoneSidKey = 'America/New_York';
                usr.LocaleSidKey='en_us';
                usr.EmailEncodingKey='UTF-8';        
                usr.LanguageLocaleKey='en_us'; 
                usr.LastName = LastName;
                usr.FirstName = FirstName;
                usr.Alias = (FirstName.length() > 7) ? FirstName.substring(0, 7) : FirstName; 
                usr.ContactId = ContactId;
                usr.isActive = true;
                usr.CommunityNickname = FirstName + LastName + day + month + year;
                usr.ProfileId = profile.id; 
                
            }else{
                return null;
            }
            
        }catch(exception e){
            return null;
        }
        return usr;
    }
    
}