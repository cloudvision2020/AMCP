public class WHCourseWrapper {

    public String field_course_rating_access;
    public Boolean field_course_catalog;
    public Boolean field_course_live;
    public Boolean field_course_transcript;
    public Object field_requirements_max;
    public Object field_requirements_min;
    public Object field_show_child_catalog;
    public Object field_show_child_transcript;
    public Object field_enrollment_requirement_min;
    public Boolean field_show_on_calendar;
    public Object field_job_code;
    public Object field_primary_speciality;
    public String model;
    public String list_price;
    public String cost;
    public String sell_price;
    public String price;
    public String weight;
    public String weight_units;
    public String length;
    public String width;
    public String height;
    public String length_units;
    public String pkg_qty;
    public String ordering;
    public String shippable;
    public String nid;
    public String vid;
    public Boolean is_new;
    public String type;
    public String title;
    public String language;
    public String url;
    public String edit_url;
    public String status;
    public String promote;
    public String sticky;
    public String created;
    public String changed;
    
    public class FieldCourseCompletionMessage {
        public String value;
        public String format;
    }

    public class FieldCourseDate {
        public String value;
        public String value2;
        public Long duration;
    }

    public class FieldCourseEventDate {
        public String value;
        public String value2;
        public Long duration;
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

    public static WHCourseWrapper parse(String json) {
        return (WHCourseWrapper) System.JSON.deserialize(json, WHCourseWrapper.class);
    }
}