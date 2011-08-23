global class EditPremiumBenefit {    
    Public String BenefitId{get;set;}
    Public String GivingId{get;set;}//OpportunityId
    Public List<Opportunity> lstGiving{get;set;}
    Public List<PremiumBenefit> lstBenefit{get;set;}   
    Public String selectedAddress{get;set;}
    Public String mode{get;set;}
    Void PageLoad(){
        system.debug('**** Function : PageLoad');
        String addTo = GivingId = ApexPages.currentPage().getParameters().get('addTo');
        if(addTo != null && addTo.trim().length()>0){//Add benifit mode 
            mode = 'new';
            addBenifitMode();
        }else{//edit and edit all mode
            editBenifitMode();
        }
        
    }
    void addBenifitMode(){
        system.debug('**** Function : addBenefitMode');
        objGiving = new Opportunity();
        GivingId = ApexPages.currentPage().getParameters().get('GivingId');
        LoadGiving(GivingId);
        if(objGiving != null){
            lstGiving = new List<Opportunity>();
            lstGiving.add(objGiving);
        }
        system.debug('###Giving Id: ' + GivingId);
        system.debug('###Object : ' + objGiving);
        
        getPricebookId(objGiving.Station__c);
        searchProduct();
    }
    void editBenifitMode(){
        system.debug('**** Function : editBenefitMode');
        system.debug('######Giving id: ' + GivingId);
        system.debug('######Mode : ' + mode);
        if(mode != 'new')
            GivingId = ApexPages.currentPage().getParameters().get('GivingId');
        lstBenefit = new List<PremiumBenefit>();
        if(GivingId != null){
            String strMode = ApexPages.currentPage().getParameters().get('new');
            if(strMode != null && strMode == '1'){
                mode = 'new';
                getOpportunity(GivingId);
                getProduct();
            }
            strMode = ApexPages.currentPage().getParameters().get('editall');
            if(strMode != null && strMode == '1'){
                mode = 'editall';
                getOpportunity(GivingId);
                LoadProduct();
            }
        }
        else{
            mode = 'edit';
            BenefitId = ApexPages.currentPage().getParameters().get('id');
            getGiving();
            LoadSingleProduct();
        }
        system.debug('#### mode : ' + mode);
        system.debug('#### Product list : ' + lstBenefit);
    }
    Void getOpportunity(string oppId){
        system.debug('**** Function : getOpportunity');
        if(oppId != null && oppId.Trim().Length()>0){
            lstGiving = new List<Opportunity>();
            lstGiving = [Select Id, Name, AccountId, Gift_Type__c, Station__c, Product__c, Oppty_Related_Contact__c, Campaign_Name__c, Account.Preferred_Address__c From Opportunity Where Id =: GivingId];
        }
    }
    Void getGiving(){
        system.debug('**** Function : getGiving');
        if(BenefitId != null){
            List<OpportunityLineItem> lst = [Select OpportunityId From OpportunityLineItem Where Id =: BenefitId];
            if(lst != null && lst.size()>0){
                GivingId = lst[0].OpportunityId;
            }
            if(GivingId != null && GivingId.Trim().Length()>0){
                getOpportunity(GivingId);
            }
        }
    } 
    Public void LoadSingleProduct(){
        system.debug('**** Function : LoadSingleProduct');
        try{
            List<OpportunityLineItem> lstProduct = new List<OpportunityLineItem>();
            lstProduct = [Select Id, PricebookEntry.ProductCode, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, OpportunityId, PricebookEntryId, Street__c, Shipping_Method__c,
            State__c, Postal_Code__c, Name__c, Country__c, Quantity, Description, UnitPrice, TotalPrice, City__c, Fulfillment_Status__c, Committed_Number__c
            From OpportunityLineItem Where Id =: BenefitId];
            setProduct(lstProduct);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    String NVL(String val){
        if(val == null)
            return '';
        else
            return val; 
    }
    Public void setProduct(List<OpportunityLineItem> lstProduct){
        system.debug('**** Function : setProduct');
        Set<ID> accIds = new Set<ID>();
        if(lstGiving != null && lstGiving.size()>0)
            for(Opportunity opp:lstGiving){
                accIds.add(opp.AccountId);
            }
        List<Address__c> lstAddress = [Select Id, City__c, State__c, Street_1__c, Postal_Code__c, 
        Country__c, Name From Address__c 
        Where Account_Household__c in: accIds and Account_Household__c != null];
        if(lstProduct != null && lstProduct.Size()>0){
        boolean otherAddress = true;
            for(OpportunityLineItem o:lstProduct){
                otherAddress = true;
                PremiumBenefit benefit = new PremiumBenefit();
                benefit.ProductCode = o.PricebookEntry.ProductCode;
                benefit.ProductName = o.PricebookEntry.Product2.Name;
                benefit.PricebookEntryId = o.PricebookEntryId;
                benefit.Product2Id = o.PricebookEntry.Product2Id;
                system.debug('############## LineItem Id : ' + o.Id);
                benefit.Id = o.Id;
                benefit.Name = NVL(o.Name__c);
                benefit.Street = NVL(o.Street__c);
                benefit.City = NVL(o.City__c);
                benefit.State = NVL(o.State__c);
                benefit.Zip = NVL(o.Postal_Code__c);
                benefit.Country = NVL(o.Country__c);
                benefit.Quantity = Integer.valueOf(o.Quantity);
                benefit.Description = NVL(o.Description);
                benefit.UnitPrice = o.UnitPrice;
                benefit.TotalPrice = o.TotalPrice;
                benefit.CommittedNo = o.Committed_Number__c;
                benefit.ShippingMethod = NVL(o.Shipping_Method__c);
                benefit.FullFillmentStatus = NVL(o.Fulfillment_Status__c);
                system.debug('###Address size : ' + lstAddress.size());
                if(lstAddress != null && lstAddress.size()>0){
                    for(Address__c add:lstAddress){
                        if((add.Street_1__c != null && add.Street_1__c.trim().toUpperCase() == benefit.Street.trim().toUpperCase()) &&
                           (add.City__c != null && add.City__c.trim().toUpperCase() == benefit.City.trim().toUpperCase()) &&
                           (add.State__c != null && add.State__c.trim().toUpperCase() == benefit.State.trim().toUpperCase()) &&
                           (add.Postal_Code__c != null && add.Postal_Code__c.trim().toUpperCase() == benefit.Zip.trim().toUpperCase()) &&
                           (add.Country__c != null && add.Country__c.trim().toUpperCase() == benefit.Country.trim().toUpperCase())){
                           
                           benefit.AddressId = add.Id;
                           otherAddress = false;
                           
                        }
                            
                    }
                }
                system.debug('###################   City  : ' + o.City__c);
                benefit.blnOtherAddress = otherAddress;
                if(otherAddress==true)
                    benefit.AddressId = 'other';
                lstBenefit.add(benefit);
            }
        }
    }
    Public void LoadProduct(){
        system.debug('**** Function : LoadProduct');
        try{
            List<OpportunityLineItem> lstProduct = new List<OpportunityLineItem>();
            lstProduct = [Select Id, PricebookEntry.ProductCode, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, OpportunityId, PricebookEntryId, Street__c, Shipping_Method__c,
            State__c, Postal_Code__c, Name__c, Country__c, Quantity, Description, UnitPrice, TotalPrice, City__c, Fulfillment_Status__c, Committed_Number__c
            From OpportunityLineItem Where OpportunityId =: GivingId];
            setProduct(lstProduct);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }   
    String getPricebookId(String station){
        system.debug('**** Function : getPriceBookId');
        List<Pricebook2> lstPricebook;
        String pricebookId=null;
        if(station!=null){
            lstPricebook = [Select Id from Pricebook2 Where name like:station];
            if(lstPricebook.size()>0){
                //objPledges.Pricebook2Id = lstPricebook[0].Id;
                pricebookId = lstPricebook[0].Id;
            }
        }
        return pricebookId;
    }
    Public void getProduct(){
        system.debug('**** Function : getProduct');
        Opportunity objPledges = new Opportunity();
        if(lstGiving == null || lstGiving.size() <= 0){
            return;
        }
        objPledges = lstGiving[0];
        List<Member_Benefits_Control__c>lstMem  = [select Membership_Benefit_Package__c , Gift_Type__c
        from Member_Benefits_Control__c
        Where Station__c =: objPledges.Station__c
        and Product__c =: objPledges.Product__c];
        
        Set<ID> memIds = new Set<ID>();
        for(Member_Benefits_Control__c mbc:lstMem){
            if(mbc.Gift_Type__c!=null) {
                if(mbc.Gift_Type__c.contains(objPledges.Gift_Type__c)) {
                    memIds.add(mbc.Membership_Benefit_Package__c);
                }
            }
        }
        List<PricebookEntry> lstProduct = new List<PricebookEntry>();
        List<Package_Item__c> lstPackageItem = [Select Id,Item__r.ProductCode, Item__r.name, Item__r.Description from Package_Item__c Where Package__c IN:memIds];
        Set<ID> ProductIds = new Set<ID>();
        if(lstPackageItem.size()>0){
            for(Package_Item__c p:lstPackageItem){
                ProductIds.add(p.Item__c);
            }
            if(ProductIds.size()>0){
                lstProduct = [Select UnitPrice, ProductCode, Product2Id, 
                Pricebook2Id, Name, Id, Product2.Description, Product2.no_of_items__c
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: getPricebookId(objPledges.Station__c)
                and Product2Id in: ProductIds];
            }
        }
        
        lstBenefit = new List<PremiumBenefit>();
        Account objAcc = new Account();
        List<Address__c> lstAdd = new List<Address__c>();
        
        lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
        State__c, Country__c from Address__c 
        where account_household__c =: objPledges.accountId and account_household__c!=null];
        
        List<Account> lstPrefAddress = [select preferred_address__c from account where id =: objPledges.accountId];
        String PreferredAddress = '';
        if(lstPrefAddress.size()>0){
            PreferredAddress = lstPrefAddress[0].preferred_address__c;
        }
        List<Contact> lstContact = [Select name from Contact where id =: objPledges.Oppty_Related_Contact__c];
        String strName = '';
        if(lstContact.size()>0){
            strName = lstContact[0].name;        
        }        
        for(PricebookEntry it:lstProduct){
            PremiumBenefit o = new PremiumBenefit();
            o.Product2Id = it.Product2Id;
            o.ProductCode = it.ProductCode;//it.Item__r.ProductCode;
            o.ProductName = it.name;//it.Item__r.Name;
            o.Description = it.Product2.Description;//it.Item__r.Description;
            o.PricebookEntryId = it.id;//it.Item__r.Id;
            o.Quantity = 1;
            o.CommittedNo = it.Product2.no_of_items__c;
            o.UnitPrice = it.UnitPrice;
            o.TotalPrice = o.UnitPrice*o.Quantity;
            o.name = strName;
            o.AddressId = objPledges.Account.Preferred_Address__c;
            system.debug('@@@@@Preferred address: ' + objPledges.Account.Preferred_Address__c);
            system.debug('@@@@@household id: ' + objPledges.accountId);
            if(lstAdd.size()>0){
                for(Address__c a:lstAdd){
                    system.debug('@@@@@AddressId: ' + a.id);
                    if(a.id == PreferredAddress){
                        o.Street = a.Street_1__c;
                        o.City = a.City__c;
                        o.State = a.State__c;
                        o.Zip = a.Postal_Code__c;
                        o.Country = a.Country__c;
                        o.AddressId = a.id;
                    }
                }
            }           
            lstBenefit.add(o);
        }
    }               
    public boolean blnTest{get;set;}
    Public PageReference SelectAddress(){
        System.debug('Selected Address: ----> ' + selectedAddress);
        List<Address__c> lstAdd = new List<Address__c>();                
        Set<ID> lstAddId = new Set<ID>();     
        for(PremiumBenefit prod:lstBenefit){
            if(prod.AddressId.trim().toLowerCase() != 'other'){
                lstAddId.add(prod.AddressId);
            }
        }        
        lstAdd = [select id, Street_1__c, City__c, State__c, Postal_Code__c, 
        Country__c from Address__c where id IN: lstAddId];
        if(lstAdd != null && lstAdd.size()>0){
            for(Address__c add:lstAdd){
                for(PremiumBenefit prod:lstBenefit){
                    if(prod.AddressId.trim().toLowerCase() != 'other' && prod.AddressId == add.Id){
                        prod.blnOtherAddress = false;
                        prod.Street = add.Street_1__c;
                        prod.City = add.City__c;
                        prod.Zip = add.Postal_Code__c;
                        prod.Country = add.Country__c;
                        prod.State = add.State__c;
                    }
                }
            }
        }
        for(PremiumBenefit prod:lstBenefit){
            if(prod.AddressId.trim().toLowerCase() == 'other'){
                if(prod.blnOtherAddress == false){
                    prod.Street = '';
                    prod.City = '';
                    prod.Zip = '';
                    prod.Country = '';
                    prod.State = '';
                }
                prod.blnOtherAddress = true;
            }
        }  
        return null;
    }
    
    public List<SelectOption> getShippingMethod()
    {
        system.debug('**** Function : getShippingMethod');
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Shipping_Method__c.getDescribe();        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                       
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    Boolean blnPreferSelected = false;
    Public List<SelectOption> getShipToAddress(){
        system.debug('**** Function : getShipToAddress');
        List<SelectOption> shipAddress = new List<SelectOption>();
        List<Address__c> lstAdd = new List<Address__c>();
        
        string AccID = '';
        
        if(lstGiving!=null && lstGiving.size()>0) {
            AccID = lstGiving[0].AccountID;
        }
        
        lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
        State__c, Country__c from Address__c 
        where account_household__c =: AccID and account_household__c!=null];
        
        if(lstAdd.size()>0){
            for(Address__c a:lstAdd){
                shipAddress.add(new SelectOption(a.id,a.name));
                if(mode=='new' && blnPreferSelected == false && lstGiving[0].Account.Preferred_Address__c == a.id){
                    for(PremiumBenefit prod:lstBenefit){
                        prod.Street = a.Street_1__c;
                        prod.City = a.City__c;
                        prod.State = a.State__c;
                        prod.Zip = a.Postal_Code__c;
                        prod.Country = a.Country__c;
                        prod.AddressId = a.id;
                        blnPreferSelected = true;
                    }
                }
            }
        }
        shipAddress.add(new SelectOption('other','Other'));
        return shipAddress;
    }
    
    Public PageReference saveBenefit(){
        system.debug('**** Function : saveBenefit');
        List<OpportunityLineItem> lstLineItemInsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstLineItemUpdate = new List<OpportunityLineItem>();
        try{
            if(lstBenefit != null && lstBenefit.size()>0){
                List<OpportunityLineItem> lstLineItem = new List<OpportunityLineItem>();
                for(PremiumBenefit o:lstBenefit){
                    OpportunityLineItem item = new OpportunityLineItem();
                    if(o.Id != null){
                        item = [select id from OpportunityLineItem where Id =: o.Id];
                    }
                    item.Street__c = o.Street;
                    item.City__c = o.City;
                    item.State__c = o.State;
                    item.Postal_Code__c = o.Zip;
                    item.Country__c = o.Country;
                    item.Quantity = Decimal.valueOf(o.Quantity);
                    item.Description = o.Description;
                    item.UnitPrice = o.UnitPrice;
                    item.Name__c = o.Name;
                    item.Fulfillment_Status__c = o.FullFillmentStatus;
                    item.Committed_Number__c = o.CommittedNo;
                    //item.TotalPrice = o.TotalPrice;
                    item.Shipping_Method__c = o.ShippingMethod;
                    System.debug('########## Lineitem Id on Saving:     ' + o.id);
                    if(o.Id == null){
                        item.OpportunityId = GivingId;
                        item.PricebookEntryId = o.PricebookEntryId;
                        lstLineItemInsert.add(item);
                    }
                    if(o.Id != null){
                        lstLineItemUpdate.add(item);
                    }
                }
                if(lstLineItemInsert.size()>0){
                    insert lstLineItemInsert;
                }
                if(lstLineItemUpdate.size()>0){
                    update lstLineItemUpdate;
                }
            }
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
    
        return Redirect(GivingId);
    }
    
    Public PageReference Cancel(){
        return Redirect(GivingId);
    }
    
    Public PageReference Redirect(String Url){
        PageReference P;
        P = new PageReference ('/' + Url);
        P.SetRedirect(true);
        return P;
    }
    
    public List<SelectOption> getStatus()
    {
        system.debug('**** Function : getShippingMethod');
        List<SelectOption> options = new List<SelectOption>();        
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Fulfillment_Status__c.getDescribe();        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();                       
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    Public Class PremiumBenefit{
        Public ID id{get;set;}
        Public ID Product2Id{get;set;}
        Public String ProductCode{get;set;}
        Public String ProductName{get;set;}
        Public String Description{get;set;}
        Public Integer Quantity{get;set;}
        Public String Name{get;set;}
        Public String Street{get;set;}
        Public String City{get;set;}
        Public String State{get;set;}
        Public String Zip{get;set;}
        Public String Country{get;set;}
        Public String ShippingMethod{get;set;}
        Public String PricebookEntryId{get;set;}
        Public Double UnitPrice{get;set;}
        Public Double TotalPrice{get;set;}
        Public String AddressId{get;set;}
        Public Boolean blnOtherAddress{get;set;}
        Public Decimal CommittedNo{get;set;}
        Public String FullFillmentStatus{get;set;}
        Public String PackageName{get;set;}
        Public Boolean IsBenefit{get;set;}
    }
    Public PageReference selectStatus(){
        return null;
    }
    Public EditPremiumBenefit(ApexPages.StandardController controller) {
        system.debug('**** Function : EditPremiumBenefit(ApexPages.StandardController controller)');
        PageLoad();
    }
    
    Public EditPremiumBenefit() {
        system.debug('**** Function : EditPremiumBenefit()');
        PageLoad();
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////ADD BENEFIT/////////////////////////////////////
    Public Opportunity objGiving;
    Public String PricebookId{get;set;}    
    

    private List<String> noMatch;
    private List<PricebookEntry> results;
    private List<PricebookEntry> smallresults;
    private String name;
    public String index{get;set;}
    private String value;
    public string getValue(){
        return this.value;
    }  
    private String typeOf;
    
    private String DistributorID='';
    private String MfgAccID='';
    private String EndCustomer='';
    public String pricebook{get;set;}  
    public void setName(String name){
        this.name = name;
    }
   
    public String getName(){
        return this.name;
    }
    
    public List<PricebookEntry> getSmallResults(){
        return this.smallresults;
    }
  
    public List<String> getNoMatch() {
        return this.noMatch;
    }
  
    public Boolean getShowResults() {
        if(lstResult.size() > 0)
            return true;
        else
            return false;
    }
    
    Public List<SearchResult> lstResult{get;set;}
    Map<ID,Boolean> mapEligibility = new Map<ID,Boolean>();
    Public Class SearchResult{
        Public Boolean selected{get;set;}
        Public Boolean eligible{get;set;}
        Public String PricebookEntryId{get;set;}
        Public String Product2Id{get;set;}
        Public String Name{get;set;}
        Public String ProductCode{get;set;}
        Public String Description{get;set;}
        Public Decimal UnitPrice{get;set;}
        Public Decimal ItemNo{get;set;}
        Public String RecordType{get;set;}
        Public String PackageName{get;set;}
        Public Boolean IsPackage{get;set;}
    }
    Public String selectedProducts{get;set;}
    public PageReference cancelAddProduct(){
        Return Cancel();
    }
    PageReference redirectPage(string url){
        PageReference P = new PageReference(url);
        P.setRedirect(true);
        return P;
    }    
    public Decimal GivingAmount{get;set;}
    void LoadGiving(String OppId){
        if(OppId != null){
            objGiving = [Select Id, Giving_Amount__c, Account.Preferred_Address__c, AccountId, Oppty_Related_Contact__c, Campaign_Name__c, Gift_Type__c, station__c, Product__c, Pricebook2Id, Gift_Kind__c, Payment_Method__c
            From Opportunity 
            Where Id =: OppId];
            
            if(objGiving != null){
                PricebookId = objGiving.Pricebook2Id;
                GivingAmount = objGiving.Giving_Amount__c;
            }else{
                GivingAmount = 0.0;
            }
        }
    }
    boolean checkEligibility(){
        boolean eligible = true;
        Set<ID> productIds = new Set<ID>();
        String strMessage = '';
        List<String> lstInEligibleBenefit = new List<String>();
        if(smallresults != null && smallresults.size() > 0 && objGiving != null){
            List<ID> lstID = selectedProducts.split('#');
            if(lstID != null && lstID.size()>0){
                for(ID pid:lstID){
                    productIds.add(pid);
                }
                lstInEligibleBenefit = commonApex.checkBenefitEligibility(objGiving,productIds);
                if(lstInEligibleBenefit != null && lstInEligibleBenefit.size()>0){
                    eligible = false;
                    strMessage = 'Following premium(s) are not Eligible.';
                    for(String str:lstInEligibleBenefit){
                        strMessage += '\n' + str;
                    }
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,strMessage));
                }
            } 
        }
        System.debug('######## Product Eligibility : ' + eligible);
        return eligible;
    }
    public PageReference addProduct(){
        try{
            if(mode=='new'){
                lstBenefit = new List<PremiumBenefit>();
            }else{
                if(lstBenefit == null)
                    lstBenefit = new List<PremiumBenefit>();
            }
            List<Account> lstPrefAddress = [select preferred_address__c from account where id =: objGiving.accountId];
            String PreferredAddress = '';
            if(lstPrefAddress.size()>0){
                PreferredAddress = lstPrefAddress[0].preferred_address__c;
            }
            List<Address__c> lstAdd = new List<Address__c>();
            lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
            State__c, Country__c from Address__c 
            where account_household__c =: objGiving.accountId and account_household__c!=null];
            
            List<Contact> lstContact = [Select name from Contact where id =: objGiving.Oppty_Related_Contact__c];
            String strName = '';
            if(lstContact.size()>0){
                strName = lstContact[0].name;        
            }
            Set<ID> packageIds = new Set<ID>();
            Map<ID, String> mapPackageName = new Map<ID, String>();
            if(lstResult != null && lstResult.size()>0){
                for(SearchResult result:lstResult){
                    if(result.selected == true){
                        PremiumBenefit o = new PremiumBenefit();
                        if(result.IsPackage == false){
                            o.Product2Id = result.Product2Id;
                            o.ProductCode = result.ProductCode;//it.Item__r.ProductCode;
                            o.ProductName = result.name;//it.Item__r.Name;
                            o.Description = result.Description;//it.Item__r.Description;
                            o.PricebookEntryId = result.PricebookEntryId;//it.Item__r.Id;
                            o.Quantity = 1;
                            o.UnitPrice = result.UnitPrice;
                            o.TotalPrice = o.UnitPrice*o.Quantity;
                            o.name = strName;
                            o.CommittedNo = result.ItemNo;
                            o.AddressId = objGiving.Account.Preferred_Address__c;
                            o.IsBenefit = false;
                            if(lstAdd.size()>0){
                                for(Address__c a:lstAdd){
                                    if(a.id == PreferredAddress){
                                        o.Street = a.Street_1__c;
                                        o.City = a.City__c;
                                        o.State = a.State__c;
                                        o.Zip = a.Postal_Code__c;
                                        o.Country = a.Country__c;
                                        o.AddressId = a.id;
                                    }
                                }
                            }    
                            else{
                                o.AddressId = 'other';
                                o.blnOtherAddress = true;
                            }         
                            lstBenefit.add(o);   
                        }else{
                            packageIds.add(result.Product2Id);
                            system.debug('######### This is a package : ' + result.PackageName);
                            //mapPackageName.put(result.Product2Id, result.PackageName);
                        }  
                    }
                }
                if(packageIds != null && packageIds.size()>0){
                
                
                
                    List<PriceBookEntry> lstItem = [ select id,  Product2ID,Name, ProductCode, Product2.Description, 
                    Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                    from PricebookEntry where Pricebook2Id =: PricebookId and IsActive = true 
                    and Product2ID in(Select Item__c from Package_Item__c Where Package__c In:packageIds)
                    order by Name limit 100];
                    
                    List<Package_Item__c> lstPackageName = [Select Package__r.Name, Item__c from Package_Item__c Where Package__c in:packageIds];
                    if(lstPackageName != null && lstPackageName.size()>0){
                        for(Package_Item__c p:lstPackageName){
                            mapPackageName.put(p.Item__c, p.Package__r.Name);
                        }
                    }                    
                    if(lstItem != null && lstItem.size()>0){
                        
                        //List<Package_Item__c> lstPackage = [Select Item__c, Package__r.Name From Package_Item__c where Package__c in:packageIds];
                        system.debug('######### lstItem : ' + lstItem);
                        system.debug('######### mapPackageName : ' + mapPackageName);
                        
                        for(PricebookEntry result2:lstItem){
                            PremiumBenefit o2 = new PremiumBenefit();
                            o2.Product2Id = result2.Product2Id;
                            o2.ProductCode = result2.ProductCode;
                            o2.ProductName = result2.Name;
                            o2.Description = result2.Product2.Description;
                            o2.PricebookEntryId = result2.Id;//it.Item__r.Id;
                            o2.Quantity = 1;
                            o2.UnitPrice = result2.UnitPrice;
                            o2.TotalPrice = o2.UnitPrice*o2.Quantity;
                            o2.name = strName;
                            o2.IsBenefit = false;
                            o2.CommittedNo = result2.Product2.no_of_items__c;
                            o2.AddressId = objGiving.Account.Preferred_Address__c;
                            
                            system.debug('########## mapPackageName : ' + mapPackageName);
                            system.debug('########## Pricebook id : ' + result2.id);
                            system.debug('########## product2 id: ' + result2.Product2.Id);
                            if(mapPackageName != null && mapPackageName.size()>0 && mapPackageName.containsKey(result2.Product2.Id)){
                                o2.PackageName = mapPackageName.get(result2.Product2.Id);
                            }
                            
                            if(lstAdd.size()>0){
                                for(Address__c a:lstAdd){
                                    if(a.id == PreferredAddress){
                                        o2.Street = a.Street_1__c;
                                        o2.City = a.City__c;
                                        o2.State = a.State__c;
                                        o2.Zip = a.Postal_Code__c;
                                        o2.Country = a.Country__c;
                                        o2.AddressId = a.id;
                                        o2.blnOtherAddress = false;
                                    }
                                }
                            }   
                            else{
                                o2.AddressId = 'other';
                                o2.blnOtherAddress = true;
                            }        
                            lstBenefit.add(o2);                                                                                                                  
                        }
                    }
                 }                
                
            }
            Return Page.EditPremiumBenefit;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }                    
    }

    public PageReference searchProduct() {
        smallresults = new List<PricebookEntry>();
        noMatch = new List<String>();
        noMatch.add('No Matches Found.');
        pricebook = PricebookId;
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<PricebookEntry>)[ select id,  Name, Product2ID,ProductCode, Product2.Description, UnitPrice, Product2.Id, Product2.RecordType.DeveloperName , Product2.no_of_items__c
                        from PricebookEntry where (Name like :sName or ProductCode like :sName or Product2.Description like :sName) 
                        and Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
        }else{
            results = (List<PricebookEntry>)[ select id,  Name, Product2ID,ProductCode, Product2.Description, UnitPrice, Product2.Id, Product2.RecordType.DeveloperName, Product2.no_of_items__c
                        from PricebookEntry where Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
        }             
        lstResult = new List<SearchResult>();
        getEligibility();
        system.debug('###############mapEligibility ' + mapEligibility);
        if(results != null && results.size()>0){
            for(PricebookEntry p:results){
                SearchResult res = new SearchResult();
                res.selected = false;
                if(mapEligibility != null && mapEligibility.size()>0 && mapEligibility.containsKey(p.Product2.Id)){
                    res.eligible = mapEligibility.get(p.Product2.Id);
                }
                else{
                    res.eligible = true;
                }
                res.PricebookEntryId = p.Id;
                res.Product2Id = p.Product2.Id;
                res.Name = p.Name;
                res.ProductCode = p.ProductCode;
                res.Description = p.Product2.Description;
                res.UnitPrice = p.UnitPrice;
                res.ItemNo = p.Product2.no_of_items__c;
                res.RecordType = p.Product2.RecordType.DeveloperName;
                res.PackageName = p.Name;
                if(res.RecordType == 'Package'){
                    res.IsPackage = true;
                    system.debug('######### Package Name: ' + p.name);
                }
                else{
                    res.IsPackage = false;
                    system.debug('######### Item Name: ' + p.name);
                }
                lstResult.add(res);
            }
        }
        return null;
    }
    void getEligibility(){
        boolean eligible = true;
        Set<ID> productIds = new Set<ID>();
        String strMessage = '';
        List<String> lstInEligibleBenefit = new List<String>();
        if(results != null && results.size() > 0 && objGiving != null){
            for(PricebookEntry p:results){
                productIds.add(p.Product2.Id);
                mapEligibility.put(p.Product2.Id,true);
            }
            lstInEligibleBenefit = commonApex.checkBenefitEligibility(objGiving,productIds);
            system.debug('#######lstInEligibleBenefit : ' + lstInEligibleBenefit);
            if(lstInEligibleBenefit != null && lstInEligibleBenefit.size()>0){
                for(String s:lstInEligibleBenefit){
                    if(mapEligibility != null && mapEligibility.size()>0){
                        if(mapEligibility.containsKey(ID.valueOf(s))){
                            mapEligibility.put(ID.valueOf(s),false);
                        }
                    }
                }
            } 
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    static testMethod void TestEditPremiumBenefit2() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cont = New Contact();
        cont.LastName = 'LastContact';
        Insert cont;
        
        Address__c adds = new Address__c();
        adds.City__c = 'NY';
        adds.State__c = 'AL';
        adds.Street_1__c = '444';
        adds.Postal_Code__c = '3321223';
        adds.Country__c = 'US';
        adds.Account_Household__c = a.Id ;
        
        Insert adds;
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        
        Product2 objProduct = new Product2();        
        objProduct.name = 'TestProduct';        
        objProduct.Family = 'Renewable Energy Inverters';        
        objProduct.ProductCode = 'TESTPRODUCT';        
        objProduct.Description = 'TestProduct';        
        Insert objProduct;
        
        
        Opportunity opp = New Opportunity();
        opp.AccountID = a.Id;
        opp.Name = 'Test';
        opp.gift_kind__c = 'One Payment';
        opp.CloseDate = system.Today().AddDays(15);
        opp.Gift_Date_Time__c = system.now();
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        opp.campaign_name__c = 'Annual';
        opp.station__c = 'WGBH';
        opp.Product__c = 'Cultivation';
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';
        opp.Oppty_Related_Contact__c = cont.Id;
        
        insert opp; 
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        Product2 prod = new Product2(Name = 'Anti-infectives 2007', Family = 'Best Practices',  IsActive = true);
        insert prod;
        
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true limit 1];

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        
        /*PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = prod.Id, UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;*/
        
        OpportunityLineItem oli = new OpportunityLineItem();
        oli.OpportunityId = opp.id;
        oli.Quantity = 4;
        oli.TotalPrice = 10000;
        oli.PricebookEntryId = pbe.Id;        
        //fill in necessary details to insert an opportunity line item
        insert oli;
        
        Member_Benefits_Control__c memBC = New Member_Benefits_Control__c();
        memBC.Gift_Type__c = 'New';
        memBC.Station__c = 'WGBH';
        memBC.Product__c = 'Cultivation';
        memBC.Membership_Benefit_Package__c = prod.Id;
        Insert memBC;
        
        Package_Item__c pkgItem = New Package_Item__c();
        memBC.Package__c = prod.Id;
        Insert pkgItem;
        
        
        
       // List<Package_Item__c> lstPackageItem = [Select Id,Item__r.ProductCode, Item__r.name, Item__r.Description from Package_Item__c Where Package__c IN:memIds];           
              
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        ApexPages.currentPage().getParameters().put('GivingId',opp.id);
        
        ApexPages.currentPage().getParameters().put('id',opp.id);
        
        EditPremiumBenefit clsTest = new EditPremiumBenefit(controller);
        ApexPages.currentPage().getParameters().put('editall','1');
        clsTest.SelectAddress();
        
        ApexPages.currentPage().getParameters().put('addTo',opp.id);
        clsTest.mode = 'new';
        
        clsTest.PageLoad();
        clsTest.editBenifitMode();
        clsTest.getGiving();
        clsTest.getShippingMethod();
        clsTest.getShipToAddress();
        clsTest.Cancel();
        clsTest.LoadSingleProduct();
        clsTest.searchProduct();
        clsTest.addProduct();
        clsTest.cancelAddProduct();
        clsTest.getShowResults();
        clsTest.getNoMatch();
        clsTest.getSmallResults();
        clsTest.getName();
        clsTest.saveBenefit();
        clsTest.SelectAddress();
        
        
        clsTest.getProduct();
        clsTest.LoadProduct();
        clsTest.addBenifitMode();
        clsTest.getPricebookId('WGBH');
        clsTest.getOpportunity(opp.id);
        clsTest.getValue();
        clsTest.setName('test');
        clsTest.redirectPage('/006/o');
        clsTest.getStatus();

        clsTest.selectStatus();        
                //clsTest.LoadGiving(a.Id);
        
        
    }    
}