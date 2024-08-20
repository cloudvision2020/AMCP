public class WHProfileProfile {
    
    public String field_first_name;
    public String field_last_name;
    public String field_middle_name;
    public String field_name_prefix;
    public List<Object> field_profile_location;
    public String field_primary_speciality;
    public List<FieldAccmeIds> field_accme_ids;
    public String field_preferred_pronouns;
    public FieldAccmeIdsAbim field_accme_ids_abim;
    public String pid;
    public String vid;
    public ProfileType type;
    public String label;
    public String created;
    public String changed;
    public String url;
    public ProfileUser user;
    public String feeds_item_guid;
    public String feeds_item_url;
    public String feed_nid;
    
    public class FieldAccmeIds {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
    
    public class FieldAccmeIdsAbim {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
    
    public class ProfileType {
        public String uri;
        public String id;
        public String resource;
    }
    
    public class ProfileUser {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
    
    public static WHProfileProfile parse(String json) {
        return (WHProfileProfile) System.JSON.deserialize(json, WHProfileProfile.class);
    }
}