trigger PurchaseOrderBefore on Purchase_Order__c (before delete) {
	//
	// If a PO is deleted, delete it's line items first so that roll-ups fire
	//
	
	if (Trigger.isDelete) {
		delete [Select Id From Purchase_Order_Product__c Where Purchase_Order__c IN : Trigger.oldMap.keySet()];
	}
}