import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import searchAccount from '@salesforce/apex/leadsearchcontroller.searchAccount';
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
        //Details of Account
        label: 'Account Page View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            name:'View Details',
            title: 'View Details',
            alternativeText: 'View Details',
            iconName: 'action:info'
        }
    },
    {
        //Related Conatact Details of Account
        label: 'Account Related View',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            name:'View Related Details',
            title: 'View Related Details',
            alternativeText: 'View Related Details',
            iconName: 'action:info'
        }
    },
    {
        //Related Conatact Details of Account
        label: 'Account Edit',
        type: 'button-icon',
        initialWidth: 75,
        typeAttributes: {
            name:'Account Edit',
            title: 'View Related Detail',
            alternativeText: 'View Related Detail',
            iconName: 'action:info'
        }
    },

];
export default class LwcRecipesMod extends NavigationMixin(LightningElement) {
    @track accounts = [];//account
    @track searchTerm;//account
    @track cols = COLS;
    @track error;

    handleSearchTermChange(event) {
        this.searchTerm = event.target.value;
        if (this.Account) {
            const selectedEvent = new CustomEvent('newsearchacc', { detail: this.searchTerm });
            window.clearTimeout(this.delayTimeout);
            this.delayTimeout = setTimeout(() => {
                this.dispatchEvent(selectedEvent);
            }, DELAY);
        }
    }
    //Fetching the list from Apex class
    @wire(searchAccount, {
        searchTerm: '$searchTerm'
    })
    //Display to the page for more loaddata
    loadAccount({ error, data }) {
        if (data) {
            this.accounts = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.accounts = undefined;
        }
    }
    //custom Action options
    handleRowAction(event) {
        const row = event.detail.row;
        this.record = row;
        //options of account page
        if(event.detail.action.name==='View Details') {
            console.log('clicked FIRST button');
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,//record id
                    actionName: 'view',
                },
            });
        } else if (event.detail.action.name==='View Related Details') {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordRelationshipPage',
                attributes: {
                    recordId: row.Id,//record id
                    objectApiName: 'Account',
                    relationshipApiName: 'Contacts',
                    actionName: 'view'
                },
            });
        } else if(event.detail.action.name==='View Related Detail'){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: row.Id,//record id
                    objectApiName: 'Account',
                    actionName: 'edit'
                },
            });
        }
    }

    // Navigate to New Account Page
    navigateToNewAccountPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            },
        });
    }
    // Navigation to Account List view(recent)
    navigateToAccountListView() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'list'
            },
            state: {
                filterName: 'Recent'
            },
        });
    }
    //Navigate to home page
    navigateToHomePage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
    // Navigation to contant object home page
    navigateToContactHome() {
        this[NavigationMixin.Navigate]({
            "type": "standard__objectPage",
            "attributes": {
                "objectApiName": "Contact",
                "actionName": "home"
            }
        });
    }
    //Navigate to chatter
    navigateToChatter() {
        this[NavigationMixin.Navigate]({
            type: 'standard__namedPage',
            attributes: {
                pageName: 'chatter'
            },
        });
    }
    //Navigate to Reports
    navigateToReports() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Report',
                actionName: 'home'
            },
        });
    }
    //Navigate to Files home
    navigateToFilesHome() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'ContentDocument',
                actionName: 'home'
            },
        });
    }
    //EXTRAS
    navigateToNameHome() {
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'home'
            },
        });
    }
    // Navigation to Sales App Tab
    navigateToSalesApp() {
        this[NavigationMixin.Navigate]({
            type: 'standard__app',
            attributes: {
                //navigate to standerd sales app
                appTarget: 'standard__Sales',
            },
        }
        );
    }
    //Navigation to compoennt
    navigateToComp() {
        this[NavigationMixin.Navigate]({
            type: 'standard__component',
            attributes: {
                componentName: 'c__lwcProductCatalog'
            },
        }
        );

    }
    //Navigation to Login
    navigateToLogin() {
        this[NavigationMixin.Navigate](
            {
                type: 'comm__loginPage',
                attributes: {
                    actionName: 'login'
                },
            }
        );

    }
    //Navigate to the Web Page
    navigateToWebPage() {
        this[NavigationMixin.Navigate](
            {
                type: 'standard__webPage',
                attributes: {
                    url: 'http://salesforce.com'
                }
            }
        );

    }


}