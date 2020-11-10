public class NewAccount {
    public void CreateAccount(){
    Account acct = new Account(Name = 'Tester1',
                               Phone = '(111)-111-1112',
                               RecordTypeId ='0124W0000011JRKQA2',
                               VAT_Number__c= 112223454,
                               Designated_Email__c = 'Jacob.conrad@cap.com',
                               Billing_Responsible__c='Eric',
                              OwnerId='Lance Armstrong');
    
    insert acct;
    }
}