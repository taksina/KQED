public class HouseholdGivingSummary {

    String householdId='';
    public String currentURL{get;set;}
    Public List<Opportunity> lstOpp{get;set;}
    Public String selectedStation{get;set;}
    Public List<Giving_Summary__c> lstAnnual{get;set;}
    Public List<Giving_Summary__c> lstInkind{get;set;}
    Public List<Giving_Summary__c> lstAuction{get;set;}
    //Fiscal Year
    Public List<Giving_Summary__c> lstCapital{get;set;}
    Public List<Giving_Summary__c> lstRestricted{get;set;}
    Public List<Giving_Summary__c> lstPlanned{get;set;}
    Public List<Giving_Summary__c> lstSales{get;set;}
    Public List<Giving_Summary__c> lstEvent{get;set;}
    
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
    public String selectedFiscalYear{get;set;}
    
    Public PageReference saveExpirationDateHousehold(){
        List<Giving_Summary__c> objSummary = new List<Giving_Summary__c>();
        try{
            if(lstAnnual.size()>0 && lstAnnual[0].Id != null){
                objSummary.add(lstAnnual[0]);
            }
            if(lstInkind.size()>0 && lstInkind[0].Id != null){
                objSummary.add(lstInkind[0]);
            }
            if(lstAuction.size()>0 && lstAuction[0].Id != null){
                objSummary.add(lstAuction[0]);
            }
            
            if(objSummary != null && objSummary.size()>0){
                update objSummary;
            }
            PageReference P = new PageReference('/' + householdId);
            P.setRedirect(true);
            return P;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
            return null;
        }
        //householdId
        
    }
    void pageLoad(){
        householdId = ApexPages.currentPage().getParameters().get('id');
        currentURL = ApexPages.currentPage().getHeaders().get('Host');
        system.debug('#######################################PageLoad###############################');
        getStations();
        getGivingSummaryFiscal();
        getGivingSummaryMain();
        getGivingSummaryMember();
    }
    Public PageReference refreshTable(){
        getGivingSummaryMain();
        return null;
    }
    Public PageReference selectStation(){
        getGivingSummaryFiscal();   
        getGivingSummaryMember();     
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
        lstSummaryMain = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, RecordType.DeveloperName,
        RecordType.Name, CreatedDate, CreatedById, History__c,
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, Most_Recent_Giving_Amount__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c 
        From Giving_Summary__c a
        Where a.Account__c =: householdId and a.Station__c =: selectedStation];
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
    Public Boolean showAnnualDate{get;set;}
    Public Boolean showInkindDate{get;set;}
    Public Boolean showAuctionDate{get;set;}
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
        options.add(new SelectOption('4','Previous-3'));

        return options;
    }
    Public List<GivingSummary> getGivingSummaryMember(){
        if(selectedStation == null || selectedStation == '')
            selectedStation = defaultStation;
        if(selectedMemberYear == null || selectedMemberYear == ''){
            MemberYear = System.Today().Year();
            showExpireDate = true;
        }
        lstSummaryMember = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, RecordType.DeveloperName,
        RecordType.Name, CreatedDate, CreatedById,  History__c, Summary_Count__c,
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, History_Date_Time__c, Most_Recent_Giving_Amount__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c 
        From Giving_Summary__c a Where a.Account__c =: householdId and a.Station__c =: selectedStation];
        CumulativeTotalPledgeAmount = 0;
        CumulativeTotalPaidAmount = 0;
        lstGivingMember = new List<GivingSummary>();
        if(lstSummaryMember.size()>0){   
            for(Giving_Summary__c g:lstSummaryMember){
                GivingSummary s = new GivingSummary();
                s.Station = g.Station__c;
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
        return lstGivingMember;
    }
    Public void populateSummaryMember(){

        lstAnnual = new List<Giving_Summary__c>();
        lstInkind = new List<Giving_Summary__c>();
        lstAuction = new List<Giving_Summary__c>(); 
        showAnnualDate = false;
        showInkindDate = false;
        showAuctionDate = false;
        if(lstSummaryMember.size()>0){
            for(Giving_Summary__c g:lstSummaryMember){
                Integer SummaryCount=0;
                if(g.Summary_Count__c != null)
                    SummaryCount = Integer.valueOf(g.Summary_Count__c);
                system.debug('######Summary count : ' + g.Summary_Count__c);
                system.debug('######Selected Summary count : ' + displaySummaryNumber);
                //if(g.Start_Date__c.Year() == MemberYear && displaySummaryNumber == SummaryCount){
                if(g.Start_Date__c!=null) {
                    if(g.Start_Date__c.Year() == System.Today().Year()) {
                        showExpireDate = true;
                    }
                }
                if(displaySummaryNumber == SummaryCount){
                    if(g.RecordType.DeveloperName == 'Annual_Giving'){
                        lstAnnual.add(g);
                        showAnnualDate = true;
                    }
                    if(g.RecordType.DeveloperName == 'In_Kind_Gifts'){
                        lstInkind.add(g);
                        showInkindDate = true;
                    }
                    if(g.RecordType.DeveloperName == 'Auction_Giving'){
                        lstAuction.add(g);
                        showAuctionDate = true;
                    }
                }
            }
        }
        if(lstAuction.size()==0){
            Giving_Summary__c obj5 = new Giving_Summary__c();
            lstAuction.add(obj5);
        }
        if(lstInkind.size()==0){
            Giving_Summary__c obj6 = new Giving_Summary__c();
            lstInkind.add(obj6);
        }
        if(lstAnnual.size()==0){
            Giving_Summary__c obj8 = new Giving_Summary__c();
            lstAnnual.add(obj8);
        }
        //return null;
    }
    
    //////////////////////////////Fiscal////////////////////////////////////////
    
    Public PageReference selectFiscalYear(){
        getGivingSummaryFiscal();
        return null;
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
        RecordType.Name, CreatedDate, CreatedById,  History__c,
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, 
        current_fis_yr_pd__c, current_mem_yr_add_amt__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, 
        largest_date__c, largest_recent_amt__c,  Most_Recent_Giving_Date__c, 
        last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, 
        Station__c, Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, 
        Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, 
        Solicitation_Cycle1__c, Most_Recent_Giving_Amount__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c 
        From Giving_Summary__c a Where a.Account__c =: householdId and a.Station__c =: selectedStation and a.Fiscal_Year__c =: selectedFiscalYear];
        CumulativeTotalPledgeAmount = 0;
        CumulativeTotalPaidAmount = 0;
        
        system.debug('####### Fiscal Rows for year: ' + selectedFiscalYear + ' ----> ' + lstSummaryFiscal.size());
        
        lstGivingFiscal = new List<GivingSummary>();
        if(lstSummaryFiscal.size()>0){   
            for(Giving_Summary__c g:lstSummaryFiscal){
                GivingSummary s = new GivingSummary();
                s.Station = g.Station__c;
                s.Summary = g.RecordType.Name;
                s.FirstGiftDate = g.first_date__c;
                s.FirstGiftAmount = g.first_amt__c;
                s.TotalPledgeAmount = g.total_amt__c;
                s.TotalPaidAmount = g.total_pd__c;
                s.MemberYearStatus = g.Member_Yr_Status__c;
                s.ExpirationDate = g.expiration_date__c;
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
        system.debug('####### Fiscal Rows for year: ' + selectedFiscalYear + ' ----> ' + lstSummaryFiscal.size());
        return lstGivingFiscal;
    }
    
    Public void populateSummaryFiscal(){
        lstCapital = new List<Giving_Summary__c>(); 
        lstRestricted = new List<Giving_Summary__c>(); 
        lstPlanned = new List<Giving_Summary__c>();             
        lstSales = new List<Giving_Summary__c>(); 
        lstEvent = new List<Giving_Summary__c>();
        system.debug('####### size of capital campaign : ' + lstCapital.size());
        if(lstSummaryFiscal.size()>0){
            for(Giving_Summary__c g:lstSummaryFiscal){
                
                if(g.RecordType.DeveloperName == 'Capital_Campaign_Giving'){
                    lstCapital.add(g);
                }
                if(g.RecordType.DeveloperName == 'Restricted_Giving'){
                    lstRestricted.add(g);
                }
                if(g.RecordType.DeveloperName == 'Planned_Giving'){
                    lstPlanned.add(g);
                }
                if(g.RecordType.DeveloperName == 'Sales_Giving'){
                    lstSales.add(g);
                }
                if(g.RecordType.DeveloperName == 'Events_Giving'){
                    lstEvent.add(g);
                }             
            }
        }
    
        if(lstEvent.size()==0){
            Giving_Summary__c obj1 = new Giving_Summary__c();
            lstEvent.add(obj1);
        }
        if(lstPlanned.size()==0){
            Giving_Summary__c obj2 = new Giving_Summary__c();
            lstPlanned.add(obj2);
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
        system.debug('####### size of event campaign : ' + lstEvent.size());
        system.debug('####### size of Planned campaign : ' + lstPlanned.size());
        system.debug('####### size of Restricted campaign : ' + lstRestricted.size());
        system.debug('####### size of capital campaign : ' + lstCapital.size());
        system.debug('####### size of Sales campaign : ' + lstSales.size());
    }
    
    
    public List<String> getCampaignType()
    {
        List<String> options = new List<String>();
        
        Schema.DescribeFieldResult fieldResult = Campaign.Campaign_Name__c.getDescribe();
        
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
        P = new PageReference('/apex/HouseholdGivingSummaryDetail?id=' + householdId);
        P.setRedirect(true);
        Return P;
    }
    public HouseholdGivingSummary(ApexPages.StandardController controller) {
        pageLoad();
    }
    public HouseholdGivingSummary(){
        pageLoad();
    }
    static testMethod void HouseholdGivingSummary(){
        SObject o = new Opportunity();
         ApexPages.StandardController sc = new ApexPages.StandardController(o);
         
         //EditGiving clsTest = new EditGiving(sc);
        HouseholdGivingSummary clsTest = new HouseholdGivingSummary(sc);
        clsTest.saveExpirationDateHousehold();
        clsTest.pageLoad();
        clsTest.refreshTable();
        clsTest.selectStation();
        clsTest.getGivingSummaryMain();
        clsTest.SelectMemberYear();
        clsTest.getMemberYear();
        clsTest.getGivingSummaryMember();
        clsTest.populateSummaryMember();
        clsTest.selectFiscalYear();
        clsTest.getGivingSummaryFiscal();
        clsTest.populateSummaryFiscal();
        clsTest.getCampaignType();
        clsTest.getFiscalYear();
        clsTest.getStations();
        clsTest.GivingSummaryDetail();
        //clsTest.HouseholdGivingSummary();
        
    }
    
}