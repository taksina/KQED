public with sharing class ShipmentLineWrapper {

	public Boolean checked 					{ get; set; }
	//public decimal availableQty 		 	{ get; set; }
	
	public Shipment_Line__c shipmentLine 	{ get; set; }
	public OpportunityLineItem oli 			{ get; set; }	
	
	public ShipmentLineWrapper(OpportunityLineItem li) {
		checked = false;
		//availableQty = li.PricebookEntry.Product2.Units_Available__c;
		this.oli = li;
		this.shipmentLine = new Shipment_Line__c(Opportunity_Line_Item_ID__c=oli.Id, Product__c=oli.PricebookEntry.Product2Id, Quantity__c=null, Shipment__c=null);
	}
}