@isTest
public class EthosWebhookHandlerTest {
    @isTest
    static void testHandlePost_ValidPayload() {
        // Setup test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'John', 
            LastName = 'Doe', 
            Email = 'john.doe@example.com', 
            AccountId = testAccount.Id
        );
        insert testContact;

        EventApi__Event__c testEvent = new EventApi__Event__c(EventApi__Display_Name__c = 'Test Event',
                                                              EventApi__Event_Key__c = '1234'
                                                             );
        insert testEvent;

        OrderApi__Item_Class__c iClass = new OrderApi__Item_Class__c(Name = 'test iclass');
        insert iClass;
        
        OrderApi__Item__c testItem = new OrderApi__Item__c(
            OrderApi__Display_Name__c = 'Test Item', 
            OrderApi__Item_Class__c = iClass.Id
        );
        insert testItem;

        EventApi__Ticket_Type__c testTicketType = new EventApi__Ticket_Type__c(
            EventApi__Item__c = testItem.Id,
            EventApi__Event__c = testEvent.Id,
            EventApi__Is_Active__c = true
        );
        insert testTicketType;

        String requestBody = '{"nid":{"price":"0.00","title":"Test Event"},"uid":{"profile_profile":{"field_first_name":"John","field_last_name":"Doe"},"mail":"john.doe@example.com"}}';
        
