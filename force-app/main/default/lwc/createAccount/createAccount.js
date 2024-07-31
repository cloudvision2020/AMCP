import { LightningElement,track,api,wire } from 'lwc';
import fetchPicklistValues from '@salesforce/apex/CreateAccountController.getDependentMap';
import createAccount from '@salesforce/apex/CreateAccountController.saveContact';
import login from '@salesforce/apex/CreateAccountController.login';
import UserCreated from '@salesforce/label/c.UserCreated';
import noemailfound from '@salesforce/label/c.No_Email_Found';
import foundcontactwithemail from '@salesforce/label/c.Found_Contact_With_Email';
import CancelButton from '@salesforce/label/c.Cancel';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import basePath from '@salesforce/community/basePath';

import PRIMARY_POSITIONS_FIELD from '@salesforce/schema/Contact.Primary_Position__c';
import EMPLOYER_TYPE_FIELD from '@salesforce/schema/Contact.Employer_Type__c';
import JOB_ROLE_FIELD from '@salesforce/schema/Contact.Job_Role__c';
import ADDRESS_TYPE_FIELD from '@salesforce/schema/Contact.Address_Type__c';
import EMAIL_TYPE_FIELD from '@salesforce/schema/Contact.OrderApi__Preferred_Email_Type__c';
import PHONE_TYPE_FIELD from '@salesforce/schema/Contact.OrderApi__Preferred_Phone_Type__c';

import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';

//import verifyRecaptcha from '@salesforce/apex/CreateAccountController.verifyRecaptcha';

export default class CreateAccount extends LightningElement {
    @track headerMsg = 'Account Lookup';
    @track contentMsg;
    @track contentMsgDescr;
    @track isDisplay = false;
    @api objDetail = {'sobjectType': 'Contact' };
    @track newContact =  {'sobjectType': 'Contact' };
    
    @track depnedentFieldMap;
    @api recordId;
    @api controllerField = 'MailingCountryCode';
    @api dependentField = 'MailingStateCode';
   
    @track controllingValues = [];
    @track dependentValues = [];
    @track selectedCountry;
    @track selectedState;

    @track controllingHomeValues = [];
    @track dependentHomeValues = [];
    @track selectedHomeCountry;
    @track selectedHomeState;

    @track bDisabledDependentFld = false; 
    @track showLoadingSpinner = false;
    @track isAccountCreate = false;
    @track accountCountyName;  
    @track accountCountyRecordId;  
    @track accountDistrictName;  
    @track accountDistrictRecordId;
    @track accountSchooltName;  
    @track accountSchoolRecordId;  
    showSchoolLookup = false;
    @track conUsername;  
    @track conPassword;  
    
    @track retURLVal;

    //@track recaptchaToken;
    
    optionsPositions = [];
    optionsEmployerType = [];
    optionsJobRole = [];
    optionsAddressType = [];
    optionsEmailType = [];
    optionsPhoneType = [];

    selectedSalutation;
    selectedPosition;
    selectedEmployerType;
    selectedJobRole;
    selectedAddressType;
    selectedEmailType;
    selectedPhoneType;
    selectedEmail;
   
   /******/
    // recaptchaResponse = '';
    
    connectedCallback(){
        this.initURLData();
        // this.loadRecaptcha();
    }

    
    initURLData(){
        const strKeyReturnURL = 'ReturnUrl=';
        let fullPageURL = window.location.href;
        let decodedURL = decodeURIComponent(fullPageURL);
        const lstSplitURL = decodedURL.split(strKeyReturnURL);
        if(lstSplitURL.length > 1){
            let strReturnURLValue = lstSplitURL[1];
            this.retURLVal = lstSplitURL[1];
            console.log('><>> '+ this.retURLVal);
        }
    }

      /*loadRecaptchaScript() {
        const recaptchaScript = document.createElement('script');
        recaptchaScript.src = 'https://www.google.com/recaptcha/api.js';
        recaptchaScript.async = true;
        recaptchaScript.defer = true;
        recaptchaScript.onload = this.renderRecaptcha.bind(this);
        document.head.appendChild(recaptchaScript);
    }

    renderRecaptcha() {
        grecaptcha.render(this.template.querySelector('.recaptcha'), {
            'sitekey': 'YOUR_SITE_KEY',
            'callback': this.recaptchaCallback.bind(this)
        });
    }

    recaptchaCallback(response) {
        this.recaptchaResponse = response;
    }*/



