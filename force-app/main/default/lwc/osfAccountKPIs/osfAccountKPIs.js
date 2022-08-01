import { LightningElement, api, wire, track } from 'lwc';

import getAccountKPIs from '@salesforce/apex/OSF_AccountController.getAccountKPIs';

import YTDTotalOfOrderAmount from '@salesforce/label/c.YTD_total_of_order_amount';
import YTD5TotalOfOrderAmount from '@salesforce/label/c.YTD_5_total_of_order_amount';
import TotalNumberOfOrders from '@salesforce/label/c.Total_number_of_orders';
import TotalCasesAmount from '@salesforce/label/c.Total_cases_amount';
import OpenCasesAmount from '@salesforce/label/c.Open_cases_amount';
import CustomerSince from '@salesforce/label/c.Customer_since';
import Birthday from '@salesforce/label/c.Birthday';
import AverageOrderValue from '@salesforce/label/c.Average_order_Value';

export default class OsfAccountKPIs extends LightningElement {
    @api recordId;
    @track ordersAmountCurrentYear;
    @track ordersAmountCurrentYearMinus5;
    @track casesCount;
    @track accountKPIs;
    error;

    label = {
        YTDTotalOfOrderAmount,
        YTD5TotalOfOrderAmount,
        TotalNumberOfOrders,
        TotalCasesAmount,
        OpenCasesAmount,
        CustomerSince,
        Birthday,
        AverageOrderValue       
    };    

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