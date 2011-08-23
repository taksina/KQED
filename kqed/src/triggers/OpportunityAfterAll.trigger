/**********************************************************
 * Description      : Apex Trigger to calculate Products Units Sold
 * @date            : May 11, 2011
 **********************************************************/

trigger OpportunityAfterAll on Opportunity (after delete, after insert, after undelete, after update) {
	
	set<Id> productIds = new set<Id>();
	set<Id> oppIds = new set<Id>();	
	
	list<Opportunity> opportunities = (Trigger.New==null) ? Trigger.Old : Trigger.New;
	System.debug('\n ### OpportunityAfterAll Insert ' + Trigger.isInsert + ' Update ' + Trigger.isUpdate + ' Delete ' + Trigger.isDelete + ' size ' + opportunities.size() + ' records)');
	
	// get distinct opportunity ids
	for (Opportunity o : opportunities) {
//		if ( (o.isWon && (Trigger.isInsert || Trigger.isUnDelete || Trigger.isDelete)) || (Trigger.isUpdate && o.StageName != Trigger.oldMap.get(o.Id).StageName && (o.isWon || Trigger.oldMap.get(o.Id).isWon)) ) {			
		if ( o.isWon && (Trigger.isInsert || Trigger.isUnDelete || Trigger.isDelete || (Trigger.isUpdate && !Trigger.oldMap.get(o.Id).isWon) ) ) {			
			oppIds.add(o.Id);
		}
	}
	
	system.debug('\n ### oppIds.size ' + oppIds.size() + ' => ' + oppIds);
	if (!oppIds.isEmpty()) {
		list<OpportunityLineItem> olis_to_update = [select Id, priceBookEntry.Product2Id from OpportunityLineItem where Opportunity.Id in : oppIds];
		
		// get distinct product ids
		for (OpportunityLineItem oli : olis_to_update) {
			productIds.add(oli.priceBookEntry.Product2Id);
		}
		
		system.debug('\n ### olis_to_update.size ' + olis_to_update.size() + ' => ' + olis_to_update);
		if (!olis_to_update.isEmpty()) {
			update olis_to_update;
		}
	}
	
	system.debug('\n ### productIds.size ' + productIds.size() + ' => ' + productIds);
	if (!productIds.isEmpty()) {
		try {
			// TO DO - move this to a helper class and make sure there are no more than 5 jobs runnings at a time. 
			BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds, 'ProductUnitsSold');
			ID batchProcessid = Database.executeBatch(scriptBatch);
		} catch (Exception ex) {}	
	}
}