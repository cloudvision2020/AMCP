global inherited sharing class SSOConnectedAppPlugin extends Auth.ConnectedAppPlugin {
  global override Map<String, String> customAttributes(
    Id userId,
    Id connectedAppId,
    Map<String, String> formulaDefinedAttributes,
    Auth.InvocationContext context
  ) {
    CustomAttributeLoader customAttributeLoader = CustomAttributeLoader.getInstance(userId, connectedAppId, context);
    return customAttributeLoader.augmentCustomAttributes(formulaDefinedAttributes);
  }
}