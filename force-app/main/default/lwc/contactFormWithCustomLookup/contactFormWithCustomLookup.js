import {
  LightningElement,
  track,
  api
} from "lwc";
import {
  NavigationMixin
} from "lightning/navigation";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ContactFormWithCustomLookup extends NavigationMixin(LightningElement) {
  _title = 'Contact Created';
  message = 'Successfully';
  variant = 'success';
  @api title = "Contact Creation of Account";
  @track selectedAccountRecord;
  @track isLoaded = false;

  contactCreateSuccess(event) {
    const evt = new ShowToastEvent({
      title: this._title,
      message: this.message,
      variant: this.variant,

      
  });
  this.dispatchEvent(evt);
  }
  contactCancel() {
    this[NavigationMixin.Navigate]({
      type: "standard__objectPage",
      attributes: {
        objectApiName: "Account",
        actionName: "home"
      }
    });
  }
  //for creation of contacts
  handlelookupselectaccount(event) {
    this.selectedAccountRecord = event.detail;
    console.log('contactform parent'+this.selectedAccountRecord);
  }
  onaccountselect(event){
    this.selectedAccountRecord = event.detail;
    console.log('contactform parent'+this.selectedAccountRecord);
  }
}