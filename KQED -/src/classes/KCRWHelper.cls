public with sharing class KCRWHelper {

	public static Id getRecordTypeId(String objectName, String recordTypeName) {
		System.debug('\n ### KCRWHelper.getRecordTypeId');
		System.debug('\n ### Queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
		Id recordTypeId;
		try {
			recordTypeId = [Select r.Id From RecordType r where r.SobjectType = :objectName and r.Name = :recordTypeName and r.IsActive = true].Id;
		} catch (Exception ex) {}
		
		return recordTypeId;
	}

	public static void handleShipmentPendingStatus(set<Id> shipmentIds_Pending) {

		set<Id> productIds_Pending = new set<Id>();
		
		system.debug('\n ### shipmentIds_Pending.size ' + shipmentIds_Pending.size() + ' => ' + shipmentIds_Pending);		
		if (!shipmentIds_Pending.isEmpty()) {
			for (Shipment_Line__c sl : [Select Product__c from Shipment_Line__c where Shipment__c in : shipmentIds_Pending]) {
				productIds_Pending.add(sl.Product__c);
			}
		}
		
		system.debug('\n ### productIds_Pending.size ' + productIds_Pending.size() + ' => ' + productIds_Pending);
		if (!productIds_Pending.isEmpty()) {
			try {	
				BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds_Pending, 'ProductUnitsPending');
				ID batchProcessid_Pending = Database.executeBatch(scriptBatch);
			} catch (Exception ex) {}	
		}
	}

	public static void handleShipmentShippedStatus(set<Id> shipmentIds_Shipped) {
		set<Id> productIds_Shipped = new set<Id>();
		set<Id> oliIds_Shipped = new set<Id>();		
				
		system.debug('\n ### shipmentIds_Shipped.size ' + shipmentIds_Shipped.size() + ' => ' + shipmentIds_Shipped);		
		if (!shipmentIds_Shipped.isEmpty()) {
			for (Shipment_Line__c sl : [Select Product__c, Opportunity_Line_Item_ID__c from Shipment_Line__c where Shipment__c in : shipmentIds_Shipped]) {
				productIds_Shipped.add(sl.Product__c);
				oliIds_Shipped.add(sl.Opportunity_Line_Item_ID__c);
			}
			
			// update oli shipped quantity field - if necessary move this to batch process 
			if (!oliIds_Shipped.isEmpty()) {
				
				AggregateResult[] aggResults = [Select Opportunity_Line_Item_ID__c, sum(Quantity__c) aggTotal
								from Shipment_Line__c
								where Opportunity_Line_Item_ID__c in : oliIds_Shipped
								group by Opportunity_Line_Item_ID__c];
		
				map<Id, decimal> mapAggTotals = BatchInventoryStatistics.getAggResultsMap('Opportunity_Line_Item_ID__c', 'aggTotal', aggResults);
				decimal aggTotal;
				
				list<OpportunityLineItem> olis_To_Update = new list<OpportunityLineItem>();
			   	for(Id oliId : oliIds_Shipped) {
					aggTotal = null;
					if (mapAggTotals.containsKey(oliId)) aggTotal = mapAggTotals.get(oliId);
					if (aggTotal == 0) aggTotal = null;

					olis_To_Update.add(new OpportunityLineItem(Id=oliId, Shipped_Quantity__c=aggTotal));
				}

				system.debug('\n ### olis_To_Update.size ' + olis_To_Update.size() + ' => ' + olis_To_Update);
				if (!olis_To_Update.isEmpty()) {
					update olis_To_Update;
				}
			}
			
			system.debug('\n ### productIds_Shipped.size ' + productIds_Shipped.size() + ' => ' + productIds_Shipped);
			if (!productIds_Shipped.isEmpty()) {
				Integer numJobs = [Select count() From AsyncApexJob Where Status = 'Processing' OR Status = 'Queued'];
				if (numJobs >= 5) return;
				try {
					// TO DO - move this to a helper class and make sure there are no more than 5 jobs runnings at a time. 
					BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds_Shipped, 'ProductUnitsShipped');
					ID batchProcessid_Shipped = Database.executeBatch(scriptBatch);
				} catch (System.LimitException ex) {}	
			}			
		}
	}
	
	public static void updateShipmentPrintStatus(set<ID> shipmentIds_PrintingCompleted, boolean value) {
		
		system.debug('\n ### shipmentIds_PrintingCompleted.size ' + shipmentIds_PrintingCompleted.size() + ' => ' + shipmentIds_PrintingCompleted);		
		if (!shipmentIds_PrintingCompleted.isEmpty()) {
			list<Shipment__c> shipments_To_Update = [Select Id, To_Print__c, Printing_Complete__c from Shipment__c where Id in : shipmentIds_PrintingCompleted];  
			for (Shipment__c s : shipments_To_Update) {
				s.To_Print__c = value;
				s.Printing_Complete__c = value;
			}
			
			if (!shipments_To_Update.isEmpty()) {
				update shipments_To_Update;
			}
		}		
	}	
}