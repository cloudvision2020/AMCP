({
  fireLoadedEvent: function (component) {
      console.log("redirect loaded init");
    var loadEvent = $A.get("e.FDService:SparkPlugLoadedEvent");
    loadEvent.setParams({ extensionPoint: component.get("v.extensionPoint") });
    loadEvent.fire();
      console.log("redirect loaded");
  },

  fireCompleteEvent: function (component) {
      console.log("redirect completed init");
    var completeEvent = $A.get("e.FDService:SparkPlugCompleteEvent");
    completeEvent.setParams({
      extensionPoint: component.get("v.extensionPoint"),
    });
    completeEvent.fire();
      console.log("redirect completed");
  },

});