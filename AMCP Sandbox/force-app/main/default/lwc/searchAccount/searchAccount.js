import { LightningElement, wire, track } from 'lwc';
import searchAccounts from '@salesforce/apex/AccountController.searchAccounts';

export default class AccountSearch extends LightningElement {
    @track searchTerm = '';
    @track accounts = [];
    @track selectedAccountId = '';
    @track selectedAccountName = '';

    @wire(searchAccounts, { searchTerm: '$searchTerm' })
    wiredAccounts({ error, data }) {
    if (data) {
        console.log('Received data from Apex method:', data);
        if (this.searchTerm.trim() !== '') {
            this.accounts = data;
        }
    } else if (error) {
        console.error('Error retrieving accounts:', error);
    }
}


    handleSearchTermChange(event) {
    this.searchTerm = event.target.value;
    console.log('Search term changed:', this.searchTerm);
    if (this.searchTerm.trim() === '') {
        this.accounts = [];
    }
}


    handleAccountSelection(event) {
        const selectedAccountId = event.currentTarget.dataset.id;
        console.log('Selected Account Id:', selectedAccountId);
        const selectedAccount = this.accounts.find(acc => acc.Id === selectedAccountId);
        if (selectedAccount) {
            this.selectedAccountId = selectedAccountId;
            this.selectedAccountName = selectedAccount.Name;
            console.log('Selected Account Name:', this.selectedAccountName);

            this.accounts = [];
        }
    }
}