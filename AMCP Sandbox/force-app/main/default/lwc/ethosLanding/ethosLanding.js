import { LightningElement, wire } from 'lwc';
import userId from "@salesforce/user/Id";
import isGuest from "@salesforce/user/isGuest";
import {NavigationMixin} from 'lightning/navigation';
import initiateCheckout from '@salesforce/apex/EthosLandingController.initiateCheckout';

export default class EthosLanding extends NavigationMixin(LightningElement) {

  salesOrder;

  get salesOrderId(){
    if(salesOrder){
      return salesOrder.Id;
    }
  }


  error;

  get isError(){
    if(this.error){
      return true;
    } else{
      return false;
    }
  }

  get errorMessage(){
    if(this.error){
      return this.error.body.message;
    }
  }

  connectedCallback(){

    if(!isGuest){
          initiateCheckout({userId})
          .then(result => {
            this.salesOrder = result;
            this.redirectUser();
          })
          .catch(error =>{
            console.log('error');
            console.log(JSON.stringify(error));
            this.error = error;
          });
    }
  }

  redirectUser(){
    if(this.salesOrder){
          const baseUrl = '/store#/store/checkout/';
          let redirectUrl = baseUrl+this.salesOrder.OrderApi__Encrypted_Id__c;
          const pageReference = {
            type : 'standard__webPage',
            attributes : {
              url : redirectUrl
            }
          };

          this[NavigationMixin.Navigate](pageReference);
    }
  }
}