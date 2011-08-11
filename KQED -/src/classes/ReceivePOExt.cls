public with sharing class ReceivePOExt {
	
    private final Purchase_Order__c purchaseOrder;
    
    public ReceivePOExt(ApexPages.StandardController stdController) {
    	try {
	        this.purchaseOrder = (Purchase_Order__c)stdController.getRecord();
    	} catch (Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));    		
    	}
    } 
    	
	public list<POProductWrapper> POProductWPs {
		get {
			if (POProductWPs == null) {
		    	list<Purchase_Order_Product__c> POProducts = [Select p.Unreceived_Quantity__c, p.Status__c, p.Received_Quantity__c, p.Quantity__c, p.Purchase_Price__c,
		    						 p.Purchase_Order__c, p.Product__c, p.Product__r.Name, p.Name, p.Id 
		    					From Purchase_Order_Product__c p 
		    					Where Purchase_Order__c =: purchaseOrder.Id and Unreceived_Quantity__c > 0];
    			
    			POProductWPs = new list<POProductWrapper>();
    			for(Purchase_Order_Product__c POProd : POProducts)
					POProductWPs.add(new POProductWrapper(POProd));
					
    			system.debug('\n ### POProducts.size ' + POProducts.size() + ' => ' + POProducts);
			}
			
			return POProductWPs;
		}
		
		private set; 
	}    
    
	public PageReference receivePO() {
		try {
			
			if(!Validate())
				return null;
			
			list<Purchase_Order_Product__c> POProducts_To_Update = new list<Purchase_Order_Product__c>();
			for(POProductWrapper POWP : POProductWPs) {
				if(POWP.POProduct.Received_Quantity__c == null) POWP.POProduct.Received_Quantity__c = 0;

				// update PO Product only if the quantity is greater than zero
				if (POWP.receivedQty > 0) {
					POWP.POProduct.Received_Quantity__c += POWP.receivedQty;
					if(POWP.POProduct.Received_Quantity__c == POWP.POProduct.Quantity__c)
						POWP.POProduct.Status__c = 'Received';
					else
						POWP.POProduct.Status__c = 'Partially Received';

					POProducts_To_Update.add(POWP.POProduct);	
				}
			}
			
			System.debug('\n ### POProducts_To_Update.size ' + POProducts_To_Update.size() + ' => ' + POProducts_To_Update);
			if(!POProducts_To_Update.isEmpty()) {
				update POProducts_To_Update;				
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Records updated Successfully.'));
			}
			
	        return Cancel();
	        
    	} catch (Exception ex) {
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, ex.getMessage()));
    	}
    	return null;
	}
	
	public PageReference cancel() {
		
		return new PageReference('/'+purchaseOrder.Id);
	}
	
	public boolean validate() {
		boolean bError = false;
		boolean bAtleastOneProductReceived = false;
		
		for(POProductWrapper POWP : POProductWPs) {
			if (POWP.POProduct.Received_Quantity__c == null) POWP.POProduct.Received_Quantity__c = 0;
			if (POWP.POProduct.Received_Quantity__c < 0) {
				bError = true;				
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Quantity Received must be greater than zero for product ' + POWP.POProduct.Product__r.Name +'.'));
			}

			if (POWP.receivedQty > 0) bAtleastOneProductReceived = true;
			
			if (POWP.POProduct.Quantity__c < (POWP.POProduct.Received_Quantity__c + POWP.receivedQty)) {
				bError = true;				
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Total Quantity Received can not be greater than Quantity Ordered for product ' + POWP.POProduct.Product__r.Name +'.'));
			}
		}
		
		if (bAtleastOneProductReceived==false) {
			bError = true;			
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Quantity Received must be greater than zero for at least one Product.'));
		}
		
		return !bError;
	}
	
	// inner class	
	public class POProductWrapper {

		public Integer receivedQty 					{ get; set; }
		public Purchase_Order_Product__c POProduct 	{ get; set; }		
		
		public POProductWrapper(Purchase_Order_Product__c prod) {
			POProduct = prod;
			receivedQty = 0;
		}
	}
}