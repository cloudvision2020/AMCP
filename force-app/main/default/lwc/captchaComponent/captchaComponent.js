import { LightningElement , track } from 'lwc';
import validateRecaptcha from '@salesforce/apex/RecaptchaController.validateRecaptcha';
export default class CaptchaComponent extends LightningElement {
    @track isButtonDisabled = true;
    siteKey = '6LfKhgwqAAAAAFRC2-7bRLU1bKpGUmMdJ6OPi_x7';
    recaptchaResponse;

    connectedCallback() {
        // Load the Google reCAPTCHA API script
        const script = document.createElement('script');
        script.src = 'https://www.google.com/recaptcha/api.js';
        script.async = true;
        script.defer = true;
        this.template.querySelector('div').appendChild(script);
    }

    onRecaptchaSuccess(response) {
        this.recaptchaResponse = response;
        this.isButtonDisabled = false;
    }

    handleSubmit() {
        if (this.recaptchaResponse) {
            validateRecaptcha({ response: this.recaptchaResponse })
                .then((result) => {
                    if (result.success) {
                        // Handle success scenario
                        console.log('reCAPTCHA validated successfully');
                    } else {
                        // Handle failure scenario
                        console.error('reCAPTCHA validation failed');
                    }
                })
                .catch((error) => {
                    console.error('Error in reCAPTCHA validation', error);
                });
        }
    }
}