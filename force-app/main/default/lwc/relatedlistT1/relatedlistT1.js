import {LightningElement,track,api,wire} from "lwc";
import findContacts from '@salesforce/apex/relatedobjects.getContacts';
const DELAY = 300;
export default class relatedlistT1 extends LightningElement {
    @track selectedAccountRecord;
    @api accountRecord;
     //Wire method for fetchingcontacts of selected account
  @wire(findContacts, { searchKey: '$selectedAccountRecord' })
  contacts

  //for creation of contacts
  handlelookupselectaccount(event) {
    this.selectedAccountRecord = event.detail;
    console.log('relatedlist'+this.selectedAccountRecord);
  }
  handleaccountselectaccount(event){
    this.selectedAccountRecord = event.detail;
    console.log('relatedlist'+this.selectedAccountRecord);
  }
}