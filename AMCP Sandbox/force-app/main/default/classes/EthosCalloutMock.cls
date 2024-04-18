@IsTest
public class EthosCalloutMock{

  public class Stub implements HttpCalloutMock{

    private List<HttpResponse> responses = new List<HttpResponse>();

    public Stub(HttpResponse response){
      this.responses.add(response);
    }

    public Stub (List<HttpResponse> responses){
      this.responses = responses;
    }

    public HttpResponse respond(HttpRequest param1) {
      HttpResponse response = responses[0];
      responses.remove(0);
      return response;
    }
  }
}