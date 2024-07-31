public class UpdateMembershipAndContactFieldsBatch implements Database.Batchable<sObject>{
   
    private static String strContactEntity = 'Contact';
    private static String strAccountEntity = 'Account';
    private static Set<String> statusSet = new Set<String>{'Active','Expired'};

    private static Set<String> setType = new Set<String>{'Corporate Contact', 'Corporate Rep'};
       
        public  Database.querylocator start(Database.BatchableContext BC){
            //String strTestId = '0038c00003GdoIf';
            //String query = 'SELECT Id, AccountId, AMCP_Membership_Type__c, Activated_Date__c, Expiration_Date__c, Membership_Status__c, Secondary_AMCP_Membership_Type__c, Secondary_Expiration_Date__c, Secondary_Membership_Status__c FROM Contact WHERE Id = :strTestId';
            String query = 'SELECT Id, AccountId, AMCP_Membership_Type__c, Activated_Date__c, Expiration_Date__c, Membership_Status__c, Secondary_AMCP_Membership_Type__c, Secondary_Expiration_Date__c, Secondary_Membership_Status__c FROM Contact';
            return Database.getQueryLocator(query);
        }
   
    public void execute(Database.BatchableContext BC, List<Contact> scope) {
       
        Map<Id, List<OrderApi__Subscription__c>> subscriptionsXContactIdMap = new Map<Id, List<OrderApi__Subscription__c>>();
        Map<Id, Contact> contactToUpdateMap = new Map<Id, Contact>();
        Date dateToday = System.today();
        Map<Id, List<OrderApi__Subscription__c>> mapIdToLstContactSubs = new Map<Id, List<OrderApi__Subscription__c>>();
        Map<Id, List<OrderApi__Subscription__c>> mapIdToLstAccountSubs = new Map<Id, List<OrderApi__Subscription__c>>();
        
        for(Contact con: scope){
            List<OrderApi__Subscription__c> lSubscriptions = new List<OrderApi__Subscription__c>();
            subscriptionsXContactIdMap.put(con.Id,lSubscriptions);
            contactToUpdateMap.put(con.Id,con);
        }
       
        for(OrderApi__Subscription__c subs: [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c, 
                                                OrderApi__Grace_Period_End_Date__c, 
                                                OrderApi__Item__c, Item_Display_Name__c, OrderApi__Item__r.Name,
                                                OrderApi__Activated_Date__c, OrderApi__Status__c, OrderApi__Entity__c 
                                             FROM OrderApi__Subscription__c
                                             WHERE OrderApi__Contact__c IN: subscriptionsXContactIdMap.keySet()
                                             ORDER BY OrderApi__Paid_Through_Date__c DESC]){
             /*
             List<OrderApi__Subscription__c> lSubscriptions = subscriptionsXContactIdMap.get(subs.OrderApi__Contact__c);
             lSubscriptions.add(subs);
             subscriptionsXContactIdMap.put(subs.OrderApi__Contact__c,lSubscriptions);  
             */
             //AMCP-10 New logic
            if(strContactEntity.equalsIgnoreCase(subs.OrderApi__Entity__c)){
                if(!mapIdToLstContactSubs.containskey(subs.OrderApi__Contact__c)){
                    List<OrderApi__Subscription__c> lstSubscriptions = new List<OrderApi__Subscription__c>();
                    mapIdToLstContactSubs.put(subs.OrderApi__Contact__c,lstSubscriptions);
                }
                List<OrderApi__Subscription__c> lstSubscriptions = mapIdToLstContactSubs.get(subs.OrderApi__Contact__c);
                lstSubscriptions.add(subs);
                mapIdToLstContactSubs.put(subs.OrderApi__Contact__c,lstSubscriptions);
                
            }else if(strAccountEntity.equalsIgnoreCase(subs.OrderApi__Entity__c)){
                if(!mapIdToLstAccountSubs.containskey(subs.OrderApi__Contact__c)){
                    List<OrderApi__Subscription__c> lstSubscriptions = new List<OrderApi__Subscription__c>();
                    mapIdToLstAccountSubs.put(subs.OrderApi__Contact__c,lstSubscriptions);
                }
                List<OrderApi__Subscription__c> lstSubscriptions = mapIdToLstAccountSubs.get(subs.OrderApi__Contact__c);
                lstSubscriptions.add(subs);
                mapIdToLstAccountSubs.put(subs.OrderApi__Contact__c,lstSubscriptions);
            }
                                                                  
        }
         
        //AMCP-10 New logic
        Map<Id,Account> mapIdToObjAccount = new Map<Id,Account>();
        for(Id eachContactId : mapIdToLstContactSubs.keySet()){
            List<OrderApi__Subscription__c> lstSubscriptions = mapIdToLstContactSubs.get(eachContactId);
            if(!lstSubscriptions.isEmpty()){
                Contact objContact = contactToUpdateMap.get(eachContactId);
                syncMembershipType(objContact, mapIdToObjAccount, lstSubscriptions[0]);
            }else{
                Contact objContact = contactToUpdateMap.get(eachContactId);
                objContact.AMCP_Membership_Type__c = '';
                objContact.Activated_Date__c = null;
                objContact.Expiration_Date__c = null;
                objContact.Membership_Status__c = '';
                contactToUpdateMap.put(eachContactId, objContact);
            }
        }
        
        //AMCP-10 New logic
        for(Id eachContactId : mapIdToLstAccountSubs.keySet()){
            List<OrderApi__Subscription__c> lstSubscriptions = mapIdToLstAccountSubs.get(eachContactId);
            if(!lstSubscriptions.isEmpty()){
                Contact objContact = contactToUpdateMap.get(eachContactId);
                syncMembershipType(objContact, mapIdToObjAccount, lstSubscriptions[0]);
            }
            
        }
        
        
        /*
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
                       // con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name; //Using this method (syncMembershipType) to assing value
                       syncMembershipType(con, mapIdToObjAccount, lSubscriptions[0]);
                       //con.Activated_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                       //con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                       //con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                       contactToUpdateMap.put(contactId, con);                  
                   }
            }
            if(lSubscriptions.size() > 1){
                Integer pos = lSubscriptions.size()-1;
                if(lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c != 'Expired'){
                    Contact con = contactToUpdateMap.get(contactId);
                    //con.AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                    //con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                    //con.Expiration_Date__c = lSubscriptions[1].OrderApi__Paid_Through_Date__c;
                    //con.Membership_Status__c = lSubscriptions[1].OrderApi__Status__c;
                    //con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;  //Using this method (syncMembershipType) to assing value
                    syncMembershipType(con, mapIdToObjAccount, lSubscriptions[0]);
                    //con.Secondary_Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    //con.Secondary_Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                    
                    contactToUpdateMap.put(contactId, con);
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                   
                    Integer daysDifference = System.today().daysBetween(lSubscriptions[1].OrderApi__Paid_Through_Date__c);
                    Integer maxDaysForTwoYears = 365 * 2;
                   
                    if (daysDifference <= maxDaysForTwoYears) {
                        Contact con = contactToUpdateMap.get(contactId);
                        //con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name; //Using this method (syncMembershipType) to assing value
                        syncMembershipType(con, mapIdToObjAccount, lSubscriptions[0]);
                        //con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                        //con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                        //con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                        //con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                        contactToUpdateMap.put(contactId, con);
                    }
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Expired' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    Contact con = contactToUpdateMap.get(contactId);
                    //con.AMCP_Membership_Type__c = lSubscriptions[0].Item_Display_Name__c; //Using this method (syncMembershipType) to assing value
                    syncMembershipType(con, mapIdToObjAccount, lSubscriptions[0]);
                    //con.Activated_Date__c = lSubscriptions[pos].OrderApi__Activated_Date__c;
                    //con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    //con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                    //con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                    contactToUpdateMap.put(contactId, con);
                }
               
            }
           
           
        }
        */
        
        if (!contactToUpdateMap.isEmpty()) {
            update contactToUpdateMap.values();
        }
        if (!mapIdToObjAccount.isEmpty()) {
            update mapIdToObjAccount.values();
        }
       
    }
   
    public void finish(Database.BatchableContext BC){
       
    }
    
    public static void syncMembershipType(Contact objContact, Map<Id,Account> mapIdToObjAccount, OrderApi__Subscription__c objSubs) {
        String strItemName = '';
        
        String strAcademyCorpMem = 'Academy Corporate Member';
        if(objSubs.OrderApi__Item__c != null){
            strItemName = objSubs.OrderApi__Item__r.Name;
        }
        if(strContactEntity.equalsIgnoreCase(objSubs.OrderApi__Entity__c) && 
                        !strItemName.containsIgnoreCase(strAcademyCorpMem)){
            objContact.AMCP_Membership_Type__c = strItemName;
            objContact.Expiration_Date__c = objSubs.OrderApi__Paid_Through_Date__c;
            objContact.Membership_Status__c = objSubs.OrderApi__Status__c;
            objContact.Reinstatement_Date__c = objSubs.OrderApi__Activated_Date__c;
        }else if(strAccountEntity.equalsIgnoreCase(objSubs.OrderApi__Entity__c) && 
                        String.isNotBlank(objContact.AccountId) && 
                        strItemName.containsIgnoreCase(strAcademyCorpMem)){
            if(!mapIdToObjAccount.containsKey(objContact.AccountId)){
                Account objAccount = new Account(Id = objContact.AccountId);
                mapIdToObjAccount.put(objContact.AccountId, objAccount);
            }
            Account objAccount = mapIdToObjAccount.get(objContact.AccountId);
            objAccount.Corporate_Membership_Type__c = strItemName;
            mapIdToObjAccount.put(objContact.AccountId, objAccount);
        }
        
    }
   
}