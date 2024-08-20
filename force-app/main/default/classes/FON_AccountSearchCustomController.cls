public without sharing class FON_AccountSearchCustomController {
    
    @AuraEnabled(cacheable=true)  
    public static List<RecordsData> fetchRecords(String searchString ) {
        List<RecordsData> recordsDataList = new List<RecordsData>();
        try {
            Set<Id> accountIds = new Set<Id>();
            String query = 'SELECT Id, Name,BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode, ';
            query+='ShippingCity,ShippingCountry,ShippingState,ShippingStreet,ShippingPostalCode ';
            query+='FROM Account WHERE Name LIKE ' + '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\' ';
            query+='ORDER BY Name';
            
            String cityQuery = 'SELECT Id, Name,BillingCity,BillingCountry,BillingState,BillingStreet,BillingPostalCode, ';
            cityQuery+='ShippingCity,ShippingCountry,ShippingState,ShippingStreet,ShippingPostalCode ';
            cityQuery+='FROM Account WHERE ShippingCity LIKE ' + '\'%' + String.escapeSingleQuotes(searchString.trim()) + '%\' ';
            cityQuery+='ORDER BY Name';
            
            for(SObject s : Database.query(query)){
                accountIds.add(String.valueOf(s.get('id')));
                RecordsData recordsData = new RecordsData();
                recordsData.value = String.valueOf(s.get('id'));
                recordsData.label = String.valueOf(s.get('Name'));
                recordsData.account = (Account) s;
                
                recordsData.billingAddress = 'Billing Address: '+ String.valueOf(s.get('BillingStreet'))+', '+
                    String.valueOf(s.get('BillingCity'))+', '+
                    String.valueOf(s.get('BillingCountry'))+', '+
                    String.valueOf(s.get('BillingState'))+', '+
                    String.valueOf(s.get('BillingPostalCode'));
                recordsData.shipingAddress = 'Shipping Address: '+ String.valueOf(s.get('ShippingStreet'))+', '+
                    String.valueOf(s.get('ShippingCity'))+', '+
                    String.valueOf(s.get('ShippingCountry'))+', '+
                    String.valueOf(s.get('ShippingState'))+', '+
                    String.valueOf(s.get('ShippingPostalCode'));
                recordsDataList.add(recordsData);
            } 
            
            for(SObject s : Database.query(cityQuery)) {
                
                if (accountIds.contains(String.valueOf(s.get('id')))) {
                    continue;
                }
                accountIds.add(String.valueOf(s.get('id')));
                RecordsData recordsData = new RecordsData();
                recordsData.value = String.valueOf(s.get('id'));
                recordsData.label = String.valueOf(s.get('Name'));
                recordsData.account = (Account) s;
                
                recordsData.billingAddress = 'Billing Address: '+ String.valueOf(s.get('BillingStreet'))+', '+
                    String.valueOf(s.get('BillingCity'))+', '+
                    String.valueOf(s.get('BillingCountry'))+', '+
                    String.valueOf(s.get('BillingState'))+', '+
                    String.valueOf(s.get('BillingPostalCode'));
                recordsData.shipingAddress = 'Shipping Address: '+ String.valueOf(s.get('ShippingStreet'))+', '+
                    String.valueOf(s.get('ShippingCity'))+', '+
                    String.valueOf(s.get('ShippingCountry'))+', '+
                    String.valueOf(s.get('ShippingState'))+', '+
                    String.valueOf(s.get('ShippingPostalCode'));
                recordsDataList.add(recordsData);
            } 
            
        } catch (Exception err) {
            system.debug('Get Line No : '+ err.getLineNumber() );
            if ( String.isNotBlank( err.getMessage() ) && err.getMessage().contains( 'error:' ) ) {
                throw new AuraHandledException(err.getMessage().split('error:')[1].split(':')[0] + '.');
            } else {
                throw new AuraHandledException(err.getMessage());
            }
        }
        return recordsDataList;
    }
    
    public class RecordsData{
        @AuraEnabled public String label          {get;set;}
        @AuraEnabled public String value          {get;set;}
        @AuraEnabled public String billingAddress {get;set;}
        @AuraEnabled public String shipingAddress {get;set;}
        @AuraEnabled public Account account       {get;set;}
        
    }
    
    @AuraEnabled
    public static Account createAccount(Account acc){
        acc.OwnerId = getOwnerId();
        insert acc;
        return acc;
    }
    
    public static Id getOwnerId() {
        OrderApi__Store__c store = [SELECT id, OrderApi__New_Contact_Account_Owner__c 
                                    FROM OrderApi__Store__c 
                                    ];
                                   
        return store.OrderApi__New_Contact_Account_Owner__c;
    }
    
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
}