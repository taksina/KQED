/**********************************************************
 * Description      : Apex Trigger to calculate Products Units Received
 * @date            : May 11, 2011
 **********************************************************/
 
trigger ShipmentAfterAll on Shipment__c (after delete, after insert, after undelete, after update) {
	
	set<Id> shipmentIds_Pending = new set<Id>();
	set<Id> shipmentIds_Shipped = new set<Id>();
	set<Id> shipmentIds_PrintingCompleted = new set<Id>();

	list<Shipment__c> shipments = (Trigger.New==null) ? Trigger.Old : Trigger.New;
	//System.debug('\n ### CalculateProductUnitsReceived ('+ (Trigger.isInsert?'Insert':'')+(Trigger.isUpdate?'Update':'')+(Trigger.isDelete?'Delete':'')+') (' + shipments.size() + ' records)');
	System.debug('\n ### ShipmentAfterAll Insert ' + Trigger.isInsert + ' Update ' + Trigger.isUpdate + ' Delete ' + Trigger.isDelete + ' size ' + shipments.size() + ' records)');
	
	// get distinct shipment ids				
	for (Shipment__c s : shipments) {
		
		if ( (s.Status__c == 'Pending' && (Trigger.isInsert || Trigger.isUnDelete || Trigger.isDelete)) || (Trigger.isUpdate && s.Status__c <> Trigger.oldMap.get(s.Id).Status__c && (s.Status__c == 'Pending' || Trigger.oldMap.get(s.Id).Status__c == 'Pending')) ) {		
			shipmentIds_Pending.add(s.Id);
		}
		
		if (Trigger.isUpdate && s.Printing_Complete__c == true) {
			shipmentIds_PrintingCompleted.add(s.Id);
		}		
		
		if ( (s.Status__c == 'Shipped' && (Trigger.isInsert || Trigger.isUnDelete || Trigger.isDelete)) || (Trigger.isUpdate && s.Status__c <> Trigger.oldMap.get(s.Id).Status__c && (s.Status__c == 'Shipped' || Trigger.oldMap.get(s.Id).Status__c == 'Shipped')) ) {		
			shipmentIds_Shipped.add(s.Id);
		}		
	}
	
//	Integer numJobs = [Select count() From AsyncApexJob Where Status = 'Processing' OR Status = 'Queued'];
	// update Product Units Pending
	KCRWHelper.handleShipmentPendingStatus(shipmentIds_Pending);

	// update shipment print status to false
	KCRWHelper.updateShipmentPrintStatus(shipmentIds_PrintingCompleted, false);
	
	// update OLI shipped quantity and Product units shipped
	KCRWHelper.handleShipmentShippedStatus(shipmentIds_Shipped);
}