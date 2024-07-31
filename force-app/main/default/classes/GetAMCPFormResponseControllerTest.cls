@isTest
private class GetAMCPFormResponseControllerTest {
    
    @isTest static void getTest() {
        
         
        Account account = new Account(Name = 'Test Account');
        insert account; 
        
        Contact contact = new Contact(AccountId = account.Id, Email = 'test@email.com', FirstName = 'FirstName', LastName = 'LastName',
        Phone = '(111) 111-1111',
        MailingPostalCode = '11111-1111'); 
        insert contact; 
        
        PagesApi__Form__c form = new PagesApi__Form__c();
        form.Name = 'Form Sample';
        insert form;
        
        PagesApi__Field_Group__c fg = new PagesApi__Field_Group__c();
        fg.Name = 'Form Group';
        fg.PagesApi__Order__c = 0;
        fg.PagesApi__Form__c = form.Id;
        insert fg;
        
        List<PagesApi__Field__c> fields = new List<PagesApi__Field__c>();
        // Add fields to the list as needed
        PagesApi__Field__c f1 = new PagesApi__Field__c();
        f1.Name = 'Field 1';
        f1.PagesApi__Field_Group__c = fg.Id;
        f1.PagesApi__Order__c = 0;
        f1.PagesApi__Type__c = 'Text';
        insert f1;
        
        PagesApi__Field__c f2 = new PagesApi__Field__c();
        f2.Name = 'Field 1';
        f2.PagesApi__Field_Group__c = fg.Id;
        f2.PagesApi__Order__c = 1;
        f2.PagesApi__Type__c = 'Text';
		insert f2;
        
        PagesApi__Form_Response__c fr = new PagesApi__Form_Response__c();
        fr.PagesApi__Contact__c = contact.Id;
        fr.PagesApi__Form__c = form.Id;
        insert fr;
        
        PagesApi__Field_Response__c flr = new PagesApi__Field_Response__c();
        flr.PagesApi__Form_Response__c = fr.Id;
        flr.PagesApi__Response__c = 'Test 1';
        flr.PagesApi__Field__c = f1.Id;
        insert flr;
        
        PagesApi__Field_Response__c flr2 = new PagesApi__Field_Response__c();
        flr2.PagesApi__Form_Response__c = fr.Id;
        flr2.PagesApi__Response__c = 'Test 2';
        flr2.PagesApi__Field__c = f2.Id;
        insert flr2;
            
        
        PageReference pageRef = Page.AMCPFormResponseExporterVF;
        Test.setCurrentPage(pageRef);
        System.currentPageReference().getParameters().put('id',form.Id);
        System.currentPageReference().getParameters().put('title','Case');
        
        GetAMCPFormResponseController controller = new GetAMCPFormResponseController();
        controller.selectedFieldIds = f1.Id + ',' + f2.Id; // assuming these are valid field IDs
        controller.startDate = Date.today();
        controller.endDate = Date.today();
        
        
        Test.setCurrentPageReference(new PageReference('AMCPFormResponseCSV'));
        ApexPages.currentPage().getParameters().put('formId', form.Id);
        ApexPages.currentPage().getParameters().put('sfls', f1.Id + ',' + f2.Id);
        ApexPages.currentPage().getParameters().put('sDate', '11/1/2023');
        ApexPages.currentPage().getParameters().put('eDate', '11/9/2099');
        ApexPages.currentPage().getParameters().put('title', 'Case');

        Test.startTest();
        	PageReference resultPage = controller.processSelection();
        	GetFormResponseRecordsController controller2 = new GetFormResponseRecordsController();
        Test.stopTest();
		
        
        
                

        
        
    }

}