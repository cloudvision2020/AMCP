({
  fireLoadedEvent: function (component) {
      console.log("enrollment loaded init");
    var loadEvent = $A.get("e.FDService:SparkPlugLoadedEvent");
    loadEvent.setParams({ extensionPoint: component.get("v.extensionPoint") });
    loadEvent.fire();
      console.log("enrollment loaded");
  },

  fireCompleteEvent: function (component) {
      console.log("enrollment completed init");
    var completeEvent = $A.get("e.FDService:SparkPlugCompleteEvent");
    completeEvent.setParams({
      extensionPoint: component.get("v.extensionPoint"),
    });
    completeEvent.fire();
      console.log("enrollment completed");
  },
});