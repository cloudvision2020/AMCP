({
  doInit: function (component, event, helper) {
    let data = component.get('v.data');
    component.set('v.receiptName', data.name);
      
      var compEvent = $A.get('e.FDService:SparkPlugLoadedEvent');
      compEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
      compEvent.fire();
      
    var usr1 = $A.get("$SObjectType.CurrentUser.Id");
    console.log("current user",usr1);
    if (typeof usr1 !== 'undefined') {
        console.log("should load " + usr1);
        helper.fireLoadedEvent(component);
        
    } else {
        // usr1 has a value
        var compEvent = $A.get('e.FDService:SparkPlugCompleteEvent');
        compEvent.setParams({extensionPoint : component.get('v.extensionPoint')});
        compEvent.fire();
        console.log("should complete: " + usr1);
    }
    //helper.fireLoadedEvent(component);
  },

  handleFinish: function (component, event, helper) {
    helper.fireCompleteEvent(component);
  },

});