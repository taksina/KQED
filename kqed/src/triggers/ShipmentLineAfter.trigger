trigger ShipmentLineAfter on Shipment_Line__c (after delete, after update, after insert, after undelete) {
	//
	// For any change, write a summary of the line items on the shipment 
	//
	
	Set<Id> shipIds = new Set<Id>();
	for (Shipment_Line__c line : (Trigger.New == null ? Trigger.Old : Trigger.New)) shipIds.add(line.Shipment__c);
	
	List<Shipment__c> shipments = [Select Id, Included_Premiums__c, (Select Product__c, Product__r.ProductCode, Quantity__c From Shipment_Lines__r Order By Product__r.ProductCode) From Shipment__c Where Id IN : shipIds];
	for (Shipment__c shipment : shipments) {
		String included_premiums = '';
		for (Shipment_Line__c line : shipment.Shipment_Lines__r) {
			included_premiums += line.Product__r.ProductCode;
			if (line.Quantity__c > 1) included_premiums += ' (' + line.Quantity__c + ')';
			included_premiums += ', ';
		}
		
		if (included_premiums.length() > 2) shipment.Included_Premiums__c = included_premiums.substring(0, included_premiums.length()-2);
	}
	
	update shipments;
}