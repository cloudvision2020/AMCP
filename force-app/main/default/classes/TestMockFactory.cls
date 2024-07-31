@IsTest
public class TestMockFactory {

  public static final String GET_USER_SUCCESS_RESPONSE_BODY = '{' +
    '"self":"http://your-domain.com/user?mail=external_user%40dlcdev.com",' +
    ' "first":"http://your-domain.com/user?mail=external_user%40dlcdev.com\\u0026page=0",' +
    ' "last":"http://your-domain.com/user?mail=external_user%40dlcdev.com\\u0026page=0",' +
    ' "list":[' +
    '{' +
      '"uid":"200",' +
      ' "name":"external_user",' +
      ' "mail":"external_user@dlcdev.com",' +
      ' "url":"http://your-domain.com/users/external_user",' +
      ' "edit_url":"http://your-domain.com/user/200/edit",' +
      ' "last_access":"1469471140",' +
      ' "last_login":"1469469525",' +
      ' "created":"1459800968",' +
      ' "roles":[2],' +
      ' "status":"1",' +
      ' "profile_profile":' +
      '{' +
        '"uri":"http://your-domain.com/profile2/46",' +
        '"id":"46", "resource":"profile2"}, ' +
        '"uuid":"ba5bc8af-25d7-48de-bb54-87ae70ac33b5"' +
      '}' +
    ']' +
    '}';

  public static final String GET_CART_SUCCESS_RESPONSE_BODY = '{' +
    '"self":"http://your-domain.com/user?mail=external_user%40dlcdev.com",' +
    '"first":"http://your-domain.com/user?mail=external_user%40dlcdev.com\\u0026page=0",' +
    '"last":"http://your-domain.com/user?mail=external_user%40dlcdev.com\\u0026page=0",' +
    '"list":[' +
      '{' +
      '"cart_item_id":"36",' +
      '"cart_id":"200", ' +
      '"nid":"ETHOS", ' +
      '"qty":"1", ' +
      '"changed":"1458745078", ' +
      '"node" : ' +
        '{' +
          '"uri" :"http://your-domain/node/70", ' +
          '"id"  :"ETHOS", ' +
          '"resource" : "node", ' +
          '"uuid" : "c8de7a61-0d7c-48b0-b146-289d8ed2524d"' +
        '} ' +
      '}' +
    '] ' +
    '}';

  private static final String ENROLL_SUCCESS_RESPONSE_BODY = '{' +
    '"uri":"http://your-domain.com/course_enrollment/500",' +
    '"id":"500",' +
    '"resource":"course_enrollment"' +
    '}';
    
  private static final String PROFILE_UPDATE_SUCCESS_RESPONSE_BODY = '{' +
    '"uri":"http://your-domain.com/profile2/46",' +
    '"id":"46",' +
    '"resource":"profile2"' +
    '}';

  public static EthosCalloutMock.Stub getGetUser(){
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    String body = GET_USER_SUCCESS_RESPONSE_BODY;

    response.setBody(body);
    return new EthosCalloutMock.Stub(response);
  }

  public static EthosCalloutMock.Stub getGetUserSuccessWithSpecificEmail(String email){
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    String body = GET_USER_SUCCESS_RESPONSE_BODY;
    body = body.replace('external_user@dlcdev.com', email);

    response.setBody(body);
    return new EthosCalloutMock.Stub(response);
  }

  public static EthosCalloutMock.Stub getGetCart(){
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    response.setBody(GET_CART_SUCCESS_RESPONSE_BODY);

    return new EthosCalloutMock.Stub(response);

  }

  public static EthosCalloutMock.Stub getEnroll(){
    HttpResponse response = new HttpResponse();
    response.setStatusCode(201);
    response.setBody(ENROLL_SUCCESS_RESPONSE_BODY);
    return new EthosCalloutMock.Stub(response);
  }

  public static EthosCalloutMock.Stub getClearCart(){
    HttpResponse response = new HttpResponse();
    response.setStatusCode(200);
    return new EthosCalloutMock.Stub(response);
  }

  public static EthosCalloutMock.Stub getGetUserSuccessAndEnrollSuccess(){
    HttpResponse getUserResponse = new HttpResponse();
    getUserResponse.setStatusCode(200);
    getUserResponse.setBody(GET_USER_SUCCESS_RESPONSE_BODY);
      
    HttpResponse profileUpdateResponse = new HttpResponse();
    profileUpdateResponse.setStatusCode(200);
    profileUpdateResponse.setBody(PROFILE_UPDATE_SUCCESS_RESPONSE_BODY);

    HttpResponse enrollResponse = new HttpResponse();
    enrollResponse.setStatusCode(201);
    enrollResponse.setBody(ENROLL_SUCCESS_RESPONSE_BODY);

    return new EthosCalloutMock.Stub(new List<HttpResponse>{getUserResponse, getUserResponse, profileUpdateResponse, enrollResponse});
  }

  public static EthosCalloutMock.Stub getFailureCall(){
    HttpResponse getUserResponse = new HttpResponse();
    getUserResponse.setStatusCode(404);
    getUserResponse.setBody('Zut');
    return new EthosCalloutMock.Stub(new List<HttpResponse>{getUserResponse});
  }

  public static EthosCalloutMock.Stub getGetUserAndGetCart(){
    HttpResponse getUserResponse = new HttpResponse();
    getUserResponse.setStatusCode(200);
    String body = GET_USER_SUCCESS_RESPONSE_BODY;
    getUserResponse.setBody(body);

    HttpResponse getCartResponse = new HttpResponse();
    getCartResponse.setStatusCode(200);
    getCartResponse.setBody(GET_CART_SUCCESS_RESPONSE_BODY);

    List<HttpResponse> responses = new List<HttpResponse>();
    responses.add(getUserResponse);
    responses.add(getCartResponse);


    return new EthosCalloutMock.Stub(responses);


  }

}