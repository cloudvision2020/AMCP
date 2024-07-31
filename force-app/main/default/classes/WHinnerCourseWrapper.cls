public class WHinnerCourseWrapper {

    public Nid nid { get; set; }
    public String outline { get; set; }
    public String credits { get; set; }
    public String open { get; set; }
    public String close { get; set; }
    public String duration { get; set; }
    public String external_id { get; set; }
    public String enrollment_type { get; set; }
    public Relationships relationships { get; set; }
    public Boolean course_date_open { get; set; }
    public List<String> course_credit_types { get; set; }
    public Object feeds_item_guid { get; set; }
    public Object feeds_item_url { get; set; }
    public Object feed_nid { get; set; }

    public class Nid {
        public String uri { get; set; }
        public String id { get; set; }
        public String resource { get; set; }
        public String uuid { get; set; }
    }

    public class Relationships {
        public String credit_options { get; set; }
        public String enroll_options { get; set; }
        public String auto_enroll { get; set; }
    }

    public static WHinnerCourseWrapper parse(String jsonString) {
        return (WHinnerCourseWrapper) System.JSON.deserialize(jsonString, WHinnerCourseWrapper.class);
    }
}