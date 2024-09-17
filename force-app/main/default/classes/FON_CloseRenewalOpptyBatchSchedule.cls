public class FON_CloseRenewalOpptyBatchSchedule implements Database.Batchable<sObject>, Schedulable {
    
    
    public List<SObject> start(Database.BatchableContext BC) {
        Set<Id> setOfSOId = fetchRenewalSOId();
        List<Opportunity> lstOpp = fetchRenewalOpportunity(setOfSOId);
        return lstOpp;
    }
    
    public void execute(Database.BatchableContext BC, List<Opportunity> lstOpp) {
        String strCloseWon = 'P1 (Signed/Closed Contract)';
        for(Opportunity eachOpp : lstOpp){
            eachOpp.StageName = strCloseWon;
        }
        update lstOpp;
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    public void execute(SchedulableContext sc) {
    
    }
    
    public Set<Id> fetchRenewalSOId(){
        String strAccountEntity = 'Account';
        String strItemClass = 'Business Strategies Corporate Membership';
        List<OrderApi__Sales_Order_Line__c> lstSOLI = [SELECT Id,OrderApi__Sales_Order__c  
                                                        FROM OrderApi__Sales_Order_Line__c 
                                                        WHERE OrderApi__Is_Renewal__c = true AND 
                                                        OrderApi__Entity__c =:strAccountEntity AND 
                                                        OrderApi__Item_Class__r.Name =:strItemClass AND 
                                                        OrderApi__Is_Posted__c = true];
        Set<Id> setOfSOId = new Set<Id>();
        for(OrderApi__Sales_Order_Line__c eachSOLI : lstSOLI){
            setOfSOId.add(eachSOLI.OrderApi__Sales_Order__c);
        }
        return setOfSOId; //fetchFilterSOId(setOfSOId);
    }
    
    public List<Opportunity> fetchRenewalOpportunity(Set<Id> setOfSOId){
        List<Opportunity> lstOpp = [SELECT Id,
                                    StageName,FON_Renewal_Sales_Order__c 
                                    FROM Opportunity 
                                    WHERE FON_Renewal_Sales_Order__c IN : setOfSOId];
        return lstOpp;
    }
    
    /*
    public Set<Id> fetchFilterSOId(Set<Id> setOfSOId){
        String strCloseWon = 'P1 (Signed/Closed Contract)';
        List<Opportunity> lstRenewalOpp = [SELECT Id,FON_Renewal_Sales_Order__c  
                                            FROM Opportunity 
                                            WHERE FON_Renewal_Sales_Order__c IN : setOfSOId AND 
                                                StageName !=: strCloseWon];
        Map<Id,Opportunity> mapSOIdToOpp = new Map<Id,Opportunity>();
        for(Opportunity eachOpp : lstRenewalOpp){
            mapSOIdToOpp.put(eachOpp.FON_Renewal_Sales_Order__c, eachOpp);
        }
        Set<Id> setOfFilterSOId = new Set<Id>();
        for(Id eachId : setOfSOId){
            if(!mapSOIdToOpp.containsKey(eachId)){
                setOfFilterSOId.add(eachId);
            }
        }
        return setOfFilterSOId;
    }
    */
    
}