public with sharing class ShipmentWrapper {
		
	public Boolean checked 		{ get; set; }
	public Integer selectedItemsCount { get; set; }
	public Opportunity opp 		{ get; set; }
	public Shipment__c shipment { get; set; }		
	public list<ShipmentLineWrapper> shipmentLineWPs { get; set; }
	
	public ShipmentWrapper(shipment__c sp) {
		init();
		shipment = sp;
		opp = new Opportunity();
	}
	
	public ShipmentWrapper(Opportunity op) {
		init();					
		this.opp = op;
    	shipment = new Shipment__c(Opportunity__c=opp.Id, Shipping_Contact__c=opp.Oppty_Related_Contact__c, Organization__c=opp.AccountID, Shipping_Date__c=null, Carrier__c=null);	//Date.Today()		
		//shipment.Carrier__c = 'FedEx';
	}
	
    private void init() {
    	selectedItemsCount = 0;
		checked = false;
		shipmentLineWPs = new list<ShipmentLineWrapper>();
    }
}