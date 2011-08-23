public class TestUtil {
	
	public static Account Account {
		get {
			if (Account == null) {
				Account = new Account(name='test account', phone='408-878-0923', ShippingCountry='US', BillingCountry='US');
				insert Account;
			}
			return Account;
		}
		private set;
	}

	public static Id OrganizationRecordTypeId {
		get {
			if (OrganizationRecordTypeId == null) {
				try {
					OrganizationRecordTypeId = KCRWHelper.getRecordTypeId('Account', 'Organization');
				} catch (Exception ex) {}
			}		
			return OrganizationRecordTypeId;	
		}
		
		private set;
	}
		
	public static Account Vendor {
		get {
			if (Vendor == null) {
				Vendor = new Account(name='test vendor', phone='122-878-0923', ShippingCountry='US', BillingCountry='US', RecordTypeId = OrganizationRecordTypeId);
				insert Vendor;
			}
			return Vendor;
		}
		private set;
	}
	
	public static Contact Contact {
		get {
			if (Contact == null) {
				Contact = new Contact(LastName = 'Smith', FirstName = 'Wills', AccountId = Account.Id, phone='408-878-0923');
				insert Contact;
			}
			return Contact;
		}
		private set;
	}
	
	public static list<Product2> Products {
		get {
			if (Products == null) {
				
				Products = new list<Product2>{
					new Product2( Name = 'Product 1', Family = 'F1', Units_Received_calc__c=null, Inventory_Type__c = 'Standard Inventory'),
					new Product2( Name = 'Product 2', Family = 'F2', Units_Received_calc__c=null, Inventory_Type__c = 'Standard Inventory')
				};
				
				insert Products;
			}
			return Products;
		}
		private set;
	}
	
	public static Pricebook2 StandardPriceBook {
		get {
			if(StandardPriceBook == null) {
				StandardPriceBook = [Select p.Name, p.IsActive, p.Id From Pricebook2 p where isStandard = true];
			}
			return StandardPriceBook;
		}		
		private set;
	}
			
	public static list<PricebookEntry> PricebookEntrys {
		get {
			if (PricebookEntrys == null) {
				PricebookEntrys = new list<PricebookEntry>{
				  new PricebookEntry(Product2Id = Products[0].Id, Pricebook2Id = TestUtil.StandardPriceBook.Id, IsActive = true, UseStandardPrice = false, UnitPrice = 10),  
				  new PricebookEntry(Product2Id = Products[1].Id, Pricebook2Id = TestUtil.StandardPriceBook.Id, IsActive = true, UseStandardPrice = false, UnitPrice = 20)  
				};
				insert PricebookEntrys;
			}
			return PricebookEntrys;
		}
		private set;
	}

	public static Purchase_Order__c PurchaseOrder {
		get {
			if (PurchaseOrder == null) {
				PurchaseOrder = new Purchase_Order__c(Vendor__c = Vendor.Id, Contact__c = Contact.Id, Confirm_Date__c = system.today());
				insert PurchaseOrder;
			}
			return PurchaseOrder;
		}
		private set;
	}

	public static list<Purchase_Order_Product__c> PurchaseOrderProducts {
		get {
			if (PurchaseOrderProducts == null) {
				PurchaseOrderProducts = new list<Purchase_Order_Product__c>{
					new Purchase_Order_Product__c(Product__c=Products[0].Id, Purchase_Price__c=100, Quantity__c=1, Purchase_Order__c=PurchaseOrder.Id, Received_Quantity__c = null),
					new Purchase_Order_Product__c(Product__c=Products[1].Id, Purchase_Price__c=200, Quantity__c=2, Purchase_Order__c=PurchaseOrder.Id, Received_Quantity__c = null)
				};
				insert PurchaseOrderProducts;
			}
			return PurchaseOrderProducts;
		}
		private set;
	}
	
	public static Opportunity Opportunity {
		get {
			if (Opportunity == null) {
				Opportunity = new Opportunity(Name = 'Opportunity 1', StageName = 'Closed Won', CloseDate = Date.Today(), AccountId = Account.Id);//StageName = 'Closed Won', 
				insert Opportunity;
			}
			return Opportunity;
		}
		private set;
	}
	
	public static list<OpportunityLineItem> OpportunityLineItems {
		get {
			if (OpportunityLineItems == null) {
				
				OpportunityLineItems = new list<OpportunityLineItem>{
					new OpportunityLineItem(PricebookEntryId = TestUtil.PricebookEntrys[0].Id, OpportunityId = TestUtil.Opportunity.Id, UnitPrice = 25, Quantity = 5),
					new OpportunityLineItem(PricebookEntryId = TestUtil.PricebookEntrys[1].Id, OpportunityId = TestUtil.Opportunity.Id, UnitPrice = 50, Quantity = 10)
				};				
				
				insert OpportunityLineItems;
				Set<Id> oppLineItemIds = new Set<Id>();
				oppLineItemIds.add(OpportunityLineItems[0].Id);
				oppLineItemIds.add(OpportunityLineItems[1].Id);
				OpportunityLineItems = [Select Id, PricebookEntryId, PricebookEntry.Product2Id, OpportunityId, UnitPrice, Quantity From OpportunityLineItem Where Id IN : oppLineItemIds];
			}
			return OpportunityLineItems;
		}
		private set;
	}
	
	public static PageReference getPageReference(String page, Map<String, String> params) {
		String url = '/apex/'+page+'?';
		for (String param : params.keySet()) {
			url += param + '=' + params.get(param) + '&';
		}
		PageReference p = new PageReference(url);
		return p;
	}
	

	public static Shipment__c Shipment {
		get {
			if (Shipment == null) {				
				Opportunity opp = TestUtil.Opportunity;
				Shipment = new Shipment__c(
					Opportunity__c = opp.Id, 
					Shipping_Contact__c = opp.Oppty_Related_Contact__c, 
					Organization__c = opp.AccountID, Carrier__c = 'FedEx', 
					Shipping_Date__c = Date.Today(), Street_Address__c = 'Street_Address__c', 
					City__c = 'City__c', State__c = 'State__c', Postal_Code__c = '12345'
				);
				insert Shipment;
			}
			
			return Shipment;
		}
		private set;
	}   

/*	
	public static Shipment_Line__c ShipmentLine {
		get {
			if (ShipmentLine == null) {
				
			}
			
			return ShipmentLine;
		}
		private set;
	}
*/
}