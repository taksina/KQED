public with sharing class SelectProductController {

	public Purchase_Order__c po			{get; set;}
	public Boolean renderTable 			{get; set;} 
	public Boolean renderNoRecords 		{get; set;}
	public Boolean showErrorMessage		{get; set;}
	public String strProductFamily 		{get; set;}
	public String ProFamily				{get; set;}
	public String selectedIds			{get; set;}
	public String cid					{get; set;}
	public String mode					{get; set;}
	
	public string soql = '';
	private String searchKeyWord = '';
	public Boolean bShowError = false;			
	// If this is set to TRUE (by an InputHidden tag on the page) then show SOQL and other debug messages
	public boolean DebugMode = true;
	
	public Integer PageNumber=0;
	public Integer PageSize=0;
	public Integer totalPageNumber;
	public Integer newPageIndex = 1;	
	
	public String sortDirection = 'asc';
	private String sortExp = 'ProductName';
	public String queryRowLimit = '1000';
	
	public list<searchCriteria> criteriaLine = New list<searchCriteria>();
	public list<SelectOption> cacheFieldSelectValues = new list<SelectOption>();
	//private list<id> productIdList = new list<id>();
	private list<Product2> products;	
	private list<SelectOption> lstProductFamily = new list<SelectOption>();
	private map<String, Schema.SObjectField> productFieldMap = null;	
	
	// Get/Set methods to enable or disable DebugMode on the page.
	// This is called by an InputHidden tag on the page
	public boolean getSetDebugModeTRUE()		{ this.DebugMode = true; return TRUE; }
	public boolean getSetDebugModeFALSE()   	{ this.DebugMode = false; return FALSE; }
	public void setSetDebugModeTRUE(boolean x)  { this.DebugMode = true; }
	public void setSetDebugModeFALSE(boolean x) { this.DebugMode = false; }	
	public String getSearchKeyWord()			{ return this.searchKeyWord; }  
	public void setSearchKeyWord(String x)		{ this.searchKeyWord = x; }	
	public boolean getShowErrorMessage()		{ return showErrorMessage; }	
		
	// Collection of search results for displaying	
	list<searchObject> searchResults_CurrentPage;
	public list<searchObject> searchResults = new list<searchObject>();
	public list<searchObject> sortedResults = new list<searchObject>();
	public list<searchObject> selectedResults = new list<searchObject>();
	
	/* Constructor */
    public SelectProductController() {
    	if (!Util.isNullorEmpty(ApexPages.CurrentPage().getParameters().get('id'))) cid = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('id'));
    	if (!Util.isNullorEmpty(ApexPages.CurrentPage().getParameters().get('mode'))) mode = String.escapeSingleQuotes(ApexPages.CurrentPage().getParameters().get('mode'));
    	//if (cid.substring(0,3) == '006') mode = 'o';
    	system.debug('\n ### cid in controller Constructor ' + cid + ' mode ' + mode);
    	init();
    }

	public Boolean getShowError() {
		return bShowError;
	} 

	public pagereference init() {
		
		system.debug('\n ### cid in controller init ' + cid + ' mode ' + mode);
		if(cid == null || cid == '' || mode == null || mode == '') {
			//ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Required URL parameter is missing.'));
			return null;
		}

		// Build a cached list of Products/pricebookentry fields for the criteria picklist
		BuildSearchFieldsList();
		
		// Init the criteria object to be used on the page via <Apex:DataTable>
		if (criteriaLine.size() == 0) {
			for (integer j = 0; j < 5; j++) {
				searchCriteria critLine = new searchCriteria();
				critLine.SearchField = '';
				critLine.SearchOperator = '';
				critLine.SearchValue = '';
				if (j < 4) critLine.Logical = 'AND';
				if (j >0 ) critLine.style = 'display:none';
				criteriaLine.add(critLine);
			}
		}
		
		PageNumber = 0;
		PageSize = 25;   //default PageSize onLoad
		totalPageNumber = 0;
		
		system.debug('\n ### init in Controller cid ' + cid + ' mode ' + mode);
		if (mode == 'po') {			
			po = [Select o.Name From Purchase_Order__c o where o.id = :cId];
		}
		
		doSearch();
		
		return null;
	}
	
	// Return the list of Product/PricebookEntry fields for the criteria picklists
	public list<SelectOption> getsearchFields() {
		return this.cacheFieldSelectValues;
	}		
	
	public list<searchCriteria> getsearchCriteria() {
		return criteriaLine;
	}
	
	public void sortResults() {
	
		system.debug('\n ### sortExpression sortDirection before ' + sortExpression + ' ' + sortDirection + '\n');
		//system.debug(sortedResults[0].pricebookEntry.Item__r.Name);
		system.debug('\n');
					
		sortedResults = sortProducts(sortExpression, sortDirection, searchResults);
		
		system.debug('\n ### sortExpression sortDirection after ' + sortExpression + ' ' + sortDirection + '\n');		 
		//system.debug(sortedResults);
		//system.debug(sortedResults[0].pricebookEntry.Item__r.Name);
		system.debug('\n');
		
		ResetPaging();
		getSearchResultsByPaging(1);			
		return;		
	}	
		
	// Get Product Family Picklist values
	public list<SelectOption> getProductFamilyOptions() {
		 if (lstProductFamily.size()==0) {
			   Schema.DescribeFieldResult fieldResult =
						 Product2.Family.getDescribe();
			   list<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			        
			   lstProductFamily.add(new selectOption('--None--','--None--'));     
			   for( Schema.PicklistEntry f : ple) {
			      lstProductFamily.add(new SelectOption(f.getLabel(), f.getValue()));
			   }
		 }
	 	return lstProductFamily;
	}
	
	// Create a SelectOption list Product & PriceBookEntry fields for a select list
	// Uses a method in the Criteria Class to build the select lists for the two objects
	private void BuildSearchFieldsList() {
	
		if (cacheFieldSelectValues.size() == 0) {
		
			// Create the Schema Lists for the Product & PriceBookEntry objects
			//Schema.DescribeSObjectResult pricebookentryDescribe = Price_Book_Entry__c.sObjectType.getDescribe();
			Schema.DescribeSObjectResult productDescribe = Product2.sObjectType.getDescribe();
			            
            // Create the Maps of Fields for the Product & PriceBookEntry objects
            Map<String, Schema.SObjectField> pricebookEntryFields = Schema.SObjectType.PricebookEntry.fields.getMap();
            Map<String, Schema.SObjectField> productFields = Schema.SObjectType.Product2.fields.getMap();
            
            searchCriteria critClass = new searchCriteria();
            
            // Return SelectOption lists for the Product & PriceBookEntry objects            
            list<SelectOption> sel1 = critClass.GetFieldsForObject(productFields, '', 'product2.');
            
            // Combine the two returned SelectOption[] lists into a single list
            list<SelectOption> options = new list<SelectOption>();
            options.add(new selectOption('--None--','--None--'));
            
            options.add(new selectOption('Product','Product',true));
            
            for (Selectoption selOpt : sel1) {
                options.add(selOpt);
            }
						
			// Set the cached value so we only do this once per instance
			cacheFieldSelectValues = options;
		}
	}
	
	public void doSearch() {
		system.debug('\n ### mode in doSearch ' + mode);
		if (mode == 'po') {
			queryPOProducts();
		}
	}
	
	private void queryPOProducts() {
		
		bShowError = false;
		sortExp = 'ProductName';
		sortDirection = 'asc';
		
		// Build the base SOQL String, querying the standard Product fields WHERE the price book matches the Purchase_Order__c pricebook value
		//soql = 'SELECT ' + getProductFields() +
		soql = 'SELECT id, name, ProductCode, Description, Family ' +
			' FROM Product2 pb WHERE IsActive=true and IsDeleted=false';

		buildProductFamily();
		buildSearchKeyWord();
		buildSearchCriteria();
				
		//string sortFullExp = sortExpression  + ' ' + sortDirection;
		string sortFullExp =   + 'Name ' + sortDirection;
		soql += ' ORDER BY ' + sortFullExp + ' limit ' + queryRowLimit;		
		
		system.debug('\n ### soql  ' + DebugMode + ' ' + soql);
		
		// Debug: Display the SOQL Query string
		//if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, soql));		
		
		querySQL();
	}

