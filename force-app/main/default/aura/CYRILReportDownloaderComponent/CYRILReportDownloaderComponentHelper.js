({
	initGetReports : function(component, event) {
        component.set("v.cloading", true);
        var action= component.get("c.getReports");
        action.setCallback(this,function(response){ 
            var state= response.getState(); 
            $A.log(response);            
            if(state == "SUCCESS"){ 
                component.set("v.cloading", false);
                component.set("v.reports",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
	},
    initGetBatchs : function(component, event) {
        component.set("v.cloading", true);
        var action= component.get("c.getBatchs");
        action.setCallback(this,function(response){ 
            var state= response.getState(); 
            $A.log(response);            
            if(state == "SUCCESS"){ 
                component.set("v.cloading", false);
                component.set("v.batches",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
	}
})