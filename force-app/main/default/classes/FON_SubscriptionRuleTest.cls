@IsTest
private class FON_SubscriptionRuleTest {
    
    @TestSetup
    private static void install() {
        Framework.Installer.install();
        PagesApi.PackageScripts.install();
        OrderApi.PackageScripts.install();
        EventApi.PackageScripts.install();

        Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
        Framework.RoutingRule routingRule = new Framework.RoutingRule();
        routingRule.apexClass = FON_SubscriptionRule.class.getName();
        routingRule.namespace = '';
        routingRule.isEnabled = true;
        routingRule.sObjectName = 'OrderApi__Subscription__c';
        routingRule.executionOrder = 70;
        rules.add(routingRule);
        Framework.Config.push(rules);

    }

    @IsTest
    public static void testBatch() {
        
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
        
        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c();
        itemClass.Name = 'item class test';
        insert itemClass;
        
        OrderApi__Business_Group__c bg = new OrderApi__Business_Group__c();
        bg.Name = 'Business Group Test';
        insert bg;
        
        OrderApi__Item__c item = new OrderApi__Item__c();
        item.Name = 'Test iTem';
        item.OrderApi__Is_Active__c = true;
        item.OrderApi__Item_Class__c = itemClass.Id;
        insert item;
           
        
        OrderApi__Subscription_Plan__c subPlan = new OrderApi__Subscription_Plan__c();
        subPlan.Name = 'Subscription Plan Test';
        subPlan.OrderApi__Invoice_Days_Variable__c = 10;
        subPlan.OrderApi__Type__c = 'Termed';
        subPlan.OrderApi__Is_Active__c = true;
        subPlan.OrderApi__Initial_Term_Months__c = 12;
        subPlan.OrderApi__Renewal_Term_Months__c = 12;
        insert subPlan;
        
        
        OrderApi__Subscription__c sub1 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact1.Id,
            OrderApi__Subscription_Plan__c = subPlan.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Item__c = item.Id,
            OrderApi__Status__c = 'Active'
        );
        //insert sub1;
                
        OrderApi__Subscription__c sub2 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact2.Id,
            OrderApi__Subscription_Plan__c = subPlan.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Item__c = item.Id,
            OrderApi__Status__c = 'Active'
        );
       // insert sub2;
                
        OrderApi__Subscription__c sub3 = new OrderApi__Subscription__c(
            OrderApi__Activated_Date__c = System.today(),
            OrderApi__Contact__c = contact2.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(-900),
            OrderApi__Subscription_Plan__c = subPlan.Id,
            OrderApi__Item__c = item.Id,
            OrderApi__Status__c = 'Expired'
        );
        //insert sub3;
        
        OrderApi__Subscription__c sub4 = new OrderApi__Subscription__c(
            OrderApi__Contact__c = contact3.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Subscription_Plan__c = subPlan.Id,
            OrderApi__Item__c = item.Id,
            OrderApi__Status__c = 'Active'
        );
        //insert sub4;
        
        OrderApi__Subscription__c sub5 = new OrderApi__Subscription__c(
            OrderApi__Activated_Date__c = System.today(),
            OrderApi__Contact__c = contact3.Id,
            OrderApi__Subscription_Plan__c = subPlan.Id,
            OrderApi__Paid_Through_Date__c = Date.today().addDays(30),
            OrderApi__Item__c = item.Id,
            OrderApi__Status__c = 'Active'
        );
        //insert sub5;
        Test.startTest();
        insert sub3;
        insert sub5;
        sub5.OrderApi__Paid_Through_Date__c = Date.today().addDays(25);
        update sub5;
        sub3.OrderApi__Paid_Through_Date__c = Date.today().addDays(-950);
        update sub3;
        Test.stopTest();
        
        /*Test.startTest();
        List<OrderApi__Subscription__c> usubs = new List<OrderApi__Subscription__c>();
        usubs.add(sub1);        
        FON_SubscriptionRule.syncFields(usubs); 
        usubs.add(sub1);        
        FON_SubscriptionRule.syncFields(usubs); 
        usubs.add(sub1);        
        FON_SubscriptionRule.syncFields(usubs); 
        usubs.add(sub1);        
        FON_SubscriptionRule.syncFields(usubs); 
        usubs.add(sub1);        
        FON_SubscriptionRule.syncFields(usubs); 
        sub5.OrderApi__Paid_Through_Date__c = Date.today().addDays(25);
        sub3.OrderApi__Paid_Through_Date__c = Date.today().addDays(-950);
        update sub5;
        FON_SubscriptionRule.syncFields(usubs); 
        Test.stopTest();*/
                
        //Contact con = [SELECT Id, Membership_Status__c, Activated_Date__c FROM Contact WHERE FirstName = 'Test'];
        //String ass 1
        //System.assert(con.Membership_Status__c == null, 'Membership status has to be null');
        //System.assert(con.Activated_Date__c == null, 'Activated date has to be null');
        
       
    }



}