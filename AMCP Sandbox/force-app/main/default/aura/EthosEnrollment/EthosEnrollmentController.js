({
  doInit: function (component, event, helper) {
    let data = component.get('v.data');
    component.set('v.receiptName', data.name);
    helper.fireLoadedEvent(component);
  },

  handleFinish: function (component, event, helper) {
    helper.fireCompleteEvent(component);
  },

});