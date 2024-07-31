import { LightningElement, track, wire, api } from "lwc";  
import findRecords from "@salesforce/apex/LwcLookupController.findRecords";  

export default class FonlwcLookup extends LightningElement {  
  @track recordsList;  
  @track searchKey = "";  
  @api selectedValue;  
  @api selectedRecordId;  
  @api objectApiName;  
  @api iconName;  
  @api lookupLabel;
  @api contactType;   
  @track message;  
  @api inputClass = 'slds-input slds-combobox__input slds-combobox__input-value';
  @api helpText = '';
  @api accountType;
  //@api parentId;

  parentRecordId;
  @api
    get parentId() {
        return this.parentRecordId;
    }

    set parentId(value) {
      if(value){
        this.parentRecordId = value;
      }
      else{
        this.selectedValue = null;  
        this.selectedRecordId = null; 
        this.parentRecordId = null;
        this.onSeletedRecordUpdate();  
      }
       
    }

    connectedCallback(){
      if(this.selectedValue && this.selectedRecordId){
        this.inputClass = "slds-input slds-combobox__input slds-combobox__input-value";
        this.onSeletedRecordUpdate();  
      }
    }

  
  handleOnClick(event){
    this.getLookupResult();  
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
   this.searchKey = "";  
   this.inputClass = "slds-input slds-combobox__input slds-combobox__input-value";
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
   this.inputClass = "slds-input slds-combobox__input slds-combobox__input-value errClass";
 
   this.onSeletedRecordUpdate();  
 } 
 getLookupResult() {  
    //alert(this.accountType);
    //alert(this.parentId);
    findRecords({ searchKeyWord: this.searchKey, ObjectName : this.objectApiName, strAccType : this.accountType, strParentId : this.parentRecordId })  
     .then((result) => {  
      if (result.length===0) { 
        this.inputClass = "slds-input slds-combobox__input slds-combobox__input-value errClass"; 
        this.recordsList = [];  
        this.message = "No Records Found";  
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
    
   onSeletedRecordUpdate(){  
   
    const passEventr = new CustomEvent('recordselection', {  
      detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }  
     });  
     this.dispatchEvent(passEventr);  
   }  
}