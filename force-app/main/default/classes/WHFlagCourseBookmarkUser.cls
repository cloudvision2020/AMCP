public class WHFlagCourseBookmarkUser {
    
    public List<OgUserNode> og_user_node { get; set; }
    public String field_participant_category { get; set; }
    public List<WHOgMembership> og_membership { get; set; }
    /* public List<OgMembership> og_membership__1 { get; set; }
    public List<OgMembership> og_membership__2 { get; set; }
    public List<OgMembership> og_membership__3 { get; set; }
    public List<OgMembership> og_user_node__og_membership { get; set; }
    public List<OgMembership> og_user_node__og_membership__1 { get; set; }
    public List<OgMembership> og_user_node__og_membership__2 { get; set; }
    public List<OgMembership> og_user_node__og_membership__3 { get; set; }*/
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
    //public List<FlagCourseBookmark> flag_course_bookmark_flagged { get; set; }
    public Integer flag_sid { get; set; }
    public List<Object> relation_faculty_node_reverse { get; set; }
    public String sms_user_phone_number { get; set; }
    public String sms_user_status { get; set; }
    public String sms_user_gateway { get; set; }
    public String uuid { get; set; }
    public WHProfileProfile profile_profile { get; set; }
    
    public class OgUserNode {
        public String uri { get; set; }
        public String id { get; set; }
        public String resource { get; set; }
        public String uuid { get; set; }
    }
    public class OgMembership {
        public String uri { get; set; }
        public Integer id { get; set; }
        public String resource { get; set; }
    }
    public class FlagCourseBookmark {
        public String uri { get; set; }
        public Integer id { get; set; }
        public String resource { get; set; }
        public String uuid { get; set; }
    }
    
    public class ProfileProfile {
        public String uri { get; set; }
        public String id { get; set; }
        public String resource { get; set; }
    }
    
    public static WHFlagCourseBookmarkUser parse(String jsonString) {
        return (WHFlagCourseBookmarkUser) System.JSON.deserialize(jsonString, WHFlagCourseBookmarkUser.class);
    }
}