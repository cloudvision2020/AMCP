@IsTest
public class FON_SOViewDocumentTest {
    
    @isTest static void updateJSONDataTest() {
        Account acc = new Account();
        acc.Name = 'TestFON_SOViewDocument';
        insert acc;
        
        Contact con = New Contact(FirstName='FF',LastName='LL');
        insert con;
        
        OrderApi__Sales_Order__c SO = new OrderApi__Sales_Order__c();
        so.OrderApi__Account__c = acc.id;
        so.OrderApi__Contact__c = con.id;
        so.Orderapi__JSON_Data__c = 'tst';
        insert so;
        
        OrderApi__Receipt__c RC = new OrderApi__Receipt__c();
        RC.OrderApi__Account__c = acc.id;
        RC.OrderApi__Contact__c = con.id;
        RC.OrderApi__Action_Information__c = 'tst';
        RC.OrderApi__Sales_Order__c = so.id;
        insert RC;
    }
}