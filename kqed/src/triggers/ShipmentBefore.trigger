trigger ShipmentBefore on Shipment__c (before delete) {
	//
	// If a Shipment is deleted, delete it's line items first so that roll-ups fire
	//
	
	if (Trigger.isDelete) {
		delete [Select Id From Shipment_Line__c Where Shipment__c IN : Trigger.oldMap.keySet()];
	}

}