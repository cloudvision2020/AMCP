public without sharing class CourseEnrollmentController {

  private static final EthosWebServiceCaller caller = EthosWebServiceCaller.getInstance();
  private static final ReceiptFetcher receiptFetcher = new ReceiptFetcherImpl();
  private static final ItemFetcher itemFetcher = new ItemFetcherImpl();
  private static String ethosProfileId;

  @AuraEnabled
  public static String enroll(String userId, String receiptName) {
    String response = '';
 
    List<String> ethosItemIds = fetchEthosItemIds(receiptName);
    if(ethosItemIds.isEmpty()){
      return response;
    }
      
    String ethosUserId = fetchEthosUserId(userId);
    if (ethosUserId == null) {
      return 'Did not find user';
    }
     
    try{
        String serializedUser = fetchEthosUserInfo(userId); 
        String responseFromUpdateMethod = caller.updateProfileUserInfo(serializedUser, ethosProfileId);
    } catch (EthosException.FailedApiCallException e){
        System.debug('Update Profile Failed ' + e.getMessage());
        throw e; 
    }
	
    for (String ethosItemId : ethosItemIds) {
      response += caller.enroll(ethosItemId, ethosUserId);
    }
    return response;
  }

  private static List<String> fetchEthosItemIds(String receiptName) {
    List<Id> itemIds = new List<Id>();
    OrderApi__Receipt__c receipt = receiptFetcher.fetchByName(receiptName);
    for (OrderApi__Receipt_Line__c receiptLine : receipt.OrderApi__Receipt_Lines__r) {
      itemIds.add(receiptLine.OrderApi__Item__c);
    }

    List<OrderApi__Item__c> items = itemFetcher.fetchByIds(itemIds);

    List<String> ethosItemIds = new List<String>();

    for (OrderApi__Item__c item : items) {
      if (item.Ethos_Id__c != null) {
        ethosItemIds.add(item.Ethos_Id__c);
      }
    }
    return ethosItemIds;
  }

  private static String fetchEthosUserId(String userId) {
    try {
      String email = [SELECT Id, Email, ContactId FROM User WHERE Id = :userId].Email;
      String ethosUserId = caller.getUser(email).uid;
      return ethosUserId;
    } catch (EthosException.UserNotFoundException e) {
      return null;
    }
  }
    
  public static String fetchEthosUserInfo(String userId) {
    try {
      User usr = [SELECT Id, ContactId, Email FROM User WHERE Id = :userId];
      Contact con = [SELECT Id, 
                            FirstName, 
                            LastName, 
                            Account_Name_fml__c,
                            Employer_Type__c, Job_Role__c, 
                            Membership_Status__c,
                     		AMCP_Membership_Type__c,
                            OrderApi__Preferred_Phone__c, 
                            Primary_Position__c,
                            Phone,
                            HomePhone,
                            MobilePhone,
                            OtherPhone,
                            OrderApi__Work_Phone__c,
                            AssistantPhone,
                            License__c,
                     		MailingStreet,
                     		MailingCity,
                     		MailingStateCode,
                     		MailingPostalCode,
                     		Mailing_Country_Code_in_Lowercase__c,
                     		MailingState,
                     		MailingCountry,
                            Title 
                     FROM Contact 
                     WHERE Id = :usr.ContactId LIMIT 1];
      ethosProfileId = caller.getUser(usr.Email).profile_profile.id;
      String jsonOutput = buildEthosUserUpdateJSON(con);
        return jsonOutput;
    } catch (EthosException.UserNotFoundException e) {
      return null;
    }
  }
    
  private static String buildEthosUserUpdateJSON(Contact con) {
    
    switch on con.AMCP_Membership_Type__c {
            when 'Active Membership' {
                con.AMCP_Membership_Type__c = 'Active';
            }	
            when 'Associate Membership' {
                con.AMCP_Membership_Type__c = 'Associate';
            }
            when 'Resident/Fellow/Graduate Membership' {
                con.AMCP_Membership_Type__c = 'Resident/Fellow/Graduate';
            }
            when 'Staff' {
                // nothing, staff is correct
            }
            when 'Corporate Rep' {
                con.AMCP_Membership_Type__c = 'Corporate Rep.';
            }
            when 'Student Membership' {
                con.AMCP_Membership_Type__c = 'Student Pharmacist';
            }
            when 'Pharmacy Technician Membership' {
                con.AMCP_Membership_Type__c = 'Pharmacy Technician';
            }
            when '2023 Academy Corporate Member' {
                con.AMCP_Membership_Type__c = 'Academy Corporate Member';
            }
            when 'Associate-Retired Membership' {
                con.AMCP_Membership_Type__c = 'Associate-Retired';
            }
            when 'Active-Retired Membership' {
                con.AMCP_Membership_Type__c = 'Active-Retired';
            }
            when 'Complimentary Membership' {
                con.AMCP_Membership_Type__c = 'Complimentary';
            }
            when 'Honorary Membership' {
                con.AMCP_Membership_Type__c = 'Honorary';
            }
            when 'Chapter Advisor Membership' {
                con.AMCP_Membership_Type__c = 'Chapter Advisor';
            }
            when else {
                con.AMCP_Membership_Type__c = 'Active';
            }
        }
    
  	EthosUserUpdateWrapper ethosUser = new EthosUserUpdateWrapper();
    ethosUser.field_custom_company = con.Account_Name_fml__c != null ? con.Account_Name_fml__c : '';
   	ethosUser.field_custom_dob = null;
    ethosUser.field_custom_employer_type = con.Employer_Type__c != null ? con.Employer_Type__c : '';
    ethosUser.field_custom_job_role = con.Job_Role__c != null ? con.Job_Role__c : '';
    ethosUser.field_custom_member_status = con.Membership_Status__c != null ? con.Membership_Status__c : 'Active';
    ethosUser.field_custom_member_type = con.AMCP_Membership_Type__c;
    if(con.OrderApi__Preferred_Phone__c != null){
      ethosUser.field_custom_phone = con.OrderApi__Preferred_Phone__c;
    } else if (con.Phone != null){
      ethosUser.field_custom_phone = con.Phone;
    } else if (con.MobilePhone != null){
      ethosUser.field_custom_phone = con.MobilePhone;
    } else if (con.HomePhone != null){
      ethosUser.field_custom_phone = con.HomePhone;
    } else if (con.OtherPhone != null){
      ethosUser.field_custom_phone = con.OtherPhone;
    } else if (con.OrderApi__Work_Phone__c != null){
      ethosUser.field_custom_phone = con.OrderApi__Work_Phone__c;
    } else if (con.AssistantPhone != null){
      ethosUser.field_custom_phone = con.AssistantPhone;
    } else {
      ethosUser.field_custom_phone = '';
    }
    ethosUser.field_custom_primary_position = con.Primary_Position__c != null ? con.Primary_Position__c : '';
    ethosUser.field_custom_profession = con.License__c != null ? con.License__c : '';
    ethosUser.field_custom_title = con.Title != null ? con.Title : '';
    ethosUser.label = 'Profile';
    ethosUser.field_first_name = con.FirstName != null ? con.FirstName : '';
    ethosUser.field_last_name = con.LastName;
    EthosUserUpdateWrapper.FieldProfileLocation location = new EthosUserUpdateWrapper.FieldProfileLocation();
    location.street = con.MailingStreet != null ? con.MailingStreet : '';
    location.city = con.MailingCity != null ? con.MailingCity : '';
    location.province = con.MailingStateCode != null ? con.MailingStateCode : '';
    location.postal_code = con.MailingPostalCode != null ? con.MailingPostalCode : '';
    location.country = con.Mailing_Country_Code_in_Lowercase__c != null ? con.Mailing_Country_Code_in_Lowercase__c : '';
    location.province_name = con.MailingState != null ? con.MailingState : '';
    location.country_name = con.MailingCountry != null ? con.MailingCountry : '';
    ethosUser.field_profile_location = location;
    return JSON.serialize(ethosUser);
  }  
    

}