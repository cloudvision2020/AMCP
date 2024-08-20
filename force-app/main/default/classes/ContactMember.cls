public class ContactMember{
   
    

    public static void updateContact(String  contactIdd) {
        List<Contact> scope = [Select Id FROM Contact WHERE Id=:contactIdd];
        
        Map<Id, List<OrderApi__Subscription__c>> contactIdVsSubscriptionsMap = new Map<Id, List<OrderApi__Subscription__c>>();
        for(Contact con: scope){
            contactIdVsSubscriptionsMap.put(con.Id,new List<OrderApi__Subscription__c>());
        }
        List<OrderApi__Subscription__c> subscriptions = new List<OrderApi__Subscription__c>();
        subscriptions = [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c, 
                                                OrderApi__Grace_Period_End_Date__c, 
                                                OrderApi__Item__c, Item_Display_Name__c, OrderApi__Item__r.Name,
                                                OrderApi__Activated_Date__c, OrderApi__Status__c, OrderApi__Entity__c 
                                             FROM OrderApi__Subscription__c
                                             WHERE OrderApi__Contact__c IN: contactIdVsSubscriptionsMap.keySet()];
        for(OrderApi__Subscription__c sub : subscriptions){
            contactIdVsSubscriptionsMap.get(sub.OrderApi__Contact__c).add(sub);
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
                    reinstatementDate = sub.OrderApi__Activated_Date__c;
                    membershipType = sub.Item_Display_Name__c;
                    membershipStatus = sub.OrderApi__Status__c;
                }
                
            
            }
            Contact contact = new Contact();
            contact.Id= contactId;
            contact.Activated_Date__c= activateDate;
            contact.Expiration_Date__c= expirationDate;
            contact.Reinstatement_Date__c= reinstatementDate;
            contact.AMCP_Membership_Type__c= membershipType;
            contact.Membership_Status__c= membershipStatus;
            contactsToUpdate.add(contact);
        }

        update contactsToUpdate;
               
    }
   
  
   
}