public class WHAuthor {
    
    public String field_participant_category { get; set; }
    public String uid { get; set; }
    public String name { get; set; }
    public String mail { get; set; }
    public String url { get; set; }
    public String edit_url { get; set; }
    public String last_access { get; set; }
    public String last_login { get; set; }
    public String created { get; set; }
    public List<Integer> roles { get; set; }
    public String status { get; set; }
    public String theme { get; set; }
    public Object feeds_item_guid { get; set; }
    public Object feeds_item_url { get; set; }
    public Object feed_nid { get; set; }
    public List<FlagCourseBookmark> flag_course_bookmark_flagged { get; set; }
    public Integer flag_sid { get; set; }
    public List<RelationFacultyNodeReverse> relation_faculty_node_reverse { get; set; }
    public String sms_user_phone_number { get; set; }
    public String sms_user_status { get; set; }
    public String sms_user_gateway { get; set; }
    public String uuid { get; set; }
    public ProfileProfile profile_profile { get; set; }
    public ProfileProfile profile_bio { get; set; }
    public ProfileProfile profile_disclosure { get; set; }
    
    public class FlagCourseBookmark {
        public String uri { get; set; }
        public Integer id { get; set; }
        public String resource { get; set; }
        public String uuid { get; set; }
    }
    
    public class RelationFacultyNodeReverse {
        public String uri { get; set; }
        public String id { get; set; }
        public String resource { get; set; }
        public String uuid { get; set; }
    }
    
    public class ProfileProfile {
        public String uri { get; set; }
        public String id { get; set; }
        public String resource { get; set; }
    }
    
    public static WHAuthor parse(String jsonString) {
        return (WHAuthor) System.JSON.deserialize(jsonString, WHAuthor.class);
    }
}