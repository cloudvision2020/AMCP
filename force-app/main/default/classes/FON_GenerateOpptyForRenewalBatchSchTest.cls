@isTest
public class FON_GenerateOpptyForRenewalBatchSchTest {

    @TestSetup
    static void createTestSetupData(){
        createTestData();
    }
    
    public static void createTestData(){
        OrderApi__Business_Group__c objBusGrp1 =  new OrderApi__Business_Group__c();
        objBusGrp1.Name = 'objBusGrp1Name';
        insert objBusGrp1;
        
        Account objAccount1 = new Account();
        objAccount1.Name = 'AKA';
        insert objAccount1;
        
        Contact objContact1 = new Contact();
        objContact1.LastName = 'John';
        objContact1.AccountId = objAccount1.Id;
        objContact1.Email ='john@testemail.com';
        insert objContact1;
        
        OrderApi__Item_Class__c objItemClass1 = new OrderApi__Item_Class__c();
        objItemClass1.Name = 'Business Strategies Corporate Membership';
        objItemClass1.OrderApi__Is_Subscription__c=true;
        objItemClass1.OrderApi__Is_Active__c = true;
        objItemClass1.OrderApi__Business_Group__c = objBusGrp1.ID;
        insert objItemClass1;
        
        OrderApi__Item__c objItem1 = new OrderApi__Item__c();
        objItem1.OrderApi__Price__c = 100;
        objItem1.OrderApi__Is_Subscription__c=true;
        objItem1.OrderApi__Is_Active__c = true;
        objItem1.OrderApi__Item_Class__c = objItemClass1.Id;
        objItem1.OrderApi__Business_Group__c = objBusGrp1.Id;
        objItem1.Name = 'Chapter Membership';
        objItem1.OrderApi__Display_Name__c = 'Chapter Membership';
        insert objItem1;
    
    }
    
    @isTest
    static void generateOpptyForRenewal(){
        String strItemClass = 'Business Strategies Corporate Membership';
        Account objAccount1 = [SELECT Id FROM Account WHERE Name = 'AKA' LIMIT 1];
        Contact objContact1 = [SELECT Id FROM Contact WHERE Email ='john@testemail.com' LIMIT 1];
        OrderApi__Item__c objItem1 = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'Chapter Membership' LIMIT 1];
        OrderApi__Item_Class__c objItemClass1 = [SELECT Id FROM OrderApi__Item_Class__c WHERE Name =: strItemClass LIMIT 1];
        
        objAccount1.OrderApi__Primary_Contact__c = objContact1.Id;
        update objAccount1;
        
        OrderApi__Sales_Order__c objSO = new OrderApi__Sales_Order__c();
        objSO.OrderApi__Account__c = objAccount1.Id;
        objSO.OrderApi__Contact__c = objContact1.Id;
        objSO.OrderApi__Entity__c = 'Account';
        insert objSO;
        
        OrderApi__Sales_Order_Line__c objSOLI1 = new OrderApi__Sales_Order_Line__c();
        objSOLI1.OrderApi__Sales_Order__c = objSO.Id;
        objSOLI1.OrderApi__Item__c = objItem1.id;
        objSOLI1.OrderApi__Item_Class__c = objItemClass1.Id;
        objSOLI1.OrderApi__Price_Override__c = true;
        objSOLI1.OrderApi__Sale_Price__c = 0;
        objSOLI1.OrderApi__Is_Renewal__c = true;
        objSOLI1.OrderApi__Entity__c = 'Account';
        objSOLI1.OrderApi__End_Date__c = Date.today();
        insert objSOLI1;
        
        objSO.OrderApi__Is_Closed__c = true;
        objSO.OrderApi__Is_Posted__c = true;
        update objSO;
        
        update objSOLI1;
        
        OrderApi__Sales_Order_Line__c objSOOLI1 = [SELECT Id,OrderApi__Is_Renewal__c,
                                                        OrderApi__Item_Class__r.Name,
                                                        OrderApi__Entity__c,
                                                        FON_Created_Date__c,
                                                        OrderApi__Is_Posted__c  
                                                     FROM OrderApi__Sales_Order_Line__c LIMIT 1];
        System.debug('==========objSOOLI1============='+objSOOLI1);
        System.debug('==========Item_Class============='+objSOOLI1.OrderApi__Item_Class__r.Name);
        System.debug('==========OrderApi__Is_Posted__c============='+objSOOLI1.OrderApi__Is_Posted__c);
        
        
        FON_GenerateOpptyForRenewalBatchSchedule objGenOppRenew1 = new FON_GenerateOpptyForRenewalBatchSchedule();
        Id batchId1 = Database.executeBatch(objGenOppRenew1);
        
        FON_GenerateOpptyForRenewalBatchSchedule objGenOppRenew2 = new FON_GenerateOpptyForRenewalBatchSchedule(Date.today().addDays(-1));
        Id batchId2 = Database.executeBatch(objGenOppRenew2);
        
