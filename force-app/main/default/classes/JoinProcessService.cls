public with sharing class JoinProcessService {
  private String stepId;
  private final joinApi.JoinUtils joinUtil;

  public JoinProcessService() {
    stepId = Framework.PageUtils.getParam('id');
    joinUtil = new joinApi.JoinUtils(stepId);
  }

  public PageReference goToNextStep() {
    String redirectURL = Test.isRunningTest()
      ? 'http://test.domain.go'
      : joinUtil.navStepsMap.get('Next');
    JSONGenerator gen = JSON.createGenerator(true);
    gen.writeStartObject();
    gen.writeStringField('stepId', stepId);
    gen.writeStringField('redirectURL', redirectURL);
    gen.writeEndObject();
    joinUtil.setRedirectURLCookie(gen.getAsString());
    return new PageReference(redirectURL);
  }

  public PageReference cancel() {
    joinUtil.deleteCookies();
    return new PageReference(
      Test.isRunningTest()
        ? 'http://test.domain.go'
        : joinUtil.navStepsMap.get('First')
    );
  }
}