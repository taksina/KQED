public with sharing class CreateShipmentController {
    
    private final Id oppid;
    private set<id> setOppIds = new set<id>();
    public String selected_ShipIds				{get;set;}
    
    public Integer queryRowLimit				{get;set;}
    public Shipment__c dummyShipment			{get;set;}
    public list<ShipmentWrapper> shipmentWPs 	{get;set;}        	
            
    public CreateShipmentController() {
    	system.debug('\n ### in CreateShipmentController constructor ');    	
    	if (Apexpages.currentPage().getParameters().containsKey('oppId')) {
    		oppid = Apexpages.currentPage().getParameters().get('oppId');
    		setOppIds.add(oppid);
    	} else if (Apexpages.currentPage().getParameters().containsKey('oppIds')) {
    		String selected_OppIds = Apexpages.currentPage().getParameters().get('oppIds');
    		system.debug('\n ### selected_OppIds ' + selected_OppIds);
    		for (String oppId : selected_OppIds.split(',')) {
    			setOppIds.add(oppId);
    		}
    	}
        init();
    }
    
    public void init() {
    	queryRowLimit = 200;
		shipmentWPs = new list<ShipmentWrapper>();
    	dummyShipment = new Shipment__c(Shipping_Date__c=Date.today());    	    	
    }
    
    public void initShipment() {
		try {
			shipmentWPs = new list<ShipmentWrapper>();
	        createShipmentWPs();
			
			if (shipmentWPs.size() == queryRowLimit)
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Only the first ' + queryRowLimit + ' Shipments are displayed.'));
			
        } catch (Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
    	}
    	
    	return ;
    }
    
    private void createShipmentWPs() {
    	
    	list<OpportunityLineItem> oppLineItems = GetOppLineItems();
        if(oppLineItems == null || oppLineItems.isEmpty()) {
           	//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No unshipped Giving Premiums/Benefits found for the selected Orders.'));	           	
           	return;
        }
    	
    	map<String, ShipmentWrapper> mapShipmentWP = new map<String, ShipmentWrapper>();
    	ShipmentWrapper shipWP;
    	String shipmentKey;
    	
    	for(OpportunityLineItem oli : oppLineItems) {
			shipmentKey = getShipmentKey(oli);
    		    		
    		if(!mapShipmentWP.containsKey(shipmentKey))
    			shipWP = new ShipmentWrapper(oli.Opportunity);
    		else
    			shipWP = mapShipmentWP.get(shipmentKey);
    		
    		shipWP.ShipmentLineWPs.add(new ShipmentLineWrapper(oli));
    		mapShipmentWP.put(shipmentKey, shipWP);
    	}
    	
    	shipmentWPs = mapShipmentWP.values();
    	system.debug('\n ### shipmentWPs.size ' + shipmentWPs.size() + ' => ' + shipmentWPs);
	}
	
	private String getShipmentKey(OpportunityLineItem oli) {
		String shipmentKey = util.assignIfNotEmpty(oli.OpportunityId,'') + util.assignIfNotEmpty(oli.Street__c,'') + util.assignIfNotEmpty(oli.City__c,'') + util.assignIfNotEmpty(oli.State__c,'') + util.assignIfNotEmpty(oli.Country__c,'');
		system.debug('\n ### shipmentKey ' + shipmentKey); 
		return shipmentKey;
	}
    
 	private list<OpportunityLineItem> GetOppLineItems() {
     	
     	//TO DO - remove unused fields from the Select stmt.
     	
    	system.debug('\n ### oppId: '+ oppid);
    	system.debug('\n ### setOppIds ' + setOppIds); 
     	
 	    list<OpportunityLineItem> oppLineItems = [Select oli.Unshipped_Quantity__c, oli.Shipped_Quantity__c, oli.Quantity,													  
													oli.OpportunityId, oli.Id, oli.Fulfillment_Status__c,  													
													oli.Street__c, oli.City__c, oli.State__c, oli.Postal_Code__c, oli.Country__c,
													oli.PricebookEntryId, oli.PricebookEntry.Product2Id, oli.PricebookEntry.Product2.Name, 
													PricebookEntry.Product2.Units_Available__c, PricebookEntry.Product2.Units_On_Hand__c,
													Opportunity.Id, Opportunity.Name, Opportunity.Gift_Date_Time__c, Opportunity.Oppty_Related_Contact__c, 
													Opportunity.AccountID, Opportunity.Account.Name
												  From  OpportunityLineItem oli
												  where Quantity > 0
												  and   PricebookEntry.Product2.Units_Available__c > 0
												  and   (Unshipped_Quantity__c > 0)		//Unshipped_Quantity__c = null OR 
												  //and   (oli.OpportunityId = : oppId OR oli.PricebookEntry.Product2Id in : setProductIds)
												  and   (oli.OpportunityId in : setOppIds)
												  order by CreatedDate
												  limit 200];
		
		system.debug('\n ### oppLineItems.size ' + oppLineItems.size() + ' => ' + oppLineItems);
		
		return oppLineItems;
 	}
    
    public PageReference CreateShipment() {
    	try {
	    	
    		boolean atLeastOneSelected = false;
    		decimal productsToShip;
    		decimal unitsAvail;
    		decimal unshippedQty;
    		map<Id, decimal> mapProductsToShip = new map<Id, decimal>();    		
    		list<Shipment__c> shipments_To_Upsert = new list<Shipment__c>();
    		list<Shipment_Line__c> shipmentLines_To_Upsert = new list<Shipment_Line__c>();
    		list<OpportunityLineItem> olis_To_Update = new list<OpportunityLineItem>();
    		
    		if (dummyShipment.Shipping_Date__c == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Shipping Date must be entered.'));
				return null;
    		}
    		
    		if (dummyShipment.Carrier__c == null) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Carrier must be selected.'));
				return null;
    		}

	    	for(ShipmentWrapper sp : shipmentWPs) {
    			
    			sp.shipment.Shipping_Date__c = dummyShipment.Shipping_Date__c;
    			sp.shipment.Carrier__c = dummyShipment.Carrier__c;
	    			    		
	    		for (ShipmentLineWrapper spl : sp.shipmentLineWPs) {
		    		if (spl.checked == true) {
		    			atLeastOneSelected = true;		    			
		    			
		    			// optionally these can be set when creating the shipment object but don't have time to change the Shipment Wrapper constructor to accept oli instead of opp.
		    			sp.checked = true;

		    			sp.shipment.Street_Address__c = spl.oli.Street__c;
		    			sp.shipment.City__c = spl.oli.City__c;
		    			sp.shipment.State__c = spl.oli.State__c;
		    			sp.shipment.Postal_Code__c = spl.oli.Postal_Code__c;
		    			sp.shipment.Country__c = spl.oli.Country__c;	    		
		    					    					    					    			
			    		if (spl.shipmentLine.Quantity__c > 0) {
			    			productsToShip = spl.shipmentLine.Quantity__c;
			    			if (mapProductsToShip.containsKey(spl.shipmentLine.Product__c)) {
								productsToShip = productsToShip + mapProductsToShip.get(spl.shipmentLine.Product__c);
			    			}
			    			mapProductsToShip.put(spl.shipmentLine.Product__c, productsToShip);
			    			
			    			unitsAvail = Util.assignIfNotNull(spl.oli.PricebookEntry.Product2.Units_Available__c, 0);
			    			system.debug('\n ### units available ' + unitsAvail + ' for product ' + spl.oli.PricebookEntry.Product2.Name + ' productsToShip ' + productsToShip);
			    			if (productsToShip > unitsAvail) {
				    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'The shipments below include ' + productsToShip + ' units of the \'' + spl.oli.PricebookEntry.Product2.Name + ' \' and only ' + unitsAvail + ' is available.'));
				    			return null;
			    			}
			    			
			    			unshippedQty = Util.assignIfNotNull(spl.oli.Unshipped_Quantity__c, 0);
			    			system.debug('\n ### unshipped quantity ' + unshippedQty + ' for product ' + spl.oli.PricebookEntry.Product2.Name + ' shipment quantity ' + spl.shipmentLine.Quantity__c);
			    			if (spl.shipmentLine.Quantity__c > unshippedQty) {
				    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Ship Qty must be less than or equal to unshipped quantity for Premium/Benefit \'' + spl.oli.PricebookEntry.Product2.Name + '\'.'));
				    			return null;			    				
			    			}
							
			    		} else {
			    			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Ship Qty must be greater than zero for selected Premium/Benefit.'));
			    			return null;
			    		}			    		
		    		}
	    		}
	    		
	    		// if necessary, allow upserts by removing IF condition below.
	    		if (sp.shipment.Id == null && sp.checked) shipments_To_Upsert.add(sp.shipment);
	    	}
	    		    	
	    	system.debug('\n ### shipments_To_Upsert.size ' + shipments_To_Upsert.size() + ' => ' + shipments_To_Upsert);
	    	if(!shipments_To_Upsert.isEmpty()) {
	    		upsert shipments_To_Upsert;
	    		
	    		//set<Id> shipmentIds = new set<Id>();
	    		selected_ShipIds = '';
		    	for(ShipmentWrapper sp : shipmentWPs) {
		    		for (ShipmentLineWrapper spl : sp.shipmentLineWPs) {
		    			if (spl.checked == true) {		    				
		    				system.debug('\n ### sp.shipment.Id ' + sp.shipment.Id);
		    				//shipmentIds.add(sp.shipment.Id);
		    				if (selected_ShipIds.indexOf(sp.shipment.Id) == -1) {
								if (selected_ShipIds != '') selected_ShipIds += ',';						    					
		    					selected_ShipIds += sp.shipment.Id;
		    				}
		    				if (spl.shipmentLine.Shipment__c == null) spl.shipmentLine.Shipment__c = sp.shipment.Id;
		    				shipmentLines_To_Upsert.add(spl.shipmentLine);
		    				
		    				//spl.oli.Unshipped_Quantity__c = Util.assignIfNotNull(spl.oli.Unshipped_Quantity__c, 0) - spl.shipmentLine.Quantity__c;
		    				//spl.oli.Shipped_Quantity__c = Util.assignIfNotNull(spl.oli.Shipped_Quantity__c, 0) + spl.shipmentLine.Quantity__c;
		    				olis_To_Update.add(spl.oli);
		    			}
		    		}
		    	}
	    		
	    		system.debug('\n ### shipmentLines_To_Upsert.size ' + shipmentLines_To_Upsert.size() + ' => ' + shipmentLines_To_Upsert);
	    		if (!shipmentLines_To_Upsert.isEmpty()) {
	    			upsert shipmentLines_To_Upsert;
	    		}

	    		system.debug('\n ### olis_To_Update.size ' + olis_To_Update.size() + ' => ' + olis_To_Update);
	    		if (!olis_To_Update.isEmpty()) {
	    			update olis_To_Update;
	    		}
	    		
	    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Shipment(s) created.'));
	    		
	    		//shipments = [select Id, Name, Carrier__c, Opportunity__c, Organization__c, Shipping_Contact__c, City__c, State__c from Shipment__c where id in :shipmentIds];
	    		
	    		return displayShipment();
	    		
	        } else if (atLeastOneSelected == true) {
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Shipment(s) have been recently created for the selected Premiums/Benefits.'));
	        } else {
	        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'At least one Premium/Benefit must be selected for shipment.'));
	        }
    	} catch (Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
    	}
        
    	return null;
    }
    
    public PageReference displayShipment() {

    	PageReference pg = new PageReference('/apex/DisplayShipment?shipIds='+selected_ShipIds);
		pg.setRedirect(true);
    	System.debug('\n ### pg '+ pg);	
    	return pg;
    }
    
    public PageReference Cancel() {
        init();
        return null;
    }
    
    public PageReference cancelShipment() {
    	init();
    	    	
    	PageReference pg;
	    
    	if (oppId != null)
    		pg = new PageReference('/'+oppId);
    	else
    		pg = new PageReference('/apex/CreateShipmentOrder');

		pg.setRedirect(true);
    	System.debug('\n ### pg '+ pg);	
    	return pg;
    }	    
}