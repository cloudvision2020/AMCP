@IsTest
public inherited sharing class FontevaTestUtilities {
  public static void initializeFonteva() {
    Framework.Installer.install();
    PagesApi.PackageScripts.install();
    OrderApi.PackageScripts.install();
    EventApi.PackageScripts.install();
  }

  public static void insertRoutingRule(String className, String sobjectName) {
    initializeFonteva();
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