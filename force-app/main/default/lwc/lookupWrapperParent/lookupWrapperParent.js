import { LightningElement, track } from 'lwc';  
export default class LookupWrapperParent extends LightningElement {  
  @track selectedAccountRecord;  
  @track selectedContactRecord;  
  @track selectedOppsRecord;
  // Event bubbles to grandparent and being handled here - Account  
  handlelookupselectaccount(event) {  
    this.selectedAccountRecord = event.detail;  
  }  
  // Event bubbles to grandparent and being handled here - Contact  
  handlelookupselectcontact(event) {  
    this.selectedContactRecord = event.detail;  
  }  
  // Event bubbles to grandparent and being handled here - Opportunity  
  handlelookupselectopps(event) {  
    this.selectedOppsRecord = event.detail;  
  }  
}