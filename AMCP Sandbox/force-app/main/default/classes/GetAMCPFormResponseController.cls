public class GetAMCPFormResponseController {

    public List<PagesApi__Field__c> fields {get; set;}
    public String selectedFieldIds {get; set;}
    public String title {get; set;}
    public Date startDate { get; set; }
    public Date endDate { get; set; }
    private Id appId;
    private Id formId;

    public GetAMCPFormResponseController() {
        // Retrieve ID from the URL
        formId = ApexPages.currentPage().getParameters().get('id');
        title = ApexPages.currentPage().getParameters().get('title');
        
        // get form Id
        //Application_Package__c app = [Select Id,Form__c FROM Application_Package__c WHERE Id =: appId];
		//formId = app.Form__c;
        
        fetchFields();
    }

    public void fetchFields() {
        fields = new List<PagesApi__Field__c>();

        if(formId != null) {
            PagesApi__Form__c form = [SELECT (SELECT Id, Name FROM PagesApi__Field_Groups__r ORDER BY PagesApi__Order__c ASC) FROM PagesApi__Form__c WHERE Id = :formId LIMIT 1];
            for(PagesApi__Field_Group__c fg : form.PagesApi__Field_Groups__r) {
                fields.addAll([SELECT Id, Name FROM PagesApi__Field__c WHERE PagesApi__Field_Group__c = :fg.Id AND PagesApi__Type__c != 'Section Header' AND PagesApi__Type__c != 'Instructional Text' ORDER BY PagesApi__Order__c ASC]);
            }
        }
    }

    public PageReference processSelection() {
        // Split selectedFieldIds to get individual field IDs and process them
        selectedFieldIds = selectedFieldIds.replace(' ', '');
        List<String> fieldIds = selectedFieldIds.split(',');

        String sDate;
        String eDate;
        if(startDate != null){
			sDate = startDate.format();
        	eDate = endDate.format();
        }

        PageReference redirectPage = new PageReference('/apex/AMCPFormResponseCSV');
        redirectPage.getParameters().put('sfls', selectedFieldIds);
        redirectPage.getParameters().put('formId', formId);
        if(startDate != null){
            redirectPage.getParameters().put('sDate', sDate);
            redirectPage.getParameters().put('eDate', eDate);
        }
        redirectPage.getParameters().put('title', title);
        redirectPage.setRedirect(true);
        return redirectPage;

    }
}