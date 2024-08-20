public  with sharing class Fon_ContactTriggerHandler {
    
     public static void handlebeforeInsert(List<Contact> newContacts) {
        checkDuplicateEmails(newContacts);
    }

    public static void handlebeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldMap) {
        checkDuplicateEmails(newContacts);
    }
    
    private static void checkDuplicateEmails(List<Contact> contacts) {
        Set<String> emailSet = new Set<String>();
        Set<String> dupEmailCheck = new Set<String>();
        // Collect all email addresses from the specified fields
        for (Contact con : contacts) {
            if (con.Email != null) {
                emailSet.add(con.Email.toLowerCase());
            }
        }
        List<Contact> existingContactRecords = [SELECT Id, 
                                                        Email, 
                                                        OrderApi__Personal_Email__c, 
                                                        OrderApi__Work_Email__c, 
                                                        OrderApi__Other_Email__c, 
                                                        OrderApi__Assistant_Email__c
                                               FROM Contact
                                               WHERE Email =:emailSet
                                               OR OrderApi__Personal_Email__c =:emailSet
                                               OR OrderApi__Work_Email__c =:emailSet
                                               OR OrderApi__Other_Email__c =:emailSet
                                               OR OrderApi__Assistant_Email__c =:emailSet];
        if(existingContactRecords.size() > 0){
            for (Contact con : existingContactRecords) {
                if(con.Email != null){
                	dupEmailCheck.add(con.Email);
                }
                if(con.OrderApi__Personal_Email__c != null){
                	dupEmailCheck.add(con.OrderApi__Personal_Email__c);
                }
                if(con.OrderApi__Work_Email__c != null){
                	dupEmailCheck.add(con.OrderApi__Work_Email__c);
                }
                if(con.OrderApi__Other_Email__c != null){
                	dupEmailCheck.add(con.OrderApi__Other_Email__c);
                }
                if(con.OrderApi__Assistant_Email__c != null){
                	dupEmailCheck.add(con.OrderApi__Assistant_Email__c);
                }
       			
        	}
        }
        for (Contact con : contacts) {
            if(dupEmailCheck.contains(con.Email)){
                con.addError('Duplicate Email Address Found!');
            }
        }
         
    }   

}