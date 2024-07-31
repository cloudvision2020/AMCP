@IsTest
public with sharing class SiteTestFactory {
  public static PagesApi__Site__c makeSite() {
  
      OrderApi__Payment_Gateway__c pGateway = new OrderApi__Payment_Gateway__c();
      pGateway.OrderApi__Is_Enabled__c = true;
      pGateway.OrderApi__Is_Test__c = true;
      pGateway.Name = 'Test';
      insert pGateway;
      
      OrderApi__Store__c store = new OrderApi__Store__c();
      store.OrderApi__Is_Published__c = true;
      store.Name = 'Test Store';
      store.OrderApi__New_Contact_Fieldset_CSV__c = 'Contact_Information';
      store.OrderApi__Gateway__c = pGateway.Id;
    
      insert store;


      PagesApi__Theme__c theme = new PagesApi__Theme__c(Name = 'Test');
      insert theme;

    PagesApi__Site__c result = new PagesApi__Site__c(
      OrderApi__Store__c = store.Id,
      PagesApi__Is_Default__c = true,
      PagesApi__Is_Published__c = true,
      PagesApi__Theme__c = theme.Id,
      PagesApi__Site_URL__c = 'https://test.go'
    );
    insert result;
    return result;
  }
}