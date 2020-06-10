import { LightningElement, api, track,wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class AccountContactFormT1 extends LightningElement {
  @api accountRecord;
  @api eventRecordId;
  @track isLoaded = false;
  handleOnLoad() {
    this.isLoaded = true;
  }

  handleContactSuccess(event) {
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: "Contact created Successfully.",
        variant: "success"
      })
    );
    this.dispatchEvent(
      new CustomEvent("contactsuccess", {
        detail: event.detail.id,
        bubbles: true
      })
    );
  }

  handleOnContactSubmit(event) {
    event.preventDefault(); // stop the form from submitting
    const fields = event.detail.fields;
    if (this.accountRecord === undefined || this.accountRecord === null) {
      this.dispatchEvent(
        new ShowToastEvent({
          title: "Error",
          message: "Please select an Account",
          variant: "error"
        })
      );
      return;
    }

    fields.AccountId = this.accountRecord.Id;
    this.template.querySelector("lightning-record-edit-form").submit(fields);
  }
  cancelContactScreen() {
    this.dispatchEvent(
      new CustomEvent("contactcancel", {
        bubbles: true
      })
    );
  }
}