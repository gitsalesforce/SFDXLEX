import { LightningElement, track, api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getLookupSerachRecords from '@salesforce/apex/ManageRecordsController.getLookupSerachRecords';
import findContacts from '@salesforce/apex/relatedobjects.getContacts';
/** The delay used when debouncing event handlers before invoking Apex. */
const DELAY = 100;
export default class LookupSearch extends LightningElement {
  // Tracked properties  
  @track records;
  @track noRecordsFlag = false;
  @track showoptions = true;
  searchString = '';
  @track selectedName; //selected Name
  @track selectedId;//selected id
  // API properties  
  @api selectedsobject;
  @api recordlimit;
  @api label;
  @track error;
  @track contacts;
  @wire(getLookupSerachRecords, { searchString: '$searchString', selectedSObject: '$selectedsobject', recordLimit: '$recordlimit' })
  wiredContacts({ error, data }) {
    this.noRecordsFlag = 0;
    if (data) {
      this.records = data;
      this.error = undefined;
      this.noRecordsFlag = this.records.length === 0 ? true : false;
    } else if (error) {
      this.error = error;
      this.records = undefined;
    }
  }
  //Wire method for fetchingcontacts of selected account
  @wire(findContacts, { searchKey: '$selectedName' })
  contacts
  @wire(findContacts)
  imperativeWiring(result) {
    this.contacts = result;
    if (result.data) {
      this.contacts = JSON.stringify(result.data);
    }
  }
  @api
  refresh() {
    return refreshApex(this.contacts);
  }
  
  connectedCallback() {
    findContacts().then(results => {
      this.contacts = results;
    })
      .catch(error => {
        this.error = error;
      });
    // Debouncing this method: Do not update the reactive property as long as this function is
    // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
    window.clearTimeout(this.delayTimeout);
    const searchKey1 = this.selectedName;
    this.delayTimeout = setTimeout(() => {
      this.searchKey = searchKey1;
    }, DELAY);
  }
  // handle event called lookupselect  
  handlelookupselect(event) {
    this.selectedName = event.detail.Name;//Name
    this.selectedId = event.detail.Id;//Name
    console.log(this.selectedName);
    console.log(this.selectedId);
    this.showoptions = false;
  }
  // key change on the text field  
  handleKeyChange(event) {
    this.showoptions = true;
    this.searchString = event.target.value;
  }

}