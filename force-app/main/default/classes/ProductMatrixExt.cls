public class ProductMatrixExt {
    private final Account acct;
    //This list is used to display the ingredients and products made with the ingredient
    public List<productIngredientWrapper> displayList {get;set;}
    //This wrapper class holds the ingredient name in a String and a list of the products made with that
    //ingredient in a list of Product2 SObjects
    public class productIngredientWrapper{
        String ingredientName {get;set;}
        List<Product2> productList {get;set;}
        //New
       public Decimal gettingAmount {get;set;}
        
        public productIngredientWrapper(String ingredientName, List<Product2> productList, Decimal gettingAmount){
            this.ingredientName = ingredientName;
            this.productList = productList;
            //For the set invoiceAmount
            this.gettingAmount = gettingAmount;
        }
        public String getIngredientName(){return ingredientName;}
        public List<Product2> getProductList(){return productList;}
        //New
   
        public String getAmount(){Return String.ValueOf(gettingAmount);}
    }
    
    
    //This method returns the List of Wrapper Class objects
    public List<productIngredientWrapper> getDisplayList(){return displayList;}
    
    //Constructor
    public ProductMatrixExt(ApexPages.StandardController stdController) {
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
        
         Set<id> prodids = new Set<id>();
        for(Product_Ingredient__c ing : prodIngList){
            prodids.add(ing.Product__c);            
        }
		
        //New MAPs
        Map<Id,Decimal> mapping = new Map<Id,Decimal>();
        Map<String,Decimal> mapping2 = new Map<String, Decimal>();
        List<SalesInvoiceLineItem__c> SalesLineItem = new List<SalesInvoiceLineItem__c>(
            [SELECT Id, Amount__c, Product__c, Sales_Invoice__c FROM SalesInvoiceLineItem__c WHERE Product__c IN :prodids]);
        system.debug(prodids);
        for(SalesInvoiceLineItem__c sili : SalesLineItem){
            if(mapping.containsKey(sili.Id)){
                Decimal d = mapping.get(sili.Id);
                d += sili.Amount__c;
                mapping.put(sili.Id,d);
            }
            else{
                mapping.put(sili.Id,sili.Amount__c);
            }            
        }
        System.debug(mapping);
       
        for(Product_Ingredient__c pc : prodIngList){
            if(mapping2.containsKey(pc.Ingredient__r.Name)){
                mapping2.put(pc.Ingredient__r.Name,mapping.get(pc.Product__c));

            }
            else{
                mapping2.put(pc.Ingredient__r.Name,mapping.get(pc.Product__c));
            }
            System.debug(pc.Ingredient__r.Name + mapping.get(pc.Product__c));
        }
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
            this.displayList.add(new productIngredientWrapper(ingName, displayListMap.get(ingName), 1443));
        }
               // mapping2.get(Ingredient__c.Id)
			
    	//siIngList = [Select Id, Name, Account__c, Ingredient__c 
                   	  //From Suppliers_Ingredients__c Where Account__c = :this.acct.id];
        
    }
}