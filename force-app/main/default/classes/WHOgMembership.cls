public class WHOgMembership {
    public Object og_membership_request;
    public String id;
    public OgMembershipType type;
    public String entity_type;
    public String group_type;
    public String state;
    public String created;
    public String field_name;
    public String language;
    //public OgMembershipGroup group; reserved_word
    public OgMembershipEntity entity;
    public String etid;
    public String gid;
    public Object feeds_item_guid;
    public Object feeds_item_url;
    public Object feed_nid;
    
    public class OgMembershipType {
        public String uri;
        public String id;
        public String resource;
    }
    
    public class OgMembershipGroup {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
    
    public class OgMembershipEntity {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
}