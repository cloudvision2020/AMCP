global inherited sharing class EthosPermissionSetRoutingRule extends Framework.Domain{
  public EthosPermissionSetRoutingRule(List<User> users) {
    super(users);
  }

  global class Constructor implements Framework.Domain.DomainConstructor  {
    global Framework.Domain construct(List<SObject> users) {
      return new EthosPermissionSetRoutingRule(users);
    }
  }

  global override void afterInsert() {
    try {
      List<User> users = (List<User>) records;
      Profile profile = [SELECT Id FROM Profile WHERE Name = 'Fonteva Customer Community Login'];

      List<User> fontevaCommunityUsers = new List<User>();
      for (User u : users) {
        if (u.ProfileId == profile.Id) {
          fontevaCommunityUsers.add(u);
        }
      }

      PermissionSetAssigner assigner = new PermissionSetAssigner('Ethos_Checkout');
      assigner.assign(fontevaCommunityUsers);
    } catch (Exception e) {
      System.debug('FAILED TO ASSIGN USER');
      System.debug(e.getCause());
      System.debug(e.getMessage());
    }







  }
}