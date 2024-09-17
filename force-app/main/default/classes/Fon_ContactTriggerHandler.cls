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
        Set<Id> conIds = new Set<Id>();
        // Collect all email addresses from the specified fields
        for (Contact con : contacts) {
            if(con.Email != null){
                emailSet.add(con.Email);
            }
            if(con.OrderApi__Personal_Email__c != null){
                emailSet.add(con.OrderApi__Personal_Email__c);
            }
            if(con.OrderApi__Work_Email__c != null){
                emailSet.add(con.OrderApi__Work_Email__c);
            }
            if(con.OrderApi__Other_Email__c != null){
                emailSet.add(con.OrderApi__Other_Email__c);
            }
            if(con.OrderApi__Assistant_Email__c != null){
                emailSet.add(con.OrderApi__Assistant_Email__c);
            }
            conIds.add(con.Id);
        }

        List<Contact> existingContactRecords = [SELECT Id, 
                                                        Email, 
                                                        OrderApi__Personal_Email__c, 
                                                        OrderApi__Work_Email__c, 
                                                        OrderApi__Other_Email__c, 
                                                        OrderApi__Assistant_Email__c
                                               FROM Contact
                                               WHERE (Email =:emailSet
                                               OR OrderApi__Personal_Email__c =:emailSet
                                               OR OrderApi__Work_Email__c =:emailSet
                                               OR OrderApi__Other_Email__c =:emailSet
                                               OR OrderApi__Assistant_Email__c =:emailSet) and Id Not IN: conIds];
       
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
            for (Contact con : contacts) {
                if(dupEmailCheck.contains(con.Email) ||
                    dupEmailCheck.contains(con.OrderApi__Personal_Email__c) ||
                    dupEmailCheck.contains(con.OrderApi__Work_Email__c) || 
                    dupEmailCheck.contains(con.OrderApi__Other_Email__c) || 
                    dupEmailCheck.contains(con.OrderApi__Assistant_Email__c)){
                    con.addError(Label.Duplicate_Email);
                }
            }
        }
        
         
    }   

}