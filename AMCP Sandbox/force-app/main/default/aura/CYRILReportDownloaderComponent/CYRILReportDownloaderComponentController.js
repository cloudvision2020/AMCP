({
    doInit : function(component, event, helper) {
        helper.initGetReports(component, event);
        //helper.initGetBatchs(component, event);
        
        var rId = component.get('v.recordId');
        if(rId){
            console.log("rid", rId);
            component.set('v.batchId','m0j5200000005KZAAY');
            var exc = component.get('c.ExecuteBatch');
            $A.enqueueAction(exc);
        }
    },
    ExecuteBatch : function(component, event, helper) {  
        component.set("v.cloading", true); 
        console.log("try execute batch",component.get('v.batchId')); 
        var action= component.get("c.configBatch");
        action.setParams({
            "reportId": component.get("v.reportId"),
            "column": component.get('v.column'),
            "title": component.get('v.exportTitle'),
            "rId": component.get('v.recordId')
        });
        action.setCallback(this,function(response){ 
            var state= response.getState(); 
            var err = response.getError();
            $A.log(response);
            console.log('state' + state);
            if(state == "SUCCESS"){ 
                component.set("v.cloading", false);
                
                console.log("results",response.getReturnValue());
                
                //component.set("v.apexJob",response.getReturnValue());
            }else{
                component.set("v.cloading", false);
                component.set("v.cerror", true);
                component.set("v.cerrormsg", err[0].message);
                console.log(err,"ERRROR");
            }
        });
        $A.enqueueAction(action);
    },
    /*refreshApexJob : function(component, event, helper) { 
        var action= component.get("c.getApexJob");
        action.setParams({
            "Id": component.get("v.apexJob").Id
        });
        action.setCallback(this,function(response){ 
            var state= response.getState(); 
            $A.log(response);
            //console.log('state' + response);
            if(state == "SUCCESS"){ 
                component.set("v.apexJob",response.getReturnValue());
            } 
        });
        $A.enqueueAction(action);
    },*/
    openTab : function(component, event, helper){
        window.open('/lightning/setup/AsyncApexJobs/home');
    }
})