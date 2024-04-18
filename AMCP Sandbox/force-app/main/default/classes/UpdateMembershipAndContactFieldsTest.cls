@IsTest
private class UpdateMembershipAndContactFieldsTest {
    
    static testMethod void testBatch() {
        
        Contact contact1 = new Contact(
            FirstName = 'Name 1',
            LastName = 'LastName 1'
        );
        insert contact1;
        
        Contact contact2 = new Contact(
            FirstName = 'Name 2',
            LastName = 'LastName 2'
        );
        insert contact2;
        
        Contact contact3 = new Contact(
            FirstName = 'Name 3',
            LastName = 'LastName 3'
        );
        insert contact3;
        
        Contact contact4 = new Contact(
            FirstName = 'Test',
            LastName = 'Test',
            Membership_Status__c = 'Active',
            Activated_Date__c = System.today()
        );
        insert contact4;
        
        OrderApi__Subscription__c sub1 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact1.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Status__c = 'Active'
        );
        insert sub1;
        
        OrderApi__Subscription__c sub2 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact2.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Status__c = 'Active'
        );
        insert sub2;
        
        OrderApi__Subscription__c sub3 = new OrderApi__Subscription__c(
            OrderApi__Activated_Date__c = System.today(),
            OrderApi__Contact__c = contact2.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Status__c = 'Expired'
        );
        insert sub3;
        
        OrderApi__Subscription__c sub4 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact3.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Status__c = 'Active'
        );
        insert sub4;
        
        OrderApi__Subscription__c sub5 = new OrderApi__Subscription__c(
            OrderApi__Activated_Date__c = System.today(),
            OrderApi__Contact__c = contact3.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Status__c = 'Active'
        );
        insert sub5;
        
        Test.startTest();
        UpdateMembershipAndContactFieldsBatch batch = new UpdateMembershipAndContactFieldsBatch();
        
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        Contact con = [SELECT Id, Membership_Status__c, Activated_Date__c FROM Contact WHERE FirstName = 'Test'];
        System.assert(con.Membership_Status__c == null, 'Membership status has to be null');
        System.assert(con.Activated_Date__c == null, 'Activated date has to be null');
        
       
    }



}