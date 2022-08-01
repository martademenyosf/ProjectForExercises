/**********************************************************************
 * @Name         : OSF_AccountControllerTest
 * @Description  : test class for OSF_AccountController.
 *
 * @Created By   : Marta Demeny
 * @Created Date : 11 jul. 2022
 * @Modification Log: 
 ********************************************************************
 * Version		Developer		Date			Description
 *___________________________________________________________________
 *
 *********************************************************************/
@isTest
public with sharing class OSF_AccountControllerTest {
/**********************************************************************
 * @Name         : setup
 * @Description  : Helper method to create the testing data.
 * @Created By   : Marta Demeny
 * @Created Date : 11 jul. 2022
 *
 *********************************************************************/ 
    @testSetup 
    private static void setup() {
        //Create Person Account
        RecordType personRecordType = [SELECT Id FROM RecordType WHERE Name = 'Person Account'];
        Account account = new Account(FirstName = 'Test', LastName = 'Account', RecordTypeId = personRecordType.Id, PersonBirthdate = Date.newInstance(2009, 04, 07));
        insert account;

        //add case to Account
        Case case1 = new Case(Origin = 'Web', Status = 'New', Subject = 'Subject Web', AccountId = account.id);
        Case case2 = new Case(Origin = 'Email', Status = 'New', Subject = 'Subject Email', AccountId = account.Id);
        Case case3 = new Case(Origin = 'Email', Status = 'Closed', Subject = 'Subject Email', AccountId = account.Id);
        insert new List<Case>{case1, case2, case3};

        //Create Contract
        Contract contract = new Contract(Status = 'Draft', AccountId = account.Id, StartDate = Date.newInstance(2015, 05, 15), ContractTerm = 600);
        insert contract;

        //Search  Price Entry for 2 products
        Product2 product1 = new Product2(Name = 'Installation: Industrial - Low');
        Product2 product2 = new Product2(Name = 'Installation: Industrial - High');
        insert new List<Product2>{product1, product2};

        PricebookEntry price1 = new PricebookEntry(UnitPrice = 100, Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product1.Id);
        PricebookEntry price2 = new PricebookEntry(UnitPrice = 200, Pricebook2Id = Test.getStandardPricebookId(), Product2Id = product2.Id);
        insert new List<PricebookEntry>{price1, price2};

        //create this year order and 5 years ago order
        Order orderThisYear = new Order(AccountId = account.Id, EffectiveDate = Date.newInstance(2022, 06, 15), ContractId = contract.Id, Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId());
        Order orderFiveYearsAgo = new Order(AccountId = account.Id, EffectiveDate = Date.newInstance(2017, 06, 15), ContractId = contract.Id, Status = 'Draft', Pricebook2Id = Test.getStandardPricebookId());
        insert new List<Order>{orderThisYear, orderFiveYearsAgo};
 
        //create Products for Order
        OrderItem orderProduct1 = new OrderItem(Product2Id = product1.Id, Quantity = 1, orderId = orderThisYear.Id, PricebookEntryId = price1.Id, UnitPrice = 100);
        OrderItem orderProduct2 = new OrderItem(Product2Id = product2.Id, Quantity = 1, orderId = orderFiveYearsAgo.id, PricebookEntryId = price2.Id, UnitPrice = 200);
        insert new List<OrderItem>{orderProduct1, orderProduct2};        

    }
/**********************************************************************
 * @Name         : testGetOrdersAmountCurrentYear
 * @Description  : Test method for .getOrdersAmountCurrentYear
 * @Created By   : Marta Demeny
 * @Created Date : 11 jul. 2022
 * 
 *
 *********************************************************************/
    @isTest   
    public static void testGetOrdersAmountCurrentYear() {  
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        AggregateResult ordersAmountThisYear = OSF_AccountController.getOrdersAmountCurrentYear(account.Id);
        System.assertEquals(100, ordersAmountThisYear.get('ordersAmountValue'));

    }

/**********************************************************************
 * @Name         : testGetOrdersAmountCurrentYearMinus5
 * @Description  : Test method for getOrdersAmountCurrentYear.
 * @Created By   : Marta Demeny
 * @Created Date : 11 jul. 2022
 * 
 *
 *********************************************************************/
    @isTest   
    public static void testGetOrdersAmountCurrentYearMinus5() {  
        Account account = [SELECT Id FROM Account WHERE Name = 'Test Account'];
        AggregateResult ordersAmountThisYear = OSF_AccountController.getOrdersAmountCurrentYearMinus5(account.Id);
        System.assertEquals(200, ordersAmountThisYear.get('ordersAmountValue'));

    }  
    
/**********************************************************************
 * @Name         : testgetAccountKPIs
 * @Description  : Test method for getAccountKPIs.
 * @Created By   : Marta Demeny
 * @Created Date : 11 jul. 2022
 * 
 *
 *********************************************************************/
@isTest   
public static void testGetAccountKPIs() {  
    Account account = [SELECT Id FROM Account WHERE Name = 'Test Account'];
    OSF_AccountKPIWrapper accountKPIs = OSF_AccountController.getAccountKPIs(account.Id);

    System.assertEquals(Date.newInstance(2009, 04, 07), accountKPIs.birthDay);
    System.assertEquals(3, accountKPIs.casesCount);
    System.assertEquals(System.today(), accountKPIs.customerSince);
    System.assertEquals(2, accountKPIs.openCasesCount);
    System.assertEquals(150, accountKPIs.avarageOrderValue);

}     
}
