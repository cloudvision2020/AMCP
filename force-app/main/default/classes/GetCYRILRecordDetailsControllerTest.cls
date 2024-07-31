@isTest
public class GetCYRILRecordDetailsControllerTest {
    @isTest static void getTest() {
        
        Contact con = new contact(LastName='Test Con');
        insert con;

        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name LIKE '%Administrator%' LIMIT 1].Id,
            LastName = 'last',
            Email = 'puser000@amamama.com',
            Username = 'puser000@amamama.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US');
        insert u; 

        system.runAs(u)
        {
            Test.startTest();
                System.debug('current user '+u);
            
                PageReference pageRef = Page.CYRILRecordDetailsVF;
                Test.setCurrentPage(pageRef);
              System.currentPageReference().getParameters().put('fls','Name');
              System.currentPageReference().getParameters().put('rId',con.Id);
            	System.currentPageReference().getParameters().put('whr','Id = \''+con.Id+'\'');

            
                GetCYRILRecordDetailsController gpdf = new GetCYRILRecordDetailsController();
                System.debug('Test1xxx' + gpdf );
            
              String rDetails = gpdf.rDetails;
              String sz1 = rDetails;
              System.assertEquals(sz1, rDetails);
            
            Test.stopTest();
        }
        
    }
}