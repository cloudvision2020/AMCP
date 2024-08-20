public without sharing class CreateUser{
   @future
   public static void createUser(String contId, String firstname, String lastname, String EmailAddress, String username, String password, String accountId) {
        Profile profileList; 
        List<Profile> lstProfile1 = [select Id,name from Profile where Name = 'Fonteva Customer Community Login' limit 1];
          
        profileList = lstProfile1[0];
        //Database.DMLOptions dmo = new Database.DMLOptions();
        //dmo.EmailHeader.triggerUserEmail = true;

        User newUser = new User();
        newUser.contactid = contId;
        newUser.alias =  (firstname!=Null?firstname.substring(1,1):'')+ (lastname.length()>6?lastname.substring(1,6):lastname);
        System.Debug('newUser.alias: '+newUser.alias);
        newUser.username = username;
        newUser.firstname = firstname;
        newUser.lastname = lastname;
        newUser.profileid = profileList.Id;
        newUser.email = EmailAddress;
        newUser.emailencodingkey = 'ISO-8859-1';            
        newUser.languagelocalekey='en_US';
        newUser.localesidkey = 'en_US';
        newUser.timezonesidkey =  'America/Los_Angeles';
        newUser.CommunityNickname = (EmailAddress + Math.random()).LEFT(40);    
        newUser.isActive = True;
        
        //Site.validatePassword(newUser, password, password);  
        
        String userId = Site.createPortalUser(newUser, accountId , Password);
        
        
        //String networkId = Network.getNetworkId();

        // If using site to host the community the user should not hit s1 after logging in from mobile.
        //if(networkId != null ) {
           // newUser.put('UserPreferencesHideS1BrowserUI',true);
        //}
        
        //String userId = Site.createPortalUser(newUser, accountId, password);
        
       // Framework.Dispatcher.disableTriggerInContext.put('User', true);
        //insert newUser;
        
        //system.debug('>>> '+ newUser.Id);
        //system.debug('>>>password '+ password);
        
        //System.setPassword(newUser.id, password);
        //List<User> users = new List<User>(); 
        //users.add(newUser);
        //Database.DMLOptions dlo = new Database.DMLOptions();
        //dlo.EmailHeader.triggerUserEmail = false;
        //database.insert(users, dlo);
        //Framework.Dispatcher.disableTriggerInContext.put('User', false);
          
   }
   
}