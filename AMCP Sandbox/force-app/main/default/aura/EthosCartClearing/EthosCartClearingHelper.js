({
  fireLoadedEvent: function (component) {
    var loadEvent = $A.get("e.FDService:SparkPlugLoadedEvent");
    loadEvent.setParams({ extensionPoint: component.get("v.extensionPoint") });
    loadEvent.fire();
  },

  fireCompleteEvent: function (component) {
    var completeEvent = $A.get("e.FDService:SparkPlugCompleteEvent");
    completeEvent.setParams({
      extensionPoint: component.get("v.extensionPoint"),
    });
    completeEvent.fire();
  },
});