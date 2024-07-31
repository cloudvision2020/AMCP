@isTest
public class LwcLookupControllerTest {

    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            accounts.add(new Account(Name = 'Test Account ' + i));
        }
        insert accounts;
    }

    @isTest
    static void testFindRecords() {
  
        String searchKeyWord = 'Test Account';
        String objectName = 'Account';
        String strAccType = '';
        String strParentId = '';
        
        List<sObject> results = LwcLookupController.findRecords(searchKeyWord, objectName, strAccType, strParentId);      
        System.assertNotEquals(null, results, 'Results should not be null');
        System.assertEquals(5, results.size(), 'Expected 5 records to be returned');
        for (sObject obj : results) {
            System.assert(obj instanceof Account, 'Expected instance of Account');
            System.assert(((Account)obj).Name.startsWith('Test Account'), 'Expected name to start with "Test Account"');
        }
    }
}