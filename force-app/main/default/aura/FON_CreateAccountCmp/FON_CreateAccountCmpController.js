({
    initializeComponent: function(component){
        return new Promise(function(resolve, reject){
            var action = component.get("c.getDependentMap");
            action.setParams({
                objDetail: component.get("v.objDetail"),
                contrfieldApiName: 'BillingCountryCode',
                depfieldApiName: 'BillingStateCode'
            });
            action.setCallback(this,function(response) {
                if(response.getState() == 'SUCCESS') {
                    var results = response.getReturnValue();
                    component.set("v.depnedentFieldMap", results);
                    var countries = ['United States'];
                    for (var singlekey in results) {
                        countries.push(singlekey);
                    }
                    component.set('v.countries', countries);                
                    
                    var country = component.get('v.country');
                    var countriesMap = component.get("v.depnedentFieldMap");
                    if(country == 'United States') {
                        if(countriesMap[country].length > 0){
                            component.set('v.statePicklistValues', countriesMap[country]);
                        }
                        else {
                            component.set('v.statePicklistValues', []);
                            component.set('v.disableState', true);
                        }
                    }
                    var st = component.get('v.statePicklistValues');
                    component.set("v.state",st[0]);
                   // alert(component.get("v.state"));
                    
                }
            });
            $A.enqueueAction(action);	
            
            var action = component.get('c.getEmailPicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    debugger;
                    component.set("v.emailPicklist",response.getReturnValue());
                } else {
                   
                }
            });
            $A.enqueueAction(action);

            var action = component.get('c.getPhonePicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    debugger;
                    component.set("v.phonePicklist",response.getReturnValue());
                } else {
                }
            });
            $A.enqueueAction(action);

            var action = component.get('c.getEmployerPicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    component.set("v.employerPicklist",response.getReturnValue());
                } else {
                }
            });
            $A.enqueueAction(action);

            var action = component.get('c.getPrimaryPositionPicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    component.set("v.primaryPicklist",response.getReturnValue());
                } else {
                }
            });
            $A.enqueueAction(action);

            var action = component.get('c.getJobRolePicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    component.set("v.jobRolePicklist",response.getReturnValue());
                } else {
                }
            });
            $A.enqueueAction(action);

            var action = component.get('c.getaddressPicklistValues');
            action.setCallback(component, function(response){
                if(response.getState() === 'SUCCESS'){
                    component.set("v.addressPicklist",response.getReturnValue());
                    resolve(result);
                } else {
                    reject();
                }
            });
            $A.enqueueAction(action);
        });
    },
    
    doInit : function(component, event, helper) {
        var action = component.get('c.getaccountId');
        action.setCallback(this, function(actionResult) {

            if(actionResult.getState() === 'SUCCESS'){

                component.set("v.account.Name",actionResult.getReturnValue().Name);

            }

        });

        $A.enqueueAction(action);
    },

        handleWorkEmailChange : function(component, event, helper) {
            var workEmail = event.getSource().get("v.value");
            component.set("v.username", workEmail);
        },
    
    
    
    validateEvtHandler : function(component, event, helper) {
        var error = {
            firstName: $A.get('$Label.c.FON_FirstNameValidationMsg'), 
            lastName: $A.get('$Label.c.FON_LastNameValidationMsg'),
            email: $A.get('$Label.c.FON_EmailValidationMsg'),
            emailType : $A.get('$Label.c.FON_EmailTypeValidationMsg'),
            company: $A.get('$Label.c.FON_CompanyValidationMsg'),
            PhoneType : $A.get('$Label.c.Phone_TypeValidationMsg'),
            phoneNo : $A.get('$Label.c.Phone_No_ValidationMesg'),
            title1 : $A.get('$Label.c.FON_TitleValidationMsg'),
            EmployerType : $A.get('$Label.c.FON_EmployerTypeValidationMesg'),
            PrimaryPosition : $A.get('$Label.c.FON_PrimaryPositionValidationMesg'),
            JobRole : $A.get('$Label.c.FON_JobRoleValidationMesg'),
            AddressType : $A.get('$Label.c.FON_AddressTypeValidationMesg'),
            street : $A.get('$Label.c.FON_streetValidationMesg'),
            city : $A.get('$Label.c.FON_CityValidationMesg'),
            country : $A.get('$Label.c.FON_CountryValidationMesg'),
            State1 : $A.get('$Label.c.FON_StateValidationMesg'),
            PostalCode : $A.get('$Label.c.FON_ZipCodeValidationMesg'),
            username : $A.get('$Label.c.FON_Title2ValidationMesg'),
            password: $A.get('$Label.c.FON_Password1ValidationMesg'),
            confirmPassword: $A.get('$Label.c.FON_PasswordValidationMsg'),
        }
        var a = event.getSource();
        var id = a.getLocalId();
        var ele = component.find(id);
        if(ele.get('v.value') == undefined || ele.get('v.value') == '') {
            document.getElementById(id + '_highlight').innerHTML = error[id];
        }
        else {
            document.getElementById(id + '_highlight').innerHTML = '';
            helper.validateEmail(component);
            helper.validatePassword(component);
            helper.validateConfirmPassword(component);
        }
    },
    
    search : function(component, event, helper){
        component.set("v.openAccountSearch",true);
    },
    
    closeCreateAccount : function(component, event, helper){
        component.set("v.openAccountSearch",true);
        component.set("v.showCreateAccountScreen",false);
    },
    
    closeModal : function(component, event, helper){
        component.set("v.openAccountSearch",false);
    },
    
    handleComponentEvent : function(component, event){
        var account = event.getParam("account");
        component.set("v.account", account);
        component.set("v.openAccountSearch",false);
        document.getElementById('company_highlight').innerHTML = '';
    },
    
    createAccount  : function(component, event, helper){
        helper.onSubmitHandler(component, event);
    },
    
    optionClickHandler : function (component, event, helper) {
        helper.getStateOptions(component);
    },
    
    nextClick : function (component, event, helper) {
        var selectedRecord = component.get("v.selectedRecord");
        var message = component.get("v.message");
        var selectedCompanyName = component.find("company").get("v.value");
        component.set("v.accountName", selectedCompanyName);
        
        if(message == 'No Records Found'){
            component.set("v.searchString",'');
            component.set("v.message",'');
            component.set("v.openAccountSearch", false);
            component.set("v.showCreateAccountScreen", true);
            return;
        }
        if(selectedRecord){
            component.set("v.account", selectedRecord.account);
            component.set("v.openAccountSearch",false);
            document.getElementById('company_highlight').innerHTML = '';
        }
        else{
            alert($A.get("$Label.c.FON_AccountSearchPlaceHolder"));

        }
    }
})