/*	
	private String getProductFields() {
		
		// Define the private vars of the Map and Set of Product Fields so we only do the describe one time		
		if (productFieldMap == null) productFieldMap = Schema.SObjectType.Product2.fields.getMap();
		
		Set <String> productFlds = productFieldMap.keySet();
		string productFieldsList = ''; 
		for (string f : productFlds) {
			string fldType = ('' + productFieldMap.get(f).getDescribe().getType()).replace('Schema.DisplayType.', '') ;
			if (fldType <> 'REFERENCE' && f <> 'IsDeleted' && f <> 'SystemModstamp') {
				if (productFieldsList <> '') productFieldsList += ', ';
				productFieldsList += f;
			}
		}
		
		return productFieldsList;
	}
*/	
	
	private void buildProductFamily() {
		
		system.debug('\n ### PRoduct family ' + strProductFamily);
		if(strProductFamily != null && strProductFamily != '--None--') {
			if (mode == 'po') {
				soql+= ' and Family  = \'' + strProductFamily + '\' ';
			}
		}
		system.debug('\n ### soql ' + soql);
	}
	
	private void buildSearchKeyWord() {

		system.debug('\n ### SearchKeyWord::-------------> ' + SearchKeyWord);
		if (SearchKeyWord != null && SearchKeyWord != '') {
			if (SearchKeyWord.length() < 2) {
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Search string must be of 2 or more characters.'));
				return;
			}
			list<list<SObject>> searchList = [find :SearchKeyWord in all 
								fields returning Product2 (id,name) limit 200];
			system.debug('\n ### searchList ' + searchList);
									
			products = ((list<Product2>)searchList[0]);
			system.debug('\n ### search keyword products ' + products);

			//if (!products.isEmpty()) {
				soql += ' and Product2 in (';
				
				for (Product2 p : products) {
					soql += '\'' + p.id + '\',';
				}
				
				if (products.isEmpty()) 
					soql += '\'\'';
				else
					soql = soql.substring(0, soql.length()-1);
						
				soql += ')';
			//}
		}
		system.debug('\n ### soql ' + soql);
	}	
	
	private void buildSearchCriteria() {
		
		for (searchCriteria cl : criteriaLine) {
			if (cl.SearchField != 'none' && cl.SearchField != '--None--' && cl.SearchField != '') {
				system.debug('\n ### criteriaLine ' + cl);
				soql += cl.buildWhereClause(DebugMode);
			}
		}
		system.debug('\n ### soql ' + soql);
	}
		
	private void querySQL() {
		
		// Run the database query and place results into the searchObject class 
		try {
			system.debug('searchResults.size()-------------->' + searchResults.size());
			searchResults.clear();
			
			system.debug('\n ### soql ' + soql);

/*			
			if (mode == 'po') {
				list<Price_Book_Entry__c> results = Database.Query(soql);
				for (Price_Book_Entry__c pbe : results) {
					searchResults.add( new searchObject(pbe));
				}
				system.debug('\n ### Results.size ' + results.size() + ' => ' + results);
				// If zero or more than 1000 records returned, display a message
				if (results.size() == Integer.valueOf(queryRowLimit)) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only the first ' + queryRowLimit + ' products are displayed. Please use Search feature to filter Products.'));
								
			} else if (mode == 'p') {
				list<Product2> results = Database.Query(soql);
				for (Product2 p : results) {
					searchResults.add( new searchObject(p));
				}				
			}
*/						
			list<SObject> results = Database.Query(soql);
			for (SObject so : results) {
				searchResults.add( new searchObject(so, mode));
			}
			system.debug('\n ### Results.size ' + results.size() + ' => ' + results);
			// If zero or more than 1000 records returned, display a message
			if (results.size() == Integer.valueOf(queryRowLimit)) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Only the first ' + queryRowLimit + ' products are displayed. Please use Search feature to filter Products.'));			
									
			// we used sortProducts function here because the list sort is working bit different than database query sort. (sample products service bundle and SLA: Bronze (VAT)) 
			//sortedResults = searchResults;
			sortedResults = sortProducts(sortExpression, sortDirection, searchResults); 
			
			system.debug('\n ### After add searchResults.size() ' + searchResults.size() + ' => ' + searchResults);			
			ResetPaging();
			
			getSearchResultsByPaging(1);
			
		} catch (Exception ex) {
				system.debug('\n ### Error:  ---> ' + ex.getMessage());
			if (searchResults.size() != 0)
				ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Query Error: ' + ex.getMessage()));
		}
		
		if (searchResults.size() == 0) {
			ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO , 'No records were found based on your search criteria.'));
		   // return null;
		}
	}
	
	/* Start Paging Functions & Variables */

		public void changePagesize()
		{
			ResetPaging();
			getSearchResultsByPaging(1);
		}
		
		public PageReference ResetPaging()
		{
			PageNumber = 0;
			totalPageNumber = 0; 
			PageSize = getPageSize();
			renderTable = false;
			renderNoRecords = true;
			return null;
		}
		public Integer getPageNumber()
		{
			return PageNumber;
		}		
		public Integer getPageStartIndex()
		{
			return ((PageNumber * PageSize) - PageSize + 1);
		}		
		public Integer getPageStopIndex()
		{
			if ((PageNumber * PageSize)<searchResults.size())
				return (PageNumber * PageSize);
			else
				return searchResults.size();			
		}			  
		public PageReference NextBtnClick() 
		{	  
			if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' Next Bnt click PageNumber ' + PageNumber ));					   
			getSearchResultsByPaging(PageNumber + 1);
			return null;
		}
		public PageReference PreviousBtnClick() 
		{		
			if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' Next Bnt click PageNumber ' + PageNumber ));
			getSearchResultsByPaging(PageNumber - 1);		
			return null;
		}
		public Integer getPageSize()
		{
			if (PageSize == 0)
				PageSize = 25;
			return PageSize;
		}	   
		public void setPageSize(Integer pz)
		{
			this.PageSize = pz;
		}
				
		public Boolean getPreviousButtonEnabled()
		{
			return !(PageNumber > 1);
		}
		public Boolean getNextButtonDisabled()
		{
			if (searchResults == null) 
				return true;	
			else
				return ((PageNumber * PageSize) >= searchResults.size());
		}
		public Integer getTotalPageNumber()
		{
			system.debug( 'totalPageNumber---------->' + totalPageNumber );
			if (totalPageNumber == 0 && searchResults !=null)
			{
				totalPageNumber = searchResults.size() / getPageSize();
				Integer mod = searchResults.size() - (totalPageNumber * getPageSize());
				if (mod > 0)
					totalPageNumber++;
			}
			return totalPageNumber;
		}

