/**********************************************************
 * Description      : Apex Trigger to calculate Products Units Sold
 * @date            : June 2, 2011
 **********************************************************/

trigger OLIAfterAll on OpportunityLineItem (after delete, after update, after insert) { // undeletes not supported for OLI
	set<Id> productIds = new set<Id>();
	set<Id> oliIds = new set<Id>();	
	
	List<OpportunityLineItem> olis = (Trigger.New==null) ? Trigger.Old : Trigger.New;
	System.debug('\n ### OLIAfterAll size ' + olis.size() + ' records)');
	
	for (OpportunityLineItem oli : olis) {
		if (Trigger.isDelete || Trigger.isInsert || (Trigger.isUpdate && oli.Unshipped_Quantity__c != Trigger.oldMap.get(oli.Id).Unshipped_Quantity__c)) {
			oliIds.add(oli.Id);
		}
	}
	
	if (!oliIds.isEmpty()) {
		List<OpportunityLineItem> olis_to_update = [select Id, priceBookEntry.Product2Id from OpportunityLineItem where Id in : oliIds];

		for (OpportunityLineItem oli : olis_to_update) productIds.add(oli.priceBookEntry.Product2Id);
		
		// run a quick update on them to trigger workflow
		if (!olis_to_update.isEmpty() && !Trigger.isInsert) update olis_to_update;

		try {
			BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds, 'ProductUnitsSold');
			ID batchProcessid = Database.executeBatch(scriptBatch);
		} catch (Exception ex) {}	
	}
}