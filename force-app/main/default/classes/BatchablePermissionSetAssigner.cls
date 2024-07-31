public inherited sharing class BatchablePermissionSetAssigner implements Database.Batchable<SObject>{

  public static BatchablePermissionSetAssigner getForProfile(String permSetName, String profileName){

    String query = 'SELECT Id FROM User WHERE IsActive = TRUE AND Profile.Name = \''+profileName+'\'';
    return new BatchablePermissionSetAssigner(
      query,
      new PermissionSetAssigner(permSetName)
    );
  }

  private PermissionSetAssigner assigner;

  private String userQuery;

  public BatchablePermissionSetAssigner(String userQuery, PermissionSetAssigner assigner){
    this.assigner = assigner;
    this.userQuery = userQuery;
  }

  public Database.QueryLocator start(Database.BatchableContext param1) {
    return Database.getQueryLocator(userQuery);
  }

  public void execute(Database.BatchableContext param1, List<User> users) {
    assigner.assign(users);
  }

  public void finish(Database.BatchableContext param1) {
  }
}