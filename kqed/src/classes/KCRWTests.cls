@isTest
private with sharing class KCRWTests {

///////////////////////////////////////////////////////////
// INVENTORY-RELATED TESTS
///////////////////////////////////////////////////////////
	public static testmethod void test_ReceivePOExt() {
		
		Map<String, String> urlParams = new Map<String, String> {
			'id' => TestUtil.PurchaseOrder.Id
		};
		
		// Switch to test context
		Test.startTest();

		PageReference ref = TestUtil.getPageReference('ReceivePO', urlParams);
		System.assertNotEquals(null, ref);
		
		// setup a reference to the page the controller is expecting with the parameters
		system.debug('\n ### Test page reference ' + TestUtil.getPageReference('ReceivePO', urlParams));
		Test.setCurrentPage(ref);
		
		list<Purchase_Order_Product__c> poProductList = TestUtil.PurchaseOrderProducts;

		// create PO with two line items.		
		ApexPages.StandardController con = new ApexPages.StandardController(new Purchase_Order__c(Id=TestUtil.PurchaseOrderProducts[0].Purchase_Order__c));
		
		ReceivePOExt receivePO;
		try {
			receivePO = new ReceivePOExt(null);
		} catch (Exception ex) {}
			
		receivePO = new ReceivePOExt(con);
		list<ReceivePOExt.POProductWrapper> POProductWPs = receivePO.POProductWPs;
		
		// PO has two products
		system.assertEquals(POProductWPs.size(), 2);
		
		// inner class Received quantity is zero
		system.assertEquals(POProductWPs[0].receivedQty, 0);
		system.assertEquals(POProductWPs[1].receivedQty, 0);
		
		// db Received quantity is null
		system.assertEquals(POProductWPs[0].POProduct.Received_Quantity__c, null);
		system.assertEquals(POProductWPs[1].POProduct.Received_Quantity__c, null);
		
		// raise an error in the validation
		receivePO.validate();
		receivePO.ReceivePO();
		
		// set received quantity to 1 for both the products 
		receivePO.POProductWPs[0].receivedQty = 1;
		receivePO.POProductWPs[1].receivedQty = 1;
		
		// validation is successful and save the values to db
		receivePO.ReceivePO();
		
		// First Product is fully received and product 2 is partially received 
		system.assertEquals(POProductWPs[0].POProduct.Status__c, 'Received');
		system.assertEquals(POProductWPs[1].POProduct.Status__c, 'Partially Received');
		
		// db received quantity must be 1 for both the products
		system.assertEquals(POProductWPs[0].POProduct.Received_Quantity__c, 1);
		system.assertEquals(POProductWPs[1].POProduct.Received_Quantity__c, 1);
				
		receivePO.POProductWPs[1].receivedQty = 1;
		receivePO.ReceivePO();
		
		// raise an error/exception in the save operation
		try {
			receivePO.POProductWPs.add(new ReceivePOExt.POProductWrapper(new Purchase_Order_Product__c(Product__c=TestUtil.Products[0].Id, Purchase_Price__c=200, Quantity__c=2, Purchase_Order__c='abcd', Received_Quantity__c = null)));
			receivePO.POProductWPs[2].receivedQty = 1;
			receivePO.ReceivePO();
			
		} catch (Exception ex) {}
		
		// cancel
		receivePO.Cancel();
		
		// Total Quantity Received can not be greater than Quantity Ordered for product
		receivePO.POProductWPs[1].receivedQty = 1;
		receivePO.ReceivePO();

		//Quantity Received must be greater than zero for at least one Product.				
		receivePO.POProductWPs[0].POProduct.Received_Quantity__c = -1;
		// raise an error for negative quantity check
		receivePO.ReceivePO();
				
		// Switch back to runtime context
		Test.stopTest();
	}


///////////////////////////////////////////////////////////
// SHIPMENTS-RELATED TESTS
///////////////////////////////////////////////////////////

	public static testmethod void test_OppLineItemExt() {
		// Switch to test context
		Test.startTest();
		
		ApexPages.StandardController con = new ApexPages.StandardController(TestUtil.OpportunityLineItems[0]);
		
		OppLineItemExt oppLineItem = new OppLineItemExt(con);
		list<Shipment_Line__c> shipLineItems = oppLineItem.ShipmentLineItems;
		
		system.assertEquals(true, shipLineItems.isEmpty());
		
		// Switch back to runtime context
		Test.stopTest();
	}	


	public static testmethod void test_ShipmentWrapper() {
		ShipmentWrapper sw = new ShipmentWrapper(new Shipment__c());
		
		system.assertEquals(false, sw.checked);
		system.assertEquals(0, sw.selectedItemsCount);
		system.assertEquals(true, sw.shipmentLineWPs.isEmpty());
		
		sw = new ShipmentWrapper(TestUtil.Opportunity);
		system.assertEquals(sw.opp.Id, TestUtil.Opportunity.Id);
		system.assertEquals(sw.shipment.Opportunity__c, TestUtil.Opportunity.Id);
	}
		
	public static testmethod void test_ShipmentLineWrapper() {
		ShipmentLineWrapper slw = new ShipmentLineWrapper(TestUtil.OpportunityLineItems[0]);
		
		system.assertEquals(false, slw.checked);
		system.assertEquals(slw.oli.Id, TestUtil.OpportunityLineItems[0].Id);
		system.assertEquals(slw.shipmentLine.Opportunity_Line_Item_ID__c, TestUtil.OpportunityLineItems[0].Id);
	}

	public static testmethod void test_CreateShipment() {
		
		// create an opportunity with two line items
		Map<String, String> urlParams = new Map<String, String> {
			'oppid' => TestUtil.OpportunityLineItems[0].OpportunityId
		};
		
		// Switch to test context
		Test.startTest();

		system.debug('\n ### setting page reference to CreateShipmentOrder page'); 
		PageReference ref = TestUtil.getPageReference('CreateShipmentOrder', urlParams);
		System.assertNotEquals(null, ref);
		
		// setup a reference to the page the controller is expecting with the parameters
		system.debug('\n ### Test page reference ' + TestUtil.getPageReference('CreateShipmentOrder', urlParams));
		Test.setCurrentPage(ref);
		
		CreateShipmentOrderExt csoExt = new CreateShipmentOrderExt(new ApexPages.StandardController(TestUtil.Shipment));
		
		//TestUtil.Opportunity.StageName = 'Closed Won';
		//update TestUtil.Opportunity;
		system.debug('\n ### TestUtil.Opportunity.isWon ' + TestUtil.Opportunity.isWon);
		
		// remove the following two lines
		Opportunity dummyTest = [select Id, isWon from Opportunity where Id = :TestUtil.Opportunity.Id];
		system.debug('\n ### dummyTest.isWon ' + dummyTest.isWon);
		
		// close a new opportunity
		Opportunity oppNew = new Opportunity(Name = 'Opportunity 2', StageName = 'Prospecting', CloseDate = Date.Today()-4);
		insert oppNew;
		
		list<OpportunityLineItem> oppLineItems = new list<OpportunityLineItem>{
			new OpportunityLineItem(PricebookEntryId = TestUtil.PricebookEntrys[0].Id, OpportunityId = oppNew.Id, UnitPrice = 25, Quantity = 5),
			new OpportunityLineItem(PricebookEntryId = TestUtil.PricebookEntrys[1].Id, OpportunityId = oppNew.Id, UnitPrice = 50, Quantity = 10)
		};
		insert oppLineItems;
		
		OpportunityStage stage = [Select o.MasterLabel, isWon From OpportunityStage o Where isWon=true AND isActive=true LIMIT 1];
		oppNew.StageName = stage.MasterLabel;
		oppNew.payment_method__c = 'Cash';
		oppNew.payment_amount__c = 625;
		oppNew.Payment_Date__c = Date.today();
		update oppNew;
		oppNew = [Select Id, StageName, isClosed, isWon, HasOpportunityLineItem, Shipment_Status__c, Inventory_Status__c From Opportunity Where Id =: oppNew.Id];
		system.debug('\n ### oppNew.isWon ' + oppNew.isWon);
		System.assertEquals(true, oppNew.isWon, 'Stage is ' + oppNew.StageName); 
		system.assertEquals(stage.MasterLabel, oppNew.StageName);
		System.assertEquals(true, oppNew.HasOpportunityLineItem);
		
		system.assertEquals(3, csoExt.shipmentStatusListOptions.size());
		system.assertEquals(3, csoExt.dateFilterListOptions.size());
		
		csoExt.shipmentStatus = 'PSNS';
		csoExt.searchOpp();
		system.debug('\n ### csoExt.oppWPs in testmethod ' + csoExt.oppWPs);

		system.debug('\n ### create a purchase order with two products');
		system.assertEquals(2, TestUtil.PurchaseOrderProducts.size());
				
		csoExt.shipmentStatus = 'PS';
		csoExt.searchOpp();
		
		system.debug('\n ### receive the products, update PO status and Products Units On Hand quantity');
		TestUtil.PurchaseOrderProducts[0].Received_Quantity__c = 1;
		TestUtil.PurchaseOrderProducts[1].Received_Quantity__c = 1;
		update TestUtil.PurchaseOrderProducts;
		
		TestUtil.PurchaseOrder.Status__c = 'Partially Received';
		update TestUtil.PurchaseOrder;
		
		TestUtil.Products[0].Units_Received_calc__c = 1;
		TestUtil.Products[1].Units_Received_calc__c = 1;
		update TestUtil.Products;
				
		//search results should return at least one Opportunity.
		system.debug('\n ### search a product ' + TestUtil.Products[0].Name);
		csoExt.shipmentStatus = 'PSNS';
		csoExt.productName = TestUtil.Products[0].Name;
		csoExt.searchOpp();
		system.assertEquals(false, csoExt.oppWPs.isEmpty());

		// Not Shipped Opp search
		csoExt.shipmentStatus = 'NS';
		csoExt.searchOpp();
		
		//system.debug('\n ### search for a specific PO number');
		csoExt.shipmentStatus = 'PSNS';
		csoExt.productName = '';
		csoExt.searchOpp();
		system.assertEquals(false, csoExt.oppWPs.isEmpty());
		
		// no Opp found
		csoExt.dateFilter = 'After';
		csoExt.dummyOpp.closeDate = system.today().addYears(3);
		csoExt.searchOpp();
		system.assertEquals(true, csoExt.oppWPs.isEmpty());
		
		// no Opp found
		csoExt.dateFilter = 'Before';
		csoExt.dummyOpp.closeDate = system.today();
		csoExt.searchOpp();
		
		// find at least one Opp
		csoExt.dateFilter = 'On';
		csoExt.dummyOpp.closeDate = system.today();
		csoExt.searchOpp();
		
		// fint at least one Opp
		csoExt.dummyOpp.closeDate = null;
		csoExt.shipmentStatus = 'PSNS';
		csoExt.acctName = TestUtil.Account.Name;
		csoExt.searchOpp();		
		
		system.debug('\n ### create a new PO with recevied status');		
		Purchase_Order__c poNew = new Purchase_Order__c(Vendor__c = TestUtil.Vendor.Id, Contact__c = TestUtil.Contact.Id, Confirm_Date__c = system.today().addDays(-3), Status__c = 'Received');		
		insert poNew;

		Purchase_Order_Product__c pop = new Purchase_Order_Product__c(Product__c=TestUtil.Products[0].Id, Purchase_Price__c=100, Quantity__c=10, Purchase_Order__c=poNew.Id, Received_Quantity__c = 10);
		insert pop;
				
		// PO found
		system.debug('\n ### Opp date Before search');
		csoExt.dateFilter = 'Before';
		csoExt.dummyOpp.closeDate = system.today();
		csoExt.searchOpp();
				
		system.debug('\n ### search should find at least one PO');
		csoExt.shipmentStatus = 'PSNS';
		csoExt.productName = '';
		csoExt.queryRowLimit = 1;
		csoExt.dummyOpp.closeDate = null;
		csoExt.acctName = null;
//		CreateShipmentOrderExt.assertFailure = true; // will throw an assertion fail and display the query
		csoExt.searchOpp();
		CreateShipmentOrderExt.assertFailure = false;
		System.assertEquals(false, csoExt.oppWPs.isEmpty());
		
		// none of the POs selected - return null
		ref = csoExt.createShipmentOrder();
		system.assertEquals('', csoExt.selected_OppIds);		
		
		system.debug('\n ### select Opp and navigate to CreateShipmentOpp page');		
		ref = csoExt.createShipmentOrder();
		csoExt.oppWPs[0].checked = true;
		ref = csoExt.createShipmentOrder();		
		System.assertNotEquals(null, ref);
		Test.setCurrentPage(ref);
		csoExt.Cancel();
		
		CreateShipmentController csc = new CreateShipmentController(); 

		system.debug('\n ### initShipment');
		csc.initShipment();
		csc.CreateShipment();
		
		csc.dummyShipment.Shipping_Date__c = null;
		csc.CreateShipment();
		
		// set shipping date, carrier and select products to create shipment
		csc.dummyShipment.Shipping_Date__c = system.today();
		csc.dummyShipment.Carrier__c = 'FedEx';
		csc.CreateShipment();
		
		for(ShipmentWrapper sp : csc.shipmentWPs) {
			for (ShipmentLineWrapper spl : sp.shipmentLineWPs) {
				if (spl.oli.id == TestUtil.OpportunityLineItems[0].ID) {
					spl.checked = true;
					spl.shipmentLine.Quantity__c = 0;
				}	
			}
		}
		csc.CreateShipment();
		
		// set the shipment quantity
		for(ShipmentWrapper sp : csc.shipmentWPs) {
			for (ShipmentLineWrapper spl : sp.shipmentLineWPs) {
				if (spl.oli.id == TestUtil.OpportunityLineItems[0].ID) {
					spl.checked = true;
					spl.shipmentLine.Quantity__c = spl.oli.Unshipped_Quantity__c + 1;
				}	
			}
		}
		csc.CreateShipment();
		
		for(ShipmentWrapper sp : csc.shipmentWPs) {
			for (ShipmentLineWrapper spl : sp.shipmentLineWPs) {
				if (spl.oli.id == TestUtil.OpportunityLineItems[0].ID) {
					spl.checked = true;
					spl.shipmentLine.Quantity__c = 1;
				}	
			}
		}
//		csc.CreateShipment();
		csc.CreateShipment();
		
		csc.Cancel();
		csc.CancelShipment();
		
		//update shipment and shipmentline print status
		ManageShipmentController msc = new ManageShipmentController();
		msc.SearchShipment();
		msc.Print();
		for(ShipmentWrapper sp : msc.shipmentWPs) {
			sp.checked = true;
		}
		msc.Print();
		msc.Print();
		
		//system.assertEquals(true, msc.shipmentWPs[0].shipment.Status__c == 'Pending');
		system.assertEquals(true, msc.shipmentWPs[0].shipment.To_Print__c == true);		
		
		msc.shipmentWPs[0].shipment.Printing_Complete__c = true;
		update msc.shipmentWPs[0].shipment;
				
		msc.shipmentWPs[0].shipment.Status__c = 'Shipped';
		update msc.shipmentWPs[0].shipment;
		
		msc.resetShipmentStatus(null);
		
		msc.Cancel();
								
		//delete TestUtil.Opportunity;
		
		// Switch back to runtime context
		//Test.stopTest();
	}

	public static testmethod void test_CreateShipmentController() {
		
		// create an opportunity with two line items
		Map<String, String> urlParams = new Map<String, String> {
			'oppId' => TestUtil.OpportunityLineItems[0].OpportunityId
		};
		
		// Switch to test context				
		Test.startTest();
		
		system.debug('\n ### setting page reference to CreateShipmentOpp page'); 
		PageReference ref = TestUtil.getPageReference('CreateShipmentOpp', urlParams);
		System.assertNotEquals(null, ref);
		
		system.debug('\n ### Test page reference ' + TestUtil.getPageReference('CreateShipmentOpp', urlParams));
		Test.setCurrentPage(ref);
		
		CreateShipmentController csc = new CreateShipmentController(); 

		system.debug('\n ### initShipment');
		TestUtil.Opportunity.StageName = 'Closed Won';
		update TestUtil.Opportunity;		
		csc.queryRowLimit = 1;
		csc.initShipment();
		csc.CreateShipment();
		
		csc.Cancel();
		csc.CancelShipment();

		// Switch back to runtime context
		Test.stopTest();
	}
	
	public static testmethod void test_ManageShipmentController() {
		
		// Switch to test context				
		Test.startTest();
						
		Shipment__c sp = TestUtil.Shipment;
		ManageShipmentController msc = new ManageShipmentController();
		msc.SearchShipment();
		msc.Print();
		msc.Cancel();		
		
		msc.startNumber = '0';
		msc.SearchShipment();
		msc.endNumber = '1000';
		msc.SearchShipment();
		msc.startNumber = '';
		msc.SearchShipment();
		msc.endNumber = '';				
		
		msc.queryRowLimit = 1;
		msc.SearchShipment();
		
		ShipmentWrapper sw = new ShipmentWrapper(sp);
		msc.shipmentWPs.add(sw);
		if (msc.shipmentWPs != null && msc.shipmentWPs.size() > 0) {
			msc.queryRowLimit =  msc.shipmentWPs.size();
			msc.shipmentWPs[0].checked = true;
			msc.shipmentWPs[0].Shipment.Status__c = 'Pending';
		}
		msc.Print();
		
		msc.shipmentWPs[0].Shipment.Status__c = '';
		msc.Print();
		
		// Switch back to runtime context
		Test.stopTest();
	}		   
	
	public static testmethod void TestUtilTest() {
		// Switch to test context
		Test.startTest();
		
		Account a = TestUtil.Account;
		Account vendor = TestUtil.Vendor;
		Contact Contact = TestUtil.Contact;
		
		Opportunity opp = TestUtil.Opportunity;
		list<OpportunityLineItem> oppLineItems = TestUtil.OpportunityLineItems;
				
		list<Product2> Products = TestUtil.Products;
		Purchase_Order__c PurchaseOrder = TestUtil.PurchaseOrder;
		list<Purchase_Order_Product__c> PurchaseOrderProducts= TestUtil.PurchaseOrderProducts;
		
		// Switch back to runtime context
		Test.stopTest();
	}

	private static testMethod void test_OppBeforeTrigger() {
		Opportunity opp = TestUtil.Opportunity;
		delete opp;
	}

	private static testMethod void test_POBeforeTrigger() {
		Purchase_Order__c po = TestUtil.PurchaseOrder;
		delete po;
	}

	private static testMethod void test_ShipmentBeforeTrigger() {
		Shipment__c shipment = TestUtil.Shipment;
		delete shipment;
	}
	
	private static testMethod void test_ShipmentLineAfterTrigger() {
		Opportunity opp = TestUtil.Opportunity;
		Shipment__c shipment = TestUtil.Shipment;

		List<Shipment_Line__c> slines = new List<Shipment_Line__c>();
		for (OpportunityLineItem oli : TestUtil.OpportunityLineItems) {
			Shipment_Line__c sl = new Shipment_Line__c(
				Shipment__c = shipment.Id,
				Product__c = oli.PricebookEntry.Product2Id,
				Quantity__c = oli.Quantity
			);
			slines.add(sl);
		}
		insert slines;
	}
	
	private static testMethod void test_PackageItemAfterTrigger() {
		Product2 p1 = TestUtil.Products[0];
		Product2 p2 = TestUtil.Products[1];
		
		Id item_rectype = KCRWHelper.getRecordTypeId('Product2', 'Item');
		Id pack_rectype = KCRWHelper.getRecordTypeId('Product2', 'Package');
		
		p1.RecordTypeId = item_rectype; update p1;
		p2.RecordTypeId = pack_rectype; update p2;
		Product2 p3 = p2.clone(false, true); p3.Name = 'Product 3'; insert p3;
		
		Package_Item__c pi1 = new Package_Item__c(
			Item__c = p1.Id,
			Package__c = p2.Id
		);
		insert pi1;
		p1 = [select id, item_packs__c from product2 Where id =: p1.id];
		System.assertEquals(p2.Id, p1.Item_Packs__c);
		
		Package_Item__c pi2 = new Package_Item__c(
			Item__c = p1.Id,
			Package__c = p3.Id
		);
		insert pi2;
		p1 = [select id, item_packs__c from product2 Where id =: p1.id];
		System.assertEquals(p2.Id +','+p3.Id, p1.Item_Packs__c);
		
		delete pi1;
		p1 = [select id, item_packs__c from product2 Where id =: p1.id];
		System.assertEquals(p3.Id, p1.Item_Packs__c);
		
		undelete pi1;
		p1 = [select id, item_packs__c from product2 Where id =: p1.id];
		System.assertEquals(p2.Id +','+p3.Id, p1.Item_Packs__c);
		
		delete new List<Package_Item__c>{pi1,pi2};
		p1 = [select id, item_packs__c from product2 Where id =: p1.id];
		System.assert(Util.isNullOrEmpty(p1.Item_Packs__c));
	}
}