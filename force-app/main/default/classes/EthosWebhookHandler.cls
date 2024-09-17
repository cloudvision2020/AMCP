@RestResource(urlMapping='/api/EthosWebhook/*')
global without sharing class EthosWebhookHandler {
    @HttpPost
    global static void handlePost() {
        
        RestRequest requestContext = RestContext.request;
        RestResponse responseContext = RestContext.response;
        
        String jsonString = requestContext.requestBody.toString();
        
        WHCourseEnrollment payload;
        
        try {
            System.debug('jsonString ' + jsonString);
            payload = (WHCourseEnrollment)JSON.deserialize(jsonString, WHCourseEnrollment.class);
        } catch (Exception e) {
            responseContext.statusCode = 400; // Bad Request
            responseContext.responseBody = Blob.valueOf('Invalid JSON payload.');
            System.debug('exception 1 ' + e.getMessage());
            return;
        }
        
        String price = payload.nid.price;
        String event = payload.nid.title;
        String contactFirstName = payload.uid.profile_profile.field_first_name;
        String contactLastName = payload.uid.profile_profile.field_last_name;
        String contactEmail = payload.uid.mail;
        Contact contact = new Contact();
        OrderApi__Item__c item = new OrderApi__Item__c();
        EventApi__Event__c ev = new EventApi__Event__c();
        EventApi__Attendee__c attendee = new EventApi__Attendee__c();
        
        try {
            if(price == '0.00000' || price == '0.0000' || price == '0.000' || price == '0.00' || price == '0') {
                
                contact = [SELECT Id, AccountId, Name FROM Contact WHERE FirstName =: contactFirstName AND LastName =: contactLastName AND Email =: contactEmail LIMIT 1];
                
                if(contact != new Contact()) {
                    
                    try {
                        ev = [SELECT Id FROM EventApi__Event__c WHERE EventApi__Display_Name__c =: event LIMIT 1];
                    } catch (QueryException e) {
                        ev = null;
                    }
                    
                    if (ev != null) {
                        item = [SELECT Id, OrderApi__Item_Class__c FROM OrderApi__Item__c WHERE Id IN (
                            SELECT EventApi__Item__c FROM EventApi__Ticket_Type__c 
                            WHERE EventApi__Is_Active__c = true 
                            AND EventApi__Event__c =: ev.Id) LIMIT 1];
                    } else {
                        item = [SELECT Id, OrderApi__Item_Class__c FROM OrderApi__Item__c WHERE OrderApi__Display_Name__c =: event LIMIT 1];
                    }
                    
                    if(item != new OrderApi__Item__c()) {
                        OrderApi__Sales_Order__c salesOrder = new OrderApi__Sales_Order__c();
                        salesOrder.OrderApi__Account__c = contact.AccountId;
                        salesOrder.OrderApi__Contact__c = contact.Id;
                        salesOrder.OrderApi__Date__c = Date.today();
                        salesOrder.OrderApi__Entity__c = 'Contact';
                        salesOrder.OrderApi__Posting_Entity__c = 'Invoice';
                        insert salesOrder;
                        
                        OrderApi__Sales_Order_Line__c sol = new OrderApi__Sales_Order_Line__c();
                        sol.OrderApi__Sales_Order__c = salesOrder.Id;
                        sol.OrderApi__Account__c = contact.AccountId;
                        sol.OrderApi__Contact__c = contact.Id;
                        sol.OrderApi__Item__c = item.Id;
                        sol.OrderApi__Item_Class__c = item.OrderApi__Item_Class__c;
                        sol.OrderApi__Price_Override__c = true;
                        sol.OrderApi__Sale_Price__c = 0;
                        
                        insert sol;
                        
                        salesOrder.OrderApi__Is_Closed__c = true;
                        salesOrder.OrderApi__Status__c = 'Closed';
                        update salesOrder;
                        
                        salesOrder.OrderApi__Is_Posted__c = true;
                        update salesOrder;
                        
                        if(ev != null){
                            EventApi__Attendee__c att = new EventApi__Attendee__c();
                            att.EventApi__Contact__c = contact.Id;
                            att.EventApi__Attendee_Event__c = ev.Id;
                            att.EventApi__Full_Name__c = contact.Name;
                            att.EventApi__Status__c = 'Registered';
                            att.EventApi__Sales_Order__c = salesOrder.Id;
                            att.EventApi__Sales_Order_Line__c = sol.Id;
                            insert att;
                        }
                        
                    }
                }
            }
            
            responseContext.statusCode = 201; // Created
            responseContext.responseBody = Blob.valueOf('Records created successfully');
            
        } catch (QueryException e) {
            
            if (e.getMessage().contains('List has no rows for assignment to SObject')) {
                
                responseContext.statusCode = 404;
                responseContext.responseBody = Blob.valueOf('No Contact or Item found ' + e.getMessage());
            } else {
                
                responseContext.statusCode = 500; // Internal Server Error
                responseContext.responseBody = Blob.valueOf('Error: ' + e.getMessage());
            }
        } 
    }
}