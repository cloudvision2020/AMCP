({
  doInit: function (component, event, helper) {
   let data = component.get('v.data');
   component.set('v.receiptName', data.name);
   console.log('Aura Redirect Loaded');
   console.log(data);


   helper.fireLoadedEvent(component);
  },

  handleFinish: function (component, event, helper) {
    helper.fireCompleteEvent(component);
  },

});