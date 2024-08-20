@isTest
public class FON_AccountSearchCustomControllerTest {

    @testSetup
    static void createTestData(){
        Account ac = new Account();
        ac.Name='testAccount';
        insert ac;
        
        OrderApi__Store__c store = new OrderApi__Store__c();
        //store.Name = System.Label.FON_APPAStoreName;
        store.OrderApi__New_Contact_Account_Owner__c = UserInfo.getUserId();
        insert store;
    }
    
    @isTest
    static void coverAllMethods_test(){
        Account ac = new Account(Name='newAccount');
        Test.startTest();
        FON_AccountSearchCustomController.fetchRecords('test');
        FON_AccountSearchCustomController.createAccount(ac);
        FON_AccountSearchCustomController.getDependentMap(ac, 'BillingCountryCode' ,'BillingStateCode');
        Test.stopTest();
    }
    
}