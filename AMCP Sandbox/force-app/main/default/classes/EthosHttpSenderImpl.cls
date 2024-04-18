public inherited sharing class EthosHttpSenderImpl implements EthosHttpSender{

  public HttpResponse send(HttpRequest request) {
    Http http = new Http();
    return http.send(request);
  }
}