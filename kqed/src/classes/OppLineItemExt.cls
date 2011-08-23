public with sharing class OppLineItemExt {

    private final Id cid;
    public OppLineItemExt(ApexPages.StandardController stdController) {
    	cid = (Id)stdController.getRecord().Id;
    	system.debug('\n ### oli id ' + cid);
    }
    
	public list<Shipment_Line__c> ShipmentLineItems {
		get {
			if (ShipmentLineItems == null) {
		    	ShipmentLineItems = [Select s.Shipment__c, s.Quantity__c, s.Product__c, s.Opportunity_Line_Item_ID__c, s.Name,
		    							   s.LastModifiedDate, s.LastModifiedById, s.Id, s.CreatedDate, s.CreatedById 
		    						From Shipment_Line__c s
		    						Where Opportunity_Line_Item_ID__c =: cid];
    						
				system.debug('\n ### ShipmentLineItems.size ' + ShipmentLineItems.size() + ' => ' + ShipmentLineItems);
			}
			return ShipmentLineItems;
		}
		private set;
	}
}