    @wire( getObjectInfo, { objectApiName: CONTACT_OBJECT } )
    objectInfo;

    // Get Primary Position Picklist values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PRIMARY_POSITIONS_FIELD } )
    wiredPositionsData( { error, data } ) {
        if ( data ) {
            this.optionsPositions = data.values;
        }
        else if ( error ) {
        }
    }

    // Get Employer Type Picklist Values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: EMPLOYER_TYPE_FIELD } )
    wiredEmployerData( { error, data } ) {
        if ( data ) {
            this.optionsEmployerType = data.values;
            console.log('><><> '+ JSON.stringify(this.optionsEmployerType));
        }
        else if ( error ) {
        }
    }

    // Get Email Type Picklist Values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: EMAIL_TYPE_FIELD } )
    wiredEmailData( { error, data } ) {
        if ( data ) {
            this.optionsEmailType = data.values;
            console.log('><>EMAIL_TYPE<> '+ JSON.stringify(this.optionsEmailType));
        }
        else if ( error ) {
        }
    }

    // Get Phone Type Picklist Values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: PHONE_TYPE_FIELD } )
    wiredPhoneDataType( { error, data } ) {
        if ( data ) {
            this.optionsPhoneType = data.values;
            console.log('><>EMAIL_TYPE<> '+ JSON.stringify(this.optionsPhoneType));
        }
        else if ( error ) {
        }
    }

    // Get Job Role Picklist Values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: JOB_ROLE_FIELD } )
    wiredJobRoleData( { error, data } ) {
        if ( data ) {
            this.optionsJobRole = data.values;
        }
        else if ( error ) {
        }
    }

