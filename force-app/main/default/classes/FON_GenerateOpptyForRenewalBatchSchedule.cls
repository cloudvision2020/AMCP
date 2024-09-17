public class FON_GenerateOpptyForRenewalBatchSchedule implements Database.Batchable<sObject>, Database.Stateful, Schedulable {
    
    public Date objCreatedDate;
    
    public FON_GenerateOpptyForRenewalBatchSchedule(){
        this.objCreatedDate = Date.today();
    }
    
    public FON_GenerateOpptyForRenewalBatchSchedule(Date objCreatedDate){
        this.objCreatedDate = objCreatedDate;
    }
    
    public List<SObject> start(Database.BatchableContext BC) {
        Set<Id> setOfSOId = fetchRenewalSOId();
        if(setOfSOId.isEmpty()){
            List<String> lstTestId = new List<String>();
            lstTestId.add('aaa');
        }
        List<OrderApi__Sales_Order__c> lstRenewalSO = fetchSalesOrderById(setOfSOId);
        return lstRenewalSO;
    }
    
    public void execute(Database.BatchableContext BC, List<OrderApi__Sales_Order__c> lstSO) {
        Map<Id,PricebookEntry> mapIdToObjPriceBookEntry = new Map<Id,PricebookEntry>();
        Map<Id,Opportunity> mapIdToObjOpportunity = new Map<Id,Opportunity>();
        Map<Id,List<Opportunity_Item__c>> mapIdToLstOppLineItem = new Map<Id,List<Opportunity_Item__c>>();
        for(OrderApi__Sales_Order__c eachSO : lstSO){
            List<Opportunity_Item__c> lstOppLineItem = new List<Opportunity_Item__c>();
            if(eachSO.OrderApi__Sales_Order_Lines__r != null && !eachSO.OrderApi__Sales_Order_Lines__r.isEmpty()){
                Opportunity objOpp = fetchOpportunityInstance(eachSO);
                for(OrderApi__Sales_Order_Line__c eachSOLI : eachSO.OrderApi__Sales_Order_Lines__r){
                    Opportunity_Item__c objOppLineItem = fetchOppProductInstance(eachSOLI);
                    lstOppLineItem.add(objOppLineItem);
                    if(eachSOLI.OrderApi__Is_Renewal__c && String.isBlank(objOpp.Name)){
                        objOpp.Name = fetchFormatedOppName(eachSO, eachSOLI);
                    }
                    if(eachSOLI.OrderApi__End_Date__c == null){
                        objOpp.CloseDate = eachSOLI.OrderApi__Activation_Date__c;
                    }
                    if(objOpp.CloseDate == null){
                        objOpp.CloseDate = eachSOLI.OrderApi__End_Date__c;
                    }
                }
                mapIdToObjOpportunity.put(eachSO.Id, objOpp);
                mapIdToLstOppLineItem.put(eachSO.Id, lstOppLineItem);
            }
        }
        if(!mapIdToObjOpportunity.values().isEmpty()){
            insert mapIdToObjOpportunity.values();
        }
        if(!mapIdToLstOppLineItem.values().isEmpty()){
            List<Opportunity_Item__c> lstAllOppLineItem = new List<Opportunity_Item__c>();
            for(Id eachSOId : mapIdToLstOppLineItem.keySet()){
                List<Opportunity_Item__c> lstOppLineItem = mapIdToLstOppLineItem.get(eachSOId);
                for(Opportunity_Item__c eachOppLine : lstOppLineItem){
                    eachOppLine.Opportunity__c = mapIdToObjOpportunity.get(eachSOId).Id;
                    lstAllOppLineItem.add(eachOppLine);
                }
            }
            insert lstAllOppLineItem;
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    public void execute(SchedulableContext sc) {
    
    }
    
    public Set<Id> fetchRenewalSOId(){
        //Date objCreatedDate = Date.today();//.addDays(-1);
        String strAccountEntity = 'Account';
        String strItemClass = 'Business Strategies Corporate Membership';
        List<OrderApi__Sales_Order_Line__c> lstSOLI = [SELECT Id,
                                                            OrderApi__Is_Renewal__c,OrderApi__Entity__c,
                                                            OrderApi__Item__c,OrderApi__Item__r.Name,
                                                            OrderApi__Item__r.OrderApi__Display_Name__c,
                                                            OrderApi__Balance_Due__c,OrderApi__Quantity__c,
                                                            OrderApi__Subscription_Plan__c,OrderApi__Item_Class__c,
                                                            OrderApi__Item_Class__r.Name,OrderApi__Sales_Order__c,
                                                            OrderApi__End_Date__c,OrderApi__Activation_Date__c  
                                                        FROM OrderApi__Sales_Order_Line__c 
                                                        WHERE OrderApi__Is_Renewal__c = true AND 
                                                        OrderApi__Entity__c =:strAccountEntity AND 
                                                        OrderApi__Item_Class__r.Name =:strItemClass AND 
                                                        FON_Created_Date__c =: this.objCreatedDate];
        Set<Id> setOfSOId = new Set<Id>();
        for(OrderApi__Sales_Order_Line__c eachSOLI : lstSOLI){
            setOfSOId.add(eachSOLI.OrderApi__Sales_Order__c);
        }
        return fetchFilterSOId(setOfSOId);
    }
    
    public List<OrderApi__Sales_Order__c> fetchSalesOrderById(Set<Id> setOfSOId){
        List<OrderApi__Sales_Order__c> lstSO = [SELECT Id,
                                                    OrderApi__Contact__c,OrderApi__Account__c,
                                                    OrderApi__Account__r.Id,OrderApi__Account__r.Name,
                                                    OrderApi__Account__r.OrderApi__Primary_Contact__c,
                                                    OrderApi__Account__r.OwnerId,
                                                    OrderApi__Balance_Due__c,OrderApi__Date__c,
                                                    (SELECT Id,
                                                        OrderApi__Is_Renewal__c,OrderApi__Entity__c,
                                                        OrderApi__Item__c,OrderApi__Item__r.Name,
                                                        OrderApi__Item__r.OrderApi__Display_Name__c,
                                                        OrderApi__Balance_Due__c,OrderApi__Quantity__c,
                                                        OrderApi__Sale_Price__c,OrderApi__End_Date__c,
                                                        OrderApi__Subscription_Plan__c,OrderApi__Item_Class__c,
                                                        OrderApi__Item_Class__r.Name,OrderApi__Sales_Order__c,
                                                        OrderApi__Activation_Date__c  
                                                    FROM OrderApi__Sales_Order_Lines__r) 
                                                FROM OrderApi__Sales_Order__c 
                                                WHERE Id IN: setOfSOId];
        return lstSO;
    }
    
    public Opportunity fetchOpportunityInstance(OrderApi__Sales_Order__c objSO){
        String strStage = 'P2 (Pending contract/verbal)';
        Opportunity objOpp = new Opportunity();
        objOpp.Name = '';
        objOpp.AccountId = objSO.OrderApi__Account__r.Id;
        objOpp.Primary_Contact__c = objSO.OrderApi__Account__r.OrderApi__Primary_Contact__c;
        objOpp.Amount = objSO.OrderApi__Balance_Due__c;
        objOpp.Date__c = objSO.OrderApi__Date__c;
        objOpp.OwnerId = objSO.OrderApi__Account__r.OwnerId;
        objOpp.Family__c = 'Membership';
        objOpp.Class__c = 'Corporate Membership';
        objOpp.FON_Renewal_Sales_Order__c = objSO.Id;
        objOpp.StageName = strStage;
        objOpp.CloseDate = null;
        return objOpp;
    }
    
    public Opportunity_Item__c fetchOppProductInstance(OrderApi__Sales_Order_Line__c objSOLI){
        Opportunity_Item__c objOppItem = new Opportunity_Item__c();
        objOppItem.Opportunity__c = null;
        objOppItem.Item__c = objSOLI.OrderApi__Item__c;
        objOppItem.Sale_Price__c = objSOLI.OrderApi__Sale_Price__c;
        objOppItem.Quantity__c = objSOLI.OrderApi__Quantity__c;
        objOppItem.Total_Amount_OI__c = objSOLI.OrderApi__Balance_Due__c;
        return objOppItem;
        /*
        OpportunityLineItem objOppLineItem = new OpportunityLineItem();
        objOppLineItem.OpportunityId  = null;
        objOppLineItem.Quantity = objSOLI.OrderApi__Quantity__c;
        objOppLineItem.PricebookEntryId  = objPriceBookEntry.Id;
        objOppLineItem.TotalPrice = objSOLI.OrderApi__Sale_Price__c;
        objOppLineItem.Description = 'Auto-generated for renewal order';
        return objOppLineItem;
        */
    }
    
    public String fetchFormatedOppName(OrderApi__Sales_Order__c objSO, OrderApi__Sales_Order_Line__c objSOLI){
        String strOppName = '';
        if(objSOLI.OrderApi__End_Date__c != null){
            strOppName = '' + objSOLI.OrderApi__End_Date__c.year() + ' ' + objSOLI.OrderApi__Item__r.OrderApi__Display_Name__c + ' - ' + objSO.OrderApi__Account__r.Name;
        }else{
            strOppName = '' + objSOLI.OrderApi__Activation_Date__c.addYears(1).year() + ' ' + objSOLI.OrderApi__Item__r.OrderApi__Display_Name__c + ' - ' + objSO.OrderApi__Account__r.Name;
        }
        return strOppName;
    }
    
    public Set<Id> fetchFilterSOId(Set<Id> setOfSOId){
        List<Opportunity> lstRenewalOpp = [SELECT Id,FON_Renewal_Sales_Order__c  
                                            FROM Opportunity 
                                            WHERE FON_Renewal_Sales_Order__c IN : setOfSOId];
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
    
}