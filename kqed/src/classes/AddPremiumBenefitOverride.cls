public class AddPremiumBenefitOverride {
    Public Opportunity objGiving;
    Public String GivingId{get;set;}
    Public String PricebookId{get;set;}
    Void PageLoad(){
        //objGiving = new Opportunity();
        //GivingId = ApexPages.currentPage().getParameters().get('id');
        //LoadGiving(GivingId);
    }
    
    Public PageReference goToSelectPage(){
    
        //https://c.cs3.visual.force.com/apex/AddPremiumBenefitOverride?addTo=006Q0000007utdW&
        //retURL=%2F006Q0000007utdW&sfdc.override=1&id=006Q0000007utdW
        GivingId = ApexPages.currentPage().getParameters().get('id');
        String addTo = ApexPages.currentPage().getParameters().get('addTo');
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        PageReference P = new PageReference('/apex/selectPremiumBenefitOverride?addTo=' + addTo + '&retURL=' + retURL + '&GivingId=' + GivingId);
        P.setRedirect(true);        
        Return P;
    }
    
    void LoadGiving(String OppId){
        if(OppId != null){
            objGiving = [Select Id, Campaign_Name__c, Gift_Type__c, station__c, Product__c, Pricebook2Id
            From Opportunity 
            Where Id =: OppId];
            
            if(objGiving != null)
                PricebookId = objGiving.Pricebook2Id;
        }
    }
    
    
    
    /////////////////////////////Add product/////////////////////////////////
    private List<String> noMatch;
    //private List<PricebookEntry> results;
    private List<PricebookEntry> results;
    //private List<PricebookEntry> smallresults;
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
    //-------------------Property Section ----------------------------//
  
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
        if(smallResults.size() > 0)
            return true;
        else
            return false;
    }
    
    Public String selectedProducts{get;set;}
    public PageReference cancelAddProduct(){
        //return GoToStep3();
        //Return Page.PledgesNewStep3;
        Return null;
    }
    PageReference redirectPage(string url){
        PageReference P = new PageReference(url);
        P.setRedirect(true);
        return P;
    }
    public PageReference addProduct(){
        //List<Member_Benefits_Control__c> lstBenefit = new List<Member_Benefits__c>();
        
        Member_Benefits_Control__c objBenefit = new Member_Benefits_Control__c();
        List<Package_Item__c> lstItems = new List<Package_Item__c>();
        if(selectedProducts != null && selectedProducts.trim().length()>0){
            List<ID> lstID = selectedProducts.split('#');
            objBenefit.Campaign_Name__c = objGiving.Campaign_Name__c;
            objBenefit.Gift_Type__c = objGiving.Gift_Type__c;
            objBenefit.Membership_Benefit_Package__c = lstID[0];
            objBenefit.station__c = objGiving.station__c;
            //objBenefit.Giving_Level_Segment_L2__c = objPledges.gift_type__c;
            //objBenefit.Product__c
            objBenefit.Product__c = objGiving.Product__c;
            try{
                insert objBenefit;
                if(objBenefit.id != null){
                    for(ID pId:lstID){
                        Package_Item__c item = new Package_Item__c();
                        item.Package__c = lstID[0];
                        item.Item__c = pId;
                        lstItems.add(item);
                    }
                    insert lstItems;                    
                }
                //Return Page.PledgesNewStep3;
                Return redirectPage('/apex/EditPremiumBenefit?new=1&GivingId=' + GivingId) ;
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            }
            return null;
        }
        else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select atleast one product.'));
            return null;
        }    
        return null;    
    }

    public PageReference searchProduct() {
        smallresults = new List<PricebookEntry>();
        system.debug('###################SearchProduct');
        noMatch = new List<String>();
        noMatch.add('No Matches Found.');
        pricebook = PricebookId;
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description
                        from PricebookEntry where (Name like :sName or ProductCode like :sName or Product2.Description like :sName) 
                        and Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
            smallresults = results; 
            
        }else{
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description
                        from PricebookEntry where Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
            smallresults = results; 
        }
        system.debug('################### records: ' + results.size());               
        return null;
    }
    
    
    
    public AddPremiumBenefitOverride(ApexPages.StandardController controller) {
        PageLoad();
    }
    public AddPremiumBenefitOverride() {
        PageLoad();
    }
    
/////////////TEST METHODS//////////////////////////
    static testMethod void myTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        
        Giving_Summary__c g = new Giving_Summary__c();
        g.Account__c = a.Id;
        insert g;
        
        
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
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';        
        
        
        insert opp;

        Product2 objProduct = new Product2();        
        objProduct.name = 'TestProduct';        
        objProduct.Family = 'Renewable Energy Inverters';        
        objProduct.ProductCode = 'TESTPRODUCT';        
        objProduct.Description = 'TestProduct';        
        Insert objProduct;
        
        Pricebook2 sPB = [Select ID from Pricebook2 where Name='Standard Price Book'];
        
        Pricebook2 objPB2 = new Pricebook2();        
        objPB2.name = 'Test';        
        Insert objPB2;                

        PriceBookEntry objPB1 = new PriceBookEntry();        
        objPB1.UnitPrice = 15;        
        //objPB.Name = 'Test Entry';        
        //objPB.ProductCode = 'TEST';        
        objPB1.Pricebook2Id = sPB.Id;        
        objPB1.Product2Id = objProduct.Id;        
        //objPB1.UseStandardPrice = true;        
        insert objPB1;
        
             
        /*PriceBookEntry objPB = new PriceBookEntry();        
        objPB.UnitPrice = 15;        
        //objPB.Name = 'Test Entry';        
        //objPB.ProductCode = 'TEST';        
        objPB.Pricebook2Id = objPB2.Id;        
        objPB.Product2Id = objProduct.Id;        
        objPB.UseStandardPrice = true;        
        insert objPB;*/
        
               
        ApexPages.CurrentPage().getParameters().put('id',opp.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        
        AddPremiumBenefitOverride clsTest = new AddPremiumBenefitOverride(controller);
        clsTest.GivingId = opp.id;
        AddPremiumBenefitOverride clsTest1 = new AddPremiumBenefitOverride();
        clsTest.LoadGiving(clsTest.GivingId);
        clsTest.searchProduct();
        clsTest.setName('test');
        clstest.getName();
        clsTest.getSmallResults();
        clsTest.getNoMatch();
        clsTest.getShowResults();
        clsTest.selectedProducts = objPB1.ID;
        try {
        clsTest.addProduct();
        }
        catch(Exception ex) {}
        clsTest.getValue();
        clsTest.cancelAddProduct();
        clsTest.goToSelectPage();
        

        clsTest.redirectPage('/' + clsTest.GivingId);
        
        

    }    
}