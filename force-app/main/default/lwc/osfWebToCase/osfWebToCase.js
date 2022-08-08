import { LightningElement, track, wire } from 'lwc';
import Id from '@salesforce/user/Id';
import getCases from '@salesforce/apex/OSF_CaseController.getCases';
import getCustomFields from '@salesforce/apex/OSF_CaseController.getCustomFields';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import GetNotClosedCases  from '@salesforce/label/c.Get_not_closed_cases';
import LoadCases  from '@salesforce/label/c.Load_Cases';
import CreateNewCase  from '@salesforce/label/c.Create_New_Case';
import CreateCase from '@salesforce/label/c.Create_Case';


export default class OsfWebToCase extends LightningElement {
    @track userId = Id;
    @track customFields;

    label = {
        GetNotClosedCases,
        LoadCases,
        CreateNewCase,
        CreateCase
    };   

  
    cases;
    caseColumns = [
      { label: 'Case Id', fieldName: 'Id'},
      { label: 'Case Number', fieldName: 'CaseNumber' },
      { label: 'Origin', fieldName: 'Origin' },
      { label: 'Status', fieldName: 'Status' },
    ];
  
    handleLoadCases() {
  
        getCases({ ownerId: this.userId })
            .then(result => {
                this.cases = result;         
            })
            .catch(error => {
                this.cases = undefined;
                this.showErrorMessage(error);
            });
          
    }
  
    @wire(getCustomFields)
    wireCustomFields({ error, data }) {
        if (data) {                   
            this.customFields = data;
            console.log('customFields: ' + JSON.stringify(this.customFields));
        } else if ( error ) {
            this.customFields = undefined;
            this.showErrorMessage(error);        }      
    }

    showErrorMessage(error) {
        let message = '';
        if (Array.isArray(error.body)) {
            message = error.body.map(e => e.message).join(', ');
        } else if (typeof error.body.message === 'string') {
            message = error.body.message;
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'ERROR!!!',
                message: message,
                variant: 'error',
            }),
        );
    }

    caseId;
    handleCaseCreated(event) {
        this.caseId = event.detail.id;
        if(this.caseId !== null) {
            this.dispatchEvent(new ShowToastEvent({
                    title: "SUCCESS! ",
                    message: "Recod with Id="+ this.caseId +" has been saved.",
                    variant: "success",
                }),
             );
                
        }        
    }     

    handleCaseCreatedError(event) {
        this.dispatchEvent(new ShowToastEvent({
            title: "ERROR! ",
            message: event.detail.error,
            variant: "error",
        }),
     );
    }
}