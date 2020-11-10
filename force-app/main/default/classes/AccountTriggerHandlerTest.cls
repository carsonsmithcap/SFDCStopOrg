@isTest
private class AccountTriggerHandlerTest {
    
    @testSetup
    static void setup() {
        Account testAccount = new Account(
            Name = 'New Account'
        );
        insert testAccount;
        System.assertNotEquals(null, testAccount.Id, 'Failed to insert testAccount');
    }
    
    @isTest
    static void testAccountTriggerHandler() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Test Account';
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        
        Test.startTest();
        Boolean[] exceptions = new Boolean[]{};
            try {
                insert testAccount;
            } catch(Exception e) {
                exceptions.add(true);
            }
        try {
            update preAccounts;
        } catch(Exception e) {
            exceptions.add(true);
        }
        Test.stopTest();
        
        System.assertEquals(2, exceptions.size());
        for(Boolean exceptionThrown : exceptions){
            System.assert(exceptionThrown);
        }
        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals(1, postAccounts.size());
        System.assertEquals('New Account', postAccounts[0].Name);
    }
    
    @isTest
    static void testAccountTriggerHandlerUpdate() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Old Account';
        
        Test.startTest();
        update preAccounts;
        Test.stopTest();
        
        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('Old Account', postAccounts[0].Name);
    }
    
    @isTest
    static void testAccountTriggerHandlerDisabled() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        preAccounts[0].Name = 'Test Account';
        
        Test.startTest();
        AccountTriggerHandler.TriggerDisabled = true;
        update preAccounts;
        Test.stopTest();
        
        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('Test Account', postAccounts[0].Name);
    }
    
    @isTest
    static void testAccountTriggerHandlerDelete() {
        Account[] preAccounts = [SELECT Id, Name FROM Account];
        
        Test.startTest();
        delete preAccounts;
        undelete preAccounts;
        Test.stopTest();
        
        Account[] postAccounts = [SELECT Id, Name FROM Account];
        System.assertEquals('New Account', postAccounts[0].Name);
    }

    private void SalesInvoice2Update(Sales_Invoice__c[] SI2List) {
            // Reject any Accounts which have the word "Test" in the name
            // create a list of all accounts
            // for each account, compare account name to account name present in sales invoices repository
            List<Account> accList = new List<Account>([SELECT Id, Name FROM Account]);
            System.debug(accList);
            for(Account acc : accList ){
                accList.add(acc);
            }
}
}