/**********************************************************************
 * @Name         : OSF_UpdateAccountsBatch
 * @Description  : A batch class that modify Accounts Weather data
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/

global with sharing class OSF_UpdateAccountsBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    // instance member to retain state across transactions
    public Integer recordsProcessed = 0;

    private static final String WEATHER_IMG_URL = 'https://openweathermap.org/img/wn/';

/**********************************************************************
 * @Name         : start
 * @Description  : Implements the batchable interface method and it's invoked when the batch job starts. 
 *                 
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - contains the job Id
 * @return Database.QueryLocator - record set as a QueryLocator object that will be batched for execution.
 *********************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc) {
        try {
            return Database.getQueryLocator('SELECT Id, Temperature__c, Description, Real_Feeling__c, Icon__c, Humidity__c,  BillingCity FROM Account');
        } catch (DMLException e) {
            System.debug(e.getMessage());
            return null;
        }
    }

/**********************************************************************
 * @Name         : execute
 * @Description  : Implements the batchable interface method, it's invoked when the batch job executes and operates on one batch of records.
 *                 Return the weather data and update the account records.
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - Contains the job Id.
 * @param List<Opportunity> - Contains the batch of records to process.
 *
 *********************************************************************/
    global void execute(Database.BatchableContext bc, List<Account> source) {

        for (Account acc: source) {
            System.debug('Account Id: =' + acc.Id + ', BillingCity: ' + acc.BillingCity);
            if (acc.BillingCity != null) {
                OSF_WeatherWrapper weatherWrapper = OSF_WeatherReader.executeAPICall(acc.BillingCity);
                for(OSF_WeatherWrapperWeatherData wd: (List<OSF_WeatherWrapperWeatherData>) weatherWrapper.weather) {
                    if ((wd.icon != null) && (wd.icon.length() != 0)) {
                        acc.Icon__c = WEATHER_IMG_URL + wd.icon + '.png';
                    }
                    acc.description = wd.description;
                    break;
                }
        
                acc.Temperature__c = weatherWrapper.main.temp;
                acc.Real_Feeling__c = weatherWrapper.main.feels_like;
                acc.Humidity__c = weatherWrapper.main.humidity;
            }
            recordsProcessed = recordsProcessed + 1;
        }
        update source;
    }

/**********************************************************************
 * @Name         : finish
 * @Description  : Implements the batchable interface method and it's invoked when the batch job is finished. 
 *               
 *                 
 * @Created By   : Marta Demeny
 * @Created Date : 13 jun. 2022
 *
 * @param Database.BatchableContext - contains the job Id
 *
 *********************************************************************/    
    public void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems, CreatedBy.Email
            FROM AsyncApexJob
            WHERE Id = :bc.getJobId()];
        System.debug('Job info: ' + job.Status);
    }
}