    // Get Address Type Picklist Values
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: ADDRESS_TYPE_FIELD } )
    wiredAddressTypeData( { error, data } ) {
        if ( data ) {
            this.optionsAddressType = data.values;
        }
        else if ( error ) {
        }
    }

    // Handle Salutation Change
    handleSalutationChange( event ) {
        console.log( event.detail.value );   
        this.selectedSalutation =  event.detail.value;
    }

    // Handle Position Change
    handlePositionChange( event ) {
        console.log( event.detail.value );   
        this.selectedPosition =  event.detail.value;
    }

    // Handle Employer Type Change
    handleEmployerTypeChange( event ) {
        console.log( event.detail.value );   
        this.selectedEmployerType =  event.detail.value;
    }

    // Handle Email Type Change
    handleEmailTypeChange( event ) {
        console.log( event.detail.value );   
        this.selectedEmailType =  event.detail.value;
    }

    // Handle Email Type Change
    handlePhoneDataTypeChange( event ) {
        console.log( event.detail.value );   
        this.selectedPhoneType =  event.detail.value;
    }

    // Handle Job Role Change
    handleJobRoleChange( event ) {
        console.log( event.detail.value );   
        this.selectedJobRole =  event.detail.value;
    }

    // Handle Address Type Change
    handleAddressTypeChange( event ) {
        console.log( event.detail.value );   
        this.selectedAddressType =  event.detail.value;
    }

    // Handle Email change
    handleEmailChange( event ) {
        console.log( event.detail.value );   
        this.selectedEmail =  event.detail.value;
        this.conUsername = this.selectedEmail;
    }
    
    onCountySelection(event){  
        this.accountCountyName = event.detail.selectedValue;  
        this.accountCountyRecordId = event.detail.selectedRecordId;  
    }

    @wire(fetchPicklistValues, {objDetail:'$objDetail',contrfieldApiName: '$controllerField',depfieldApiName: '$dependentField'}) depnedentFieldValue ({ error, data }) {
        
        if (data) {
            var StoreResponse =data;
            this.depnedentFieldMap = StoreResponse;
            var listOfkeys = []; // for store all map keys (controller picklist values)
           
            // play a for loop on Return map 
            // and fill the all map key on listOfkeys variable.
            for (var singlekey in StoreResponse) {
                listOfkeys.push(singlekey);
            }

            //set the controller field value for lightning:select
            if (listOfkeys != undefined && listOfkeys.length > 0) {
                this.controllingValues.push({label : '--- None ---', value : ''});
            }

            var dataMap = [ {label : '--Select--' , value : ''}];

            for (var i = 0; i < listOfkeys.length; i++) {
                //this.controllingValues.push({label : listOfkeys[i], value : listOfkeys[i]});
                dataMap.push({label : listOfkeys[i], value : listOfkeys[i]});
            }
            this.controllingHomeValues = dataMap;
            this.controllingValues = dataMap;

            this.newContact.MailingCountry = 'United States';
           
            var ListOfDependentFields = this.depnedentFieldMap['United States'];
           
            if(ListOfDependentFields.length > 0){
                this.bDisabledDependentFld = false;  
                this.fetchDepValues(ListOfDependentFields);   
            }
        } else if (error) {
            this.error = error;
        }
    }

    onControllerFieldChange(event) {
        const allMailingAddress = this.template.querySelectorAll('lightning-input-address');
        allMailingAddress.forEach(function(address){
			if(address.name == 'mailingAddress'){  
                if (!address.country||address.country=='--None--' || address.country=='') {
                    address.setCustomValidityForField('Complete this field', 'country');
                    address.reportValidity();
                } else {
                    address.setCustomValidityForField('', 'country');
                    address.reportValidity();
                }
                
                this.newContact.MailingCountry = event.detail.country;//event.detail.country//event.target.value;
                var controllerValueKey = event.detail.country;//event.detail.country; //event.target.value;
                var depnedentFieldMap = this.depnedentFieldMap;
                this.bDisabledDependentFld = true; 
                this.dependentValues= [];
                
                if (controllerValueKey != '--- None ---' || controllerValueKey != '' || controllerValueKey != undefined) {
                    var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
                
                    if(ListOfDependentFields.length > 0){
                        this.bDisabledDependentFld = false;  
                        this.fetchDepValues(ListOfDependentFields);    
                    }else{
                        this.bDisabledDependentFld = true; 
                        this.dependentValues = [];
                    }  
                    
                } else {
                    this.bDisabledDependentFld = true; 
                    this.dependentValues= [];
                }

                this.newContact.mailingStreet = event.detail.street;
                this.newContact.mailingCity = event.detail.city;
                this.newContact.mailingPostalCode = event.detail.postalCode;
                this.newContact.mailingState = event.detail.province;
            }
        },this);
    }

    fetchDepValues(ListOfDependentFields){
        this.dependentValues = [];
        var dep = [];
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dep.push({label : ListOfDependentFields[i], value : ListOfDependentFields[i]});
        }
        this.dependentValues = dep;
    }
    
   
    createAccount(){
        try{
        this.isAccountCreate = false;
        var inp=this.template.querySelectorAll("lightning-input");
        var inp2=this.template.querySelectorAll("lightning-combobox");
       
        var isvalid = true;
        inp.forEach(function(res){
            if(res.name=='conFirstName' || res.name=='conLastName' || res.name=='conEmail' || 
            res.name=='conCompanyName' || res.name=='conJobTitle' || res.name=='conUsername' || res.name=='conPassword' || 
            res.name=='conWorkPhone' || res.name=='conMobilePhone' || res.name=='country' || res.name=='province' || res.name=='postal-code' || 
            res.name=='street' || res.name=='city' || res.companyNotFound=='city' || res.companyNotFound=='conCompanyName'){

                if(!res.checkValidity()){
                    res.showHelpMessageIfInvalid();
                   
                    isvalid = false;
                }
                if(res.name=='conEmail'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                    var emailValue = res.value;
                    this.personalEmail = emailValue;
                    if( !(emailValue.match(regExpEmailformat)) ){
                        isvalid = false;
                        res.setCustomValidity('Please Enter a Valid Personal Email Address');
                        res.reportValidity();
                    } 
                }
                if(res.name=='conMobilePhone'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    var regExpPhone = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
                    var mobilePhoneValue = res.value;
                    if(!(mobilePhoneValue.match(regExpPhone))){
                        isvalid = false;
                        res.setCustomValidity('Please Enter a Valid Mobile Phone');
                        res.reportValidity();
                    }
                }
                
                if(res.name=='conPassword'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    var regPassowrd = /^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*\W)(?!.* ).{8,16}$/;
                    var passWordValue = res.value;
                    if(!(passWordValue.match(regPassowrd))){
                        isvalid = false;
                        res.setCustomValidity('Your password must contain at least one digit, one lowercase, one upper case, one symbol from the list @#$%!, and atleast 8 characters’ should be displayed.');
                        res.reportValidity();
                    }
                }

                if(res.name=='conWorkPhone'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    var regExpPhone = /^\(?([0-9]{3})\)?[-. ]?([0-9]{3})[-. ]?([0-9]{4})$/;
                    var workPhoneValue = res.value;
                    if(!(workPhoneValue.match(regExpPhone))){
                        isvalid = false;
                        res.setCustomValidity('Please Enter a Valid Work Phone');
                        res.reportValidity();
                    }
                }
                
            }
            if(res.name=='conFirstName'){
                this.newContact.FirstName = res.value;
            }
            if(res.name=='conLastName'){
                this.newContact.LastName = res.value;
            }
            if(res.name=='conEmail'){
                this.newContact.Email = res.value;
            }
         
            if(res.name=='street'){
                this.newContact.MailingStreet = res.value;
            }
            if(res.name=='city'){
                this.newContact.MailingCity = res.value;
            }
            if(res.name=='postalCode'){
                this.newContact.MailingPostalCode = res.value;
            }
            
            if(res.name=='conMobilePhone'){
                this.newContact.MobilePhone = res.value;
            }
            if(res.name=='conWorkPhone'){
                this.newContact.OrderApi__Work_Phone__c = res.value;
            }

            if(res.name=='companyNotFound'){
                this.newContact.Company_Not_Found__c = res.value;
            }

            if(res.name=='conCompanyName'){
                this.newContact.Company_Organization_Name__c = res.value;
            }

            if(res.name=='conUsername'){
                this.conUsername = res.value;
            }

            if(res.name=='conPassword'){
                this.conPassword = res.value;
            }
            if(res.name=='conJobTitle'){
                this.newContact.Title = res.value;
            }
            this.newContact.AccountId = this.accountCountyRecordId;
            
            if(this.newContact.AccountId == null && (this.newContact.Company_Organization_Name__c == '' || this.newContact.Company_Organization_Name__c == undefined)){
                if(res.name=='conCompanyName'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    isvalid = false;
                    res.setCustomValidity('Please select a Company or check Company Not Found and provide your Company Name in Company/School of Pharmacy.');
                    res.reportValidity();
                }
            }else if(this.newContact.AccountId != null && (this.newContact.Company_Organization_Name__c != '' && this.newContact.Company_Organization_Name__c != undefined)){
                if(res.name=='conCompanyName'){
                    res.setCustomValidity("");
                    res.reportValidity();
                    isvalid = false;
                    res.setCustomValidity('Please enter only one out of Company and Company/School of Pharmacy.');
                    res.reportValidity();
                }
            }else{
                isvalid = true;
                res.setCustomValidity("");
                res.reportValidity();
            }

            if(this.newContact.Company_Organization_Name__c != '' && this.newContact.Company_Organization_Name__c != undefined){
                this.newContact.Company_Not_Found__c = true;
            }

          },this);
          

          inp2.forEach(function(res){
            /*
            if( res.name=='conSalutation'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please Select out Salutation');
                    res.reportValidity();
                }
            }
            */
            if( res.name=='conPhoneType'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Phone Type');
                    res.reportValidity();
                }
            }
            if( res.name=='conEmailType'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Email Type');
                    res.reportValidity();
                }
            }
            if( res.name=='conEmployerType'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Employer Type');
                    res.reportValidity();
                }
            }
            if( res.name=='conPrimaryPosition'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Primary Position');
                    res.reportValidity();
                }
            }
            if( res.name=='conJobRole'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Job Role');
                    res.reportValidity();
                }
            }
            if( res.name=='conAddressType'){
                if(this.dependentValues.length>1 && (res.value=='--- None ---' || res.value=='' || res.value==undefined)){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    res.setCustomValidity('Please fill out Address Type');
                    res.reportValidity();
                }
            }
           
        },this);

     
        var allAddress = this.template.querySelectorAll('lightning-input-address');
        allAddress.forEach(function(address){ 
            console.log('In allAddress check');
            if (!address.country||address.country=='--None--' || address.country=='') {
                address.setCustomValidityForField('Complete this field', 'country');
                address.reportValidity();
                isvalid = false;
            } else {
                address.setCustomValidityForField('', 'country');
                address.reportValidity();
            }
            if (!address.province||address.province=='--None--' || address.province=='') {
                address.setCustomValidityForField('Complete this field', 'province');
                address.reportValidity();
                isvalid = false;
            } else {
                address.setCustomValidityForField('', 'province');
                address.reportValidity();
            }
        },this);
        console.log('isvalid :: ',isvalid);
        if(isvalid){
            allAddress.forEach(function(address){ 
                if(address.name == 'Address'){
                    this.newContact.MailingStreet = address.street;
                    this.newContact.MailingCity = address.city;
                    this.newContact.MailingPostalCode = address.postalCode;
                    this.newContact.MailingState = address.province;
                    this.newContact.MailingCountry = address.country;
                }
            },this);

            this.newContact.Salutation = this.selectedSalutation;
           
            this.newContact.Address_Type__c = this.selectedAddressType;
            this.newContact.Primary_Position__c = this.selectedPosition;
            this.newContact.Job_Role__c = this.selectedJobRole;
            this.newContact.Employer_Type__c = this.selectedEmployerType;
            this.newContact.OrderApi__Preferred_Email_Type__c = this.selectedEmailType;
            this.newContact.OrderApi__Preferred_Phone_Type__c = this.selectedPhoneType;
            this.showLoadingSpinner = true;

            //if(this.accountRecordId!=undefined)
                //this.newContact.AccountId =  this.accountRecordId;
            console.log('all fields are okay');
            createAccount({con: this.newContact, username : this.conUsername, password : this.conPassword})
            .then(result => {
                console.log('========this.newContact========='+result);
                console.log('this.conUsername=========.  '+this.conUsername);
                console.log('this.conPassword=========.  '+this.conPassword);
                if(result=='success'){
                    //this.isAccountCreate = true;
                    setTimeout(() => {
                        login({username : this.conUsername, password : this.conPassword})
                        .then(result => {
                            console.log('========logged========='+result);
                            console.log('this.conUsername>>>  '+this.conUsername);
                            console.log('this.conPassword>>>  '+this.conPassword);
                            if(!result.includes('login attempt')){
                                if(this.retURLVal != '' && this.retURLVal != undefined){
                                    let hrefVAl = new URL(result);
                                    hrefVAl.searchParams.set('retURL', this.retURLVal);
                                    window.location.href = hrefVAl;
                                }else{
                                    window.location.href = result;
                                }
                            }else{
                                this.showLoadingSpinner = false;
                                const event = new ShowToastEvent({
                                    title: 'Error',
                                    variant: 'error',
                                    message: result
                                }); 
                                this.dispatchEvent(event);
                            }
                        })
                        .catch(error => {
                            console.error('Error logging in: ', error);
                            this.showLoadingSpinner = false;
                        
                            this.error = error;
                            const event = new ShowToastEvent({
                                title: 'Error',
                                variant: 'error',
                                message: error.body
                            });
                            this.dispatchEvent(event);
                        });

                        this.headerMsg = 'Record created!';
                        const event = new ShowToastEvent({
                            title: 'Success',
                            variant: 'success',
                            message: 'Record Created'
                        });
                        this.dispatchEvent(event);
                        this.isDisplay =true;
                        this.showLoadingSpinner = false;
                    
                        //var userCreationLabel = $A.get("$Label.c.UserCreated");
                        

                    }, 3000);
                }
                else{
                    this.isAccountCreate = true;
                    this.contentMsg = result;  
                    this.showLoadingSpinner = false;
                    const event = new ShowToastEvent({
                        title: 'Error',
                        variant: 'error',
                        message: result
                    }); 
                    this.dispatchEvent(event);
                }
                var scrollOptions = {
                    left: 0,
                    top: 0,
                    behavior: 'smooth'
                }
                window.scrollTo(scrollOptions);
            })
            .catch(error => {
                this.showLoadingSpinner = false;
             
                this.error = error;
                const event = new ShowToastEvent({
                    title: 'Error',
                    variant: 'error',
                    message: error.body
                  });
                this.dispatchEvent(event);
            }); 
        }
        }catch(e){
            console.log('exception message :: ');
            console.log(e.message);
        }
    }
    

    handleFieldChangeState(event){
        this.newContact.MailingState = event.target.value;
    }
    cancelAction(){
        location.href = CancelButton;
    }
    
    salutationsList = [
        { label: 'Esq.', value: 'Esq.' },
        { label: 'II.', value: 'II.' },
        { label: 'III.', value: 'III' },
        { label: 'Jr.', value: 'Jr.' },
        { label: 'Sr.', value: 'Sr.' },
    ];
    get salutationOptions() {
        return this.salutationsList;
    }

    onHomeControllerFieldChange(event) {
		const allOtherAddress = this.template.querySelectorAll('lightning-input-address');
		allOtherAddress.forEach(function(address){
			//if(address.name == 'otherAddress'){
				if (!address.country||address.country=='--None--' || address.country=='') {
					address.setCustomValidityForField('Complete this field', 'country');
					address.reportValidity();
				} else {
					address.setCustomValidityForField('', 'country');
					address.reportValidity();
				}
				this.newContact.OtherCountry = event.detail.country;//event.detail.country//event.target.value;
				var controllerValueKey = event.detail.country;//event.detail.country; //event.target.value;
				var depnedentFieldMap = this.depnedentFieldMap;
				this.bDisabledDependentFld = true; 
				this.dependentHomeValues= [];
				
                
				if (controllerValueKey != '--- None ---' || controllerValueKey != '' || controllerValueKey != undefined) {
					var ListOfDependentFields = depnedentFieldMap[controllerValueKey];
					if(ListOfDependentFields.length > 0){
						this.bDisabledDependentFld = false;  
						this.fetchHomeDepValues(ListOfDependentFields);    
					}else{
						this.bDisabledDependentFld = true; 
						this.dependentHomeValues = [];
					}  
					
				} else {
					this.bDisabledDependentFld = true; 
					this.dependentHomeValues= [];
				}
                this.newContact.OtherStreet = event.detail.street;
                this.newContact.OtherCity = event.detail.city;
                this.newContact.OtherPostalCode = event.detail.postalCode;
                this.newContact.OtherState = event.detail.province;

			//}
		},this);
    }

    fetchHomeDepValues(ListOfDependentFields){
        this.dependentHomeValues = [];
        var dep = [];
        for (var i = 0; i < ListOfDependentFields.length; i++) {
            dep.push({label : ListOfDependentFields[i], value : ListOfDependentFields[i]});
        }
        this.dependentHomeValues = dep;
    }
}


  /************/

   /* loadRecaptcha() {
        const script = document.createElement('script');
        script.src = 'https://www.google.com/recaptcha/api.js?render=your_site_key';
        script.onload = () => {
            grecaptcha.ready(() => {
                grecaptcha.render(this.template.querySelector('#recaptcha-container'), {
                    'sitekey': '6LfKhgwqAAAAAFRC2-7bRLU1bKpGUmMdJ6OPi_x7',
                    'callback': this.recaptchaCallback.bind(this)
                });
            });
        };
        this.template.querySelector('head').appendChild(script);
    }

    recaptchaCallback(token) {
        this.recaptchaToken = token;
    }

  createAccount() {
        if (this.recaptchaToken) {
            verifyRecaptcha({ recaptchaToken: this.recaptchaToken })
                .then(result => {
                    if (result) {
                        console.log('reCAPTCHA verification successful.');
                        // Proceed with account creation logic here
                    } else {
                        console.error('reCAPTCHA verification failed.');
                    }
                })
                .catch(error => {
                    console.error('Error verifying reCAPTCHA:', error);
                });
        } else {
            console.error('reCAPTCHA token is not available.');
        }
    }
}*/