/*
		public list<searchObject> getselectedResults() {
			return selectedResults;
		}

		public Integer getSelectedResultsCount() {
			if (selectedResults == null) return 0;
			return selectedResults.size();
		}
*/		
		
		// Return searchResults to the DATAGRID
		public list<searchObject> getSearchResults() {
			system.debug('In search Result--------------->');
			system.debug('searchResults_CurrentPage :: ' + searchResults_CurrentPage);
			return searchResults_CurrentPage;
				//return this.searchResults;
		}   
		
		public integer getSearchResultsCurrentPageSize() {
			if (searchResults_CurrentPage != null) {
				return searchResults_CurrentPage.size();
			} else {return 0;}
		}		

		public Integer currentPageSelectedCount {get; set;}
		public list<searchObject> getSearchResultsByPaging(Integer newPageIndex)
		{		  
			//if (DebugMode) ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.INFO, ' in getSearchResultsByPaging  searchResults.size() ' + searchResults.size() ));
			
			list<searchObject> tmpSearchResults;
				
			tmpSearchResults = sortedResults;
									
			searchResults_CurrentPage = new list<searchObject>();   
			system.debug('searchResults inPaging---------->' + tmpSearchResults);  
			if(tmpSearchResults != null && tmpSearchResults.size() > 0)
			{		   
				Transient Integer counter = 0;
				Transient Integer min = 0;
				Transient Integer max = 0;
				Integer PNum;
				Integer PSize;
				totalPageNumber = 0;
				PNum = PageNumber;
				PSize = PageSize;
				system.debug('PNum ::----->' + PNum + '   PSize -------> ' + PSize);
				if (newPageIndex >= PNum)
				{
					min = PNum * PSize;
					max = newPageIndex * PSize;
				}
				else
				{
					max = ( PNum -1 ) * PSize;
					min = max - PSize;				
				}
				system.debug('max ::----->' + max + '  min -------> ' + min);
				currentPageSelectedCount = 0;
				for(searchObject c : tmpSearchResults)
				{
					if (counter >= min && counter <= max-1)
					{					
						searchResults_CurrentPage.add(c);
						if (c.selected == true ) {							
							currentPageSelectedCount = currentPageSelectedCount + 1;
						}						
					}  
					counter++;		 
				}
				PageNumber = newPageIndex;
				if (searchResults_CurrentPage == null || searchResults_CurrentPage.size() <= 0)
				{
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
				}
			}
			else
			{
				if (searchResults_CurrentPage == null || searchResults_CurrentPage.size() <= 0)
				{
					//ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,'Data not available for this view.'));
				}
			}
			if(searchResults_CurrentPage.size() > 0)
			{
				renderTable = true;
				renderNoRecords = false;			
			}
			else
			{
				//searchResults_CurrentPage = new list<searchObject>();
				renderTable = false;
				renderNoRecords = true; 
			}
			
			//sorter.originalList = searchResults_CurrentPage;
			//assignSorterKeys();
			return searchResults_CurrentPage;		
		}	
		
	/* Start Pageblock Sorting methods */					
	public String sortExpression {
		get { return sortExp; }
		set {
			//if the column is clicked on then switch between Ascending and Descending modes	   
			if (value == sortExp)
				sortDirection = (sortDirection == 'asc')? 'desc' : 'asc';	   
			else
				sortDirection = 'asc';	   
			sortExp = value;
		   }
	}
		   
	public String getSortDirection() {	
		//if not column is selected
		if (sortExpression == null || sortExpression == '')	  
			return 'asc';
		else
			return sortDirection; 
	}
	 
	public void setSortDirection(String value) {	 
		sortDirection = value;
	}
		
	public void ResetSearchOperator() {
		for (searchCriteria cl : criteriaLine) {
				if (cl.SearchField != 'none' && cl.SearchField != '--None--' && cl.SearchField != '') {
					//system.debug('\n ### criteriaLine ' + cl);						
					cl.ResetSearchOperator();
				}
		}			
	}
	
	public integer getsearchResultsSize() {		
		return searchResults.size();		
	}		
	
	public pagereference processSelected() {
		selectedIds = '';
		
		// move the logic to javascript
		if (searchResults != null) {
			
			for(searchObject cProd : searchResults) {
				if(cProd.selected == true) {
					if (selectedIds != '') selectedIds += ',';
					if (mode == 'po') {
						//selectedIds += cProd.pricebookEntry.Product2;
						selectedIds += cProd.prod.Id;
					}
				}
			}
		}
		 
		//return error message if no Product is selected
		system.debug('\n ### selectedIds ' + selectedIds);
		if (selectedIds == '') {
			bShowError = true;
		} else {
			bShowError = false;
			system.debug('\n ### selectedIds in component ' + selectedIds);			
		}
		
		return null;
	}
	
	public pagereference cancel() {
		Pagereference p = new Pagereference ('/' + cid);	 
		return p;
	}
	
	public string getShowBlockIfResults() {
		if (this.searchResults.size() > 0) {
			return 'display: block;' ;
		} else {
			return 'display: none;' ;
		}
	}
	
	// Used in test method only.
	public void selectAllResults() {
		for(searchObject searchObj : searchResults) {
			system.debug('\n ### Product Name: ' + searchObj.POProduct.Product__c);															   
			searchObj.selected = true;
		}
	}
		
	/* sort searchObject - Make the logic more generic and move it to sortHelper */
	public static list<searchObject> sortProducts(String sortExpression, String sortDirection, list<searchObject> searchResult) {
		String tmpKey;		
		list<String> searchKey = new list<String>();		
		map<String, list<searchObject>> searchKeyMap = new map<String, list<searchObject>>();
				
		list<Double> searchKeyNum = new list<Double>();
												
		for (searchObject so : searchResult){			
			if (sortExpression=='ProductName'){
				//tmpKey = so.pricebookEntry.Item__r.Name;
				tmpKey = so.Prod.Name;
			} else if (sortExpression=='ProductCode'){
				tmpKey = so.Prod.ProductCode;
			} else if (sortExpression=='Description'){
	   		tmpKey = so.Prod.Description;
			} else if (sortExpression=='Family'){
				tmpKey = so.Prod.Family;
			} else if (sortExpression=='ListPrice'){
				//tmpKey = so.pricebookEntry.List_Price__c.format();
			}
				
			if (sortExpression=='ListPrice______'){
				//searchKeyNum.add(so.pricebookEntry.List_Price__c);	
			}
			else{
				searchKey.add(tmpKey);
			}
			
			if (!searchKeyMap.containsKey(tmpKey))
				searchKeyMap.put(tmpKey, new list<searchObject>());
			
			searchKeyMap.get(tmpKey).add(so);				
			
		}
		
							   
		list<searchObject> sortedSearchResult = new list<searchObject>();
		if (sortExpression=='Sales_Price__c'){
			
			// Sort the List in ascending po.			
			searchKeyNum.sort();
			
			for (Double d : searchKeyNum){
								
				String s = d.format();				
				sortedSearchResult.add(searchKeyMap.get(s).get(0));
				searchKeyMap.get(s).remove(0);
				// Optionally we can remove the item from the Map.
				if (searchKeyMap.get(s).size() == 0){
					searchKeyMap.remove(s);
				}
			}			
			
		} else {
			
			// Sort the List in ascending po.
			searchKey.sort();
			
			for (String s : searchKey){
				sortedSearchResult.add(searchKeyMap.get(s).get(0));
				searchKeyMap.get(s).remove(0);
				// Optionally we can remove the item from the Map.
				if (searchKeyMap.get(s).size() == 0){
					searchKeyMap.remove(s);
				}
				continue;			
			}			
		}
		
		// Implement Desc Logic except for Service field.
		if (sortDirection != 'asc'){
			list<searchObject> sortedSearchResultDesc = new list<searchObject>();

			for(Integer i=sortedSearchResult.size()-1; i>=0; i--){
				sortedSearchResultDesc.add(sortedSearchResult[i]);
			}
			
			return sortedSearchResultDesc;
		}
		
		return sortedSearchResult;
	}
}