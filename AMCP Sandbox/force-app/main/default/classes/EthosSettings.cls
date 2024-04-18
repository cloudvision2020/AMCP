public inherited sharing class EthosSettings {

  private final String BASE_URL = 'https://mcp.hosted.test.cloud.ethosce.com';
  private Boolean isSandbox;

  public String getBaseUrl(){
    return this.BASE_URL;
  }

  public String getEndpoint(){

    setIsSandbox();

    if(isSandbox){
      return 'callout:Ethos_Integration_Sandbox';
    } else{
      return 'callout:Ethos_Integration_Production';
    }
  }

  private void setIsSandbox() {
    if(isSandbox == null){
      isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
  }
}