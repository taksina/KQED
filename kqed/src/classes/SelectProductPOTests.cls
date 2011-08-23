@isTest

private class SelectProductPOTests {
    static testMethod void testSelectAddProduct() {
        Map<String, String> urlParams = new Map<String, String> {
            'mode'  =>  'po',           
            'id' => TestUtil.PurchaseOrder.Id
        };

        PageReference ref = TestUtil.getPageReference('SelectProductPO', urlParams);
        System.assertNotEquals(null, ref);
        
        SelectProductController spConPriceBook = new SelectProductController();
        spConPriceBook.mode = 'p';
        spConPriceBook.init();
        spConPriceBook.doSearch();
        
        // setup a reference to the page the controller is expecting with the parameters
        system.debug('\n ### Test page reference ' + TestUtil.getPageReference('SelectProductPO', urlParams));
        Test.setCurrentPage(ref);

        // create the class with Std. controller
        SelectProductPOExt spOppExt = new SelectProductPOExt(new ApexPages.StandardController(TestUtil.PurchaseOrder));
        SelectProductController spCon = new SelectProductController();
        
        spOppExt.initAdd();
        
        spCon.cid = TestUtil.PurchaseOrder.Id;
        spCon.mode = 'o';
        spCon.init();
        spCon.doSearch();
        
        list<Purchase_Order_Product__c> a = TestUtil.PurchaseOrderProducts;     

        spCon.queryRowLimit = '10';
        spOppExt.initAdd();
        
        System.assertNotEquals(spCon.getProductFamilyOptions().size(), 0);

        // call debug methods
        spOppExt.getShowError();
        spCon.getShowError();
        spCon.getShowErrorMessage();
        spCon.getSetDebugModeTRUE();
        spCon.getSetDebugModeFALSE();       
        spCon.setSetDebugModeFALSE(false);
        spCon.setSetDebugModeTRUE(true);
        spCon.getSearchKeyWord();
        spCon.setSearchKeyWord('test');     

        spOppExt.getselectedResults();
        spOppExt.getselectedResultsCount();
        
        //spOppExt.criteriaLine[0].setSearchField('STRING/BillingName');
        //spOppExt.criteriaLine[0].setSearchOperator ('starts');
        system.debug('\n ### soql ' + spCon.soql);
        spCon.doSearch();
        spCon.ResetSearchOperator();        

        spCon.getsearchResultsSize();
        spCon.getsearchFields();
        spCon.getShowBlockIfResults();
        spCon.getsearchCriteria();              

        // Call paging methods          
        spCon.ResetPaging();
        spCon.getPageNumber();
        spCon.getSearchResults();
        spCon.getPageSize();
        spCon.getPreviousButtonEnabled();
        spCon.getNextButtonDisabled();
        spCon.getNextButtonDisabled();
        spCon.getTotalPageNumber();
        spCon.nextBtnClick();
        spCon.previousBtnClick();
        spCon.setPageSize(0);
        spCon.changePagesize();
        spCon.getPageStartIndex();
        spCon.getPageStopIndex();

        // Call Sorting methods
        spCon.sortExpression = 'ItemCode';
        String se = spCon.sortExpression;
        spCon.sortExpression = null;
        se = spCon.sortExpression;
            
        spCon.setSortDirection('ASC');
        spCon.getSortDirection();                       
                                
        spCon.sortExpression = 'ProductName';
        spCon.sortResults();
        
        spCon.sortExpression = 'ItemCode';          
        spCon.sortResults();
        
        spCon.sortExpression = 'Description';
        spCon.sortDirection = 'desc';
        spCon.sortResults();
        
        spCon.sortExpression = 'Family';
        spCon.sortDirection = 'desc';
        spCon.sortResults();
        
        spCon.sortExpression = 'ListPrice';
        spCon.sortDirection = 'desc';
        spCon.sortResults();
        spCon.sortExpression = 'ListPrice';
        spCon.getSortDirection();
        
        //Select and process all available Products
        spOppExt.selectedIds = TestUtil.Products[0].Id + ',' + TestUtil.Products[0].Id;
        spOppExt.processSelected();             
        spCon.selectAllResults();
        spOppExt.processSelected();

        // create the matching page reference
        PageReference redir = new PageReference('/'+TestUtil.PurchaseOrder.Id+'/e?retURL=%2F'+TestUtil.PurchaseOrder.Id);       

        PageReference refAction = spOppExt.AddMoreProduct();
        spOppExt.DeleteAllLines();
        refAction = spOppExt.cancel();
        
        spOppExt.cid = TestUtil.PurchaseOrder.Id;
        spOppExt.initAdd();

        spCon.getsearchResultsSize();
        spCon.getShowBlockIfResults();      
        spCon.setSearchKeyWord('s');
        spCon.doSearch();
        
        // Search for non existing products
        spCon.setSearchKeyWord('safdjkadfj');
        spCon.doSearch();
        spCon.getsearchResultsSize();
        
        spCon.strProductFamily = 'Sales'; 
        
        // Search for existing products. Get the Product name from the controller. 
        spCon.setSearchKeyWord('GenWatt');
                        
        spCon.criteriaLine[0].setSearchField('STRING/Name');
        spCon.criteriaLine[0].setSearchOperator('Starts');
        spCon.criteriaLine[0].setSearchValue('%');      
        
        spCon.doSearch();
        spCon.getsearchResultsSize();
        
        spCon.processSelected();
        spCon.getSearchResultsCurrentPageSize();
        
        spOppExt.strEditAll = 'editall';
        spOppExt.getMode();
        spOppExt.initEditAll();
    }

