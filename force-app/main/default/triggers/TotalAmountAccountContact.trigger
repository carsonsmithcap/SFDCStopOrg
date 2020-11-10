trigger TotalAmountAccountContact on Sales_Invoice__c (after insert, after update, after delete) {
	TriggerDispatcher.Run(new SalesInvoiceTriggerHandler(), Trigger.operationType);
}