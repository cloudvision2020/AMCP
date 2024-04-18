@IsTest
private class EthosEnrollmentBuilderTest {

  private static final EthosEnrollmentBuilder testObj = new EthosEnrollmentBuilder();


  @IsTest
  public static void whenMultiplesArePassed_listSameSizeIsReturned() {
    List<String> courseIds = new List<String>();
    courseIds.add('One');
    courseIds.add('Two');
    courseIds.add('Three');

    String ethosUserId = 'Test';

    Test.startTest();

    List<EthosEnrollment> enrollments = testObj.build(courseIds, ethosUserId);

    Test.stopTest();

    Assert.areEqual(courseIds.size(), enrollments.size());

    for (Integer i = 0; i < enrollments.size(); i++) {
      EthosEnrollment enrollment = enrollments[i];
      String courseId = courseIds[i];
      assertEnrollmentObject(courseId, enrollment, ethosUserId);
    }
  }

  private static void assertEnrollmentObject(String courseId, EthosEnrollment enrollment, String ethosUserId) {
    Assert.areEqual(courseId, enrollment.nid);
    Assert.areEqual(ethosUserId, enrollment.uid);
    Assert.areEqual('webservice_call', enrollment.enrollmenttype);
    Assert.areEqual('course_enrollment', enrollment.type);
    Assert.areEqual('1', enrollment.status);
  }
}