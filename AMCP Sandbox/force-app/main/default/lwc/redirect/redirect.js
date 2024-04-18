import { LightningElement, api } from 'lwc';
import { NavigationMixin } from "lightning/navigation";
export default class Redirect extends NavigationMixin(LightningElement) {
  @api item;

  get itemLabel() {
    return this.item?.name;
  }

  handleRedirect() {

    const redirectUrl = this.item?.url;

    this[NavigationMixin.Navigate]({
      type: "standard__webPage",
      attributes: {
        url: redirectUrl,
      },
    });
  }

}