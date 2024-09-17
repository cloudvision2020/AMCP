public class FON_DeleteLog implements Database.Batchable<sObject>, Schedulable {
    
    public List<SObject> start(Database.BatchableContext BC) {
        List <Apexlog> loglist = [Select Id from Apexlog];
        return loglist;
    }
    
    public void execute(Database.BatchableContext BC, List<Apexlog> loglist) {
        for(Apexlog al: loglist){
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(Url.getOrgDomainUrl().toExternalForm()
            + '/services/data/v44.0/sobjects/Apexlog/'+al.Id);
            req.setMethod('DELETE');
            req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionId());
            HttpResponse res = h.send(req);
            System.debug(res.getStatusCode());
        }
    }
    
    public void finish(Database.BatchableContext BC) {
        
    }
    
    public void execute(SchedulableContext sc) {
    
    }
    
}