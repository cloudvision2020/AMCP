public inherited sharing class EthosWebServiceCaller {

  private final EthosHttpSender httpSender;
  private final EthosSettings settings;

  private final EthosUserFetcher userFetcher;
  private final EthosCartTransformer cartTransformer;
  private final EthosEnrollmentBuilder enrollmentBuilder;

  public static EthosWebServiceCaller getInstance(){
    return new EthosWebServiceCaller(
      new EthosHttpSenderImpl(),
      new EthosSettings(),
      new EthosUserFetcher(),
      new EthosCartTransformer(),
      new EthosEnrollmentBuilder()
    );
  }

  public EthosWebServiceCaller (
    EthosHttpSender httpSender,
    EthosSettings settings,
    EthosUserFetcher userFetcher,
    EthosCartTransformer cartTransformer,
    EthosEnrollmentBuilder enrollmentBuilder
  ){
    this.httpSender = httpSender;
    this.settings = settings;
    this.userFetcher = userFetcher;
    this.cartTransformer = cartTransformer;
    this.enrollmentBuilder = enrollmentBuilder;
  }

  public List<EthosUser> getAllUsers(){
    String userEndpoint = '/user.json';
    HttpRequest request = generateGetRequest(userEndpoint);
    String responseBody = sendHttpRequest(request);
    return userFetcher.retrieveMultipleUsers(responseBody);
  }

  public String getOrders(String ethosUserId){
    String orderEndpoint = '/uc_order.json?uid=';
    String cartQueryEndpoint = orderEndpoint+ethosUserId;
    HttpRequest request = generateGetRequest(cartQueryEndpoint);
    String responseBody = sendHttpRequest(request);
    return responseBody;
  }

  public EthosUser getUser(String email){

    String userEndpoint = '/user.json?mail=';
    String userQueryEndpoint = userEndpoint+email;
    HttpRequest request = generateGetRequest(userQueryEndpoint);
    String responseBody = sendHttpRequest(request);
    return userFetcher.retrieveSingleUser(responseBody);
  }

  public EthosCart getCart(String ethosUserId) {
    String cartEndpoint = '/uc_cart_item.json?cart_id=';
    String cartQueryEndpoint = cartEndpoint+ethosUserId;
    HttpRequest request = generateGetRequest(cartQueryEndpoint);
    String responseBody = sendHttpRequest(request);
    return cartTransformer.transform(responseBody);
  }

  public List<String> clearCart(List<String> cartItemIds){

    List<String> responses = new List<String>();

    for(String cartItemId :cartItemIds){
      String endpoint = '/uc_cart_item/'+cartItemId;
      HttpRequest request = generateDeleteRequest(endpoint);
      String responseBody = sendHttpRequest(request);
      responses.add(responseBody);
    }
    return responses;
  }

  public String getAllCourses(){
    String cartEndpoint = '/course.json?';
    HttpRequest request = generateGetRequest(cartEndpoint);
    String responseBody = sendHttpRequest(request);
    return responseBody;
  }

  public String getCourse(String courseNodeId){
    String cartEndpoint = '/node.json?nid=';
    String cartQueryEndpoint = cartEndpoint+courseNodeId;
    HttpRequest request = generateGetRequest(cartQueryEndpoint);
    String responseBody = sendHttpRequest(request);
    return responseBody;
  }

  public String enroll(String courseNodeId, String ethosUserId){

    String enrollmentEndpoint = '/course_enrollment';
    EthosEnrollment enrollment = enrollmentBuilder.build(courseNodeId, ethosUserId);
    String serializedEnrollment = JSON.serialize(enrollment);
    HttpRequest request = generatePostRequest(enrollmentEndpoint,serializedEnrollment);
    String response = sendHttpRequest(request);

    return response;
  }

  public List<String> enroll(List<String> courseNodeIds, String ethosUserId){
    List<String> responses = new List<String>();

    String enrollmentEndpoint = '/course_enrollment';

    List<EthosEnrollment> ethosEnrollments = new List<EthosEnrollment>();

    for(String courseNodeId : courseNodeIds){
      ethosEnrollments.add(enrollmentBuilder.build(courseNodeId, ethosUserId));
      EthosEnrollment enrollment = enrollmentBuilder.build(courseNodeId, ethosUserId);
      String serializedEnrollment = JSON.serialize(enrollment);
      HttpRequest request = generatePostRequest(enrollmentEndpoint,serializedEnrollment);
      String response = sendHttpRequest(request);
      responses.add(response);
    }

    return responses;

  }
 
  public String updateProfileUserInfo(String serializedUser, String ethosProfileId){

    String enrollmentEndpoint = '/profile2/'+ethosProfileId;
    HttpRequest request = generatePutRequest(enrollmentEndpoint,serializedUser);
    String response = sendHttpRequest(request);
    return response;
  }
    
//  public String getCourseEnrollment(String ethosUserId, String courseId){
//    String enrollmentEndpoint = '/course_enrollment.json?uid='+ethosUserId+'&nid='+courseId;
//    HttpRequest request = generateGetRequest(enrollmentEndpoint);
//    String responseBody = sendHttpRequest(request);
//    return responseBody;
//  }
//
//  public String getAllCourseEnrollment(){
//    String enrollmentEndpoint = '/course_enrollment.json';
//    HttpRequest request = generateGetRequest(enrollmentEndpoint);
//    String responseBody = sendHttpRequest(request);
//    return responseBody;
//  }
//
//  public void deleteCourseEnrollment(String courseEnrollmentId){
//    String endpoint = '/course_enrollment/'+courseEnrollmentId;
//
//    HttpRequest request = generateDeleteRequest(endpoint);
//    String responseBody = sendHttpRequest(request);
//    System.debug(responseBody);
//
//  }

  private HttpRequest generateGetRequest(String queryEndpoint) {
    HttpRequest request = generateBasicRequest(queryEndpoint);
    request.setMethod('GET');
    return request;
  }

  private HttpRequest generatePutRequest(String endpoint, String body) {
    HttpRequest request = generateBasicRequest(endpoint);
    request.setHeader('Content-Type','application/json');
    request.setMethod('PUT');
    request.setBody(body);
    return request;
  }
  
  private HttpRequest generatePostRequest(String endpoint, String body) {
    HttpRequest request = generateBasicRequest(endpoint);
    request.setHeader('Content-Type','application/json');
    request.setMethod('POST');
    request.setBody(body);
    return request;
  }

  private HttpRequest generateDeleteRequest(String deleteEndpoint){
    HttpRequest request = generateBasicRequest(deleteEndpoint);
    request.setMethod('DELETE');
    return request;
  }

  private HttpRequest generateBasicRequest(String extraEndpoint) {
    String baseUrl = settings.getEndpoint();
    String finalEndpoint = baseUrl + extraEndpoint;
    HttpRequest request = new HttpRequest();
    request.setEndpoint(finalEndpoint);
    return request;
  }

  private String sendHttpRequest(HttpRequest request) {
    HttpResponse response = httpSender.send(request);

    if (response.getStatusCode() != 201 && response.getStatusCode() != 200) {
      String message ='Error code: ' + response.getStatusCode() +
        ' Error Message: ' + response.getBody() +
        'Request Endpoint: '+ request.getEndpoint() +
        'Request Body: '+ request.getBody();
      EthosException.FailedApiCallException failedApiCallException = new EthosException.FailedApiCallException();
      failedApiCallException.setMessage(message);

      throw failedApiCallException;
    }
    return response.getBody();
  }

}