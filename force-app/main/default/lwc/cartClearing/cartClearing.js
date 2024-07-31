import { LightningElement, api } from 'lwc';
import isGuest from "@salesforce/user/isGuest";
import clearCart from "@salesforce/apex/CartClearingController.clearCart";

export default class CartClearing extends LightningElement {
  _receiptName;

  @api set receiptName(value){
    this._receiptName = value;
    this.initiateCartClearing();
  }

  get receiptName(){
    return this._receiptName;
  }

  get isGuestUser(){
    return isGuest;
  }

  initiateCartClearing(){
    if(!isGuest && this.receiptName){
      let payload = {receiptName : this.receiptName};
      clearCart(payload)
       .then(result => {
        this.handleClose();
     })
     .catch(error =>{
       this.error = error;
       console.log('Cart Clearing failed');
       console.log(error);
       console.log(JSON.stringify(error));
       this.handleClose();

     });
    } else{
      this.handleClose();
    }
  }

  handleClose(){
    this.dispatchEvent(new CustomEvent('close'));
  }

    manualClose(){
      this.dispatchEvent(new CustomEvent('manual'));
    }

}