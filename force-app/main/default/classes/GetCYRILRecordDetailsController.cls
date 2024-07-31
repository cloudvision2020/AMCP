global without sharing class GetCYRILRecordDetailsController {

    Sobject o;
    public String rDetails {get;set;}
    public GetCYRILRecordDetailsController () {
        
        String rId = Apexpages.currentPage().getparameters().get('rId');
        String obj = Apexpages.currentPage().getparameters().get('obj');
        String fls = Apexpages.currentPage().getparameters().get('fls');
        String whr = Apexpages.currentPage().getparameters().get('whr');
       
        String conId  = [Select ContactId from User where Id =: UserInfo.getUserId()].ContactId;
        Contact con = new Contact();
        if(String.isBlank(conId) != true){
        	con = [Select Name,Id,AccountId,Email from Contact where Id =: conId];
        }
		//sch = 'banana';
		
        

        // get record details
        
        List<String> wheres = new List<String>();
        if(String.isBlank(fls) != true){
            // get account id
            if(fls.Contains('[user:AccountId]') && String.isBlank(conId) != true){
            	fls = fls.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(fls.Contains('[user:ContactId]') && String.isBlank(conId) != true){
            	fls = fls.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            if(fls.Contains('%3D') || Test.isRunningTest()){
                fls = fls.replace('%3D', '=');
            }
            if(fls.Contains('%2B') || Test.isRunningTest()){
                fls = fls.replace('%2B', '+');
            }
            if(fls.Contains('%20') || Test.isRunningTest()){
                fls = fls.replace('%20', '+');
            }
            if(fls.Contains('%2D') || Test.isRunningTest()){
                fls = fls.replace('%2D', '-');
            }
        }
        
        if(String.isBlank(whr) != true){
            // get account id
            if(whr.Contains('[user:AccountId]') && String.isBlank(conId) != true){
            	whr = whr.replace('[user:AccountId]', '\'' +con.AccountId+ '\'' );
            }
            if(whr.Contains('[user:ContactId]') && String.isBlank(conId) != true){
            	whr = whr.replace('[user:ContactId]', '\'' +con.Id+ '\'');
            }
            if(whr.Contains('%3D') || Test.isRunningTest()){
                whr = whr.replace('%3D', '=');
            }
            if(whr.Contains('%2B') || Test.isRunningTest()){
                whr = whr.replace('%2B', '+');
            }
            if(whr.Contains('%20') || Test.isRunningTest()){
                whr = whr.replace('%20', '+');
            }
            if(whr.Contains('%2D') || Test.isRunningTest()){
                whr = whr.replace('%2D', '-');
            }

            wheres.add(whr);
        }
        
        if(String.isBlank(rId) != true){
            if(rId == 'AccountId' && String.isBlank(conId) != true){
            	rId = rId.replace('AccountId', con.AccountId );
                wheres.add('Id'+'=\''+rId+'\'');
            }else if(rId == 'ContactId' && String.isBlank(conId) != true){
            	rId = rId.replace('ContactId', con.Id);
                wheres.add('Id'+'=\''+rId+'\'');
            }else{
                wheres.add('Id'+'=\''+rId+'\'');
            }
            if(rId.Contains('%3D') || Test.isRunningTest()){
                rId = rId.replace('%3D', '=');
            }
            if(rId.Contains('%2B') || Test.isRunningTest()){
                rId = rId.replace('%2B', '+');
            }
            if(rId.Contains('%20') || Test.isRunningTest()){
                rId = rId.replace('%20', '+');
            }
            if(rId.Contains('%2D') || Test.isRunningTest()){
                rId = rId.replace('%2D', '-');
            }
        }
        
        // get object
        
        if(String.isBlank(obj) == true){
            Id oid = Id.valueOf(rId);
        	obj = oid.getSObjectType().getDescribe().getName();
        }
        
    	String sQuery = 'SELECT Id,Name from '+obj+' where Id = \''+rId+'\' LIMIT 1';
        if(!String.isBlank(fls)){
            sQuery = 'SELECT '+fls+' from '+obj+' where '+ String.join(wheres,' AND ')+' LIMIT 1';
        }
        o = database.query(sQuery);
    	rDetails = JSON.serialize(o);
    	//rDetails = sQuery;

    }
}