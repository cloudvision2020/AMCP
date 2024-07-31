@isTest
private class FON_As_Of_BatchableTest {
    
    static testMethod void testFON_As_Of_Batchable() {
        
        Contact co = new Contact(
            FirstName = 'Test',
            LastName = 'FonBatch123',
            Email = 'testfonbatch@mailinator.com'
        );
        insert co;
        
        OrderApi__Sales_Order__c so = new OrderApi__Sales_Order__c();
        so.OrderApi__Contact__c = co.Id;
        so.OrderApi__Entity__c = 'Contact';
        so.OrderApi__Is_Posted__c = true;
        insert so;
        
        OrderApi__Item_Class__c iclass = new OrderApi__Item_Class__c();
        iclass.OrderApi__Is_Active__c = true;
        iclass.Name = 'TESTTEST';
        insert iclass;
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.OrderApi__Item_Class__c = iclass.Id;
        item.OrderApi__Price__c = 200;
        insert item;
        
        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
        sol.OrderApi__Item__c = item.id;
        sol.OrderApi__Sale_Price__c = 200;
        sol.OrderApi__Sales_Order__c = so.Id;
        insert sol;
        
        OrderApi__Transaction__c tr = new OrderApi__Transaction__c();
        tr.OrderApi__Date__c = date.newinstance(2023, 11, 11);
        tr.OrderApi__Sales_Order__c = so.Id;
        tr.OrderApi__Type__c = 'Cash';
        insert tr;
        
        OrderApi__Transaction_Line__c tl1 = new OrderApi__Transaction_Line__c();
        tl1.OrderApi__Transaction__c = tr.id;
        tl1.OrderApi__Debit__c = 100;
        insert tl1;
        
        OrderApi__Transaction_Line__c tl2 = new OrderApi__Transaction_Line__c(
            
        );
        
        
        
        
        // run the batchable
        Test.startTest();
        FON_As_Of_Batchable batchable = new FON_As_Of_Batchable();
        Database.executeBatch(batchable);
        Test.stopTest();
    }
}