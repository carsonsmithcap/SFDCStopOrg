public class SalesInvoiceTriggerHandler implements ITriggerHandler {
    /* 
    Allows unit tests (or other code) to disable this trigger for the transaction
    To stop this trigger from firing while in a unit test, I could just add the following code to the test:
    AccountTriggerHandler.TriggerDisabled = true;
    */
    public static Boolean TriggerDisabled = false;
    /*
    Checks to see if the trigger has been disabled. For example, you could check a custom setting here.
    In this example, a static property is used to disable the trigger.
    In a unit test, you could use AccountTriggerHandler.TriggerDisabled = true to completely disable the trigger.
    */
    public Boolean IsDisabled() {
        /*
        Use the option below if you set up Custom Settings to controll Triggers
        */
        // if(TriggerSettings__c.AccountTriggerDisabled__c = true) {
        //   return true;
        // } else {
        //   return TriggerDisabled;
        // }
        return TriggerDisabled;
    }
    
    public void BeforeInsert(List<SObject> newItems) {
        // Cast the Sobject[] to Account[]
        SalesInvoiceInventory((Sales_Invoice__c[])newItems);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // Cast the Map<Id, Sobject> to Account[]
        SalesInvoiceInventory((Sales_Invoice__c[])newItems.values());
    }
        public void BefeforeDelete(List<SObject> newItems) {
        // Cast the Sobject[] to Account[]
        SalesInvoiceInventory((Sales_Invoice__c[])newItems);
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {}
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    /*
    Check the accounts to make sure their name does not contain the text "test".
    If any do, reject them.
    */
     // private void AccountNameCheck(Account[] accountList) {
        // Reject any Accounts which have the word "Test" in the name
       // for(Account iAccount : accountList) {
         //   if(iAccount.Name.containsIgnoreCase('test')) {
           //     System.debug('You may not use the word "test" in the account name');
            //    iAccount.Name.addError('You may not use the ord "test" in the account name');
            //}
        //}
    //}
    Private void SalesInvoiceInventory(Sales_Invoice__c[] si){
                //create a set of strings        
        //create a list
        // create list called accList for accounts
        //each entry of accList will be a mini list of account info IF an account is named same as above
        List<Account> accList = new List<Account>(
                                [SELECT Id, Name
                                FROM Account]);
                                
        //for each mini list of accounts in acclist...
        for( Account acc : accList ){
            //create a list called siList for sales invoice
            //each entry of silist will be a mini list of sales invoice info IF the invoice ID = account ID
            List<AggregateResult> siList = new List<AggregateResult>(
                                            [SELECT Account__r.Name, Name name3, Contact__r.Name name2, SUM(Amount__c) sumOfAmount 
                                            FROM Sales_Invoice__c 
                                            WHERE Account__r.Name = :acc.Name GROUP BY Account__r.Name, Contact__r.Name, Name ]);// : reference something outside of query
			                    System.debug('Account: ' + acc.Name);

            // check length for each iteration through accList
            // if nothing is still added to the siList section...
            // then change acc.Active__c is false, and update that on acc. 
                
    
       // List<AggregateResult> SalesList= [SELECT Contact__r.Name name2, Account__r.Name, SUM(Amount__c) sumOfAmount FROM Sales_Invoice__c 
                               // WHERE  Account__r.Name = :acc.Name GROUP BY Account__r.Name, Contact__r.Name];
            
          for(AggregateResult SIInventory : siList) {
                Decimal sumAmount = (Decimal)siList[0].get('sumOfAmount');
                try{
                    acc.totalAmount_a__c = sumAmount;
                    // Make the update call.
                    // 
                    System.debug('Account: ' + acc.ID);
                    update acc;
                } catch(DmlException e) {
                  System.debug('An unexpected error has occurred: ' + e.getMessage());
                }
            }
        }
    }
}