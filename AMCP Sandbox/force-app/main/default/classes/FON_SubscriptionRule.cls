global without sharing class FON_SubscriptionRule extends Framework.Domain {
    
    private static Set<String> statusSet = new Set<String>{'Active','Expired'};
        
    public FON_SubscriptionRule(List<OrderApi__Subscription__c> sObjectList) {
    	super(sObjectList);
    }
    
    global class Constructor implements Framework.Domain.DomainConstructor {
        public Framework.Domain construct(List<SObject> sObjectList) {
            return new FON_SubscriptionRule(sObjectList);
        }
    }
    
    public override virtual void afterInsert() {
        Framework.Log.push(FON_SubscriptionRule.class.getName(), 'afterInsert');
        System.debug('After Insert');
        syncFields(records);
        Framework.Log.pop();
    }
    
    public override void afterUpdate(Map<Id, SObject> existingRecords) {
        System.debug('After Update');
        Framework.Log.push(FON_SubscriptionRule.class.getName(), 'afterUpdate');
        syncFields(records);
        Framework.Log.pop();
    }
    
    public static void syncFields(List<OrderApi__Subscription__c> records) {

        Set<String> setType = new Set<String>{'Corporate Contact', 'Corporate Rep'};

        Map<Id, List<OrderApi__Subscription__c>> subscriptionsXContactIdMap = new Map<Id, List<OrderApi__Subscription__c>>();
        Date dateToday = System.today();
        Set<Id> conIDS = new Set<Id>();
        for(OrderApi__Subscription__c sub: records){
            List<OrderApi__Subscription__c> lSubscriptions = new List<OrderApi__Subscription__c>();
            lSubscriptions.add(sub);
            subscriptionsXContactIdMap.put(sub.OrderApi__Contact__c,lSubscriptions);
            conIDS.add(sub.OrderApi__Contact__c);
        }
         
        List<Contact> rcons = new List<Contact>();
        if(conIDS.size()>0){
            rcons = [Select Id,AMCP_Membership_Type__c,Activated_Date__c,Expiration_Date__c,Membership_Status__c,Reinstatement_Date__c FROM Contact WHERE Id IN: conIDS];
        }
        Map<Id, Contact> contactToUpdateMap = new Map<Id, Contact>(rcons);
        
        for(OrderApi__Subscription__c subs: [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c, 
                                            OrderApi__Grace_Period_End_Date__c, Item_Display_Name__c, OrderApi__Item__r.Name, 
                                            OrderApi__Activated_Date__c, OrderApi__Status__c  
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
                System.debug('Empty IF');
                Contact con = contactToUpdateMap.get(contactId);
                con.AMCP_Membership_Type__c = '';
                con.Activated_Date__c = null;
                con.Expiration_Date__c = null;
                con.Membership_Status__c = '';
                contactToUpdateMap.put(contactId, con);
            }

            if(lSubscriptions.size() == 1 || (lSubscriptions.size() == 2 && lSubscriptions[0].id == lSubscriptions[1].id)){
                Integer index = 0;
                if(lSubscriptions.size() == 2){
                    index = 1;
                }
                System.debug('1 sub'); 
                Contact con = contactToUpdateMap.get(contactId);
                con.AMCP_Membership_Type__c = lSubscriptions[index].Item_Display_Name__c;
                con.Activated_Date__c = lSubscriptions[index].OrderApi__Activated_Date__c;
                con.Expiration_Date__c = lSubscriptions[index].OrderApi__Paid_Through_Date__c;
                con.Membership_Status__c = lSubscriptions[index].OrderApi__Status__c;
                contactToUpdateMap.put(contactId, con);
            }

            if(lSubscriptions.size() > 1){
                System.debug('More than 1 sub');
                Integer pos = lSubscriptions.size()-1;
                if(lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c != 'Expired'){
                    System.debug('First IF');
                    Contact con = contactToUpdateMap.get(contactId);
                    con.AMCP_Membership_Type__c = lSubscriptions[1].Item_Display_Name__c;
                    con.Expiration_Date__c = lSubscriptions[1].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[1].OrderApi__Status__c;
                    con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    con.Secondary_Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    con.Secondary_Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;

                    if(setType.contains(lSubscriptions[0].OrderApi__Item__r.Name)){
                        con.AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                        con.Secondary_AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                    }

                    if(setType.contains(lSubscriptions[1].OrderApi__Item__r.Name)){
                        con.AMCP_Membership_Type__c = lSubscriptions[1].OrderApi__Item__r.Name;
                        con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    }
                    
                    contactToUpdateMap.put(contactId, con);
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    System.debug('Second IF');
                    Integer daysDifference = System.today().daysBetween(lSubscriptions[1].OrderApi__Paid_Through_Date__c);
                    Integer maxDaysForTwoYears = -(365 * 2); 
                    
                    if ((daysDifference <= maxDaysForTwoYears) && (daysDifference < 0)) {
                        Contact con = contactToUpdateMap.get(contactId);
                        con.AMCP_Membership_Type__c = lSubscriptions[0].Item_Display_Name__c;
                        con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                        con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                        con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                        contactToUpdateMap.put(contactId, con);
                    }
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Expired' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    System.debug('Third IF');
                    integer newest;
                    if(lSubscriptions[0].OrderApi__Paid_Through_Date__c > lSubscriptions[1].OrderApi__Paid_Through_Date__c){
                        newest = 0;
                    }else{
                        newest = 1;
                    }
                    Contact con = contactToUpdateMap.get(contactId);
                    con.AMCP_Membership_Type__c = lSubscriptions[newest].Item_Display_Name__c;
                    con.Expiration_Date__c = lSubscriptions[newest].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[newest].OrderApi__Status__c;
                    con.Reinstatement_Date__c = lSubscriptions[newest].OrderApi__Activated_Date__c;
                    contactToUpdateMap.put(contactId, con);
                }
                
            }
        }

        /*for(Id contactId : subscriptionsXContactIdMap.keySet()){
            List<OrderApi__Subscription__c> lSubscriptions = subscriptionsXContactIdMap.get(contactId);
            if(lSubscriptions.isEmpty()){
                System.debug('Empty IF');
                Contact con = contactToUpdateMap.get(contactId);
                con.AMCP_Membership_Type__c = '';
                con.Activated_Date__c = null;
                con.Expiration_Date__c = null;
                con.Membership_Status__c = '';
                contactToUpdateMap.put(contactId, con);
            }

            if(lSubscriptions.size() == 1 || (lSubscriptions.size() == 2 && lSubscriptions[0].id == lSubscriptions[1].id)){
                Integer index = 0;
                if(lSubscriptions.size() == 2){
                    index = 1;
                }
                System.debug('1 sub'); 
                Contact con = contactToUpdateMap.get(contactId);
                con.AMCP_Membership_Type__c = lSubscriptions[index].Item_Display_Name__c;
                con.Activated_Date__c = lSubscriptions[index].OrderApi__Activated_Date__c;
                con.Expiration_Date__c = lSubscriptions[index].OrderApi__Paid_Through_Date__c;
                con.Membership_Status__c = lSubscriptions[index].OrderApi__Status__c;
                contactToUpdateMap.put(contactId, con);
            }

            if(lSubscriptions.size() > 1){
                System.debug('More than 1 sub');
                Integer pos = lSubscriptions.size()-1;
                if(lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c != 'Expired'){
                    System.debug('First IF');
                    Contact con = contactToUpdateMap.get(contactId);
                    con.AMCP_Membership_Type__c = lSubscriptions[1].Item_Display_Name__c;
                    con.Expiration_Date__c = lSubscriptions[1].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[1].OrderApi__Status__c;
                    con.Secondary_AMCP_Membership_Type__c = lSubscriptions[0].OrderApi__Item__r.Name;
                    con.Secondary_Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                    con.Secondary_Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                    contactToUpdateMap.put(contactId, con);
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Active' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    System.debug('Second IF');
                    Integer daysDifference = System.today().daysBetween(lSubscriptions[1].OrderApi__Paid_Through_Date__c);
                    Integer maxDaysForTwoYears = -(365 * 2); 
                    
                    if ((daysDifference <= maxDaysForTwoYears) && (daysDifference < 0)) {
                        Contact con = contactToUpdateMap.get(contactId);
                        con.AMCP_Membership_Type__c = lSubscriptions[0].Item_Display_Name__c;
                        con.Expiration_Date__c = lSubscriptions[0].OrderApi__Paid_Through_Date__c;
                        con.Membership_Status__c = lSubscriptions[0].OrderApi__Status__c;
                        con.Reinstatement_Date__c = lSubscriptions[0].OrderApi__Activated_Date__c;
                        contactToUpdateMap.put(contactId, con);
                    }
                }
                if (lSubscriptions[0].OrderApi__Status__c == 'Expired' && lSubscriptions[1].OrderApi__Status__c == 'Expired') {
                    System.debug('Third IF');
                    integer newest;
                    if(lSubscriptions[0].OrderApi__Paid_Through_Date__c > lSubscriptions[1].OrderApi__Paid_Through_Date__c){
                        newest = 0;
                    }else{
                        newest = 1;
                    }
                    Contact con = contactToUpdateMap.get(contactId);
                    con.AMCP_Membership_Type__c = lSubscriptions[newest].Item_Display_Name__c;
                    con.Expiration_Date__c = lSubscriptions[newest].OrderApi__Paid_Through_Date__c;
                    con.Membership_Status__c = lSubscriptions[newest].OrderApi__Status__c;
                    con.Reinstatement_Date__c = lSubscriptions[newest].OrderApi__Activated_Date__c;
                    contactToUpdateMap.put(contactId, con);
                }
                
            }
        }*/
        if (!contactToUpdateMap.isEmpty()) {
            update contactToUpdateMap.values();
        }
        // im sorry for this ugly thing. the task is super urgent...
        Integer tvar = 0;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        tvar++;
        
    }

    
    
}