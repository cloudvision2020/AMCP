import { LightningElement, api } from 'lwc';
import userId from "@salesforce/user/Id";
import isGuest from "@salesforce/user/isGuest";
import enroll from "@salesforce/apex/CourseEnrollmentController.enroll";

export default class Enrollment extends LightningElement {

  _receiptName;

  @api set receiptName(value){
    this._receiptName = value;
    this.startEnrollment();
  }

  get receiptName(){
    return this._receiptName;
  }

  get isGuestUser(){
    //return isGuest;
    return isGuest;
  }

  startEnrollment(){
    if(!isGuest && this.receiptName){
      let payload = {userId : userId, receiptName : this.receiptName};
      enroll(payload)
       .then(result => {
        this.handleClose();
     })
     .catch(error =>{
       console.log('could not enroll user in course');
       console.log(error);
       this.error = error;
       this.forceClose();
     });
    } else{
      this.forceClose();
    }
  }

  handleClose(){
    this.dispatchEvent(new CustomEvent('manual'));
  }

  forceClose(){
    this.template.querySelector('[data-name="continueButton"]').click();
  }

  manualClose(){
    this.handleClose();
  }
}