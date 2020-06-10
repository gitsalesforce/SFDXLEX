import {
    LightningElement,
    wire,
    track
} from 'lwc';
 
//import method from the Apex Class
import fetchAccounts from '@salesforce/apex/LWCWeek_Controller_Account.fetchAccounts';
 
// Declaring the columns in the datatable
const columns = [{
        label: 'View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            iconName: 'action:preview',
            title: 'Preview',
            variant: 'border-filled',
            alternativeText: 'View'
        }
    },
    {
        label: 'Name',
        fieldName: 'Name',
        sortable: "true"
    },
    {
        label: 'Phone',
        fieldName: 'Phone',
        sortable: "true"
    },
    {
        label: 'Type',
        fieldName: 'Type',
        sortable: "true"
    }
];
 
// declare class to expose the component
export default class LWCWeek_AccountTable extends LightningElement {
    //reactive variables
   // columns = columns;
    set_size = 5;
    perpage = 10;
    data = [];
    @track columns = columns
    @track record = {};
    @track rowOffset = 0;
    @track bShowModal = false;
    @track page = 1;//current page number
    @track pages = [];
    @track sortBy;
    @track sortDirection='asc';
    renderedCallback() {
        this.renderButtons();
    }
    renderButtons = () => {
        this.template.querySelectorAll('button').forEach((but) => {
            but.style.backgroundColor = this.page === parseInt(but.dataset.id, 10) ? 'dodgerblue' : 'white';
            but.style.color = this.page === parseInt(but.dataset.id, 10) ? 'white' : 'black';
        });
    }
    get pagesList() {
        let mid = Math.floor(this.set_size / 2) + 1;
        if (this.page > mid) {
            return this.pages.slice(this.page - mid, this.page + mid - 1);
        }
        return this.pages.slice(0, this.set_size);
    }
    async connectedCallback() {
        this.data = await fetchAccounts();
        this.setPages(this.data);
    }
    pageData = () => {
        let page = this.page;
        let perpage = this.perpage;
        let startIndex = (page * perpage) - perpage;
        let endIndex = (page * perpage);
        return this.data.slice(startIndex, endIndex);
    }
    setPages = (data) => {
        console.log(data.length);
        let numberOfPages = Math.ceil(data.length / this.perpage);
        console.log(numberOfPages);
        for (let index = 1; index <= numberOfPages; index++) {
            this.pages.push(index);
        }
    }
    get hasPrev() {
        return this.page > 1;
    }
    get hasNext() {
        return this.page < this.pages.length
    }
    onNext = () => {
        ++this.page;
    }
    onPrev = () => {
        --this.page;
    }
    onPageClick = (e) => {
        this.page = parseInt(e.target.dataset.id, 10);
    }
    get currentPageData() {
        return this.pageData();
    }
    // Row Action event to show the details of the record
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        const fetchid = event.detail.row.Id;
        this.bShowModal = true; // display modal window
    }
 
    // to close modal window set 'bShowModal' tarck value as false
    closeModal() {
        this.bShowModal = false;
    }
    //Handle sorting data
    handleSortdata(event) {
        // field name
        this.sortBy = event.detail.fieldName;

        // sort direction
        this.sortDirection = event.detail.sortDirection;

        // calling sortdata function to sort the data based on direction and selected field
        this.sortData(event.detail.fieldName, event.detail.sortDirection);
    }
    //sortData function
    sortData(fieldname, direction) {
        // serialize the data before calling sort function
        let parseData = JSON.parse(JSON.stringify(this.data));

        // Return the value stored in the field
        let keyValue = (a) => {
            return a[fieldname];
        };

        // cheking reverse direction 
        let isReverse = direction === 'asc' ? 1: -1;

        // sorting data 
        parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : ''; // handling null values
            y = keyValue(y) ? keyValue(y) : '';

            // sorting values based on direction
            return isReverse * ((x > y) - (y > x));
        });

        // set the sorted data to data table data
        this.data = parseData;

    }
}