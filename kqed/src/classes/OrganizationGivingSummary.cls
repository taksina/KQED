public class OrganizationGivingSummary {

    String accountId='';
    public String currentURL{get;set;}
    Public List<Opportunity> lstOpp{get;set;}
    Public List<Giving_Summary__c> lstSummary{get;set;}
    Public String selectedStation{get;set;}
    Public List<Giving_Summary__c> lstAnnual{get;set;}
    Public List<Giving_Summary__c> lstInkind{get;set;}
    Public List<Giving_Summary__c> lstAuction{get;set;}
    //Fiscal Year
    Public List<Giving_Summary__c> lstCapital{get;set;}
    Public List<Giving_Summary__c> lstRestricted{get;set;}
    Public List<Giving_Summary__c> lstSales{get;set;}
    Public List<Giving_Summary__c> lstFoundation{get;set;}
    Public List<Giving_Summary__c> lstEvent{get;set;}
    Public List<Giving_Summary__c> lstMatching{get;set;}
    Public List<GivingSummary> lstGivingSummary;
    
    Public Decimal CumulativeTotalPledgeAmount{get;set;}
    Public Decimal CumulativeTotalPaidAmount{get;set;}
    
    Public Decimal CumulativeTotalPledgeAmountMain{get;set;}
    Public Decimal CumulativeTotalPaidAmountMain{get;set;}
    
    
    Public List<GivingSummary> lstGivingSummaryMain{get;set;}
    Public List<Giving_Summary__c> lstSummaryMain{get;set;}
    Public List<Giving_Summary__c> lstSummaryMember{get;set;}
    Public List<GivingSummary> lstGivingMember{get;set;}
    Public List<Giving_Summary__c> lstSummaryFiscal{get;set;}
    Public List<GivingSummary> lstGivingFiscal{get;set;}
    public String selectedMemYear{get;set;}
    public String selectedFiscalYear{get;set;}
    
    void pageLoad(){
        accountId = ApexPages.currentPage().getParameters().get('id');
        currentURL = ApexPages.currentPage().getHeaders().get('Host');
        getStations();
        getGivingSummaryFiscal();
        getGivingSummaryMain();
        getGivingSummaryMember();
    }
    Public PageReference SelectStation(){
        getGivingSummaryFiscal();   
        getGivingSummaryMember(); 
        return null;
    }
    
    Public PageReference refreshTable(){
        getGivingSummaryMain();
        return null;
    }
    Public PageReference selectFiscalYear(){
        getGivingSummaryFiscal();
        return null;
    }
    //////////////////////////////Main////////////////////////////////////////
    String defaultStation = '';
    public List<SelectOption> getStations()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Opportunity.Station__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        Integer i=0;
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
            if(i==0)defaultStation=f.getValue();
            i++;
        }       
        return options;
    }
    Public List<GivingSummary> getGivingSummaryMain(){
        if(selectedStation == null || selectedStation == '')
            selectedStation = defaultStation;
        lstSummaryMain = [Select Id, History__c,Summary_Count__c,OwnerId, IsDeleted, Name, RecordTypeId, RecordType.DeveloperName,
        RecordType.Name, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, Most_Recent_Giving_Amount__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c 
        From Giving_Summary__c a
        Where a.Account__c =: accountId and a.Station__c =: selectedStation];
        CumulativeTotalPledgeAmountMain = 0;
        CumulativeTotalPaidAmountMain = 0;
        lstGivingSummaryMain = new List<GivingSummary>();
        if(lstSummaryMain.size()>0){   
            for(Giving_Summary__c g:lstSummaryMain){
                if(g.History__c == false){
                    GivingSummary s = new GivingSummary();
                    s.Station = g.Station__c;
                    s.Summary = g.RecordType.Name;
                    s.GivingLevel = g.Giving_Level__c;
                    s.FirstGiftDate = g.first_date__c;
                    s.FirstGiftAmount = g.first_amt__c;
                    s.TotalPledgeAmount = g.total_amt__c;
                    s.TotalPaidAmount = g.total_pd__c;
                    s.MemberYearStatus = g.Member_Yr_Status__c;
                    s.ExpirationDate = g.expiration_date__c;
                    lstGivingSummaryMain.add(s);
                    if(g.total_amt__c != null)
                        CumulativeTotalPledgeAmountMain += g.total_amt__c;
                    if(g.total_pd__c != null)
                        CumulativeTotalPaidAmountMain += g.total_pd__c;
                 }
            }
        }
        return lstGivingSummaryMain;
    }
    //////////////////////////////Member////////////////////////////////////////
    Public String selectedMemberYear{get;set;}    
    Integer MemberYear;
    Public Boolean showExpireDate{get;set;}
    Public Boolean showInkindDate{get;set;}
    public string testMemberYear{get;set;}
    Integer displaySummaryNumber = 0;
    Public PageReference SelectMemberYear(){
        if(selectedMemberYear == null || selectedMemberYear == ''){
            MemberYear = System.Today().Year();
            displaySummaryNumber = 0;
        }
        else{
            displaySummaryNumber = Integer.valueOf(selectedMemberYear);
            MemberYear = System.Today().Year() - Integer.valueOf(selectedMemberYear);
        }
        testMemberYear = String.valueOf(MemberYear);
        if(MemberYear == System.Today().Year())
            showExpireDate = true;
        else
            showExpireDate = false;
        getGivingSummaryMember();
        return null;
    }    
    public List<SelectOption> getMemberYear() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('0','Current'));
        options.add(new SelectOption('1','Previous'));
        options.add(new SelectOption('2','Previous-1'));
        options.add(new SelectOption('3','Previous-2'));

        return options;
    }
    Public List<GivingSummary> getGivingSummaryMember(){
        if(selectedStation == null || selectedStation == '')
            selectedStation = defaultStation;
        if(selectedMemberYear == null || selectedMemberYear == ''){
            MemberYear = System.Today().Year();
            showExpireDate = true;
        }
        lstSummaryMember = new List<Giving_Summary__c>();
        lstSummaryMember = [Select Id,History__c,Summary_Count__c, OwnerId, IsDeleted, Name, RecordTypeId, RecordType.DeveloperName,
        RecordType.Name, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Most_Recent_Giving_Amount__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c
        From Giving_Summary__c a Where a.Account__c =: accountId and a.Station__c =: selectedStation];
        CumulativeTotalPledgeAmount = 0;
        CumulativeTotalPaidAmount = 0;
        
        lstGivingMember = new List<GivingSummary>();  
        if(lstSummaryMember.size()>0){  
            for(Giving_Summary__c g:lstSummaryMember){
                GivingSummary s = new GivingSummary();
                s.Station = selectedStation;
                s.Summary = g.RecordType.Name;
                s.FirstGiftDate = g.first_date__c;
                s.FirstGiftAmount = g.first_amt__c;
                s.TotalPledgeAmount = g.total_amt__c;
                s.TotalPaidAmount = g.total_pd__c;
                s.MemberYearStatus = g.Member_Yr_Status__c;
                s.ExpirationDate = g.expiration_date__c;
                lstGivingMember.add(s);
                if(g.total_amt__c != null)
                    CumulativeTotalPledgeAmount += g.total_amt__c;
                if(g.total_pd__c != null)
                    CumulativeTotalPaidAmount += g.total_pd__c;
            }
            populateSummaryMember();
        }
        else{
            populateSummaryMember();
            lstSummaryMember = new List<Giving_Summary__c>();
            Giving_Summary__c objSummary = new Giving_Summary__c();
            lstSummaryMember.add(objSummary);
        }
        return lstGivingSummary;
    }
    Public void populateSummaryMember(){
        lstInkind = new List<Giving_Summary__c>();
        showInkindDate = false;
        
        if(lstSummaryMember.size()>0){
            for(Giving_Summary__c g:lstSummaryMember){
                Integer SummaryCount=0;
                if(g.Summary_Count__c != null)
                    SummaryCount = Integer.valueOf(g.Summary_Count__c);
                if(g.Start_Date__c!=null) {
                    if(g.Start_Date__c.Year() == System.Today().Year()) {
                        showExpireDate = true;
                    }
                }
                //if(g.Start_Date__c.Year() == MemberYear){
                if(displaySummaryNumber == SummaryCount){
                    if(g.RecordType.DeveloperName == 'In_Kind_Gifts'){
                        lstInkind.add(g);
                        showInkindDate = true;
                    }
                }  
            }            
        }
        if(lstInkind.size()==0){
            Giving_Summary__c obj = new Giving_Summary__c();
            lstInkind.add(obj);
        }
    }
    
    
    Public List<GivingSummary> getGivingSummaryFiscal(){
        if(selectedStation == null || selectedStation == '')
            selectedStation = defaultStation;
        if(selectedFiscalYear == null || selectedFiscalYear == ''){
            Date dt = system.today();
            selectedFiscalYear = String.valueOf(dt.year());
        }
        lstSummaryFiscal = new List<Giving_Summary__c>();
        lstSummaryFiscal = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, RecordType.DeveloperName,
        RecordType.Name, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, Most_Recent_Giving_Amount__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c
        From Giving_Summary__c a Where a.Account__c =: accountId and a.Station__c =: selectedStation and a.Fiscal_Year__c =: selectedFiscalYear];
        CumulativeTotalPledgeAmount = 0;
        CumulativeTotalPaidAmount = 0;
        lstGivingFiscal = new List<GivingSummary>();  
        if(lstSummaryFiscal.size()>0){  
            for(Giving_Summary__c g:lstSummaryFiscal){
                GivingSummary s = new GivingSummary();
                s.Station = selectedStation;
                s.Summary = g.RecordType.Name;
                s.FirstGiftDate = g.first_date__c;
                s.FirstGiftAmount = g.first_amt__c;
                s.TotalPledgeAmount = g.total_amt__c;
                s.TotalPaidAmount = g.total_pd__c;
                s.MemberYearStatus = g.Member_Yr_Status__c;
                s.ExpirationDate = g.expiration_date__c;
                //Matching Gifts
                //In-Kind Gifts
                //Capital Campaign
                lstGivingFiscal.add(s);
                if(g.total_amt__c != null)
                    CumulativeTotalPledgeAmount += g.total_amt__c;
                if(g.total_pd__c != null)
                    CumulativeTotalPaidAmount += g.total_pd__c;
            }
            populateSummaryFiscal();
        }
        else{
            populateSummaryFiscal();
            lstSummaryFiscal = new List<Giving_Summary__c>();
            Giving_Summary__c objSummary = new Giving_Summary__c();
            lstSummaryFiscal.add(objSummary);
        }
        
        return lstGivingSummary;
    }
    Public PageReference saveExpirationDateHousehold(){
        List<Giving_Summary__c> objSummary = new List<Giving_Summary__c>();
        try{
            if(lstCapital.size()>0 && lstCapital[0].Id != null){
                objSummary.add(lstCapital[0]);
            }
            if(lstRestricted.size()>0 && lstRestricted[0].Id != null){
                objSummary.add(lstRestricted[0]);
            }
            if(lstSales.size()>0 && lstSales[0].Id != null){
                objSummary.add(lstSales[0]);
            }
            if(lstFoundation.size()>0 && lstFoundation[0].Id != null){
                objSummary.add(lstFoundation[0]);
            }
            if(lstEvent.size()>0 && lstEvent[0].Id != null){
                objSummary.add(lstEvent[0]);
            }
            if(lstMatching.size()>0 && lstMatching[0].Id != null){
                objSummary.add(lstMatching[0]);
            }
            if(lstInkind != null && lstInkind.size() >0 && lstInkind[0].Id != null){
                objSummary.add(lstInkind[0]);
            }
            
            if(objSummary != null && objSummary.size()>0){
                update objSummary;
            }
            PageReference P = new PageReference('/' + AccountId);
            P.setRedirect(true);
            return P;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
            return null;
        }
    }
    Public void populateSummaryFiscal(){
        lstCapital = new List<Giving_Summary__c>(); 
        lstRestricted = new List<Giving_Summary__c>();             
        lstSales = new List<Giving_Summary__c>(); 
        lstFoundation = new List<Giving_Summary__c>(); 
        lstEvent = new List<Giving_Summary__c>();
        lstMatching = new List<Giving_Summary__c>(); 
        
        if(lstSummaryFiscal.size()>0){
            for(Giving_Summary__c g:lstSummaryFiscal){
                
                //if(g.Campaign_type__c == 'Capital Campaign'){
                if(g.RecordType.DeveloperName == 'Capital'){
                    lstCapital.add(g);
                }
                //if(g.Campaign_type__c == 'Restricted Campaign'){
                if(g.RecordType.DeveloperName == 'Restricted'){
                    lstRestricted.add(g);
                }
                //if(g.Campaign_type__c == 'Sales'){
                if(g.RecordType.DeveloperName == 'Sales'){
                    lstSales.add(g);
                }                
                //if(g.Campaign_type__c == 'Foundation'){
                if(g.RecordType.DeveloperName == 'Foundation'){
                    lstFoundation.add(g);
                }
                //if(g.Campaign_type__c == 'Events'){
                if(g.RecordType.DeveloperName == 'Events'){
                    lstEvent.add(g);
                }     
                //if(g.Campaign_type__c == 'Matching Gifts'){
                if(g.RecordType.DeveloperName == 'Matching_Gifts'){
                    lstMatching.add(g);
                }         
            }
        }
        if(lstEvent.size()==0){
            Giving_Summary__c obj1 = new Giving_Summary__c();
            lstEvent.add(obj1);
        }
        if(lstFoundation.size()==0){
            Giving_Summary__c obj1 = new Giving_Summary__c();
            lstFoundation.add(obj1);
        }
        if(lstMatching.size()==0){
            Giving_Summary__c obj1 = new Giving_Summary__c();
            lstMatching.add(obj1);
        }
        if(lstRestricted.size()==0){
            Giving_Summary__c obj3 = new Giving_Summary__c();
            lstRestricted.add(obj3);
        }
        if(lstCapital.size()==0){
            Giving_Summary__c obj4 = new Giving_Summary__c();
            lstCapital.add(obj4);
        }
        if(lstSales.size()==0){
            Giving_Summary__c obj7 = new Giving_Summary__c();
            lstSales.add(obj7);
        }
        //return null;
    }
    public List<String> getCampaignType()
    {
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Campaign.Campaign_Type__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            //options.add(new SelectOption(f.getLabel(), f.getValue()));
            options.add(f.getLabel());
        }       
        return options;
    }
    
    Public Class GivingSummary{
        Public String Station{get;set;}
        Public String Summary{get;set;}     
        Public String GivingLevel{get;set;}
        Public Date FirstGiftDate{get;set;}
        Public Double FirstGiftAmount{get;set;}
        Public Double TotalPledgeAmount{get;set;}
        Public Double TotalPaidAmount{get;set;}
        Public String MemberYearStatus{get;set;}
        Public Date ExpirationDate{get;set;}
    }
        

    
    
    public List<SelectOption> getFiscalYear() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('2011','2011'));
        options.add(new SelectOption('2010','2010'));
        options.add(new SelectOption('2009','2009'));
        options.add(new SelectOption('2008','2008'));
        options.add(new SelectOption('2007','2007'));
        options.add(new SelectOption('2006','2006'));

        return options;
    }
    public pagereference GivingSummaryDetail(){
        PageReference P;
        P = new PageReference('/apex/OrganizationGivingSummaryDetail?id=' + accountId);
        P.setRedirect(true);
        Return P;
    }
    public OrganizationGivingSummary(ApexPages.StandardController controller) {
        pageLoad();
    }
    public OrganizationGivingSummary(){
        pageLoad();
    }


    ///////////////////////TEST METHOD///////////////////////////
    static testMethod void myTest() {
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(a);
        
        OrganizationGivingSummary ClsTest = new OrganizationGivingSummary(controller);
        OrganizationGivingSummary clsTest1 = new OrganizationGivingSummary();
        clsTest.SelectStation();
        clsTest.refreshTable();
        clsTest.selectFiscalYear();
        clsTest.getGivingSummaryMain();
        clsTest.SelectMemberYear();
        clsTest.getMemberYear();
        clsTest.getGivingSummaryMember();
        clsTest.populateSummaryMember();
        clsTest.getGivingSummaryFiscal();
        clsTest.saveExpirationDateHousehold();
        clsTest.populateSummaryFiscal();
        clsTest.getCampaignType();
        
        clsTest.getFiscalYear();
        clsTest.getStations();
        clsTest.GivingSummaryDetail();
        
        
        
    }   
    
}