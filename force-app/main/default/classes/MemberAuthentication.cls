public without sharing class MemberAuthentication{
    
    public MemberAuthentication(){
        
        system.debug('>>>MemberAuthentication ');
    }
    
    public PageReference urlRedirection() {
        
        List<User> lstUserId = [Select Id, ContactId from User where Id=:Userinfo.getuserId()];
        
        system.debug('>>> '+lstUserId.size());
        if(lstUserId.size() > 0){
            if(lstUserId[0].ContactId == null){
                  PageReference page = new PageReference('https://amcp--amcpfull.sandbox.my.site.com/s/login/');
                  page.setRedirect(true);
                  return page;
            }
            
        }else{
             PageReference page = new PageReference('https://amcp--amcpfull.sandbox.my.site.com/s/login/');
             page.setRedirect(true);
             return page;
        }
        
        return null;
         
    }
    
}