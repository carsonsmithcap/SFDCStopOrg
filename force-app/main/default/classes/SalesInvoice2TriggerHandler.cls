public class SalesInvoice2TriggerHandler implements ITriggerHandler {
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
        //SalesInvoice2Update((Sales_Invoice__c[])newItems);
        //AccountNameCheck((Account[])newItems);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // Cast the Map<Id, Sobject> to Account[]
        //SalesInvoice2Update((Sales_Invoice__c[])newItems.values());
        //AccountNameCheck((Account[])newItems.values());
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {
        
       // SalesInvoice2Update((Sales_Invoice__c[])newItems.values());
        //AccountNameCheck((Account[])newItems);
    }
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // SalesInvoice2Update((Sales_Invoice__c[])newItems.values());
        //AccountNameCheck((Account[])newItems.values());
    }
    
    public void AfterDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterUndelete(Map<Id, SObject> oldItems) {}
    
    /*
    Check the accounts to make sure their name does not contain the text "test".
    If any do, reject them.
    */
    private void AccountNameCheck(Account[] accountList) {
        // Reject any Accounts which have the word "Test" in the name
        for(Account iAccount : accountList) {
            if(iAccount.Name.containsIgnoreCase('test')) {
                System.debug('You may not use the word "test" in the account name');
                //iAccount.Name.addError('You may not use the word "test" in the account name');
            }
        }
    }
    
    /*
    Sales Invoice Pt. II 
    */
    private void SalesInvoice2Update(Sales_Invoice__c[] SI2List) {
        // Reject any Accounts which have the word "Test" in the name
        // create a list of all accounts
        // for each account, compare account name to account name present in sales invoices repository
        double grandtotal =0;
        //make a list of all account id's from SI2List
        /*for (i:SI2List){
            add Id's to newlist
        }*/
        //List<Account> acc = new List<Account>();
        List<Account> newlist = new List<Account>([SELECT Id, Name FROM Account]);
        System.debug(newlist);
        for(Account a: newlist){
            //accList.add(acc);
            List<AggregateResult> siList = new List<AggregateResult>(
                                            [SELECT Account__r.Name, Name name3, Contact__r.Name name2, SUM(Amount__c) sumOfAmount 
                                            FROM Sales_Invoice__c 
                                            WHERE Account__r.Name = :a.Name GROUP BY Account__r.Name, Contact__r.Name, Name]);
        
        	
        // aggregate result list bug. 
             system.debug(siList);
             grandtotal = double.valueOf(siList[0].get('sumOfAmount'));
             system.debug('grandtotal: '+ grandtotal);
                
            a.totalAmount_a__c = grandtotal;
            update a;
            //do this in the after. DB record will already be there. 
        
    }
    
        //acc.put(Account.totalAmount_a__c,'sumOfAmount');
        //acc.put('totalAmount_a__c',20);   
        //double sum=double.valueOf(siList[0].get('sumOfAmount'));
        //accList.totalAmount_a__c = 20;
        //update acc;
        //Map<Account>accountMap=new Map<Account>();
        //accountMap.put(totalAmount_a__c, new Account(totalAmount_a__c = sumofAmount));
        
        
        
        
        // for each account, compare account name to account name present in sales invoices repository
        // add the amounts accompanied with each invoice for said account via aggregated list
        // update totalamount field on said account page with SUM retrieved from aggregated list
        //for(Sales_Invoice__c iSI2 : SI2List) {
         //   -- 
         //   }
        }
    }