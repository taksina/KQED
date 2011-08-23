/**********************************************************
 * Description      : Apex Trigger to calculate Products Units Received
 * @date            : May 11, 2011
 **********************************************************/

trigger PurchaseOrderProductAfterAll on Purchase_Order_Product__c (after insert, after update, after delete, after undelete) {
	
	set<Id> productIds = new set<Id>();
	
	list<Purchase_Order_Product__c> POProducts = (Trigger.New==null) ? Trigger.Old : Trigger.New;
	System.debug('\n ### PurchaseOrderProductAfterAll Insert ' + Trigger.isInsert + ' Update ' + Trigger.isUpdate + ' Delete ' + Trigger.isDelete + ' size ' + POProducts.size() + ' records)');
	
	// get distinct product ids
	for (Purchase_Order_Product__c pop : POProducts) {
		// IF: some amount has been received AND (it's either an Insert, Undelete, or a Delete OR it's an update and the receiving quantity changed)
		if ( (pop.Received_Quantity__c != null && pop.Received_Quantity__c > 0 && (Trigger.isInsert || Trigger.isUnDelete || Trigger.isDelete)) || (Trigger.isUpdate && pop.Received_Quantity__c <> Trigger.oldMap.get(pop.Id).Received_Quantity__c) ) {		
			productIds.add(pop.Product__c);
		}
	}
	
	system.debug('\n ### productIds.size ' + productIds.size() + ' => ' + productIds);
	if (!productIds.isEmpty()) {
		try {
			// TO DO - move this to a helper class and make sure there are no more than 5 jobs runnings at a time. 
			BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds, 'ProductUnitsReceived');
			ID batchProcessid = Database.executeBatch(scriptBatch);
		} catch (Exception ex) {}	
	}
}