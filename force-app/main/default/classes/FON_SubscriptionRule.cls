global without sharing class FON_SubscriptionRule extends Framework.Domain {
    
    private static String strContactEntity = 'Contact';
    private static String strAccountEntity = 'Account';
        
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


        Map<Id, List<OrderApi__Subscription__c>> subscriptionsXContactIdMap = new Map<Id, List<OrderApi__Subscription__c>>();
        Date dateToday = System.today();
        Set<Id> conIDS = new Set<Id>();
        Set<Id> setIds = new Set<Id>();
        for(OrderApi__Subscription__c sub: records){
            List<OrderApi__Subscription__c> lSubscriptions = new List<OrderApi__Subscription__c>();
            lSubscriptions.add(sub);
            conIDS.add(sub.OrderApi__Contact__c);
        }

        List<Contact> rcons = new List<Contact>();
        if(conIDS.size()>0){
            rcons = [Select Id,AccountId,AMCP_Membership_Type__c,Activated_Date__c,
                            Expiration_Date__c,Membership_Status__c,Reinstatement_Date__c 
                     FROM Contact 
                     WHERE Id IN: conIDS];
        }
        Map<Id, Contact> contactToUpdateMap = new Map<Id, Contact>(rcons);
        Map<Id, List<OrderApi__Subscription__c>> mapIdToLstContactSubs = new Map<Id, List<OrderApi__Subscription__c>>();
        Map<Id, List<OrderApi__Subscription__c>> mapIdToLstAccountSubs = new Map<Id, List<OrderApi__Subscription__c>>();
        for(OrderApi__Subscription__c subs: [SELECT Id, OrderApi__Contact__c, OrderApi__Paid_Through_Date__c, OrderApi__Term_Start_Date__c,
                                                OrderApi__Grace_Period_End_Date__c, OrderApi__Contact__r.Activated_Date__c,
                                                OrderApi__Item__c, Item_Display_Name__c, OrderApi__Item__r.Name,OrderApi__Last_Renewed_Date__c, 
                                                OrderApi__Activated_Date__c, OrderApi__Status__c, OrderApi__Entity__c   
                                             FROM OrderApi__Subscription__c 
                                             WHERE OrderApi__Contact__c IN: conIDS 
                                             ORDER BY OrderApi__Paid_Through_Date__c DESC]){
            
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
        
        if (!contactToUpdateMap.isEmpty()) {
            update contactToUpdateMap.values();
        }
        if (!mapIdToObjAccount.isEmpty()) {
            update mapIdToObjAccount.values();
        }
        
    }
    
    public static void syncMembershipType(Contact objContact, Map<Id,Account> mapIdToObjAccount, OrderApi__Subscription__c objSubs) {
        String strItemName = '';
        String strAcademyCorpMem = 'Academy Corporate Member';
        if(objSubs.OrderApi__Item__c != null){
            strItemName = objSubs.OrderApi__Item__r.Name;
        }
        if(strContactEntity.equalsIgnoreCase(objSubs.OrderApi__Entity__c) && 
                        !strItemName.containsIgnoreCase(strAcademyCorpMem)){
            objContact.Activated_Date__c = objSubs.OrderApi__Contact__r.Activated_Date__c != null ?  objSubs.OrderApi__Contact__r.Activated_Date__c : objSubs.OrderApi__Activated_Date__c;
            objContact.Membership_Status__c = objSubs.OrderApi__Status__c;
            objContact.AMCP_Membership_Type__c = strItemName;
            objContact.Expiration_Date__c = objSubs.OrderApi__Paid_Through_Date__c;
            objContact.Membership_Status__c = objSubs.OrderApi__Status__c;
            if(objSubs.OrderApi__Term_Start_Date__c !=null && objSubs.OrderApi__Contact__r.Activated_Date__c != null && objSubs.OrderApi__Contact__r.Activated_Date__c < objSubs.OrderApi__Term_Start_Date__c){
                objContact.Reinstatement_Date__c = objSubs.OrderApi__Term_Start_Date__c;
            }
            if(objContact.Membership_Status__c == 'Expired'){
                objContact.Reinstatement_Date__c = null;
            }
           

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