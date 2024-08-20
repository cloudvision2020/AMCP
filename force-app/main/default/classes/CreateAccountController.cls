global without sharing class CreateAccountController {
    
    private static final String base64Chars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
    
    private static final String condAND = 'AND';
    private static final String condOR = 'OR';
    //private static final String RECAPTCHA_SECRET_KEY = 'https://www.google.com/recaptcha/api.js?render=reCAPTCHA_site_key'; // Replace with your secret key
       
    public CreateAccountController() {

    }

    @AuraEnabled
    public static string saveContact(Contact con, String username, String password){
         /*if (!verifyRecaptcha(recaptchaResponse)) {
            return 'reCAPTCHA verification failed';
        }*/
        try{

            Integer recConCount = [Select count() from Contact where Email=:con.email];
            Integer recUserCount = [Select count() from User where Email=:con.email];

            if(recConCount > 0 || recUserCount > 0){
                return label.UserCreated;
            }

            //con.OrderApi__Work_Email__c = con.email;
            //con.OrderApi__Preferred_Email_Type__c = 'Work';
            con.OwnerId = Label.ACC_Owner_Id;

            
            if (con.OrderApi__Preferred_Email_Type__c != null) {
                if (con.OrderApi__Preferred_Email_Type__c == 'Personal') {
                    con.OrderApi__Personal_Email__c = con.email;
                } else if (con.OrderApi__Preferred_Email_Type__c == 'Work') {
                    con.OrderApi__Work_Email__c = con.email ;
                } else if (con.OrderApi__Preferred_Email_Type__c == 'Other') {
                    con.OrderApi__Other_Email__c = con.email;
                } else if (con.OrderApi__Preferred_Email_Type__c == 'Assistant'){
                    con.OrderApi__Assistant_Email__c = con.email;
                }
             }

            if (con.OrderApi__Preferred_Phone_Type__c != null) {
                if (con.OrderApi__Preferred_Phone_Type__c == 'Home') {
                    con.HomePhone = con.OrderApi__Work_Phone__c;
                    con.OrderApi__Work_Phone__c = null;
                } else if (con.OrderApi__Preferred_Phone_Type__c == 'Work') {
                    con.OrderApi__Work_Phone__c = con.OrderApi__Work_Phone__c ;
                } else if (con.OrderApi__Preferred_Phone_Type__c == 'Mobile') {
                    con.MobilePhone = con.OrderApi__Work_Phone__c;
                    con.OrderApi__Work_Phone__c = null;
                }
             }

           
            if(String.isNotBlank(con.MailingCountry) && String.isNotBlank(con.MailingState)){
                String strMailingState = fetchStateAPI(con.MailingCountry, con.MailingState);
                con.MailingStateCode = strMailingState;
            }
            if(String.isNotBlank(con.MailingCountry)){
                String strMailingCountry = fetchCountryAPI(con.MailingCountry);
                con.MailingCountryCode = strMailingCountry;
            }
            
            /*if(String.isNotBlank(con.OtherCountry) && String.isNotBlank(con.OtherState)){
                String strOtherState = fetchStateAPI(con.OtherCountry, con.OtherState);
                con.OtherStateCode = strOtherState;
            }
            if(String.isNotBlank(con.OtherCountry)){
                String strOtherCountry = fetchCountryAPI(con.OtherCountry);
                con.OtherCountryCode = strOtherCountry;
            }
            */

            if(con.AccountId == null){
                List<Account> lstAccount = [Select Id from Account where Name =:Label.Company_not_provided];
                if(lstAccount.size() > 0){
                    con.AccountId = lstAccount[0].Id;
                }
            }
            Framework.Dispatcher.disableTriggerInContext.put('Contact', true);
            insert con;
            Framework.Dispatcher.disableTriggerInContext.put('Contact', false);
            
            //createUser.createUser(con.id, con.firstname, con.lastname, con.email, username, password, con.AccountId);
            
            User usr = FON_CreateAccountController.createUser(Label.FON_Registration_Profile,
                                      con.email, 
                                      con.LastName, 
                                      con.FirstName, con.Id);
                                      
            if(!Test.isRunningTest()){
                Site.validatePassword(usr, password, password);  
            }
            String userId = Site.createPortalUser(usr, con.AccountId , Password);
            
            //String startUrl = System.Label.FON_ProfileUrl;
            
            //ApexPages.PageReference login = Site.login(con.email, password,startUrl);
            //Aura.redirect(login);
            //system.debug('jmd login.getUrl()--'+login.getUrl());
            
            //return login.getUrl();
            return 'success';
        }
        catch(Exception e){
            System.debug('=======Exception=========='+e.getmessage());
            return e.getmessage();
        }
    }
    @AuraEnabled(cacheable=true) 
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
    
    private static List<PicklistEntryWrapper> wrapPicklistEntries(List<Schema.PicklistEntry> PLEs) {
        return (List<PicklistEntryWrapper>)
            JSON.deserialize(JSON.serialize(PLEs), List<PicklistEntryWrapper>.class);
    }
    
    public class PicklistEntryWrapper{
        public String active {get;set;}
        public String defaultValue {get;set;}
        public String label {get;set;}
        public String value {get;set;}
        public String validFor {get;set;}
        public PicklistEntryWrapper(){            
        }
        
    }
    
    public static String fetchCountryAPI(String strCountry){
        String contrfieldApiName = 'MailingCountryCode';
        String controllingField = contrfieldApiName.toLowerCase();
        Schema.sObjectType objType = Schema.Contact.getSObjectType();
        if (objType == null){
            return '';
        }
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        if (!objFieldMap.containsKey(controllingField)){
            return '';     
        }
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        for(Schema.PicklistEntry ple : contrEntries) {
            String label = ple.getLabel();
            if(label.equalsIgnoreCase(strCountry)){
                strCountry = ple.getValue();
            }
            
        }
        System.debug('=======strCountry=========='+strCountry);
        
        return strCountry;
        
    }
    
    public static String fetchStateAPI(String strCountry, String strState){
        String contrfieldApiName = 'MailingCountryCode';
        String depfieldApiName = 'MailingStateCode';
        String controllingField = contrfieldApiName.toLowerCase();
        String dependentField = depfieldApiName.toLowerCase();
        
        Schema.sObjectType objType = Schema.Contact.getSObjectType();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        if (!objFieldMap.containsKey(controllingField) || !objFieldMap.containsKey(dependentField)){
            return '';     
        }
        Schema.SObjectField ctrlField = objFieldMap.get(controllingField);
        Schema.SObjectField theField = objFieldMap.get(dependentField);
        List<Schema.PicklistEntry> contrEntries = ctrlField.getDescribe().getPicklistValues();
        List<PicklistEntryWrapper> depEntries = wrapPicklistEntries(theField.getDescribe().getPicklistValues());
        List<String> controllingValues = new List<String>();
        for(Schema.PicklistEntry ple : contrEntries) {
            controllingValues.add(ple.getLabel());
        }
        for (PicklistEntryWrapper plew : depEntries) {
            String validForBits = base64ToBits(plew.validFor);
            for (Integer i = 0; i < validForBits.length(); i++) {
                String bit = validForBits.mid(i, 1);
                if (bit == '1') {
                    if(strCountry.equalsIgnoreCase(controllingValues.get(i)) && strState.equalsIgnoreCase(plew.label)){
                        strState = plew.value;
                    }
                }
            }
        }
        System.debug('=======strState=========='+strState);
        
        return strState;
    }
    

    @TestVisible 
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
        Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }

    @AuraEnabled
    public static String login(String username, String password) {
        String result = null;
        try {
            system.debug('username = '+ username );
            system.debug('password = '+ password );
            String siteURL  = Label.Site_URL;
            ApexPages.PageReference pageRef = Site.login(username, password, siteURL);
            result = pageRef.getUrl();
        } catch (Exception ex) {
            result = ex.getMessage();
        }
        return result;

    }
    /*@AuraEnabled
    public static Boolean verifyRecaptcha(String recaptchaToken) {
        String secretKey = '6LfKhgwqAAAAAKhGedbG4J89TBoZNeV92LoIbrVm';
        String recaptchaURL = 'https://www.google.com/recaptcha/api/siteverify';
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(recaptchaURL + '?secret=' + secretKey + '&response=' + recaptchaToken);
        request.setMethod('POST');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            return (Boolean) result.get('success');
        }
        return false;
    }*/

    
    
    
}