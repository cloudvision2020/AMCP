public without sharing class GetCYRILReportDownloaderCSVController {
    public String repId {get;set;}
    public String obj {get;set;}
    public String fls {get;set;}
    public Integer colNumber {get;set;}
    
    public List<String> columns {get;set;}
    public Map<Integer,List<String>> items {get;set;}
    public String que {get;set;}
    public Integer lastIndex {get;set;}
    public GetCYRILReportDownloaderCSVController() {
        
        
        // get records from report
        List<String> listIds = new List<String>();
        
        if(Test.isRunningTest() == false){
            if(!String.isBlank(repId)){
                // Run a report synchronously
                Reports.reportResults results = Reports.ReportManager.runReport(repId, true);        
                Reports.ReportFactWithDetails factWithDetails =
                    (Reports.ReportFactWithDetails) results.getFactMap().get('T!T');        
                for (Reports.ReportDetailRow row : factWithDetails.getRows()) {
                    
                    listIds.add(row.getDataCells().get(colNumber).getLabel());
                }
            }
        }
        
    }
}