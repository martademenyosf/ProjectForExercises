/**********************************************************************
 * @Name         : OSF_AccountController
 * @Description  : Class containing callable functions from LWC.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 07 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
public with sharing class OSF_AccountController {
/**********************************************************************
 * @Name         : getOrdersAmountCurrentYear
 * @Description  : Returns total of order totals since 1st January of current year 
 *
 * @Created By   : Marta Demeny
 * @Created Date : 07 jul. 2022
 *
 * @param String - string containing account id
 * @return AggregateResult - result objects 
 *********************************************************************/
    @AuraEnabled(cacheable=true)
    public static AggregateResult getOrdersAmountCurrentYear(String accountId) {
        return [
            SELECT SUM(TotalAmount) ordersAmountValue
            FROM Order
            WHERE accountId = :accountId AND EffectiveDate  = THIS_YEAR
        ];
    }

/**********************************************************************
 * @Name         : getOrdersAmountCurrentYearMinus5
 * @Description  : Returns total of order totals since 1st January of current year - 5
 *
 * @Created By   : Marta Demeny
 * @Created Date : 07 jul. 2022
 *
 * @param String - string containing account id
 * @return AggregateResult - result objects
 *********************************************************************/
    @AuraEnabled(cacheable=true)
    public static AggregateResult getOrdersAmountCurrentYearMinus5(String accountId) {
        return [
            SELECT SUM(TotalAmount) ordersAmountValue
            FROM Order
            WHERE accountId = :accountId AND EffectiveDate = N_YEARS_AGO:5
        ];
    }

/**********************************************************************
 * @Name         : getAccountKPIs
 * @Description  : Returns a wrapper class with KPIs of an Account
 *
 * @Created By   : Marta Demeny
 * @Created Date : 07 jul. 2022
 *
 * @param String - string containing account id
 * @return Integer - result objects
 *********************************************************************/
    @AuraEnabled(cacheable=true)
    public static OSF_AccountKPIWrapper getAccountKPIs(String accountId) {
        OSF_AccountKPIWrapper kpis = new OSF_AccountKPIWrapper();

        //get Open cases amount 
        AggregateResult aggregateResult = [SELECT COUNT(Id) cases FROM CASE WHERE Status != 'Closed' AND AccountId = :accountId];
        kpis.openCasesCount = (Integer) aggregateResult.get('cases');

        //get Total cases amount
        aggregateResult = [SELECT COUNT(Id) cases FROM CASE WHERE AccountId = :accountId];
        kpis.casesCount = (Integer) aggregateResult.get('cases');
        
        //Customer since & Birthday
        Account acc = [SELECT CreatedDate, PersonBirthdate FROM Account WHERE Id = :accountId];
        kpis.customerSince = acc.CreatedDate.date();
        kpis.birthDay = acc.PersonBirthdate;

        //Total number of orders
        aggregateResult = [SELECT COUNT(Id) orders FROM ORDER WHERE AccountId = :accountId];
        kpis.ordersCount = (Integer) aggregateResult.get('orders');

        //Average order Value
        aggregateResult = [SELECT SUM(TotalAmount) ordersAmountValue FROM Order  WHERE accountId = :accountId];
        Decimal ordersAmount = (Decimal) aggregateResult.get('ordersAmountValue');
        if ((kpis.ordersCount != null) && (kpis.ordersCount != 0)){
            Decimal avarageOrdersValue = ordersAmount / kpis.ordersCount;
            kpis.avarageOrderValue = avarageOrdersValue.intValue();           
        }


        return kpis;
    }     
}
