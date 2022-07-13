import { LightningElement, api, wire, track } from 'lwc';
//import { getRecord, getFieldValue } from 'lightning/uiRecordApi'; 
//import CREATEDDATE_FIELD from '@salesforce/schema/Account.CreatedDate';
import getOrdersAmountCurrentYear from '@salesforce/apex/OSF_AccountController.getOrdersAmountCurrentYear';
import getOrdersAmountCurrentYearMinus5 from '@salesforce/apex/OSF_AccountController.getOrdersAmountCurrentYearMinus5';
import getAccountKPIs from '@salesforce/apex/OSF_AccountController.getAccountKPIs';

export default class OsfAccountKPIs extends LightningElement {
    @api recordId;
    @track ordersAmountCurrentYear;
    @track ordersAmountCurrentYearMinus5;
    @track casesCount;
    @track accountKPIs;
    error;
/*
    @wire(getRecord, { recordId: '$recordId', fields: [CREATEDDATE_FIELD] })
    account;
      
    get createddate() {
        const crDate = getFieldValue(this.account.data, CREATEDDATE_FIELD);
        return crDate;
    }
*/

    @wire(getOrdersAmountCurrentYear, { accountId: '$recordId' })
    wiredOrdersAmountCurrentYear({ error, data }) {
        if (data) {
            this.ordersAmountCurrentYear = data;
            console.log('orders amount current year:' + JSON.stringify(data));
            this.error = undefined;
            // other treatment here ...         
        } else if (error) {
            this.ordersAmountCurrentYear = undefined;
            this.error = error;
        }
    }    
    
        @wire(getOrdersAmountCurrentYearMinus5, { accountId: '$recordId' })
    wiredOrdersAmountCurrentYearMinus5({ error, data }) {
        if (data) {
            this.ordersAmountCurrentYearMinus5 = data;
            console.log('orders amount 5 years ago:' + JSON.stringify(data));
            this.error = undefined;
            // other treatment here ...         
        } else if (error) {
            this.ordersAmountCurrentYearMinus5 = undefined;
            this.error = error;
        }
    } 
     
    @wire(getOrdersAmountCurrentYearMinus5, { accountId: '$recordId' })
    wiredOrdersAmountCurrentYearMinus5({ error, data }) {
        if (data) {
            this.ordersAmountCurrentYearMinus5 = data;
            console.log('orders amount 5 years ago:' + JSON.stringify(data));
            this.error = undefined;
            // other treatment here ...         
        } else if (error) {
            this.ordersAmountCurrentYearMinus5 = undefined;
            this.error = error;
        }
    }     

    @wire(getAccountKPIs, { accountId: '$recordId' })
    getAccountKPIs({ error, data }) {
        if (data) {
            this.accountKPIs = data;
            console.log('accountKPIs:' + JSON.stringify(data));
            this.error = undefined;
            // other treatment here ...         
        } else if (error) {
            this.accountKPIs = undefined;
            this.error = error;
        }
    }     
}