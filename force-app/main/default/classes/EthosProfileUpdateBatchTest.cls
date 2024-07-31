@IsTest
public class EthosProfileUpdateBatchTest {
	@IsTest
    public static void profileUpdateIntegrationTest() {

        Account acc = new Account(
            Name = 'Test Account'            
        );
        insert acc;
          
        Contact con = new Contact(
        	FirstName = 'John',
            LastName = 'Doe Test',
            AccountId = acc.Id,
            Membership_Status__c = 'Active',
            AMCP_Membership_Type__c = 'Press Member',
            Employer_Type__c = 'Association',
            Job_Role__c = 'Vice President',
            OrderApi__Preferred_Phone_Type__c = 'Mobile',
            MobilePhone = '(703) 338-4488', 
            Primary_Position__c = 'Executive Management', 
            License__c = 'Pharmacist', 
            MailingStreet = 'Test Street', 
            MailingCity = 'Orlando', 
            MailingStateCode = 'FL', 
            MailingPostalCode = '32828', 
            MailingCountryCode = 'US', 
            MailingState = 'Florida', 
            MailingCountry = 'United States', 
            Title = 'Tester'        
        );
        insert con;
          
        Profile communityProfile = [
          SELECT Id
          FROM Profile
          WHERE Name = 'Fonteva Customer Community'
        ];
        String username =
          'test' +
            Datetime.now().getTime() +
            Crypto.getRandomInteger() +
            '@testorg.com';
        User communityUser = new User();
        communityUser.Username = username;
        communityUser.LastName = 'Doe Test';
        communityUser.Email = 'test@domain.org';
        communityUser.Alias = 'test';
        communityUser.TimeZoneSidKey = 'America/Los_Angeles';
        communityUser.LocaleSidKey = 'en_US';
        communityUser.EmailEncodingKey = 'UTF-8';
        communityUser.LanguageLocaleKey = 'en_US';
        communityUser.ContactId = con.Id;
        communityUser.ProfileId = communityProfile.Id;
        insert communityUser;
          
        Test.startTest();
        EthosProfileUpdateBatch ethosBatch = new EthosProfileUpdateBatch();
		Id batchId = Database.executeBatch(ethosBatch,3);
        Test.stopTest();    
      }
    
    @IsTest
      public static void profileUpdateIntegrationTestNoUser() {

        Account acc = new Account(
            Name = 'Test Account'            
        );
        insert acc;
          
        Contact con = new Contact(
        	FirstName = 'Mike',
            LastName = 'Testing Test',
            AccountId = acc.Id,
            Membership_Status__c = 'Active',
            AMCP_Membership_Type__c = 'Press Member',
            Employer_Type__c = 'Association',
            Job_Role__c = 'Vice President',
            OrderApi__Preferred_Phone_Type__c = 'Mobile',
            MobilePhone = '(703) 338-4488', 
            Primary_Position__c = 'Executive Management', 
            License__c = 'Pharmacist', 
            MailingStreet = 'Test Street', 
            MailingCity = 'Orlando', 
            MailingStateCode = 'FL', 
            MailingPostalCode = '32828', 
            MailingCountryCode = 'US', 
            MailingState = 'Florida', 
            MailingCountry = 'United States', 
            Title = 'Tester'        
        );
        insert con;
          
        Test.startTest();
        EthosProfileUpdateBatch ethosBatch = new EthosProfileUpdateBatch();
		Id batchId = Database.executeBatch(ethosBatch,1);
        Test.stopTest();    
      }
}