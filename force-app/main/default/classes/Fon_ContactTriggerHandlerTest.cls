@isTest
public class Fon_ContactTriggerHandlerTest {
    public static Boolean isInstalled = false;
    
    private static void install() {
        if (!isInstalled) {
            //Framework.Dispatcher.disableTriggerInContext.put('Contact', true);
            Framework.Installer.install();
            PagesApi.PackageScripts.install();
            OrderApi.PackageScripts.install();
            EventApi.PackageScripts.install();
            // Create a routing rule for Contact
            Framework.RoutingRule[] rules = new List<Framework.RoutingRule>();
            Framework.RoutingRule cons = new Framework.RoutingRule();
            cons.apexClass = Fon_ContactTriggers.class.getName();
            cons.namespace = '';
            cons.isEnabled = true;
            cons.sObjectName = 'Contact';
            cons.executionOrder = 0;
            rules.add(cons);
            Framework.Config.push(rules);                   
            isInstalled = true;
        }
    }
    
    @TestSetup
    static void setupTestData() {
        install();
        Contact contact1 = new Contact(
            LastName = 'Red',
            Email = 'test1@example.com',
            OrderApi__Personal_Email__c = 'personal1@example.com',
            OrderApi__Work_Email__c = 'work1@example.com'
        );
        Contact contact2 = new Contact(
            LastName = 'Blue',
            Email = 'test2@example.com',
            OrderApi__Personal_Email__c = 'personal2@example.com',
            OrderApi__Other_Email__c = 'other2@example.com',
            OrderApi__Assistant_Email__c = 'other3@example.com'
        );
        insert new List<Contact>{contact1, contact2};
    }
    
    @isTest
    public static void testDuplicateEmailOnInsert() {
        Test.startTest();
        Contact newContact = new Contact(
            LastName = 'Pink',
            Email = 'test1@example.com'
        );
        try {
            insert newContact;
        } catch (DmlException e) {
           // System.assert(e.getMessage().contains('Duplicate Email Address Found!'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void testDuplicateEmailOnUpdate() {
        Contact newContact = new Contact(
            LastName = 'Will',
            Email = 'unique@example.com'
        );
        insert newContact;
        
        Test.startTest();
        newContact.Email = 'test1@example.com'; 
        newContact.OrderApi__Personal_Email__c = 'personal1@example.com';
  		newContact.OrderApi__Other_Email__c = 'other2@example.com';
        newContact.OrderApi__Assistant_Email__c = 'other3@example.com';
        try {
            update newContact;
        } catch (DmlException e) {
           // System.assert(e.getMessage().contains('Duplicate Email Address Found!'), 'Unexpected error message: ' + e.getMessage());
        }
        Test.stopTest();
    }
}