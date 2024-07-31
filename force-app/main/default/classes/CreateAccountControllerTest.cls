@isTest
public class CreateAccountControllerTest {
    @isTest
    static void testSaveContact() {      
       	Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;        
      
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontact@example.com',           
            AccountId = testAccount.Id,   
            OrderApi__Preferred_Email_Type__c = 'Work',
            OrderApi__Preferred_Phone_Type__c = 'Home',
            //MailingCountry = 'US',
            MailingState = 'California'
        );
        
        Contact testContact1 = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontacst@example.com',           
            AccountId = testAccount.Id,   
            OrderApi__Preferred_Email_Type__c = 'Other',
            OrderApi__Preferred_Phone_Type__c = 'Mobile',
            MailingCountry = 'United States',
            MailingState = 'California'
        );
        
        
        Contact testContact2 = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'testcontactsa@example.com',           
            AccountId = testAccount.Id,   
            OrderApi__Preferred_Email_Type__c = 'Assistant',
            OrderApi__Preferred_Phone_Type__c = 'Work',
            //MailingCountry = 'US',
            MailingState = 'California'
        );
        CreateAccountController.fetchCountryAPI('USA');
        CreateAccountController.fetchStateAPI('USA', 'California');
        CreateAccountController.getDependentMap(testContact, 'MailingCountryCode', 'MailingStateCode'); 
        CreateAccountController.saveContact(testContact, 'testusername@test.com', 'test12344!');  
        CreateAccountController.saveContact(testContact1, 'testusernames@test.com', 'test12344!');  
        CreateAccountController.saveContact(testContact2, 'testusernamesa@test.com', 'test12344!');  
        CreateAccountController.login('testusername@test.com', 'test12344!');
    }
}