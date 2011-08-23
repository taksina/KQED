public with sharing class CreateShipmentOrderExt {

	public String memberNumber				{get;set;}
	public String inventoryStatus			{get;set;}
	public String shipmentStatus			{get;set;}
	public String dateFilter 				{get;set;}	
	public Integer queryRowLimit			{get;set;}	
	public String productName				{get;set;}
	public String productCode				{get;set;}
	public String acctName					{get;set;}
	public boolean showError 				{get;set;}
	public String selected_OppIds			{get;set;}

	public Opportunity dummyOpp				{get;set;}
	public list<OppWrapper> oppWPs 			{get;set;}
	
	public CreateShipmentOrderExt(ApexPages.StandardController c) {
		system.debug('\n ### in CreateShipmentOrderExt constructor');		
		init();
	}
	
	private void init() {
		showError = false;
		queryRowLimit = 200;
		dateFilter = 'After';
		dummyOpp = new Opportunity();
		oppWPs = new list<OppWrapper>();		
	}
	
	public list<SelectOption> inventoryStatusListOptions {
		get {
			if (inventoryStatusListOptions == null) {
				inventoryStatusListOptions = new list<SelectOption>();
				inventoryStatusListOptions.add(new SelectOption('Aval', 'Available'));
				inventoryStatusListOptions.add(new SelectOption('APA', 'Available/Partially Available'));				
			}
			return inventoryStatusListOptions;
		}
		private set;
	}	
	
	public list<SelectOption> shipmentStatusListOptions {
		get {
			if (shipmentStatusListOptions == null) {
				shipmentStatusListOptions = new list<SelectOption>();
				shipmentStatusListOptions.add(new SelectOption('PSNS', 'Partially Shipped/Not Shipped'));
				shipmentStatusListOptions.add(new SelectOption('PS', 'Partially Shipped'));
				shipmentStatusListOptions.add(new SelectOption('NS', 'Not Shipped'));
			}
			return shipmentStatusListOptions;
		}
		private set;
	}
	
	public list<SelectOption> dateFilterListOptions {
		get {
			if (dateFilterListOptions == null) {
				dateFilterListOptions = new list<SelectOption>();
				dateFilterListOptions.add(new SelectOption('After', 'After'));
				dateFilterListOptions.add(new SelectOption('Before', 'Before'));
				dateFilterListOptions.add(new SelectOption('On', 'On'));
			}

			return dateFilterListOptions;
		}
		private set;
	}
	
	public void searchOpp() {
		try {
			showError = false;
			oppWPs = new list<OppWrapper>();
			
			list<Opportunity> opportunities = GetOpportunities();
			if(opportunities == null || opportunities.isEmpty()) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'No Giving Records found.'));					
				return;
			}
			
			if (opportunities.size() == queryRowLimit) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Only the first ' + queryRowLimit + ' giving records are displayed.'));	
			}
						
			//Fill Shipment Wrapper Class
			for(Opportunity o : opportunities) {
				system.debug('\n ### adding opp to oppWPs ' + o);
				oppWPs.add(new OppWrapper(o));
			}
			system.debug('\n ### oppWPs.size ' + oppWPs.size() + ' => ' + oppWPs);
			
		} catch (Exception ex) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
		}
		
		//return null;
	}
	
	private list<Opportunity> GetOpportunities() {
		
		String soql = 'Select Id,Name, AccountId, Account.Name, Account.Member_Number__c, Oppty_Related_Contact__c, Shipment_Status__c, Inventory_Status__c, CloseDate ';		
		
		system.debug('\n ### productName ' + productName);
		if (!Util.isNullOrEmpty(productName) || !Util.isNullOrEmpty(productCode)) {
			soql += ',(select Id, PricebookEntry.Product2.Name from OpportunityLineItems where ';
			
			if (!Util.isNullOrEmpty(productName)) soql += ' PricebookEntry.Product2.Name like \'%' + String.escapeSingleQuotes(productName) + '%\' ';
			if (!Util.isNullOrEmpty(productName) && !Util.isNullOrEmpty(productCode)) soql += 'AND'; 
			if (!Util.isNullOrEmpty(productCode)) soql += ' PricebookEntry.Product2.ProductCode like \'%' + String.escapeSingleQuotes(productCode) + '%\' ';
			soql += ') ';
		}
		soql += ' from Opportunity Where HasOpportunityLineItem = true and isWon=true ';
		
		system.debug('\n ### inventoryStatus ' + inventoryStatus);
		if (inventoryStatus == 'Aval') {
			soql += ' AND Inventory_Status__c = \'Available\' ';
		} else if (inventoryStatus == 'APA') {
			soql += ' AND (Inventory_Status__c = \'Available\' OR Inventory_Status__c = \'Partially Available\') ';
		}

		system.debug('\n ### shipmentStatus ' + shipmentStatus);
		if (shipmentStatus == 'PSNS') {
			soql += ' AND (Shipment_Status__c = \'Partially Shipped\' OR Shipment_Status__c = \'Not Shipped\') ';
		} else if (shipmentStatus == 'PS') {
			soql += ' AND Shipment_Status__c = \'Partially Shipped\' ';
		} else {
			soql += ' AND Shipment_Status__c = \'Not Shipped\' ';
		}  	
		
		system.debug('\n ### memberNumber ' + memberNumber);
		if (memberNumber != null && memberNumber != '') {
			soql += ' AND Account.Member_Number__c like \'%' + String.escapeSingleQuotes(memberNumber) + '%\'';
		}
		
		system.debug('\n ### dummyOpp.closeDate ' + dummyOpp.closeDate);
		if (dummyOpp.closeDate != null) {
			soql += ' AND closeDate ';
			if (dateFilter == 'After') {
				soql += ' > ';
			} else if (dateFilter == 'Before') {
				soql += ' < ';
			} else if (dateFilter == 'On') {
				soql += ' = ';
			}
			
			soql += Util.getSOQLDateFormat(dummyOpp.closeDate);
		}
		
		system.debug('\n ### acctName ' + acctName);
		if (acctName != null && acctName != '') {
			soql += ' AND Account.Name like \'%' + String.escapeSingleQuotes(acctName) + '%\'';
		}
		
		soql += ' order by CloseDate Limit ' + queryRowLimit;
		
		System.debug('\n ### soql : '+ soql);
		if (assertFailure) System.assert(false, soql);
		list<Opportunity> opps = (list<Opportunity>) Database.Query(soql);				
		system.debug('\n ### opps.size ' + opps.size() + ' => ' + opps);
		
		list<Opportunity> opps_To_Return = new list<Opportunity>();

		// remove opportunities with no line items
		if (!Util.isNullOrEmpty(productName) || !Util.isNullOrEmpty(productCode)) {
			for (Opportunity o : opps) {
				if (!o.OpportunityLineItems.isEmpty()) {
					opps_To_Return.add(o);
				}
			}
		} else {
			opps_To_Return = opps;
		}	

		system.debug('\n ### opps_To_Return.size ' + opps_To_Return.size() + ' => ' + opps_To_Return);			
		return opps_To_Return;
	}
	
	public PageReference createShipmentOrder() {

		boolean atLeastOneSelected = false;
		PageReference pg;
		list<OpportunityLineItem> oppLineItems;
		
		showError = false;
		set<id> setOppIds = new set<id>();
		
		system.debug('\n ### oppWPs in createShipmentOrder ' + oppWPs);
		for(OppWrapper oppw : oppWPs) {
			if (oppw.checked == true) {
				atLeastOneSelected = true;
				setOppIds.add(oppw.opp.Id);
			}
		}

		system.debug('\n ### setOppIds in createShipmentOrder ' + setOppIds);
		system.debug('\n ### atLeastOneSelected ' + atLeastOneSelected);
		selected_OppIds = '';
		if (atLeastOneSelected == true) {			 			
			for (Id cid : setOppIds) {
				if (selected_OppIds != '') selected_OppIds += ',';
				selected_OppIds += cid;
			}
			
			system.debug('\n ### selected_OppIds ' + selected_OppIds);
			pg = new PageReference('/apex/CreateShipmentOpp?oppids='+selected_OppIds);
			pg.setRedirect(true);
			System.debug('\n ### pg '+ pg);
		} else {
			//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'At least one Purchase Order must be selected.'));
			showError = true;
		}
		system.debug('\n ### showError ' + showError);
		return pg;
	}
	
	public PageReference Cancel() {
		init();		
		return null;
	}
	
	public with sharing class OppWrapper {

		public Boolean checked 		{ get; set; }
		public Opportunity opp		{ get; set; }
		
		public OppWrapper(Opportunity o) {
			checked = false;
			this.opp = o;
		}
	}
	
	public static boolean assertFailure = false;
}