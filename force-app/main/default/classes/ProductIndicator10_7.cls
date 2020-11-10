public class ProductIndicator10_7 implements ITriggerHandler{
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
       // AccountNameCheck((Account[])newItems);
    }
    
    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // Cast the Map<Id, Sobject> to Account[]
       // AccountNameCheck((Account[])newItems.values());
    }
    
    public void BeforeDelete(Map<Id, SObject> oldItems) {}
    
    public void AfterInsert(Map<Id, SObject> newItems) {
 		getProduct((SObject[])newItems.values());
        //for (SObject c: newItems.values()){
            //1 filter accounts associate with that supIngt Id: 
 
            //List<Suppliers_Ingredients__c> temp = [SELECT Id FROM Suppliers_Ingredients__c WHERE Account__r.Id = :key];
    		//getProduct(temp[0]);
    		
            //2 get objects from supplierIngred then .Account__c.Id 
            //for(Supplier_Ingredients__c key: newItems.values()){
           // getProduct(c.Id);}
			
        }
        //run a for loop and run through each id in the key to modify the process
    
    
    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        getProduct((SObject[])newItems.values());
        //for (SObject c: newItems.values()){
		//getProduct(c.Id);}
        //Map <Id, Account> newItems = [SELECT Id (SELECT Id FROM Suppliers_Ingredients__c) FROM Account];
        //for (Id key : newItems.keySet()){
            //System.debug(target);
          //  getProduct(key);
        //}
        //run a for loop and run through each id in the key to modify the process
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
    
     Public static void getProduct(Suppliers_Ingredients__c[] accountList){
		 //empty object for comparison
         //Account emptyObj = new Account();
        
         for(Suppliers_Ingredients__c key: accountList){
        //Accounts with that supplier_ingredient IDs 
            Account a = key.Account__r;
            //null error
            if(a == null){continue;}
            ID acct = a.Id;
         
        //obtain the current account has the input parameter Id

       		Account currentAcct = [SELECT Name, Id, Contribution__c 
                                        FROM Account WHERE Account.Id = :acct]; 
             
        //Initialize Lists
        List<Suppliers_Ingredients__c> suppIngList = new List<Suppliers_Ingredients__c>();
        List<Product_Ingredient__c> prodIngList = new List<Product_Ingredient__c>();
        
        //Select list of all Supplier Ingredients where the Acccount ID is the current record
        suppIngList = [Select Id, Name, Account__c, Ingredient__c 
                   From Suppliers_Ingredients__c Where Account__c = :acct];

         //Load a Set with the Ingredient IDs
        Set<id> ingIds = new Set<id>();
        for(Suppliers_Ingredients__c ing : suppIngList){
            ingIds.add(ing.Ingredient__c);            
        }
         
        //Select list of all Product Ingredients where the Ingredient is supplied by the current record
        prodIngList = [Select Id, Product__c, Ingredient__c, Ingredient__r.Name
                       ,Product__r.Name, Product__r.ProductCode, Product__r.Family
                       From Product_Ingredient__c Where Ingredient__c in :ingIds
                       Order By Ingredient__r.Name, Product__r.Name];

         //for all accounts, there exist a set of ingredients, prodIngList contain all prodIng match with them
         //sort through number of distinct product, 
         Set<String> str = new Set<String>();
         for(Product_Ingredient__c c: prodIngList){
             str.add(c.product__r.Name);
         }
         
         if(str.size() == 0){
             currentAcct.Contribution__c =  'Insufficient';
             }
             
         else if(str.size() > 3){
             currentAcct.Contribution__c = 'Excellent';
             }
             
         else{
             currentAcct.Contribution__c =  'Average';
             }
         
         }
     }
}