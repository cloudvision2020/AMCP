import { LightningElement, track, api } from 'lwc';
import findRecords from "@salesforce/apex/LwcCustomLookupController.findRecords";
import createAccount from "@salesforce/apex/LwcCustomLookupController.createAccount";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import No_Records_Found from '@salesforce/label/c.No_Records_Found';
import Something_went_wrong from '@salesforce/label/c.Something_went_wrong';
import Remove_selected_option from '@salesforce/label/c.Remove_selected_option';
import Remove_selected_record from '@salesforce/label/c.Remove_selected_record';
import New_Record from '@salesforce/label/c.New_Record';
import Account_Name_Validation from '@salesforce/label/c.Account_Name_Validation';
import Cancel from '@salesforce/label/c.Cancel';
import Save from '@salesforce/label/c.Save';
import success from '@salesforce/label/c.success';
import Account_Created from '@salesforce/label/c.Account_Created';

export default class CustomLookup extends LightningElement {
  @api objDetail = {'sobjectType': 'Account' };
  @track newAccount =  {'sobjectType': 'Account' };
  @track recordsList;
  @track searchKey = "";
  @api selectedValue;
  @api selectedRecordId;
  @api objectApiName;
  @api iconName;
  @api lookupLabel;
  @api name;
  @track isNewRecord = false;
  @track message;
  @track selectedRecordList = [];
  @track showSpinner = false;
  @api accountrecordid;
  @api accountRecordType;
  @track showSpinner = false;
  @api isNew;
  @track districtType = '';
  @api roleValue;

  label = {
    Remove_selected_option,
    Remove_selected_record,
    New_Record,
    Account_Name_Validation,
    Cancel,
    Save,
    success,
    Account_Created
  }

  onLeave(event) {
    setTimeout(() => {
      this.searchKey = "";
      this.recordsList = null;
    }, 300);
  }
  onRecordSelection(event) {
    this.selectedRecordId = event.target.dataset.key;
    this.selectedValue = event.target.dataset.name;
    this.recordsList.forEach(element => {
      if (element.Id == event.target.dataset.key) {
        this.selectedRecordList = element;
      }
    });
    this.searchKey = "";
    this.onSeletedRecordUpdate();
  }
  handleKeyChange(event) {
    const searchKey = event.target.value;
    this.searchKey = searchKey;
    this.getLookupResult();
  }
  removeRecordOnLookup(event) {
    this.searchKey = "";
    this.selectedValue = null;
    this.selectedRecordId = null;
    this.recordsList = null;
    this.onSeletedRecordUpdate();
  }
  getLookupResult() {
   
    findRecords({ searchKey: this.searchKey, objectName: this.objectApiName, rtName: this.accountRecordType})
      .then((result) => {
        if (result.length === 0) {
          this.recordsList = [];
          this.message = No_Records_Found;
        } else {
          this.recordsList = result;
          this.message = "";
        }
        this.error = undefined;
      })
      .catch((error) => {
        this.error = error;
        this.recordsList = undefined;
      });
  }

  onSeletedRecordUpdate() {    
    const passEventr = new CustomEvent('recordselection', {
      detail: { 
        selectedRecordId: this.selectedRecordId, 
        selectedValue: this.selectedValue  
      }
    });
    this.dispatchEvent(passEventr);
  }
  createNewRecord() {
    this.isNewRecord = !this.isNewRecord;
  }

  insertNewRecord() {
    var inp=this.template.querySelectorAll("lightning-input");
    var isvalid = true;

    inp.forEach(function(res){

        if(res.name=='acntName'){
          if(!res.checkValidity()){
              res.showHelpMessageIfInvalid();
              isvalid = false;
          }
        }

        if(res.name=='acntName'){
            this.newAccount.Name = res.value;
        }
        if(res.name=='acntPhone'){
            this.newAccount.Phone = res.value;
        }
      },this);
      
      if(isvalid){
        this.showSpinner = true;
        createAccount({
          acnt: this.newAccount,
          rtName: this.accountRecordType
        })
        .then(result => {
            if(result!='null' && result != null){
                //this.headerMsg = 'Record Created';
                this.showSpinner = false;
                const event = new ShowToastEvent({
                    title: success,
                    variant: success,
                    message: Account_Created
                  });
                this.dispatchEvent(event);
                this.selectedValue = result.Name;
                this.selectedRecordId = result.Id;
                
                this.onSeletedRecordUpdate();
                this.isNewRecord = !this.isNewRecord;
                
                
            }else{
              this.showSpinner = false;
              const event = new ShowToastEvent({
                  title: 'Error',
                  variant: 'error',
                  message: result
              }); 
            this.dispatchEvent(event);
          }
        })
        .catch(error => {
            this.showSpinner = false;
            this.error = error;
            const event = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                //message: error.body
                message: this.error
              });
            this.dispatchEvent(event);
        });
      }
  }


  handleSuccess(event) {
    this.showSpinner = true;
    this.isNewRecord = false;
    const evt = new ShowToastEvent({
      title: Account_Created,
      message: 'Record ID: ' + event.detail.id,
      variant: success,
    });
    this.dispatchEvent(evt);
  }
  handleError(event) {
    let message = event.detail.detail;
    message = Something_went_wrong;
    
  }
  get checkLabel(){
    return this.lookupLabel=='School';
  }
}