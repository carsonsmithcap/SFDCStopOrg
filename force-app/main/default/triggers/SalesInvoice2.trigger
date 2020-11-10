trigger SalesInvoice2 on Sales_Invoice__c (before insert, after update, before delete) {
    // Call the trigger dispatcher and pass it an instance of the SalesInvoice2TriggerHandler and Trigger.opperationType
    TriggerDispatcher.Run(new SalesInvoice2TriggerHandler(), Trigger.operationType);
}