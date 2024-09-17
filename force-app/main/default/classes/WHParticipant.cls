public class WHParticipant {
    
    public String field_participant_category;
    public String uid;
    public String name;
    public String mail;
    public String url;
    public String edit_url;
    public String last_access;
    public String last_login;
    public String created;
    public List<Integer> roles;
    public String status;
    public String theme;
    public String feeds_item_guid;
    public String feeds_item_url;
    public String feed_nid;
    //public List<Object> flag_course_bookmark_flagged;
    public Integer flag_sid;
    //public List<WHRelationFacultyNodeReverse> relation_faculty_node_reverse;
    public String sms_user_phone_number;
    public String sms_user_status;
    public String sms_user_gateway;
    public String uuid;
    public WHProfileProfile profile_profile;
    //public WHProfileDisclosure profile_disclosure;

    public static WHParticipant parse(String json) {
        return (WHParticipant) System.JSON.deserialize(json, WHParticipant.class);
    }
}