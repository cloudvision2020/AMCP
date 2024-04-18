import { LightningElement, api } from 'lwc';
import isGuest from "@salesforce/user/isGuest";
import getRedirectInformation from '@salesforce/apex/RedirectDisplayController.getRedirectInformation';
import purchaseContainsEthosItems from '@salesforce/apex/RedirectDisplayController.purchaseContainsEthosItems';

export default class RedirectDisplay extends LightningElement {

  _receiptName;
  redirects = [];

  @api set receiptName(value){
    this._receiptName = value;
    this.initialize();
  }

  get receiptName(){
    return this._receiptName;
  }

  get hasRedirects(){
    if(this.redirects.length == 0){
      return false;
    }else{
      return true;
    }
  }

  initialize(){

    console.log('LWC loaded');
    console.log(this.receiptName);


    if(!isGuest && this.receiptName){
      this.verifyPurchaseContainsEthosItem();
      this.retrieveRedirectInformation();
    }else{
      this.handleClose();
    }
  }

  verifyPurchaseContainsEthosItem(){
    let payload = {receiptName : this.receiptName};
    purchaseContainsEthosItems(payload)
    .then(result => {
      console.log('verifyPurchaseContainsEthosItem');
      console.log(result);
        if(result == false){
          this.handleClose();
        }
    })
    .catch(error =>{
      this.error = error;
      console.log(' Ethos redirect error');
      console.log(error);
    });
  }


  retrieveRedirectInformation(){
    let payload = {receiptName : this.receiptName};
    getRedirectInformation(payload)
    .then(result => {
      this.redirects = result;
      this.evaluateRedirect();
    })
    .catch(error =>{
      this.error = error;
      console.log(' Ethos redirect error');
      console.log(error);
    });
  }

  evaluateRedirect(){
    if(this.hasRedirects == false){
      this.handleClose();
    }
  }

  handleClose(){
    this.dispatchEvent(new CustomEvent('close'));
  }
}