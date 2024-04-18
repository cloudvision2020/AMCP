public inherited sharing class CommunityProfilePhotoSetter {

  private Id communityId;

  private Map<Id, User> userByContactId = new Map<Id, User>();
  private Map<Id, Id> fileIdByContactId = new Map<Id, Id>();
  private Map<Id, Contact> contactById;


  public void set( Id communityId, List<User> users){
    this.communityId = communityId;

    buildUserByContactIdMap(users);
    buildContactByIdMap();
    buildFileIdByContactIdMap();

    setPhoto();
  }

  private void buildUserByContactIdMap(List<User> users) {
    for (User user : users) {
      userByContactId.put(user.ContactId, user);
    }
  }

  private void buildContactByIdMap() {
    List<Contact> contacts = [SELECT Id FROM Contact WHERE Id IN :userByContactId.keySet()];
    contactById = new Map<Id, Contact>(contacts);
  }
  private void buildFileIdByContactIdMap() {
    List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId IN :contactById.keySet()];
    for (ContentDocumentLink cdl : contentDocumentLinks) {
      fileIdByContactId.put(cdl.LinkedEntityId, cdl.ContentDocumentId);
    }
  }

  private void setPhoto() {
    for (Contact contact : contactById.values()) {
      Id userId = userByContactId.get(contact.Id).Id;
      Id fileId = fileIdByContactId.get(contact.Id);

      if (userId != null && fileId != null) {
        if(Test.isRunningTest() == false){
          ConnectApi.UserProfiles.setPhoto(communityId, userId, fileId, 1);
        }
      }
    }
  }

}