public class UpdateMembershipAndContactFieldsBatch implements Database.Batchable<sObject>{
   
    private static Set<String> statusSet = new Set<String>{'Active','Expired'};

    private static Set<String> setType = new Set<String>{'Corporate Contact', 'Corporate Rep'};
       
        public  Database.querylocator start(Database.BatchableContext BC){
            String query = 'SELECT Id, AMCP_Membership_Type__c, Activated_Date__c, Expiration_Date__c, Membership_Status__c, Secondary_AMCP_Membership_Type__c, Secondary_Expiration_Date__c, Secondary_Membership_Status__c FROM Contact';
            return Database.getQueryLocator(query);
        }
   
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
       
        Map<Id, List<OrderApi__Subscription__c>> subscriptionsXContactIdMap = new Map<Id, List<OrderApi__Subscription__c>>();
        Map<Id, Contact> contactToUpdateMap = new Map<Id, Contact>();
        Date dateToday = System.today();
       
        for(Contact con: scope){
            List<OrderApi__Subscription__c> lSubscriptions = new List<OrderApi__Subscription__c>();
            subscriptionsXContactIdMap.put(con.Id,lSubscriptions);
            contactToUpdateMap.put(con.Id,con);
        }
       
        for(OrderApi__Subscription__c subs: [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c, OrderApi__Grace_Period_End_Date__c, OrderApi__Item__r.Name, OrderApi__Activated_Date__c, OrderApi__Status__c, Item_Display_Name__c  
                                             FROM OrderApi__Subscription__c
                                             WHERE OrderApi__Contact__c IN: subscriptionsXContactIdMap.keySet()
                                             ORDER BY OrderApi__Paid_Through_Date__c DESC]){
                                                 List<OrderApi__Subscription__c> lSubscriptions = subscriptionsXContactIdMap.get(subs.OrderApi__Contact__c);
                                                 lSubscriptions.add(subs);
                                                 subscriptionsXContactIdMap.put(subs.OrderApi__Contact__c,lSubscriptions);                                                        
                                             }
       
        for(Id contactId : subscriptionsXContactIdMap.keySet()){
            List<OrderApi__Subscription__c> lSubscriptions = subscriptionsXContactIdMap.get(contactId);
            if(lSubscriptions.isEmpty()){
                Contact con = contactToUpdateMap.get(contactId);
                con.AMCP_Membership_Type__c = '';
                con.Activated_Date__c = null;
                con.Expiration_Date__c = null;
                con.Membership_Status__c = '';
                contactToUpdateMap.put(contactId, con);
            }
            if(lSubscriptions.size() == 1){
                if(lSubscriptions[0].OrderApi__Paid_Through_Date__c < dateToday
                   && lSubscriptions[0].OrderApi__Grace_Period_End_Date__c >= dateToday
                   && statusSet.contains(lSubscriptions[0].OrderApi__Status__c)){
                       Contact con = contactToUpdateMap.get(contactId);
                       con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                       con.Activated_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                       con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                       con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                       contactToUpdateMap.put(contactId, con);                  
                   }
            }
            if(lSubscriptions.size() > 1){
                Integer pos = lSubscriptions.size()-1;
                if(lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c != 'Expired'){
                    Contact con = contactToUpdateMap.get(contactId);
                    //con.AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                    con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                    con.Expiration_Date__c = lSubscriptions[1].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[1].OrderApi__Status__c;
                    //con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    con.Secondary_Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    con.Secondary_Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;

                    if(setType.contains(lSubscriptions[0].OrderApi__Item__r.Name)){
                        con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                        con.Secondary_AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                    }else if(setType.contains(lSubscriptions[1].OrderApi__Item__r.Name)){
                        con.AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                        con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    }else{
                        con.AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                        con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    }
                    contactToUpdateMap.put(contactId, con);
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                   
                    Integer daysDifference = System.today().daysBetween(lSubscriptions[1].OrderApi__Paid_Through_Date__c);
                    Integer maxDaysForTwoYears = 365 * 2;
                   
                    if (daysDifference <= maxDaysForTwoYears) {
                        Contact con = contactToUpdateMap.get(contactId);
                        con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                        con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                        con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                        con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                        con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                        contactToUpdateMap.put(contactId, con);
                    }
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Expired' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    Contact con = contactToUpdateMap.get(contactId);
                    con.AMCP_Membership_Type__c = lSubscriptions[0].Item_Display_Name__c;
                    con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                    con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                    con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                    contactToUpdateMap.put(contactId, con);
                }
               
            }
           
           
        }
        if (!contactToUpdateMap.isEmpty()) {
            update contactToUpdateMap.values();
        }
       
    }
   
    public void finish(Database.BatchableContext BC){
       
    }
   
}