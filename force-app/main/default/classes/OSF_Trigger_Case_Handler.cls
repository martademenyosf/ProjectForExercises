
/**********************************************************************
 * @Name         : OSF_Trigger_Case_Handler
 * @Description  : Handler calss for OSF_Trigger_Case trigger.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 01 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/

public with sharing class OSF_Trigger_Case_Handler {
/**********************************************************************
 * @Name         : handleBeforeUpdate
 * @Description  : Create a new person Account using Case data or update the existing case using existing account data
 *
 * @Created By   : Marta Demeny
 * @Created Date : 08 aug. 2022
 *
 * @param List<Case> - List of the new cases
 * @param Boolean - boolean showing if the trigger is for update
 *********************************************************************/
public static void handleBeforeUpdate(List<Case> newCases, boolean isUpdate) {
    List<Account> accounts = [SELECT Id, Name, Brand__c, personcontactId, personEmail  
                               FROM Account 
                               WHERE RecordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()];
    List<Account> existingAccounts = new List<Account>();                           
    for (Case cs : newCases) {
        for (Account acc : accounts) {
            if (acc.Brand__c != null && acc.personEmail != null && acc.Brand__c == cs.Brand__c && acc.personEmail == cs.SuppliedEmail) {
                existingAccounts.add(acc);
                break;
            }
        }
    }

    if (existingAccounts.size() == 0) {
         //create new PersonAccount
        createAccounts(newCases, isUpdate);
    } else {
        //update Case with Account Info
        updateCases(newCases, isUpdate, existingAccounts);
    } 
}



/**********************************************************************
 * @Name         : createAccounts
 * @Description  : Create a new person Account using Case data 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 27 jul. 2022
 *
 * @param List<Case> - List of the new cases
 * @param Boolean - boolean showing if the trigger is for update
 *********************************************************************/
    public static void  createAccounts(List<Case> newCases, boolean isUpdate) {
        List<Account> newAccounts = new List<Account>();
        for (Case cs : newCases) {
            if (cs.Origin == 'Web' || (cs.Origin == 'Email' && isUpdate)) {
                Account acc = new Account();
                acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                acc.FirstName = getFirstName(cs.SuppliedName);
                acc.LastName = getLastName(cs.SuppliedName);
                acc.Brand__c = cs.Brand__c;
                acc.personEmail = cs.SuppliedEmail; 
                newAccounts.add(acc);
            }
            if (cs.Origin == 'Email' && !isUpdate && cs.ContactId != null && cs.AccountId == null)  {
                //avoid to add the already created contact and account to the case
                cs.ContactId = null;
            }            
        }
        insert newAccounts;
    }
/**********************************************************************
 * @Name         : getFirstName
 * @Description  : Return the first item after splitting the fullName after space 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 27 jul. 2022
 *
 * @param String - string containing the data for split after space
 * @return String - the first item after splitting the parameter
 *********************************************************************/
    private static String getFirstName(String fullName) {
        if (fullName == null) {
            return '';
        } else {
            return fullName.split(' ').get(0);
        }
    }
/**********************************************************************
 * @Name         : getLastName
 * @Description  : Return the second item after splitting the fullName after space 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 27 jul. 2022
 *
 * @param String - string containing the data for split after space
 * @return String - the second item after splitting the parameter
 *********************************************************************/
    private static String getLastName(String fullName) {
        if (fullName == null || (fullName.split(' ', 2).size() < 2)) {
            return '';
        } else {
            return fullName.split(' ', 2).get(1);
        }
    }   
    
/**********************************************************************
 * @Name         : updateCases
 * @Description  : Create a new person Account using Case data 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 27 jul. 2022
 *
 * @param List<Case> - List of the new cases
 * @param Boolean - boolean showing if the trigger is for update
 *********************************************************************/
    public static void  updateCases(List<Case> newCases, boolean isUpdate, List<Account> existingAccounts) {
        for (Case cs : newCases) {
            if (cs.Origin == 'Web' || (cs.Origin == 'Email' && isUpdate)) {
                for (Account acc : existingAccounts) {
                    if (cs.Brand__c == acc.Brand__c && cs.SuppliedEmail == acc.personEmail) {
                        cs.AccountId = acc.Id;
                        cs.ContactId = acc.personcontactId;
                    }
                }
            
            }
        }
    }    
}
