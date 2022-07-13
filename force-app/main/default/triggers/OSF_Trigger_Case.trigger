trigger OSF_Trigger_Case on Case (before insert, before update) {
 
    for (Case newCase : Trigger.new) {
        System.debug('newCase---> CaseNumber=' + newCase.CaseNumber + ', Id=' + newCase.Id + ', Origin=' + newCase.Origin + ', Brand = ' + newCase.Brand__c + ', Email=' + newCase.SuppliedEmail);
        System.debug('Trigger.isInsert ' + Trigger.isInsert);
        System.debug('Trigger.isUpdate ' + Trigger.isUpdate);

       if (newCase.Origin == 'Web')  {
            List<Account> accounts = [SELECT Name, Brand__c, personcontactId, personEmail  FROM Account WHERE Brand__c = :newCase.Brand__c AND personEmail = :newCase.SuppliedEmail];
            System.debug('accounts size: ' + accounts.size());
            if (accounts.size() > 0) {
                System.debug('Account ---> Brand__c=' + accounts[0].Brand__c + ', personEmail=' + accounts[0].personEmail + ', personcontactId = ' + accounts[0].personcontactId);
            }
             if (accounts.size() == 0) {
                Account acc = new Account();
                acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                acc.LastName = 'Person Account from Web to Case';
                acc.Brand__c = newCase.Brand__c;
                acc.personEmail = newCase.SuppliedEmail;
                insert acc;

            } else {
                newCase.AccountId = accounts[0].id;
                newCase.ContactId = accounts[0].personcontactId;
            }
        } else if ((newCase.Origin == 'Email') && Trigger.isUpdate) {
            List<Account> accounts = [SELECT Name, Brand__c, personcontactId, personEmail  FROM Account WHERE Brand__c = :newCase.Brand__c AND personEmail = :newCase.SuppliedEmail];
            System.debug('accounts size: ' + accounts.size());
            if (accounts.size() > 0) {
                System.debug('Account ---> Brand__c=' + accounts[0].Brand__c + ', personEmail=' + accounts[0].personEmail + ', personcontactId = ' + accounts[0].personcontactId);
            }
             if (accounts.size() == 0) {
                Account acc = new Account();
                acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
                acc.LastName = 'Person Account from Web to Case';
                acc.Brand__c = newCase.Brand__c;
                acc.personEmail = newCase.SuppliedEmail;
                insert acc;

            } else {
                newCase.AccountId = accounts[0].id;
                newCase.ContactId = accounts[0].personcontactId;
            }
        }

    }

}