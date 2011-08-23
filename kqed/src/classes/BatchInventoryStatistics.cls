/**********************************************************
 * Description			: Batch process to calculate inventory statistics
 * @date						: May 11, 2011
 **********************************************************/

global class BatchInventoryStatistics implements Database.Batchable<Id> {
	private final list<Id> productIds;
	private final String mode;			 
	
	global BatchInventoryStatistics(set<Id> pIds, String m) {
		this.productIds = Util.convertSetToList(pids);
		this.mode = m;
		system.debug('\n ### mode ' + mode + ' productIds.size ' + this.productIds.size() + ' ' + this.productIds);
	}

	global Iterable<Id> start(Database.BatchableContext info) {
		return productIds;
	}

	global void execute(Database.BatchableContext BC, list<Id> pids) {
		calculateInventoryStatistics(pids, this.mode);
	}

	public static void calculateInventoryStatistics(list<Id> productIds, String mode) {
		system.debug('\n ### productIds.size ' + productIds.size() + ' => ' + productIds);
		if (!productIds.isEmpty()) {
				
			list<Product2> products_to_update = new list<Product2>();
				
			if (mode == 'ProductUnitsReceived') {
				Map<Id, AggregateResult> aggResults = new Map<Id, AggregateResult>();
				for (AggregateResult res : [Select Product__c, sum(Received_Quantity__c) receivedQty, sum(Quantity__c) totalQty from Purchase_Order_Product__c where Product__c != null AND Product__c in : productIds group by Product__c]) {
					aggResults.put( (Id) res.get('Product__c'), res);
				}
				
				for (Id pId : productIds) {
					Product2 p = new Product2(
						Id = pId,
						Units_Ordered_calc__c = 0,
						Units_Received_calc__c = 0
					);
					if (aggresults.containsKey(pId)) {
						Double totalQty = (Double) aggResults.get(pId).get('totalQty');
						Double receivedQty = (Double) aggResults.get(pId).get('receivedQty');
						if (totalQty != null) p.Units_Ordered_calc__c = totalQty.intValue();
						if (receivedQty != null) p.Units_Received_calc__c = receivedQty.intValue();
					}
					products_to_update.add(p);
				}
			}
					
			if (mode == 'ProductUnitsSold') {
				Map<Id, AggregateResult> aggResults = new Map<Id, AggregateResult>();
				for (AggregateResult res : [Select PricebookEntry.Product2Id, sum(Unshipped_Quantity__c) aggTotal from OpportunityLineItem where PricebookEntry.Product2Id in : productIds and Opportunity.isWon = true group by PricebookEntry.Product2Id]) {
					aggResults.put( (Id) res.get('Product2Id'), res);
				}

				for (Id pId : productIds) {
					Product2 p = new Product2(
						Id = pId,
						Units_Sold_calc__c = 0
					);
					if (aggresults.containsKey(pId)) {
						Double aggTotal = (Double) aggResults.get(pId).get('aggTotal');
						if (aggTotal != null) p.Units_Sold_calc__c = aggTotal.intValue();
					}
					products_to_update.add(p);
				}
			}

			if (mode == 'ProductUnitsPending' || mode == 'ProductUnitsShipped') {
				Map<Id, AggregateResult> aggResults = new Map<Id, AggregateResult>();
				for (AggregateResult res : [Select Product__c, sum(Quantity__c) aggTotal from Shipment_Line__c where Product__c in : productIds and Shipment__r.Status__c = : (mode == 'ProductUnitsPending' ? 'Pending' : 'Shipped') group by Product__c]) {
					aggResults.put( (Id) res.get('Product__c'), res);
				}

				for (Id pId : productIds) {
					Product2 p = new Product2(Id = pId);
					if (mode == 'ProductUnitsPending') p.Units_Pending_Shipment_calc__c = 0;
					if (mode == 'ProductUnitsShipped') p.Units_Shipped_calc__c = 0;

					if (aggresults.containsKey(pId)) {
						Double aggTotal = (Double) aggResults.get(pId).get('aggTotal');
						if (mode == 'ProductUnitsPending' && aggTotal != null) p.Units_Pending_Shipment_calc__c = aggTotal.intValue();
						if (mode == 'ProductUnitsShipped' && aggTotal != null) p.Units_Shipped_calc__c = aggTotal.intValue();
					}
					products_to_update.add(p);
				}
			}
				
			if (!products_to_update.isEmpty()) {
				Database.update(products_to_update, false);
			}
		}
	}
		
	// TO DO - move the function to Util class, if we are not planning to schedule a batch job.	 
	global static map<Id, decimal> getAggResultsMap(String fieldName, String fieldNameAgg, AggregateResult[] aggResults) {
		Id cid;
		decimal aggTotal;
		map<Id, decimal> aggResultsMap = new map<Id, decimal>();
							
		if (aggResults != null) {
			for (AggregateResult ar : aggResults) {
				System.debug('\n ### ar ' + fieldName + ' ' + ar);
				
				cid = (Id)ar.get(fieldName);
				aggTotal = (decimal)ar.get(fieldNameAgg);
				System.debug('\n ### cid ' + cid + ' Agg. Summary ' + aggTotal);
				
				aggResultsMap.put(cid, aggTotal);
			}
		}
		return aggResultsMap;
	}	 
				
	global void finish(Database.BatchableContext BC) {
		// Get the ID of the AsyncApexJob representing this batch job 
		// from Database.BatchableContext.
		// Query the AsyncApexJob object to retrieve the current job's information. 
		AsyncApexJob a = [Select Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:BC.getJobId()];
		
		if (a.NumberOfErrors > 0 || Test.isRunningTest()) {
			//Send an email to the Apex job's submitter notifying of job completion.
			Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
			String[] toAddresses = new String[] {'ryan.huff@roundcorner.com'};
			mail.setToAddresses(toAddresses);
			mail.setSubject('Batch Inventory Statistics ' + a.Status);
			mail.setPlainTextBody('The batch Apex job processed ' + a.TotalJobItems +
															' batches with '+ a.NumberOfErrors + ' failures.');
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
	}
		
	public static testMethod void test() {
		//list<Id> productIds = [select id from Product2 limit 5];
		set<Id> productIds = new set<Id>();
		for (Product2 p : [select id from Product2 where IsActive = true and IsDeleted = false limit 5]) {
				productIds.add(p.Id);
		}
		BatchInventoryStatistics scriptBatch = new BatchInventoryStatistics(productIds, 'ProductUnitsReceived');
		ID batchProcessid = Database.executeBatch(scriptBatch);
	}
}