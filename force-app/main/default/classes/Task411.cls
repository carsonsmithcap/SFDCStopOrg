public class Task411 {
public Task411() {
        //create a set of strings
        Set<String> nameSet = new Set<String>{'Burlington Textiles Corp of America','Grand Hotels & Resorts Ltd'};//yes
        
        //create a list
        // create list called accList for accounts
        //each entry of accList will be a mini list of account info IF an account is named same as above
        List<Account> accList = new List<Account>(
            					[SELECT Active__c, Id, Name, BillingStreet, BillingPostalCode, BillingCity, BillingCountry 
                                FROM Account 
                                WHERE Name = :nameSet]);
                                
        //for each mini list of accounts in acclist...
        for( Account acc : accList ){
            //create a list called siList for sales invoice
            //each entry of silist will be a mini list of sales invoice info IF the invoice ID = account ID
            List<Sales_Invoice__c> siList = new List<Sales_Invoice__c>(
                							[SELECT Account__r.Name, Name, Contact__r.Name 
                                            FROM Sales_Invoice__c 
                                            WHERE Account__r.Id = :acc.Id]);// : reference something outside of query
            // check length for each iteration through accList
            // if nothing is still added to the siList section...
            // then change acc.Active__c is false, and update that on acc. 
            if( siList.size() <= 0 ){
                acc.Active__c = 'no';//match the negative option from the picklist, not case sensitive. 
                update acc;
            }
        }        
    }
}