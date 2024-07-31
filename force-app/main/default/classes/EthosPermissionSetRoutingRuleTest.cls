@IsTest
private class EthosPermissionSetRoutingRuleTest {

  private static final String profileName = 'Fonteva Customer Community Login';
  private static final String permsetName = 'Ethos_Checkout';


  @IsTest
  public static void default() {
    insertRoutingRule(EthosPermissionSetRoutingRule.class.getName(),'User');

    Test.startTest();

    User user = TestUserFactory.createCommunityUser(profileName);

    Test.stopTest();

    List<PermissionSetAssignment> permissionSetAssignments = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :user.Id AND PermissionSet.Name = :permsetName];

//    Assert.areEqual(1, permissionSetAssignments.size());

  }


  public static void insertRoutingRule(String className, String sobjectName){
    Framework.Installer.install();
    PagesApi.PackageScripts.install();
    OrderApi.PackageScripts.install();
    EventApi.PackageScripts.install();
    List<Framework.RoutingRule> routingRules = new List<Framework.RoutingRule>();
    Framework.RoutingRule routingRule = new Framework.RoutingRule();
    routingRule.apexClass = className;
    routingRule.namespace = '';
    routingRule.isEnabled = true;
    routingRule.sObjectName = sobjectName;
    routingRule.executionOrder = 1;
    routingRules.add(routingRule);
    Framework.Config.push(routingRules);
  }
}