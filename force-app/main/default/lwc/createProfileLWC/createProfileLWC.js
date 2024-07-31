import { LightningElement,track,api,wire } from 'lwc';


export default class CreateProfileLWC extends LightningElement {

    strLinkLable = 'Create a profile';
    strNavigateUrlValue = '/s/login/SelfRegister';
   // strReturnURLValue;

    connectedCallback(){
        this.initURLData();
    }
    
    initURLData(){
        const strKeyReturnURL = 'ReturnUrl=';
        let fullPageURL = window.location.href;
        let decodedURL = decodeURIComponent(fullPageURL);
        const lstSplitURL = decodedURL.split(strKeyReturnURL);
        if(lstSplitURL.length > 1){
            let strReturnURLValue = lstSplitURL[1];
            this.strNavigateUrlValue = this.strNavigateUrlValue + '?' + strKeyReturnURL + lstSplitURL[1];
           
            
        }
        
    }

    
}