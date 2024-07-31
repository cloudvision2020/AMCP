@isTest
public class WHCourseEnrollmentTest {
    
    @isTest
    static void testParse_ValidJson() {
        // Prepare a valid JSON string
        String validJson = '{' +
            '"field_course_format": ["online", "in-person"],' +
            '"field_course2": "Course Title",' +
            '"field_please_select_your_meal_pr": "Vegetarian",' +
            '"eid": "12345",' +
            '"nid": {' +
                '"price": "100.00",' +
                '"title": "Course Event"' +
            '},' +
            '"enrollmenttype": "full-time",' +
            '"status": "enrolled",' +
            '"created": "2023-06-25T12:34:56Z",' +
            '"timestamp": "2023-06-25T12:34:56Z",' +
            '"enroll_end": "2023-07-01T12:00:00Z",' +
            '"code": "ABC123",' +
            '"user_type": "student",' +
            '"type": {' +
                '"id": "1",' +
                '"type": "enrollment",' +
                '"label": "Full Time",' +
                '"status": "active",' +
                '"module": "module1",' +
                '"feeds_item_guid": "feed123",' +
                '"feeds_item_url": "http://example.com/feed",' +
                '"feed_nid": "feed_nid123"' +
            '},' +
            '"uid": {' +
                '"profile_profile": {' +
                    '"field_first_name": "John",' +
                    '"field_last_name": "Doe"' +
                '},' +
                '"mail": "john.doe@example.com"' +
            '},' +
            '"data": "Additional data",' +
            '"updated": "2023-06-26T12:34:56Z",' +
            '"feeds_item_guid": "item123",' +
            '"feeds_item_url": "http://example.com/item",' +
            '"feed_nid": "feed_nid456"' +
        '}';

        // Call the parse method
        WHCourseEnrollment enrollment = WHCourseEnrollment.parse(validJson);
        WHAuthor Author = WHAuthor.parse(validJson);


    }
}