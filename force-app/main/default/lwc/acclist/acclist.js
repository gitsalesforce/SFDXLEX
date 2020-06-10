import { LightningElement, track, wire } from 'lwc';
import searchAccount from '@salesforce/apex/leadsearchcontroller.searchAccount';
import { NavigationMixin } from 'lightning/navigation';
const DELAY = 100;
const COLS = [
    {
        label: 'Name',
        fieldName: 'Name',
        type: 'text'
    },
    {
        label: 'Rating',
        fieldName: 'Rating',
        type: 'text'
    },
    {
        label: 'View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            title: 'View Details',
            alternativeText: 'View Details',
            iconName: 'action:info'

        }
    }
];

export default class acclist extends NavigationMixin(LightningElement) {
    @track accounts = [];//account
    @track searchTerm;//account
    @track cols = COLS;
    @track error;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        if (this.Account) {
            const selectedEvent = new CustomEvent('newsearchacc', { detail: this.searchTerm });
            window.clearTimeout(this.delayTimeout);
            // eslint-disable-next-line @lwc/lwc/no-async-operation
            this.delayTimeout = setTimeout(() => {
                this.dispatchEvent(selectedEvent);
            }, DELAY);
        }
    }

    @wire(searchAccount, {
        searchTerm: '$searchTerm'
    })
    loadAccount({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: row.Id,
                actionName: 'view',
            },
        });
    }

}