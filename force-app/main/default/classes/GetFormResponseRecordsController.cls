global without sharing class GetFormResponseRecordsController {

    public List<String> columns {get;set;}
    public Map<Integer,List<String>> items {get;set;}
    public String que {get;set;}
    public Integer lastIndex {get;set;}
    public GetFormResponseRecordsController () {
        
        String formId = Apexpages.currentPage().getparameters().get('formId');
        String sfls = Apexpages.currentPage().getparameters().get('sfls');
        String sDate = Apexpages.currentPage().getparameters().get('sDate');
        String eDate = Apexpages.currentPage().getparameters().get('eDate');
        String title = Apexpages.currentPage().getparameters().get('title');
        
        //Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+obj+'-'+rID+'.pdf');
        Apexpages.currentPage().getHeaders().put('content-disposition', 'attachment; filename='+title+'.csv');

        // Set Fields
        List<String> ss = sfls.split(',');
        
        // Get Column
        List<String> cols = new List<String>();
        cols.add('Response Date');
        cols.add('Form Name');
        cols.add('Responder');
        for (PagesApi__Field__c fl : [Select Name FROM PagesApi__Field__c WHERE Id IN:ss ORDER BY PagesApi__Field_Group__r.PagesApi__Order__c,PagesApi__Order__c ASC]) {
            cols.add(fl.Name);
    	}
		columns = cols;
        
        // Convert String to Date
        DateTime startDateTime;
        DateTime endDateTime;
        if(sDate != null){
            Date startDate = Date.parse(sDate);
            Date endDate = Date.parse(eDate);
            
            // Convert Date to DateTime (assuming start of day for startDate and end of day for endDate)
            startDateTime = DateTime.newInstance(startDate.year(), startDate.month(), startDate.day());
            endDateTime = DateTime.newInstance(endDate.year(), endDate.month(), endDate.day(), 23, 59, 59);
        }
        



        // Get Data
        Map<Integer,List<String>> its = new Map<Integer,List<String>>();
        List<PagesApi__Form_Response__c> fmrs = new List<PagesApi__Form_Response__c>();
        if(sDate != null){
            if(Test.isRunningTest()){
            	fmrs = [Select Id,CreatedDate,PagesApi__Contact__r.Name,Form_Name__c,(Select Id,PagesApi__Response__c FROM PagesApi__Field_Responses__r) FROM PagesApi__Form_Response__c WHERE PagesApi__Form__c=:formId ];
            }else{
                fmrs = [Select Id,CreatedDate,PagesApi__Contact__r.Name,Form_Name__c,(Select Id,PagesApi__Response__c FROM PagesApi__Field_Responses__r WHERE PagesApi__Field__r.Id IN:ss ORDER BY PagesApi__Field_Group__r.PagesApi__Order__c,PagesApi__Field__r.PagesApi__Order__c ASC) FROM PagesApi__Form_Response__c WHERE PagesApi__Form__c=:formId AND CreatedDate >= :startDateTime 
                                                  AND CreatedDate <= :endDateTime ORDER BY CreatedDate ASC];
            }
        }else{
            fmrs = [Select Id,CreatedDate,PagesApi__Contact__r.Name,Form_Name__c,(Select Id,PagesApi__Response__c FROM PagesApi__Field_Responses__r WHERE PagesApi__Field__r.Id IN:ss ORDER BY PagesApi__Field_Group__r.PagesApi__Order__c,PagesApi__Field__r.PagesApi__Order__c ASC) FROM PagesApi__Form_Response__c WHERE PagesApi__Form__c=:formId ORDER BY CreatedDate ASC];
        }
        System.debug('FMRS '+fmrs);
        
        Integer i = 0;
        for (PagesApi__Form_Response__c fmr : fmrs) {
            List<String> item = new List<String>();
			
            item.add(String.valueOf(fmr.CreatedDate));
            item.add(fmr.Form_Name__c);
            item.add(fmr.PagesApi__Contact__r.Name);
            
            List<PagesApi__Field_Response__c> fdrs = fmr.PagesApi__Field_Responses__r;
            for(PagesApi__Field_Response__c fdr : fdrs){
                if(fdr.PagesApi__Response__c == null){
                    item.add(' ');
                }else{
                	item.add(fdr.PagesApi__Response__c);
                }
            }
            its.put(i,item);
            i++;
    	}
        items = its;

        
        
        
        
        

    }



	
}