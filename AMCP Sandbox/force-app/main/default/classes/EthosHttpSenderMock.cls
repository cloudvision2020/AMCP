public inherited sharing class EthosHttpSenderMock implements EthosHttpSender{

  public List<HttpResponse> responses = new List<HttpResponse>();

  public HttpResponse send(HttpRequest request) {
    HttpResponse response = responses[0];
    responses.remove(0);
    return response;
  }
}