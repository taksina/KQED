public with sharing class SelectProductPOExt {

/*Start local and global variables*/
			
	public Purchase_Order__c po			{get; set;}
	public String cid 					{get; set;}
	public String strProductFamily 		{get; set;}		
	public String selectedIds			{get; set;}
	public String selected_PriceBook 	{get; set;}
	public String lineId 				{get; set;}
	public String lineName 				{get; set;}				  
	
	// Capture a Map and Set of Product Fields so we only do the Describe ONCE per instance
	private map<String, Schema.SObjectField> productFieldMap = null;
	private String[] splitIds;
	private Boolean blnAddMoreProducts = false;				

	public String strEditAll;
	public Boolean bShowError = false;		
	
	// Collection of search results for displaying		
	public list<searchObject> searchResults = new list<searchObject>();
	public list<searchObject> selectedResults = new list<searchObject>();
	private list<SelectOption> lstProductFamily = new list<SelectOption>();

	

/*Start Constructor*/ 
	public SelectProductPOExt(ApexPages.StandardController c) {
		ApexPages.CurrentPage().getParameters().put('mode', 'po');
		po = [Select po.Name  From Purchase_Order__c po where po.id =: c.getId()];
		//selected_PriceBook = opp.Price_Book__c;
		cid = po.Id;
	}

	public Boolean getShowError() {
		return bShowError;
	}

	public pagereference initAdd() {

		strEditAll = 'add';
		//system.debug('\n ### parameters in initAdd ' + ApexPages.currentPage().getParameters().get('mode'));				
		return null;
	}
	
	public pagereference initEditAll() {

		//strEditAll = ApexPages.CurrentPage().getParameters().get('mode');
		if (strEditAll != 'add') {
			strEditAll = 'editall';
		}	
		system.debug('\n ### strEditAll after ' + strEditAll);		
		
		if(strEditAll == 'editall') {
							 		
			list<Purchase_Order_Product__c> lstPOLineItems;

			lstPOLineItems = [Select po.Id, Purchase_Order__c, Purchase_Price__c, Quantity__c, Product__c, Product__r.Name From Purchase_Order_Product__c po where po.Purchase_Order__c =:cId order by po.Name];	//o.Sort_Order__c, o.Price_Book_Entry__r.Name, o.CreatedDate

			for(Purchase_Order_Product__c poLineItem : lstPOLineItems) {
				selectedResults.add(new searchObject(poLineItem.Product__r, poLineItem));
			}
			
			if (lstPOLineItems.isEmpty()) {
				return RedirectToAddPO();
			}
		}
		return null;
	}
	
	public Pagereference RedirectToAddPO() {
		String vfPage = 'SelectProductPO';
		
		Pagereference pageRef = new Pagereference ('/apex/'+vfPage+'?id=' +cid+'&mode=add');
		pageRef.setRedirect(true);
		return pageRef; 		
	}
		
	public String getMode() {
		if(strEditAll == 'add')
			return 'Add';
		else
			return 'Edit';
	}
		   
	public pagereference processSelected() {
		
		//String selectedIds = ApexPages.CurrentPage().getParameters().get('selectedIds');
		system.debug('\n ### selectedIds passed from component ' + selectedIds);
		
		if (selectedIds != null && selectedIds != '') {
			
			splitIds = selectedIds.split(',');
			system.debug('\n ### splitIds ' + splitIds);
			selectedIds = '';
			
			map<Id,Product2> mapProducts = new map<Id,Product2>([select Id, Name, Family from Product2 where Id in :splitIds]);
			
			if (splitIds != null) {
				for (string pid : splitIds) {
					searchResults.add(new searchObject(mapProducts.get(pid), true));
				}
				selectedResults = searchResults;
			}
		}

		/* return error message if no Product is selected */
		system.debug('\n ### selectedResults.size ' + selectedResults.size() + ' => ' + selectedResults); 
		if (selectedResults.size()==0) {
			bShowError = true;	  
		} else {
			bShowError = false;

  			String vfPage = 'EditAllProduct';
						
			Pagereference p=new Pagereference ('/apex/' + vfPage + '?id=' +cid+ '&mode=add');
			
			return p;
		}
		
		return null;
	}
	
	public pagereference cancel() {			
		Pagereference p=new Pagereference ('/' + cid);	 
		return p;
	}

	/* ------------------------------------------------
	* Returns a list<> of Criteria Objects for use with <Apex:DataTable>
	* to allow multiple lines to be displayed and the values retrievable
	*  ------------------------------------------------------------------------------------- */

	public PageReference save() {
		list<Purchase_Order_Product__c> lstPOLineItems = new list<Purchase_Order_Product__c>();								
		Pagereference pageRef;
		 
		system.debug('size of ' + selectedResults.size());
		system.debug('\n ### strEditAll: ' + strEditAll + ' blnAddMoreProducts: ' + blnAddMoreProducts);	 
		for( searchObject searchObj : selectedResults) {
			system.debug('Search Object ::' + searchObj);
			
			if(strEditAll != 'editall') {
				searchObj.POProduct.Purchase_Order__c = cId;
				searchObj.POProduct.Product__r = searchObj.prod;
				searchObj.POProduct.Product__c = searchObj.prod.Id;
			}
						
	   		lstPOLineItems.add(searchObj.POProduct);
							
			//system.debug('Lineitem contains ' + searchObj.LineItem);
		}
		try { 
					 	
			system.debug('\n ### in try section of Save method ' + lstPOLineItems.size());
			if (!lstPOLineItems.isEmpty())
				upsert lstPOLineItems;
			
			lstPOLineItems=null;
			
			system.debug('\n ### after upserts');
			
			if (blnAddMoreProducts == false) {
				pageRef = new Pagereference ('/' + cid); 
				pageRef.setRedirect(true);
			} else {				
				//String vfPage = 'SelectProductPO';
				
				//pageRef = new Pagereference ('/apex/'+vfPage+'?id=' +cid+'&mode=add');
				//pageRef.setRedirect(true);
				pageRef = RedirectToAddPO();
			}				

		}
		catch ( DmlException exc) {
			 // Commented the following line per Ryan's recommendation.
			 //ApexPages.addMessages(exc);
			 system.debug('\n ### in error handler exc: ' + exc); 
			 //ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Exception occured : ' + exc.getMessage()));
			 return null;
		}
			
		system.debug('SaveAction ::------>' + blnAddMoreProducts);
		system.debug('PageRef ::------>' + pageRef);
		return pageRef;
	}	
		
	public PageReference AddMoreProduct() {		
		blnAddMoreProducts = True;

		return Save();
	}
		
	public PageReference DeleteLine() {
		
		system.debug('\n ### strEditAll: ' + strEditAll);
		
		Integer icount=0;	
		Boolean blnFound=false;
		
		if(strEditAll == 'editall') {
			
			system.debug('\n ### Delete sObject id is ' + lineId);
			
			//If necessary convert this to bulk.
			Purchase_Order_Product__c opl = new Purchase_Order_Product__c(Id=lineId);				   
			delete opl;
						
			for(searchObject searchObj : selectedResults) {
				if (searchObj.id == lineId) {
					blnFound=true;					
						
					break;
				}
				icount+=1;
			}
			if (blnFound==true) {
				blnFound=false;
				selectedResults.remove(icount);
			}
										
		} else {
			system.debug('\n ### lineName: ' + lineName);
			for(searchObject searchObj : selectedResults) {
				if (searchObj.prod.Name == lineName) {
					system.debug('\n ### icount: ' + icount);
					blnFound=true;
					break;
				}
				icount+=1;
			}
			if (blnFound==true) {
				blnFound=false;
				selectedResults.remove(icount);
			}
		}
		
		if (selectedResults.size() == 0) {
			Pagereference pageRef = new Pagereference ('/' + cid); 
			pageRef.setRedirect(true);
			return pageRef;
		}
		
		return null;
	}
	
	// Used in test method only.
	public void DeleteAllLines() {
		
		Integer iCounter;	 
		while (selectedResults.size() > 0) {

			iCounter = 1;
			for(searchObject searchObj : selectedResults) {
				if (iCounter == selectedResults.size()) {
					
					lineId = searchObj.id;
					lineName = searchObj.prod.Name;
					
					DeleteLine();
					break;
				}
				iCounter += 1;
			}
		}
	}
				
	public list<searchObject> getSelectedResults() {
		return selectedResults;
	}

	public Integer getSelectedResultsCount() {
		if (selectedResults == null) return 0;
		return selectedResults.size();
	}
}