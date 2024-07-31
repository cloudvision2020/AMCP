public class WHFieldCourseImage {
    
    public Object field_file_image_alt_text;
    public Object field_file_image_title_text;
    public String fid;
    public String name;
    public String mime;
    public String size;
    public String url;
    public String timestamp;
    public Owner owner;
    public String type;
    public Object feeds_item_guid;
    public Object feeds_item_url;
    public Object feed_nid;
    public String uuid;
    
    public class Owner {
        public String uri;
        public String id;
        public String resource;
        public String uuid;
    }
    
    public class FieldCourseIntro {
        public String value;
        public String format;
    }
    
    public class FieldCourseLocation {
        public String lid;
        public String latitude;
        public String longitude;
        public String name;
        public String street;
        public String additional;
        public String city;
        public String province;
        public String postal_code;
        public String country;
        public String province_name;
        public String country_name;
        public Object phone;
        public Object fax;
        public Object email;
        public Object www;
    }
    
    public class FieldCourseSummary {
        public String value;
        public String summary;
        public String format;
    }

    public class FieldFacultyCredentials {
        public String value;
        public String format;
    }

    public class FieldLearningObjectives {
        public String value;
        public String format;
    }

    public class FieldTargetAudience {
        public String value;
        public String format;
    }
}