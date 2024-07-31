import { LightningElement, track, api, wire } from 'lwc';
import createAccount from '@salesforce/apex/SearchCommunityUserController.saveContact';
import activateUser from '@salesforce/apex/SearchCommunityUserController.activateUser';
import noemailfound from '@salesforce/label/c.No_Account_Found';
import Company_Not_Found from '@salesforce/label/c.Company_Not_Found';
import Create_Account from '@salesforce/label/c.Create_Account';
import Contact_Suffix from '@salesforce/schema/Contact.Suffix';
import { getPicklistValues } from "lightning/uiObjectInfoApi";
import SUFFIX_FIELD from "@salesforce/schema/Contact.Suffix";
export default class CreateCommunityUser extends LightningElement {
    @track isDisplay = false;
    @api objDetail = {'sobjectType': 'Contact' };
    @track newContact =  {'sobjectType': 'Contact' };
    @api conObjList = [];
    @track contactRole=[];
    @api contactRoleselected= '';
    @track contactEsdValues=[];
    @api contactEsdSelected= '';
    @track email='';
    @track depnedentFieldMap;
    @api recordId;
    @track bDisabledDependentFld = false; 
    @track showLoadingSpinner = false;
    @track accountName;  
    @track accountRecordId;  
    @track username='';  
    @track accRtName;
    @track isVisible = false;
    @track showSpinner = false;
    @track isEsdVisible = false;
    @track isNew = false;
    @track roleValue;
    @track lookupLabel = 'Company';

    @wire(getPicklistValues, { fieldApiName: SUFFIX_FIELD })
    
    fields = [Contact_Suffix];

    label = {
        noemailfound,
        Company_Not_Found,
        Create_Account
    }
    
    activateUser(event){
        this.showLoadingSpinner = true;
        var conId = event.target.name;
        activateUser({contactId: conId })
        .then(result => {
            if(result=='success'){
                const event = new ShowToastEvent({
                    title: 'Success',
                    variant: 'success',
                    message: Record_Created
                  });
                this.dispatchEvent(event);
                this.isDisplay =true;
                this.showLoadingSpinner = false;
               
                //var userCreationLabel = $A.get("$Label.c.UserCreated");
                this.contentMsg = UserCreated;  
              
            }
            else{
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
        //window.location.reload();
    }

    @api selectedRecord;
    @api sectionName;
    onRecordSelection(event){
       
        this.sectionName= event.detail.selectedValue;
        this.selectedRecord=event.detail.selectedRecordId;
        this.accountRecordId= this.selectedRecord;
    }
    

   
   
    createAccount(){
        this.showLoadingSpinner = true;
        var inp=this.template.querySelectorAll("lightning-input");
        var inp2=this.template.querySelectorAll("lightning-combobox");
        var isvalid = true;        
        inp.forEach(function(res){
            if(res.name=='conEmail' || res.name=='conFirstName' || res.name=='conLastName' || res.name=='conTitle'){
                if(!res.checkValidity()){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    this.showLoadingSpinner = false;
                }
            }
            switch (res.name){ 
                case "conFirstName":
                    this.newContact.FirstName = res.value;
                    break;
                //case "conMiddleName":
                    //this.newContact.Informal_Name__c = res.value;
                    //break;
                case "conLastName":
                    this.newContact.LastName = res.value;
                    break;
                case "conEmail":
                    this.newContact.Email = res.value;
                    break;
                case "conTitle":
                    this.newContact.Title = res.value;
                    break;
            }

          },this);

        inp2.forEach(function(res){
            if(res.name == 'ContactRolePicklist'|| res.name == 'ContactEsdPicklist'){
                if(!res.checkValidity()){
                    res.showHelpMessageIfInvalid();
                    isvalid = false;
                    this.showLoadingSpinner = false;
                }
            }
        },this);

        if(this.isVisible && (this.accountRecordId==''|| this.accountRecordId==undefined ||this.accountRecordId==null)){
            this.showLoadingSpinner = false;
            isvalid = false;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: Error_Fill_Account
            }); 
            this.dispatchEvent(event);
        }
        
        if(isvalid){
            if(this.accountRecordId!=undefined)
                this.newContact.AccountId =  this.accountRecordId;
            createAccount({con: this.newContact})
            .then(result => {
                if(result=='success'){
                    this.showLoadingSpinner = false;
                    const event = new ShowToastEvent({
                        title: 'Success',
                        variant: 'success',
                        message: Record_Created
                      });
                    this.dispatchEvent(event);
                    this.isDisplay =true;
                    this.contentMsg = UserCreated;  

                    this.newContact = '';
                    this.isVisible = false;
                    this.isEsdVisible = false;
                }
                else{
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
    }
    onAccountSelection(event){  
        this.accountName = event.detail.selectedValue;  
        this.accountRecordId = event.detail.selectedRecordId;  
    } 
    handleFieldChangeState(event){
        this.newContact.MailingState = event.target.value;
    }
    cancelAction(){
        location.href = CancelButton;
    }
    
}