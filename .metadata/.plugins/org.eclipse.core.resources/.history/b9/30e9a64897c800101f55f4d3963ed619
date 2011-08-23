trigger OpportunityBefore on Opportunity (before delete) {
	//
	// If an Opp is deleted, delete it's line items first so that roll-ups fire
	//
	
	if (Trigger.isDelete) {
		delete [Select Id From Shipment__c Where Opportunity__c IN : Trigger.oldMap.keySet()];
		delete [Select Id From OpportunityLineItem Where OpportunityId IN : Trigger.oldMap.keySet()];
	}

}