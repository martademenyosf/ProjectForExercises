/**********************************************************************
 * @Name         : OSF_AccountKPIWrapper
 * @Description  : Wrapper class for Account KPIs
 * @Created By   : Marta Demeny
 * @Created Date : 18 jun. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/

public with sharing class OSF_AccountKPIWrapper {
    @AuraEnabled
    public Integer openCasesCount {get; set;}

    @AuraEnabled
    public Integer casesCount {get; set;}

    @AuraEnabled
    public Date customerSince {get; set;}

    @AuraEnabled
    public Integer ordersCount {get; set;}

    @AuraEnabled
    public Date birthDay {get; set;}

    @AuraEnabled
    public Integer avarageOrderValue {get; set;}
}
