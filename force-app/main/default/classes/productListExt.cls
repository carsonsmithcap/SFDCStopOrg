public with sharing class productListExt {
    @AuraEnabled(cacheable=true)
    public static List<Product2> getProductList(Id acctId) {
        System.debug('Account Id: ' + acctId);
        List<Suppliers_Ingredients__c> supIngList = [Select Id, Ingredient__c
                                                      From Suppliers_Ingredients__c
                                                      Where Account__c = :acctId];
        System.debug('Supplier Ingredient List: ' + supIngList);
        Set<Id> ingIds = new Set<Id>();

        for(Suppliers_Ingredients__c supIng : supIngList){
            ingIds.add(supIng.Ingredient__c);
        }
        
        List<Product_Ingredient__c> prodIngList = [Select Id, Product__c
                                                From Product_Ingredient__c
                                                Where Ingredient__c in :ingIds
                                                ];
        System.debug('Product Ingredient List: ' + prodIngList);
        
        Set<Id> productIds = new Set<Id>();
        for(Product_Ingredient__c prodIng : prodIngList){
            productIds.add(prodIng.Product__c);
        }
        System.debug('Set of Product IDs: ' + productIds);

        return [Select Id, Name, ProductCode, Family From Product2 Where Id in :productIds];
    }
}