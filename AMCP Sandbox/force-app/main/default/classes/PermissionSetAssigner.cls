public inherited sharing class PermissionSetAssigner {

  private String permissionSetName;

  public PermissionSetAssigner(String permissionSetName){
    this.permissionSetName = permissionSetName;
  }
  public void assign(List<User> users){
    PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Name = :permissionSetName];

    List<PermissionSetAssignment> permissionSetAssignments = [SELECT Id, AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :permissionSet.Id AND AssigneeId IN :users];

    Map<Id, PermissionSetAssignment> assignmentByUserId = new Map<Id, PermissionSetAssignment>();
    for(PermissionSetAssignment psa : permissionSetAssignments){
      assignmentByUserId.put(psa.AssigneeId,psa);
    }


    List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
    for (User user : users){
      if(assignmentByUserId.get(user.Id) == null){
        PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = permissionSet.Id, AssigneeId = user.Id);
        permissionSetList.add(psa);
      }
    }

    insert permissionSetList;
  }

}