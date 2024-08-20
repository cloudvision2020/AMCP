public class WHCourseEnrollment {

    public List<String> field_course_format;
    public String field_course2;
    public String field_please_select_your_meal_pr;
    public String eid;
    public WHCourseWrapper nid;
    public String enrollmenttype;
    public String status;
    public String created;
    public String timestamp;
    public String enroll_end;
    public String code;
    public String user_type;
    public WHParticipant uid;
    public String data;
    public String updated;
    public String feeds_item_guid;
    public String feeds_item_url;
    public String feed_nid;

    public class EnrollmentType {
        public String id;
        public String type;
        public String label;
        public String status;
        public String module;
        public String feeds_item_guid;
        public String feeds_item_url;
        public String feed_nid;
    }

    public static WHCourseEnrollment parse(String json) {
        return (WHCourseEnrollment) System.JSON.deserialize(json, WHCourseEnrollment.class);
    }
}