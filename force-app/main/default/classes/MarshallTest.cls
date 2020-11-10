public class MarshallTest {
    public static void recalculateAccount(Set<id> acctIds){
        Map<Id, Decimal> acctMap = new Map<Id, Decimal>();
        Map<Id, Decimal> contMap = new Map<Id, Decimal>();
        
        List<Sales_Invoice__c> salesInvoices = [Select Id, Account__c, Contact__c, Amount__c 
                                  From Sales_Invoice__c Where Account__c in :acctIds];
        for(Sales_Invoice__c inv : salesInvoices){
            if(acctMap.containsKey(inv.Account__c)){
                acctMap.put(inv.Account__c, acctMap.get(inv.Account__c) + inv.Amount__c);
            }else{
                acctMap.put(inv.Account__c, inv.Amount__c);
            }
            if(contMap.containsKey(inv.Contact__c)){
                contMap.put(inv.Contact__c, contMap.get(inv.Contact__c) + inv.Amount__c);
            }else{
                contMap.put(inv.Contact__c, inv.Amount__c);
            }
        }
        
        List<Account> acctList = new List<Account>();
        List<Contact> contList = new List<Contact>();
        
        for(Id acctId : acctMap.keyset()){
            acctList.add(new Account(id = acctId, totalAmount_a__c = acctMap.get(acctId)));
        }
        for(Id contId : contMap.keyset()){
            contList.add(new Contact(id = contId, Total_AmountC__c = contMap.get(contId)));
        }
        
        if(!acctList.isEmpty()){
            update acctList;
        }
        if(!contList.isEmpty()){
            update contList;
        }
    }
    
    public static void recalculateProductCount(Set<id> acctIds){
        
    }
}