import { createElement } from 'lwc';
import OsfAccountKPIs from 'c/osfAccountKPIs';

import getAccountKPIs from '@salesforce/apex/OSF_AccountController.getAccountKPIs';

const mockGetAccountKPIs = require('./data/getAccountKPIs.json');

// Mocking imperative Apex method call

jest.mock(
    '@salesforce/apex/OSF_AccountController.getAccountKPIs',
    () => {
        const {
            createApexTestWireAdapter
        } = require('@salesforce/sfdx-lwc-jest');
        return {
            default: createApexTestWireAdapter(jest.fn())
        };
    },
    { virtual: true }
);

describe('c-osf-account-kp-is', () => {
    afterEach(() => {
        // The jsdom instance is shared across test cases in a single file so reset the DOM
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
            // Prevent data saved on mocks from leaking between tests
            jest.clearAllMocks();              
        }
    });
   

    describe('OrdersAmounts @wire data', () => {
        it('wire Account KPIs', () => {
            const element = createElement('c-osf-account-kp-is', {
                is: OsfAccountKPIs
            });
            document.body.appendChild(element);
                
            // Emit data from @wire
            //getAccountKPIs.emit(mockGetAccountKPIs);
            getAccountKPIs.mockResolvedValue(mockGetAccountKPIs);
            
            return Promise.resolve().then(() => {
                // Select elements for validation
                const ordersAmount = element.shadowRoot.querySelectorAll('lightning-formatted-number');
                expect(ordersAmount[0]).toBe(mockGetAccountKPIs.ordersAmountCurrentYear.ordersAmountValue);
                expect(1).toBe(1);
            });
        });
    });
});