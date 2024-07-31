public class EthosProfileUpdateBatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    
    private static final EthosWebServiceCaller caller = EthosWebServiceCaller.getInstance();
    public List<Framework__System_Log__c> logList = new List<Framework__System_Log__c>();

    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Email, FirstName, LastName, Account_Name_fml__c, Employer_Type__c, Job_Role__c, Membership_Status__c,AMCP_Membership_Type__c, OrderApi__Preferred_Phone__c, Primary_Position__c, License__c, MailingStreet, MailingCity, MailingStateCode, MailingPostalCode, Mailing_Country_Code_in_Lowercase__c, MailingState, MailingCountry, Title FROM Contact WHERE FirstName != null AND Account_Name_fml__c != null AND Employer_Type__c != null AND Job_Role__c != null AND Membership_Status__c != null AND OrderApi__Preferred_Phone__c != null AND Primary_Position__c != null AND License__c != null AND MailingStreet != null AND MailingCity != null AND MailingStateCode != null AND MailingPostalCode != null AND Mailing_Country_Code_in_Lowercase__c != null AND MailingState != null AND MailingCountry != null AND Title != null AND AMCP_Membership_Type__c != null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Contact> scope){
        
        Set<Id> contactIds = new Set<Id>();
        for(Contact con: scope){
            contactIds.add(con.Id);
        }
        
        User usr = ![SELECT Id, ContactId, Email FROM User WHERE ContactId = :contactIds LIMIT 1].isEmpty() ? [SELECT Id, ContactId, Email FROM User WHERE ContactId = :contactIds LIMIT 1] : null;
        
        if(usr != null){
            
            switch on scope[0].AMCP_Membership_Type__c {
                when 'Active Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Active';
                }	
                when 'Associate Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Associate';
                }
                when 'Resident/Fellow/Graduate Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Resident/Fellow/Graduate';
                }
                when 'Staff' {
                    // nothing, staff is correct
                }
                when 'Corporate Rep' {
                    scope[0].AMCP_Membership_Type__c = 'Corporate Rep.';
                }
                when 'Student Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Student Pharmacist';
                }
                when 'Pharmacy Technician Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Pharmacy Technician';
                }
                when '2023 Academy Corporate Member' {
                    scope[0].AMCP_Membership_Type__c = 'Academy Corporate Member';
                }
                when 'Associate-Retired Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Associate-Retired';
                }
                when 'Active-Retired Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Active-Retired';
                }
                when 'Complimentary Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Complimentary';
                }
                when 'Honorary Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Honorary';
                }
                when 'Chapter Advisor Membership' {
                    scope[0].AMCP_Membership_Type__c = 'Chapter Advisor';
                }
                when else {
                    scope[0].AMCP_Membership_Type__c = 'Active';
                }
            }
            
            EthosUserUpdateWrapper ethosUser = new EthosUserUpdateWrapper();
            ethosUser.field_custom_company = scope[0].Account_Name_fml__c;
            ethosUser.field_custom_dob = null;
            ethosUser.field_custom_employer_type = scope[0].Employer_Type__c;
            ethosUser.field_custom_job_role = scope[0].Job_Role__c;
            ethosUser.field_custom_member_status = scope[0].Membership_Status__c;
            ethosUser.field_custom_member_type = scope[0].AMCP_Membership_Type__c;
            ethosUser.field_custom_phone = scope[0].OrderApi__Preferred_Phone__c;
            ethosUser.field_custom_primary_position = scope[0].Primary_Position__c;
            ethosUser.field_custom_profession = scope[0].License__c;
            ethosUser.field_custom_title = scope[0].Title;
            ethosUser.label = 'Profile';
            ethosUser.field_first_name = scope[0].FirstName;
            ethosUser.field_last_name = scope[0].LastName;
            
            EthosUserUpdateWrapper.FieldProfileLocation location = new EthosUserUpdateWrapper.FieldProfileLocation();
            location.street = scope[0].MailingStreet;
            location.city = scope[0].MailingCity;
            location.province = scope[0].MailingStateCode;
            location.postal_code = scope[0].MailingPostalCode;
            location.country = scope[0].Mailing_Country_Code_in_Lowercase__c;
            location.province_name = scope[0].MailingState;
            location.country_name = scope[0].MailingCountry;
            
            ethosUser.field_profile_location = location;
            try{
                String serializedUser = JSON.serialize(ethosUser);
                if (!Test.isRunningTest()) {
                    String ethosProfileId = caller.getUser(usr.Email).profile_profile.id;
                    String responseFromUpdateMethod = caller.updateProfileUserInfo(serializedUser, ethosProfileId);
                } else {
                    throw new EthosException.UserNotFoundException();
                }
            } catch (EthosException e){
                System.debug('Update Profile Failed ' + e.getMessage());
                Framework__System_Log__c newLog = new Framework__System_Log__c(
                	Framework__Type__c = 'Ethos Profile Update Failure',
                    Framework__Registered_Object__c = 'Contact',
                    Framework__Path__c = 'EthosProfileUpdateBatch',
                    Framework__Exception_Data__c = e.getMessage(),
                    Framework__Data__c = scope[0].Id + ' ' + scope[0].FirstName + ' ' + scope[0].LastName + ' ' + scope[0].Email
                );
                logList.add(newLog);
            }
        } else {
            System.debug('User not found in Salesforce');
            Framework__System_Log__c newLog = new Framework__System_Log__c(
            	Framework__Type__c = 'Ethos Profile Update Failure',
                Framework__Registered_Object__c = 'Contact',
                Framework__Path__c = 'EthosProfileUpdateBatch',
                Framework__Exception_Data__c = 'User does not exist in Salesforce',
                Framework__Data__c = scope[0].Id + ' ' + scope[0].FirstName + ' ' + scope[0].LastName + ' ' + scope[0].Email
            );
            logList.add(newLog);
        }
    }
    public void finish(Database.BatchableContext bc){
        insert logList;
    }
    

}