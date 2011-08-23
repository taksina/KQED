public with sharing class ManageShipmentController {		 
	
	public String startNumber					{get;set;}
	public String endNumber						{get;set;}
	public Integer queryRowLimit				{get;set;}
	public Boolean printingStarted = false;
	public Boolean getPrintingStarted() {
		return printingStarted;
	}

	public list<ShipmentWrapper> shipmentWPs 	{get;set;}	
	
	public ManageShipmentController() {
		system.debug('\n ### in ManageShipmentController constructor');	
		printingStarted=false;
		init();
	}
	
	public void init() {
		startNumber = '';
		endNumber = '';
		queryRowLimit = 200;				
		shipmentWPs = new list<ShipmentWrapper>();
	}
		
	public void searchShipment() {
		try {
			
			shipmentWPs = new list<ShipmentWrapper>();
			list<Shipment__c> shipments = getShipments();
			if(shipments == null || shipments.isEmpty()) {			   	
			   	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No shipment records found.'));			   	
			   	return;
			}
			
			if (shipments.size() == queryRowLimit) {				
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Only the first ' + queryRowLimit + ' shipments are displayed.'));	
			}
						
			//Fill Shipment Wrapper Class			
			for(Shipment__c sp : shipments) {
				system.debug('\n ### adding shipment ' + sp);
				shipmentWPs.add(new ShipmentWrapper(sp));
			}
			
		} catch (Exception ex) {			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
		}
		
		//return null;
	}
	
	private list<Shipment__c> getShipments() {
		
		system.debug('\n ### startNumber ' + startNumber + ' endNumber ' + endNumber);
		
		String soql = 'Select Id,Name,Shipment_Number_Name__c, Organization__r.Name, Shipping_Contact__r.Name, Shipping_Date__c,Status__c from Shipment__c Where (Status__c = \'Not Scheduled\' OR Status__c = \'Pending\') ';
		if (startNumber != '' && endNumber != '') {
			soql += ' and Shipment_Number_Name__c >= '+ Integer.valueOf(startNumber);
			soql += ' and Shipment_Number_Name__c <= '+ Integer.valueOf(endNumber);
		} else if (startNumber != '') {
			soql += ' and Shipment_Number_Name__c = '+ Integer.valueOf(startNumber);
		} else if (endNumber != '') {
			soql += ' and Shipment_Number_Name__c = '+ Integer.valueOf(endNumber);
		}
		soql += ' order by Status__c, CreatedDate Limit ' + queryRowLimit;
		
		System.debug('\n ### soql : '+ soql);
		list<Shipment__c> shipments = (list<Shipment__c>)Database.Query(soql);

		system.debug('\n ### shipments.size ' + shipments.size() + ' => ' + shipments);
		
		return shipments;
	}
		
	public void print() {
		updateShipmentStatus('Pending');
	}
	
	public void markAsShipped() {
		updateShipmentStatus('Shipped');
	}
	
	public void cancelShipments() {
		updateShipmentStatus('Cancelled');
	}
	
	public void updateShipmentStatus(String newStatus) {
		try {
		
			list<Shipment__c> shipments_To_Update = new list<Shipment__c>();
			boolean atLeastOneSelected = false;
			
			for(ShipmentWrapper sp : shipmentWPs) {
				if (sp.checked == true) {
					atLeastOneSelected = true;
					if ( 
						(sp.shipment.Status__c == 'Not Scheduled' && newStatus == 'Pending') || 
						(sp.shipment.Status__c == 'Pending' && newStatus == 'Shipped') || 
						(sp.shipment.Status__c == 'Not Scheduled' && newStatus == 'Cancelled')
					) {						
						if (sp.shipment.Status__c == 'Not Scheduled' && newStatus == 'Pending') {
							sp.shipment.To_Print__c = true;
							sp.shipment.Label_Date__c = Date.Today();
							printingStarted=true;
						}
						sp.shipment.Status__c = newStatus;
						
						system.debug('\n ### adding shipment to shipments_To_Update ' + sp.Shipment);
						shipments_To_Update.add(sp.Shipment);
					}
				}
			}
			
			if (!shipments_To_Update.isEmpty()) {
				update shipments_To_Update;
				if (newStatus == 'Pending') {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Printing started.'));
					printingStarted=true;
				} else {
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Shipment status has been updated successfully.'));
				}	
			} else if (atLeastOneSelected == true) {
				if (newStatus == 'Pending')
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Shipment was already Printed.'));
				else
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Shipment Status must be \'Not Scheduled\'.'));	
			} else {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'At least one Shipment must be selected.'));
			}
		} catch (Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
			resetShipmentStatus((newStatus == 'Pending') ? 'Not Scheduled' : 'Pending');
		}
		
		System.debug(System.LoggingLevel.INFO, '\n**** printingStarted: '+printingStarted); 
	}
	
	public void resetShipmentStatus(String value) {
		for(ShipmentWrapper sp : shipmentWPs) {
			//if (sp.checked == true) {
			if (sp.checked == true && (sp.shipment.Status__c == 'Pending' && value == 'Not Scheduled') || (sp.shipment.Status__c == 'Shipped' && value == 'Pending')) {
				sp.shipment.Status__c = value;
			}
		}
	}
	
	public PageReference cancel() {
		init();
		return null;
	}

	public String popupScript {
		get {
			try {
				//APXT_CMQM__QuickMerge_Link__c launch = [Select Id, Launch_URL__c From APXT_CMQM__QuickMerge_Link__c Where APXT_CMQM__Title__c = 'Shipment Labels']; 
				//String congaUrl = launch.Launch_URL__c;
				//String s = '<script type="type/javascript">window.open(\''+congaUrl+'\', \'print\', \'width=690,height=700\');</script>';
				//return s;
				return '';
			} catch (System.Exception e) {
				return '';
			}
		}
	}
	
}