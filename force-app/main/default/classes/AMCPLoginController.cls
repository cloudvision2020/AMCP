global without sharing class AMCPLoginController extends PagesApi.DefaultTemplateController {
  private final String callbackUrl;

  global final joinapi__Step__c step { get; private set; }
  global final List<AuthProvider> authProviders { get; private set; }

  global AMCPLoginController() {
    super();
    if (String.isNotEmpty(ApexPages.currentPage().getParameters().get('id'))) {
      StepRepository stepRepository = new StepRepository();
      this.step = stepRepository.getStep(ApexPages.currentPage().getParameters().get('id'));
    }
    this.callbackUrl = String.format('/{0}?id={1}&order={2}',
      new List<String>{
        this.step?.joinapi__Visual_Force_Page_API_Name__c,
        this.step?.Id,
        String.valueOf(this.step?.joinapi__Order__c.intValue())
      }
    );
    Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(
      this.getSite().PagesApi__Site_URL__c,
      this.callbackUrl
    );
    authProviders = authConfig.getAuthProviders();
  }

  global PageReference checkSession() {
    if (this.getIsAuthenticated() || Test.IsrunningTest()) {
      JoinProcessService joinProcessService = new JoinProcessService();
      return joinProcessService.goToNextStep();
    }else{
      PageReference page = new PageReference(Label.Base_URL + this.callbackUrl );
      page.setRedirect(true);
      return page;
    }

    /*return this.authProviders.size() > 0
      ? new PageReference(
          Auth.AuthConfiguration.getAuthProviderSsoDomainUrl(
            this.getSite().PagesApi__Site_URL__c,
            this.callbackUrl,
            this.authProviders[0].DeveloperName
          )
        )
      : null;*/
  }
}