    static testMethod void testAddProductEdit() {
        Map<String, String> urlParams = new Map<String, String> {
            'mode'  =>  'editall'           
        };
        
        // Switch to test context
        Test.startTest();       

        PageReference ref = TestUtil.getPageReference('EditAllProduct', urlParams);
        System.assertNotEquals(null, ref);
        
        // setup a reference to the page the controller is expecting with the parameters
        system.debug('\n ### Test page reference ' + TestUtil.getPageReference('EditAllProduct', urlParams));
        Test.setCurrentPage(ref);

        // create the class with Std. controller
        SelectProductPOExt spOppExt = new SelectProductPOExt(new ApexPages.StandardController(TestUtil.PurchaseOrder));

        spOppExt.initEditAll();
        
        PageReference refAction = spOppExt.save();
        refAction = spOppExt.AddMoreProduct();              
        spOppExt.DeleteAllLines();
        spOppExt.Cancel();
        
        // Switch back to runtime context
        Test.stopTest();
    }
    
    static testMethod void testSearchObject() {
        // Switch to test context
        Test.startTest();
        
        searchObject so = new searchObject();
        so = new searchObject(TestUtil.Products[0]);
        so = new searchObject(TestUtil.Products[0], true);
        so = new searchObject(TestUtil.Products[0], TestUtil.PurchaseOrderProducts[0]);
        so = new searchObject(TestUtil.Products[0], 'po');
        so = new searchObject(TestUtil.Products[0], 'po', true);               
        
        // Switch back to runtime context
        Test.stopTest();
    }
                
    static testMethod void testSearchCriteria() {
        // Switch to test context
        Test.startTest();       
        
        // Create an instance of the searchCriteria to test all
        // get/set methods and the BuildWhereClause() method
        searchCriteria  critClass = new searchCriteria();
        
        // Call the various Get/Set methods to test these
        // nothing to check for, just want to run the code 
        system.debug(critClass.getInputDateFormat());
        critClass.getSearchField();
        critClass.getSearchOperator();
        critClass.getSearchValue();
        critClass.getLogical();
        critClass.getSearchValue();
        critClass.seterrMsg('');
        critClass.setLogical('AND');
        
        // Test all possible combinations of Fields and Operators
        list<SelectOption> operators = critClass.getOperatorSelectList();
        Set <String> fields = new Set<String>{'STRING/Field1', 'DATE/Field2', 'DATETIME/Field3', 
            'PICKLIST/Field4', 'MULTIPICKLIST/Field5', 'EMAIL/Field6', 'PHONE/Field7', 
            'DOUBLE/Field8', 'CURRENCY/Field9', 'BOOLEAN/Field10', 'TEXTAREA/Field11'}; 
        Set <String> values = new Set<String>{'abcde', 'abcd, efgh, ijkl', 'true', '100', 
            '12/31/2007', '12-21-2008', 'TODAY', 'NEXT 3 WEEKS'};
        
        // Three nested loops - Fields, Operators, Values
        // nothing to check for, just want to run the code
        // Can look through the Test results for Debug entries if neded 
        for (string f : fields) {
            critClass.setSearchField(f);
            for (SelectOption o : operators) {
                critClass.setSearchOperator (o.getValue());
                for (string v : values) {
                    critClass.setSearchValue (v);
                    System.debug(f + ' ' + o.getValue() + ' ' + v + ' :' + critClass.buildWhereClause(true) + ' - ' + critClass.geterrMsg());
                }
            }          
        }
        
        // Create a search criteria that must succeed
        // Get the error message values for each to confirm no errors on any criteria line
        critClass.setSearchField('STRING/ProductCode');
        critClass.setSearchOperator('eq');
        critClass.setSearchValue('%');
        System.Debug(critClass.buildWhereClause(true));
        System.assertEquals('', critClass.geterrMsg());

        // Create a search criteria that must succeed
        // Get the error message values for each to confirm no errors on any criteria line
        critClass.setSearchField('STRING/ProductCode');
        critClass.setSearchOperator('eq');
        critClass.setSearchValue('%');
        System.Debug(critClass.buildWhereClause(true));
        System.assertEquals('', critClass.geterrMsg());

        critClass.setSearchField('DATETIME/CreatedDate');
        critClass.setSearchOperator ('le');
        critClass.setSearchValue ('TODAY');
        System.Debug(critClass.buildWhereClause(true));         
        System.assertEquals('', critClass.geterrMsg());

        critClass.setSearchField('STRING/Description');
        critClass.setSearchOperator ('starts');
        critClass.setSearchValue ('%');
        System.Debug(critClass.buildWhereClause(true));         
        System.assertEquals('', critClass.geterrMsg());

        critClass.setSearchField('STRING/Owner.Alias');
        critClass.setSearchOperator ('eq');
        critClass.setSearchValue ('%');
        System.Debug(critClass.buildWhereClause(true));   
        System.assertEquals('', critClass.geterrMsg());                     
                        
        critClass.setLogical('AND');
        critClass.ResetSearchOperator();
        critClass.setSearchField('STRING/TestField');
        critClass.setSearchOperator('TestOperator');
        critClass.ResetSearchOperator();
        critClass.getSearchOperatorList();
        critClass.setSearchOperatorList((new list<SelectOption>()));
        critClass.seterrMsg('nothing');
        critClass.setStyle('');
        critClass.getStyle();
        critClass.getSearchField();
        critClass.getSearchValue();
        critClass.getLogical();
        critClass.geterrMsg();
        
        // Create the Maps of Fields for the Product & PriceBookEntry objects       
        Map<String, Schema.SObjectField> productFields = Schema.SObjectType.Product2.fields.getMap();
        
        // Return SelectOption lists for the Product & PriceBookEntry objects       
        list<SelectOption> sel2 = critClass.GetFieldsForObject(productFields, '', 'Product2.');
        
        // Switch back to runtime context
        Test.stopTest();        
    }
}