        // Mock the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        EthosWebhookHandler.handlePost();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(201, res.statusCode);
        System.assert(res.responseBody.toString().contains('Records created successfully'));
    }

    @isTest
    static void testHandlePost_InvalidPayload() {
        // Mock the REST request with invalid JSON
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf('Invalid JSON');
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        EthosWebhookHandler.handlePost();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(400, res.statusCode);
        System.assert(res.responseBody.toString().contains('Invalid JSON payload.'));
    }

    @isTest
    static void testHandlePost_NoContactFound() {
        String requestBody = '{"nid":{"price":"0.00","title":"Non-Existent Event"},"uid":{"profile_profile":{"field_first_name":"NonExistentFirstName","field_last_name":"NonExistentLastName"},"mail":"nonexistent@example.com"}}';
        
        // Mock the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        EthosWebhookHandler.handlePost();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(404, res.statusCode);
        System.assert(res.responseBody.toString().contains('No Contact or Item found'));
    }

    @isTest
    static void testHandlePost_NoItemFound() {
        // Setup test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'John', 
            LastName = 'Doe', 
            Email = 'john.doe@example.com', 
            AccountId = testAccount.Id
        );
        insert testContact;

        String requestBody = '{"nid":{"price":"0.00","title":"Non-Existent Event"},"uid":{"profile_profile":{"field_first_name":"John","field_last_name":"Doe"},"mail":"john.doe@example.com"}}';
        
        // Mock the REST request
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestBody = Blob.valueOf(requestBody);
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        EthosWebhookHandler.handlePost();
        Test.stopTest();
        
        // Assertions
        System.assertEquals(404, res.statusCode);
        System.assert(res.responseBody.toString().contains('No Contact or Item found'));
    }
    
     @IsTest
    static void testParseCourseEnrollment() {
        
        Test.startTest();
        String jsonString = '{"field_course_format":["format1","format2"],"field_course2":"course2","field_please_select_your_meal_pr":"meal","eid":"eid123","nid":{"price":"0.00","title":"courseTitle"},"enrollmenttype":"type1","status":"status1","created":"2023-01-01","timestamp":"2023-01-01T12:00:00Z","enroll_end":"2023-12-31","code":"code123","user_type":"userType1","type":{"id":"typeId1","type":"type1","label":"typeLabel1","status":"typeStatus1","module":"typeModule1","feeds_item_guid":"guid1","feeds_item_url":"url1","feed_nid":"nid1"},"uid":{"profile_profile":{"field_first_name":"firstName","field_last_name":"lastName"},"mail":"email@example.com"},"data":"someData","updated":"2023-01-02","feeds_item_guid":"guid1","feeds_item_url":"url1","feed_nid":"nid1"}';
        WHCourseEnrollment courseEnrollment = WHCourseEnrollment.parse(jsonString);
        Test.stopTest();
    }
    
    @IsTest
    static void testParseCourseWrapper() {
       
        String jsonString = '{' +
            '"field_course_rating_access": "access123",' +
            '"field_course_catalog": true,' +
            '"field_course_live": false,' +
            '"field_course_transcript": true,' +
            '"field_requirements_max": null,' +
            '"field_requirements_min": null,' +
            '"field_show_child_catalog": null,' +
            '"field_show_child_transcript": null,' +
            '"field_enrollment_requirement_min": null,' +
            '"field_show_on_calendar": true,' +
            '"field_job_code": null,' +
            '"field_primary_speciality": null,' +
            '"model": "model123",' +
            '"list_price": "100.00",' +
            '"cost": "50.00",' +
            '"sell_price": "75.00",' +
            '"price": "75.00",' +
            '"weight": "1.0",' +
            '"weight_units": "kg",' +
            '"length": "10.0",' +
            '"width": "5.0",' +
            '"height": "2.0",' +
            '"length_units": "cm",' +
            '"pkg_qty": "1",' +
            '"ordering": "1",' +
            '"shippable": "true",' +
            '"nid": "nid123",' +
            '"vid": "vid123",' +
            '"is_new": true,' +
            '"type": "course",' +
            '"title": "Course Title",' +
            '"language": "English",' +
            '"url": "http://example.com",' +
            '"edit_url": "http://example.com/edit",' +
            '"status": "active",' +
            '"promote": "yes",' +
            '"sticky": "no",' +
            '"created": "2023-01-01",' +
            '"changed": "2023-01-02"' +
        '}';

        Test.startTest();
        	WHCourseWrapper courseWrapper = WHCourseWrapper.parse(jsonString);
        Test.stopTest();
    }
    
    @IsTest
    static void testParseParticipant() {
        
        String jsonString = '{' +
            '"field_participant_category": "Category A",' +
            '"uid": "12345",' +
            '"name": "John Doe",' +
            '"mail": "johndoe@example.com",' +
            '"url": "http://example.com",' +
            '"edit_url": "http://example.com/edit",' +
            '"last_access": "2023-01-01T12:34:56Z",' +
            '"last_login": "2023-01-01T12:00:00Z",' +
            '"created": "2023-01-01T00:00:00Z",' +
            '"roles": [1, 2, 3],' +
            '"status": "active",' +
            '"theme": "default",' +
            '"feeds_item_guid": "guid123",' +
            '"feeds_item_url": "http://example.com/feed",' +
            '"feed_nid": "nid123",' +
            '"flag_sid": 1,' +
            '"sms_user_phone_number": "123-456-7890",' +
            '"sms_user_status": "verified",' +
            '"sms_user_gateway": "gateway1",' +
            '"uuid": "uuid123"' +
        '}';

        WHParticipant participant = WHParticipant.parse(jsonString);
    }
    
     @IsTest
    static void testParseProfile() {

        String jsonString = '{' +
            '"field_first_name": "John",' +
            '"field_last_name": "Doe",' +
            '"field_middle_name": "M",' +
            '"field_name_prefix": "Mr.",' +
            '"field_profile_location": [],' +
            '"field_primary_speciality": "Speciality A",' +
            '"field_accme_ids": [{' +
                '"uri": "uri1",' +
                '"id": "id1",' +
                '"resource": "resource1",' +
                '"uuid": "uuid1"' +
            '}],' +
            '"field_preferred_pronouns": "He/Him",' +
            '"field_accme_ids_abim": {' +
                '"uri": "uri_abim",' +
                '"id": "id_abim",' +
                '"resource": "resource_abim",' +
                '"uuid": "uuid_abim"' +
            '},' +
            '"pid": "pid1",' +
            '"vid": "vid1",' +
            '"type": {' +
                '"uri": "type_uri",' +
                '"id": "type_id",' +
                '"resource": "type_resource"' +
            '},' +
            '"label": "Label A",' +
            '"created": "2023-01-01T00:00:00Z",' +
            '"changed": "2023-01-02T00:00:00Z",' +
            '"url": "http://example.com",' +
            '"user": {' +
                '"uri": "user_uri",' +
                '"id": "user_id",' +
                '"resource": "user_resource",' +
                '"uuid": "user_uuid"' +
            '},' +
            '"feeds_item_guid": "guid123",' +
            '"feeds_item_url": "http://example.com/feed",' +
            '"feed_nid": "nid123"' +
        '}';

        WHProfileProfile profile = WHProfileProfile.parse(jsonString);
    }
}