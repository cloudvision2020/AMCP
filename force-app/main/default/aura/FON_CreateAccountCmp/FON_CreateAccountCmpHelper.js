({
    getSaluationPicklist : function(component, event){
        alert('function called');
        var action = component.get( "c.getSalutationPicklistValues" );
        action.setCallback( this, function( response ) {
            console.log('state--'+response.getState());
            alert('state--'+response.getState());
            alert(response.getReturnValue());
        });
        $A.enqueueAction( action );
    },
    
    validateEmail : function(component) {        
        console.log(component.find('email').get('v.value'));
        if(component.find('email').get('v.value') != '' && component.find('email').get('v.value') != undefined) {
            var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if (reg.test(component.find('email').get('v.value')) == false) {
                document.getElementById('email_highlight').innerHTML = $A.get('$Label.c.FON_ValidEmailMsg');
                return false;                
            }
            else
                return true;
        }        
    },
    
    validatePassword : function(component) {
        return true;
        if(component.find('password').get('v.value') != '' && component.find('password').get('v.value') != undefined) {
            if (component.find('password').get('v.value').length < 6) {
                document.getElementById('password_highlight').innerHTML = 'Length must be min six characters';
                return false           
            }
            else
                return true;            
        }       
    },
    
    validateConfirmPassword : function(component) {
        if(component.find('password').get('v.value') != undefined && component.find('confirmPassword').get('v.value') != undefined && component.find('confirmPassword').get('v.value') != component.find('password').get('v.value')) {
            document.getElementById('confirmPassword_highlight').innerHTML = 'Passwords not matching';
            return false;                
        }
        else
            return true;        
    },
    
    validateSubmission : function(component) {
        var errorMsg = {
            firstName: $A.get('$Label.c.FON_FirstNameValidationMsg'), 
            lastName: $A.get('$Label.c.FON_LastNameValidationMsg'),
            email: $A.get('$Label.c.FON_EmailValidationMsg'),
            company: $A.get('$Label.c.FON_CompanyValidationMsg'),
            emailType : $A.get('$Label.c.FON_EmailTypeValidationMsg'),
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
        component.set('v.errorMsg', '');
        var isValid = true;
       
        var auraIds = ['firstName', 'lastName','email', 'company', 'emailType','PhoneType','phoneNo','title1','EmployerType','PrimaryPosition','JobRole','AddressType','street','city','country','State1','PostalCode','username','password','confirmPassword'];
        for(var i=0; i<auraIds.length; i++) {
            if(component.find(auraIds[i])) {
                var inputCmp = component.find(auraIds[i]);
                if(inputCmp.get('v.value') == '' || inputCmp.get('v.value') == undefined) {
                    document.getElementById(auraIds[i] + '_highlight').innerHTML = errorMsg[auraIds[i]];
                    isValid = false;
                }
                else {
                    document.getElementById(auraIds[i] + '_highlight').innerHTML = '';
                }
            }
        }
        
        if(!this.validateEmail(component))
            isValid = false;
        
        if(!this.validatePassword(component))
            isValid = false;
        
        if(!this.validateConfirmPassword(component))
            isValid = false;
        
        return isValid;
    },    
    
    onSubmitHandler : function(component, event) {
        
        if(this.validateSubmission(component)) {   
            component.set('v.showSpinner', true);
            this.signUp(component, event);           
        }
        else {
            component.set('v.errorMsg', $A.get('$Label.c.FON_ErrorMsg'));
            window.scrollTo(0, 0);
        }
    },
    
    signUp : function(component, event) {
       
        var startUrl = window.location.href;
        var redirectUrl ;
        console.log('jmd location-->'+startUrl);
        if(startUrl.includes('startURL=/s/store#/store/checkout')){
            var finalUrl = startUrl.split('startURL=');
            redirectUrl = finalUrl[1];
        }
        else{
            var finalUrl = startUrl.split('startURL=');
            redirectUrl = finalUrl[1];
            
        }
       
        var oAccount = component.get("v.account");
       
        var oContact = component.get("v.conObj"); 
        //oContact.MailingCountry = component.get('v.country');
        //oContact['MailingState'] = component.get('v.state');
        oContact.State__c = component.get("v.state");
        oContact.First_Name__c = component.get("v.conObj.FirstName");
        oContact.Last_Name__c = component.get("v.conObj.LastName");
        oContact.OrderApi__Preferred_Email_Type__c = component.get("v.conObj.OrderApi__Preferred_Email_Type__c");
        oContact.Email = component.get("v.conObj.Email");
        oContact.OrderApi__Preferred_Phone_Type__c = component.get("v.conObj.OrderApi__Preferred_Phone_Type__c");
        oContact.OrderApi__Work_Phone__c = component.get("v.conObj.OrderApi__Work_Phone__c");
        oContact.Title = component.get("v.conObj.Title");
        oContact.Employer_Type__c = component.get("v.conObj.Employer_Type__c");
        oContact.Primary_Position__c = component.get("v.conObj.Primary_Position__c");
        oContact.Job_Role__c = component.get("v.conObj.Job_Role__c");
        oContact.Address_Type__c =  component.get("v.conObj.Address_Type__c");
        //oContact.MailingCity = component.get("v.conObj.MailingCity");
        //oContact.MailingPostalCode = component.get("v.conObj.MailingPostalCode");
        //oContact.AccountId = component.get("v.account.Name");
        // oContact.OrderApi__Is_Primary_Contact__c = true;
       // oContact.OrderApi__Preferred_Email_Type__c = 'Work';
        //oContact.Email = oContact.OrderApi__Work_Email__c;
        //oContact.OrderApi__Preferred_Phone_Type__c = 'Work';
        //oContact.Suffix = oContact.DonorApi__Suffix__c;
        //oContact.AccountId = oAccount.Id;
        debugger;
        if (oContact.OrderApi__Preferred_Email_Type__c != null) {
            if (oContact.OrderApi__Preferred_Email_Type__c == 'Personal') {
                oContact.OrderApi__Personal_Email__c = oContact.Email;
            } else if (oContact.OrderApi__Preferred_Email_Type__c == 'Work') {
                oContact.OrderApi__Work_Email__c = oContact.Email ;
            } else if (oContact.OrderApi__Preferred_Email_Type__c == 'Other') {
                oContact.OrderApi__Other_Email__c = oContact.Email;
            } else if (oContact.OrderApi__Preferred_Email_Type__c == 'Assistant'){
                oContact.OrderApi__Assistant_Email__c = oContact.Email;
            }
         }

        if (oContact.OrderApi__Preferred_Phone_Type__c != null) {
            if (oContact.OrderApi__Preferred_Phone_Type__c == 'Home') {
                oContact.HomePhone = oContact.OrderApi__Work_Phone__c;
                oContact.OrderApi__Work_Phone__c = null;
            } else if (oContact.OrderApi__Preferred_Phone_Type__c == 'Work') {
                oContact.OrderApi__Work_Phone__c = oContact.OrderApi__Work_Phone__c ;
            } else if (oContact.OrderApi__Preferred_Phone_Type__c == 'Mobile') {
                oContact.MobilePhone = oContact.OrderApi__Work_Phone__c;
                oContact.OrderApi__Work_Phone__c = null;
            }
         }

        
        const strKeyReturnURL = 'ReturnUrl=';
        let fullPageURL = window.location.href;
        let decodedURL = decodeURIComponent(fullPageURL);
        const lstSplitURL = decodedURL.split(strKeyReturnURL);
        if(lstSplitURL.length > 1){
            let strReturnURLValue = lstSplitURL[1];
            this.retURLVal = lstSplitURL[1];
        }

        component.set('v.oContact', oContact); 
        var action = component.get("c.registerUser");
        action.setParams({
            oContact:oContact,
            password:component.get("v.password"),
            confirmPassword:component.get("v.confirmPassword"),
            accId:oAccount.Id,
            startUrl : redirectUrl,
            username : component.get("v.username"),
            retURL : this.retURLVal
        });
        
        
        action.setCallback(this,function(result){
            debugger;
            if(result.getState() == 'SUCCESS') {
                let response = result.getReturnValue();
                if($A.get('$Label.c.FON_DuplicateEmailErrorMessage')==response){
                    component.set('v.errorMsg', "ERROR : " + $A.get('$Label.c.FON_DuplicateEmailErrorMessage'));
                    window.scrollTo(0, 0);
                }
                else{
                    let hrefVAl = new URL(result);
                    hrefVAl.searchParams.set('retURL', this.retURLVal);
                    window.location.href = hrefVAl;
                    // alert(response);
                    //  Window.open(response);
                }
                component.set('v.showSpinner', false);
                try{
                    //  component.set('v.showConfirm', true);
                }catch(ex){
                    console.log(ex);
                }
            }
            else if(result.getState() == 'ERROR') {
                debugger;
                component.set('v.showSpinner', false);
                var errors = result.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        let err = errors[0].message;
                        if(err.includes('/s/login/')){
                            err = err.replace('/s/login/', '/s/login/'+window.location.search);
                        }
                        component.set('v.errorMsg', "ERROR : " + err);
                    }
                } 
                else {
                    component.set('v.errorMsg', "ERROR: Unknown error occured");
                }
                window.scrollTo(0, 0);
            }
                else {
                    component.set('v.showSpinner', false);
                    component.set('v.errorMsg', "ERROR: There was a problem in request. Please try again.");
                    window.scrollTo(0, 0);
                }
        });
        $A.enqueueAction(action);        
    },
    
    getCountries : function(component) {
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
            }
        });
        
        $A.enqueueAction(action);		
    },
    
    getStateOptions : function(component) {
        var country = component.get('v.country');
        var countriesMap = component.get("v.depnedentFieldMap");
        console.log('***country', country);
        console.log('***states', countriesMap[country]);
        //  if(country == 'United States') {
        if(countriesMap[country].length > 0)
            component.set('v.statePicklistValues', countriesMap[country]);
        else {
            component.set('v.statePicklistValues', []);
            component.set('v.disableState', true);
        }
        // }
    },
    
    redirectToUrl : function(component){
        redirectTostartURL
    }
    
})