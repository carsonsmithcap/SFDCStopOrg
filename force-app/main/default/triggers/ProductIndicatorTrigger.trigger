trigger ProductIndicatorTrigger on Suppliers_Ingredients__c (After Insert, After Update) {
        TriggerDispatcher.Run(new ProductIndicator10_7(), Trigger.operationType);
    	
}