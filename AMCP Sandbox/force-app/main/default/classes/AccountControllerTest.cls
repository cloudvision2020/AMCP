/**
 * Created by Jason Cookman on 6/4/19.
 */
@IsTest
public class AccountControllerTest {

    @IsTest
    private static void testAccountController() {
        OrderApi__Business_Group__c businessGroup = new OrderApi__Business_Group__c(Name='International Society of Automation');
        insert businessGroup;

        OrderApi__Item_Class__c itemClass = new OrderApi__Item_Class__c(Name='Test',
                OrderApi__Is_Active__c=true, OrderApi__Business_Group__c=businessGroup.Id);
        insert itemClass;
        OrderApi__Item_Class__c itemClass1 = new OrderApi__Item_Class__c(Name='Sections',
                OrderApi__Is_Active__c=true, OrderApi__Business_Group__c=businessGroup.Id);
        insert itemClass1;
        OrderApi__Item_Class__c itemClass2 = new OrderApi__Item_Class__c(Name='Divisions',
                OrderApi__Is_Active__c=true, OrderApi__Business_Group__c=businessGroup.Id);
        insert itemClass2;
        OrderApi__Item__c item = new OrderApi__Item__c(Name='Basic Membership', OrderApi__Item_Class__c=itemClass.Id,
                OrderApi__Business_Group__c=businessGroup.Id, OrderApi__Is_Active__c=true);
        insert item;
        OrderApi__Item__c item1 = new OrderApi__Item__c(Name='Test', OrderApi__Item_Class__c=itemClass1.Id,
                OrderApi__Business_Group__c=businessGroup.Id, OrderApi__Is_Active__c=true);
        insert item1;

        OrderApi__Item__c item2 = new OrderApi__Item__c(Name='New Member Fee', OrderApi__Item_Class__c=itemClass.Id,
                OrderApi__Business_Group__c=businessGroup.Id, OrderApi__Is_Active__c=true);
        insert item2;

        OrderApi__Item__c item3 = new OrderApi__Item__c(Name='Eastern Division Dues', OrderApi__Item_Class__c=itemClass2.Id,
                OrderApi__Business_Group__c=businessGroup.Id, OrderApi__Is_Active__c=true);
        insert item3;

        OrderApi__Subscription_Plan__c subscriptionPlan = new OrderApi__Subscription_Plan__c(Name='1 Year', OrderApi__Initial_Term_Months__c=12);
        insert subscriptionPlan;

        OrderApi__Item_Subscription_Plan__c itemSubscriptionPlan = new OrderApi__Item_Subscription_Plan__c(OrderApi__Item__c=item.Id, OrderApi__Subscription_Plan__c=subscriptionPlan.Id);
        insert itemSubscriptionPlan;

        Account account = new Account(Name='Test Account Name');
        Account account2 = new Account(Name='Another Test Account');
        Account account3 = new Account(Name='No Organization Selected');

        List<Account> accountsToInsert = new List<Account>{account, account2, account3};
        insert accountsToInsert;

        Contact contact = new Contact(LastName='test', AccountId=account.Id, MailingStateCode='MD', MailingCountryCode='US');
        insert contact;

        Profile p = [SELECT Id FROM Profile WHERE Name='Fonteva Customer Community Login'];

        User user = new User(Alias='standt', Email='test@example.com',
                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId=p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='test@example.com', ContactId=contact.Id);
        insert user;

        Contact contact1 = new Contact(LastName='test1', AccountId=account.Id, MailingStateCode='MD',
                MailingCountryCode='US');
        insert contact1;

        OrderApi__Sales_Order__c salesOrder = new OrderApi__Sales_Order__c(OrderApi__Contact__c=contact1.Id);
        insert salesOrder;
        OrderApi__Sales_Order_Line__c salesOrderLine = new OrderApi__Sales_Order_Line__c(OrderApi__Item__c=item.Id, OrderApi__Sales_Order__c=salesOrder.Id);
        insert salesOrderLine;
        OrderApi__Sales_Order_Line__c salesOrderLine1 = new OrderApi__Sales_Order_Line__c(OrderApi__Item__c=item1.Id, OrderApi__Sales_Order__c=salesOrder.Id);
        insert salesOrderLine1;
        User user1 = new User(Alias='standt', Email='test@example.com',
                EmailEncodingKey='UTF-8', LastName='Testing1Class', LanguageLocaleKey='en_US',
                LocaleSidKey='en_US', ProfileId=p.Id,
                TimeZoneSidKey='America/Los_Angeles', UserName='test1@example.com', ContactId=contact1.Id);
        insert user1;

        System.runAs(user1) {
            List<Account> relevantAccounts = AccountController.getResults('test', true);
            //System.assertEquals(1, relevantAccounts.size(), 'Expected 1');

            Map<String, Object> result1 = AccountController.insertAffiliation(account2.Id, false, false);
            System.assertEquals(true, (Boolean)result1.get('Status'));
            Map<String, Object> result2 = AccountController.insertAffiliation(account2.Id, true, true);
            System.assertEquals(true, (Boolean)result2.get('Status'));
            Map<String, Object> result3 = AccountController.insertAffiliation(account2.Id, true, false);
            System.assertEquals(true, (Boolean)result3.get('Status'));
        }
    }

}