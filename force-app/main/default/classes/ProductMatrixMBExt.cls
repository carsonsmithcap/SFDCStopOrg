public class ProductMatrixMBExt {
    private final Account acct;
    //This list is used to display the ingredients and products made with the ingredient
    public List<productIngredientWrapper> displayList {get;set;}
    
    //This wrapper class holds the ingredient name in a String and a list of the products made with that
    //ingredient in a list of Product2 SObjects
    public class productIngredientWrapper{
        String ingredientName {get;set;}
        Decimal invoicedAmount {get;set;}
        List<Product2> productList {get;set;}
        public productIngredientWrapper(String ingredientName, Decimal invoicedAmount, List<Product2> productList){
            this.ingredientName = ingredientName;
            this.invoicedAmount = invoicedAmount;
            this.productList = productList;
        }
        public String getIngredientName(){return ingredientName;}
        public String getInvoicedAmount(){return String.ValueOf(invoicedAmount);}
        public List<Product2> getProductList(){return productList;}
    }
    
    //This method returns the List of Wrapper Class objects
    public List<productIngredientWrapper> getDisplayList(){return displayList;}
    
    //Constructor
    public ProductMatrixMBExt(ApexPages.StandardController stdController) {
        //Assign Record Id to stored variable
        this.acct = (Account)stdController.getRecord();
        
        //Initialize Lists
        List<Suppliers_Ingredients__c> suppIngList;
        List<Product_Ingredient__c> prodIngList;
        
        //Select list of all Supplier Ingredients where the Acccount ID is the current record
        suppIngList = [Select Id, Name, Account__c, Ingredient__c 
                   From Suppliers_Ingredients__c Where Account__c = :this.acct.id];
        
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
        
        //Initialize the Display List that will be used on the VisualForce Page
        this.displayList = new List<productIngredientWrapper>();
        
        //Create a Map that will store the Ingredient Name and a List of Products made with that ingredient
        //This will become the Display List in the Wrapper Class
        Map<string, List<Product2>> displayListMap = new Map<String, List<Product2>>();
        for(Product_Ingredient__c ing : prodIngList){
            if(displayListMap.containsKey(ing.Ingredient__r.Name)){
                List<Product2> tempProd = displayListMap.get(ing.Ingredient__r.Name);
                tempProd.add(new Product2(Name = ing.Product__r.Name
                                          , ProductCode = ing.Product__r.ProductCode
                                          , Family = ing.Product__r.Family));
                displayListMap.put(ing.Ingredient__r.Name, tempProd);
            }else{
                List<Product2> tempProd = new List<Product2>();
                tempProd.add(new Product2(Name = ing.Product__r.Name
                                          , ProductCode = ing.Product__r.ProductCode
                                          , Family = ing.Product__r.Family));
                displayListMap.put(ing.Ingredient__r.Name, tempProd);
            }
        }
        
        //Loop through the Map, load the Key String into the ingredient of the wrapper class
        //and load the Value List of Products into the Product List of the wrapper class
        for(string ingName : displayListMap.keyset()){
            this.displayList.add(new productIngredientWrapper(ingName, 0, displayListMap.get(ingName)));
        }
    }
}