public inherited sharing class EthosEnrollmentBuilder {

  private final String ENROLLMENT_TYPE = 'webservice_call';
  private final String TYPE = 'course_enrollment';
  private final String STATUS = '1';

  public List<EthosEnrollment> build(List<String> courseNodeIds, String ethosUserId){

    List<EthosEnrollment> enrollments = new List<EthosEnrollment>();

    for(String courseNodeId : courseNodeIds){
      enrollments.add(build(courseNodeId, ethosUserId));
    }

    return enrollments;
  }

  public EthosEnrollment build(String courseNodeId, String ethosUserId){
    EthosEnrollment enrollment = new EthosEnrollment();
    enrollment.uid = ethosUserId;
    enrollment.nid = courseNodeId;
    enrollment.enrollmenttype = ENROLLMENT_TYPE;
    enrollment.type = TYPE;
    enrollment.status = STATUS;
    return enrollment;
  }

}