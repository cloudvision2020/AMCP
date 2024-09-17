public class UpdateMembershipAndContactFieldsBatch implements Database.Batchable<sObject>{
   
    public static String corporateItemName = 'Academy Corporate Member';

    public  Database.querylocator start(Database.BatchableContext BC){
        //  String strTestId = '0038c00003GdkpIAAR';
        //  String query = 'SELECT Id,AccountId FROM Contact WHERE Id = :strTestId';
        String query = 'SELECT Id,Activated_Date__c, AccountId FROM Contact';
        return Database.getQueryLocator(query);
    }
   
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
        
        Map<Id, List<OrderApi__Subscription__c>> contactIdVsSubscriptionsMap = new Map<Id, List<OrderApi__Subscription__c>>();
        Map<Id,Contact> contactMap = new Map<Id,Contact>();
        for(Contact con: scope){
            contactIdVsSubscriptionsMap.put(con.Id,new List<OrderApi__Subscription__c>());
            contactMap.put(con.Id,con);
        }
        List<OrderApi__Subscription__c> subscriptions = new List<OrderApi__Subscription__c>();
        subscriptions = [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c,OrderApi__Account__c,
                                                OrderApi__Grace_Period_End_Date__c, 
                                                OrderApi__Item__c, Item_Display_Name__c, OrderApi__Item__r.Name,
                                                OrderApi__Activated_Date__c, OrderApi__Status__c, OrderApi__Entity__c 
                                             FROM OrderApi__Subscription__c
                                             WHERE OrderApi__Contact__c IN: contactIdVsSubscriptionsMap.keySet()];
        
        for(OrderApi__Subscription__c sub : subscriptions){
            // ENTTY -- CONTACT
            if(sub.OrderApi__Entity__c == 'Contact' && !sub.Item_Display_Name__c.containsIgnoreCase(corporateItemName)){
                contactIdVsSubscriptionsMap.get(sub.OrderApi__Contact__c).add(sub);
            }
        }

        List<Contact> contactsToUpdate = new List<Contact>();
    
        for(Id contactId : contactIdVsSubscriptionsMap.keySet()){
            Date activateDate;
            Date expirationDate;
            Date reinstatementDate;
            String membershipType;
            String membershipStatus;

            for(OrderApi__Subscription__c sub : contactIdVsSubscriptionsMap.get(contactId)){
                if(activateDate == null || activateDate > sub.OrderApi__Activated_Date__c){
                    activateDate = sub.OrderApi__Activated_Date__c;
                }
                if(expirationDate == null || activateDate < sub.OrderApi__Paid_Through_Date__c){
                    expirationDate = sub.OrderApi__Paid_Through_Date__c;
                }
                if(reinstatementDate == null || reinstatementDate < sub.OrderApi__Activated_Date__c){
                    reinstatementDate = sub.OrderApi__Activated_Date__c != activateDate ? sub.OrderApi__Activated_Date__c : null;
                    membershipType = sub.Item_Display_Name__c;
                    membershipStatus = sub.OrderApi__Status__c;
                }
            }
            Contact contact = new Contact();
            contact.Id= contactId;
            contact.Activated_Date__c= contactMap.get(contactId).Activated_Date__c == null ? activateDate : contactMap.get(contactId).Activated_Date__c;
            contact.Expiration_Date__c= expirationDate; 
            contact.Reinstatement_Date__c= reinstatementDate;
            contact.AMCP_Membership_Type__c= membershipType;
            contact.Membership_Status__c= membershipStatus;
            contactsToUpdate.add(contact);
        }
        Database.update(contactsToUpdate,false);
               
    }
   
    public void finish(Database.BatchableContext BC){
       System.debug('UpdateMembershipAndContactFieldsBatch FINISHED');
    }
    
   
}