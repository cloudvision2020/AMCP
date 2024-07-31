public without sharing class GetCYRILReportDownloaderController {
        
    @AuraEnabled
    public static List<Report> getReports(){
        return [SELECT Id, Name, DeveloperName, FolderName FROM Report ORDER BY Name ASC];
    }
    
    @AuraEnabled
    public static Map<String, String> configBatch(String reportId, String column, String title, String rId){
        Integer columnNumber = 0;
        if(!String.isBlank(column)){
            if(column.isNumeric()){
                columnNumber = Integer.valueOf(column) - 1; 
            }
        }
        Map<String, String> reportDetails = new Map<String, String>();
        // get report fields and object
		String endpoint =  'callout:FONSandboxNC/services/data/v59.0/analytics/reports/' + reportId + '?includeDetails=true';

        // Setup HTTP request
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');

        system.debug('USER SESSION '+UserInfo.getSessionId());
        // Send request
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        // Check if redirection is needed
        if (res.getStatusCode() >= 300 && res.getStatusCode() < 400) {
            String newLocation = res.getHeader('Location');
            if (String.isNotBlank(newLocation)) {
                // Modify the request to the new location
                req.setEndpoint(newLocation);
    
                // Send the new request
                res = http.send(req);
            }
        }


        reportDetails.put('repId',reportId);
        reportDetails.put('colNumber',column);
        reportDetails.put('title',title);

        
        // Parse the response
		boolean redirect = false;
        if (res.getStatusCode() == 200) {
            // Deserialize the JSON response
            Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            Map<String, Object> reportMetadata = (Map<String, Object>) resBody.get('reportMetadata');

            // Extract fields and sObject name
            if (reportMetadata != null) {
                if (reportMetadata.containsKey('detailColumns')) {
                    List<Object> detailColumns = (List<Object>) reportMetadata.get('detailColumns');
                    List<String> fields = new List<String>();
                    for (Object col : detailColumns) {
                        fields.add(String.valueOf(col));
                    }
                    if(fields.size()>0){
                        String fls = String.join(fields, ', '); // This uses a comma and a space as the delimiter
    
                        reportDetails.put('fields', fls);
                    }
                }

                if (reportMetadata.containsKey('reportType')) {
                    Map<String, Object> reportType = (Map<String, Object>) reportMetadata.get('reportType');
                    if (reportType != null && reportType.containsKey('sobjectType')) {
                        String sObjectType = (String) reportType.get('sobjectType');
                        reportDetails.put('sObjectType', sObjectType);
                    }
                }
            }
        } else {
            
            
            
            // Handle errors
            System.debug('Error fetching report metadata: ' + res.getStatusCode() + ' ' + res.getBody());
        }
        system.debug(res.getBody());

 
        return reportDetails;
    }
    
    public static String getFieldApiNameByLabel(String objectApiName, String fieldLabel) {
        // Get the object's description
        Schema.DescribeSObjectResult describeResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();
    
        // Loop through all fields
        for (Schema.SObjectField field : describeResult.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldDescribe = field.getDescribe();
    
            // Check if the label matches
            if (fieldDescribe.getLabel() == fieldLabel) {
                return fieldDescribe.getName(); // Return the API name of the field
            }
        }
        return null; // Return null if not found
    }

}