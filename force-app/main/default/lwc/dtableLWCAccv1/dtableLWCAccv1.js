import { LightningElement, track, wire } from 'lwc';
import fetchAccounts from '@salesforce/apex/dtablecontroller.fetchAccounts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class DtableLWCAccv1 extends LightningElement {

    @track gridColumns = [{
        type: 'text',
        fieldName: 'Name',
        label: 'Name'
    },
    {
        type: 'text',
        fieldName: 'Industry',
        label: 'Industry'
    },
    {
        type: 'text',
        fieldName: 'FirstName',
        label: 'FirstName'
    },
    {
        type: 'text',
        fieldName: 'LastName',
        label: 'LastName'
    }];
    _title = 'Sample Title';
    message = 'Sample Message';
    variant = 'error';
    variantOptions = [
        { label: 'error', value: 'error' },
        { label: 'warning', value: 'warning' },
        { label: 'success', value: 'success' },
        { label: 'info', value: 'info' },
    ];

    titleChange(event) {
        this._title = event.target.value;
    }

    messageChange(event) {
        this.message = event.target.value;
    }

    variantChange(event) {
        this.variant = event.target.value;
    }

    showNotification() {
        const evt = new ShowToastEvent({
            title: this._title,
            message: this.message,
            variant: this.variant,
        });
        this.dispatchEvent(evt);
    }
    @wire(fetchAccounts)
    accountTreeData({ error, data }) {
        if (data) {

            var tempData = JSON.parse(JSON.stringify(data));
            var tempjson = JSON.parse(JSON.stringify(data).split('Contacts').join('_children'));
            console.log('Temp JSON is ' + tempjson);
            for (var i = 0; i < tempData.length; i++) {

                tempData[i]._children = tempData[i]['Contacts'];
                delete tempData[i].Contacts;

            }
            this.gridData = tempData;

        } else if (error) {

            if (Array.isArray(error.body))
                console.log('Error is ' + error.body.map(e => e.message).join(', '));
            else if (typeof error.body.message === 'string')
                console.log('Error is ' + error.body.message);

        }

    }

}