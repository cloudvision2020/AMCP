({
    searchRecordsHelper : function(component, event, helper, value) {
        $A.util.removeClass(component.find("Spinner"), "slds-hide");
        component.set('v.message','');
        component.set('v.recordsList',null);
        
        // Calling Apex Method
        var action = component.get('c.fetchRecords');
        action.setStorable();
        action.setParams({
            'searchString' : component.get('v.searchString')
        });
        action.setCallback(this,function(response){
            var result = response.getReturnValue();
            console.log('state',response.getState());
            if(response.getState() === 'SUCCESS') {
                // To check if any records are found for searched keyword
                if(result.length > 0) {
                    // To check if value attribute is prepopulated or not
                    if( $A.util.isEmpty(value) ) {
                        component.set('v.recordsList',result);        
                    } else {
                        var index = result.findIndex(x => x.value === value)
                        if(index != -1) {
                            var selectedRecord = result[index];
                        }
                        component.set('v.selectedRecord',selectedRecord);
                        
                    }
                } else {
                    component.set('v.message','No Records Found');
                    if(component.get("v.message") == 'No Records Found'){
                        console.log('after search');
                        console.log('searchString',component.get('v.searchString'));
                        var searchString = component.get('v.searchString');
                    }
                }
                console.log('seleRecordss',component.get('v.selectedRecord'));
                
            } 
            else if(response.getState() === 'INCOMPLETE') {
                component.set('v.message','No Server Response or client is offline');
            }  else if(response.getState() === 'ERROR') {
                    // If server throws any error
                    var errors = response.getError();
                    if (errors && errors[0] && errors[0].message) {
                        component.set('v.message', errors[0].message);
                    }
                }
            // To open the drop down list of records
            if( $A.util.isEmpty(value) )
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.addClass(component.find("Spinner"), "slds-hide");
        });
        $A.enqueueAction(action);
    }
})