        /*
        OrderApi__Sales_Order__c objSalesOrdeer = [SELECT Id,
                                                        OrderApi__Account__r.Id,
                                                        OrderApi__Account__r.OrderApi__Primary_Contact__c,
                                                        OrderApi__Balance_Due__c,OrderApi__Date__c,
                                                        OrderApi__Account__r.OwnerId 
                                                    FROM OrderApi__Sales_Order__c LIMIT 1];
        
        String strStage = 'P2 (Pending contract/verbal)';
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opp';
        objOpp.AccountId = objSalesOrdeer.OrderApi__Account__r.Id;
        objOpp.Primary_Contact__c = objSalesOrdeer.OrderApi__Account__r.OrderApi__Primary_Contact__c;
        objOpp.Amount = objSalesOrdeer.OrderApi__Balance_Due__c;
        objOpp.Date__c = objSalesOrdeer.OrderApi__Date__c;
        objOpp.OwnerId = objSalesOrdeer.OrderApi__Account__r.OwnerId;
        objOpp.Family__c = 'Membership';
        objOpp.Class__c = 'Corporate Membership';
        objOpp.FON_Renewal_Sales_Order__c = objSalesOrdeer.Id;
        objOpp.StageName = strStage;
        objOpp.CloseDate = Date.today();
        insert objOpp;
        
        
        FON_CloseRenewalOpptyBatchSchedule objCloseRenewal = new FON_CloseRenewalOpptyBatchSchedule();
        Id batchId3 = Database.executeBatch(objCloseRenewal);
        */
    }
    
    @isTest
    static void closeOpptyForRenewal(){
        String strItemClass = 'Business Strategies Corporate Membership';
        Account objAccount1 = [SELECT Id FROM Account WHERE Name = 'AKA' LIMIT 1];
        Contact objContact1 = [SELECT Id FROM Contact WHERE Email ='john@testemail.com' LIMIT 1];
        OrderApi__Item__c objItem1 = [SELECT Id FROM OrderApi__Item__c WHERE Name = 'Chapter Membership' LIMIT 1];
        OrderApi__Item_Class__c objItemClass1 = [SELECT Id FROM OrderApi__Item_Class__c WHERE Name =: strItemClass LIMIT 1];
        
        objAccount1.OrderApi__Primary_Contact__c = objContact1.Id;
        update objAccount1;
        
        OrderApi__Sales_Order__c objSO = new OrderApi__Sales_Order__c();
        objSO.OrderApi__Account__c = objAccount1.Id;
        objSO.OrderApi__Contact__c = objContact1.Id;
        objSO.OrderApi__Entity__c = 'Account';
        insert objSO;
        
        OrderApi__Sales_Order_Line__c objSOLI1 = new OrderApi__Sales_Order_Line__c();
        objSOLI1.OrderApi__Sales_Order__c = objSO.Id;
        objSOLI1.OrderApi__Item__c = objItem1.id;
        objSOLI1.OrderApi__Item_Class__c = objItemClass1.Id;
        objSOLI1.OrderApi__Price_Override__c = true;
        objSOLI1.OrderApi__Sale_Price__c = 0;
        objSOLI1.OrderApi__Is_Renewal__c = true;
        objSOLI1.OrderApi__Entity__c = 'Account';
        objSOLI1.OrderApi__End_Date__c = Date.today();
        insert objSOLI1;
        
        objSO.OrderApi__Is_Closed__c = true;
        objSO.OrderApi__Is_Posted__c = true;
        update objSO;
        
        update objSOLI1;
        
        OrderApi__Sales_Order_Line__c objSOOLI1 = [SELECT Id,OrderApi__Is_Renewal__c,
                                                        OrderApi__Item_Class__r.Name,
                                                        OrderApi__Entity__c,
                                                        FON_Created_Date__c,
                                                        OrderApi__Is_Posted__c  
                                                     FROM OrderApi__Sales_Order_Line__c LIMIT 1];
        OrderApi__Sales_Order__c objSalesOrdeer = [SELECT Id,
                                                        OrderApi__Account__r.Id,
                                                        OrderApi__Account__r.OrderApi__Primary_Contact__c,
                                                        OrderApi__Balance_Due__c,OrderApi__Date__c,
                                                        OrderApi__Account__r.OwnerId 
                                                    FROM OrderApi__Sales_Order__c LIMIT 1];
        
        String strStage = 'P2 (Pending contract/verbal)';
        Opportunity objOpp = new Opportunity();
        objOpp.Name = 'Test Opp';
        objOpp.AccountId = objSalesOrdeer.OrderApi__Account__r.Id;
        objOpp.Primary_Contact__c = objSalesOrdeer.OrderApi__Account__r.OrderApi__Primary_Contact__c;
        objOpp.Amount = objSalesOrdeer.OrderApi__Balance_Due__c;
        objOpp.Date__c = objSalesOrdeer.OrderApi__Date__c;
        objOpp.OwnerId = objSalesOrdeer.OrderApi__Account__r.OwnerId;
        objOpp.Family__c = 'Membership';
        objOpp.Class__c = 'Corporate Membership';
        objOpp.FON_Renewal_Sales_Order__c = objSalesOrdeer.Id;
        objOpp.StageName = strStage;
        objOpp.CloseDate = Date.today();
        insert objOpp;
        
        
        FON_CloseRenewalOpptyBatchSchedule objCloseRenewal = new FON_CloseRenewalOpptyBatchSchedule();
        Id batchId3 = Database.executeBatch(objCloseRenewal);
    
    
    }
    

}