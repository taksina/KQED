public class GiftSummary {

    Public String Id{get;set;}
    Public String RelatedTo{get;set;}
    Public String RelatedToName{get;set;}
    List<Opportunity> lstParent;
    List<Opportunity> lstChild;
    Public List<Giving> lstGiving{get;set;}
    Public List<Giving> lstGivingPaging{get;set;}
    
    public integer AssetCount{get;set;}
    public string AssetName{get;set;}    
      
    public integer TotalCall {get;set;}
    public integer pageNumber {get;set;}
    private integer pageSize;
    public boolean nextPage {get;set;}
    public boolean previousPage {get;set;}
    public boolean isPaging {get;set;}
    public integer totalPage {get;set;}
    public integer totalRecords {get;set;}
    public integer FromRecords {get;set;}
    public integer ToRecords {get;set;}      
    Public String CurrentURL{get;set;}
    
    Public String showMoreLabel{get;set;}
    
    public boolean blnList{get;set;}


    void resetPaging(){
        pageNumber=0;
        if(blnList == true)
            pageSize = 200;
        else
            pageSize = 5;
        totalPage=0;
        totalRecords=0;
        FromRecords=0;
        ToRecords=0;

        nextPage = false;
        previousPage = false;
        isPaging = false;
    }
    
    Public PageReference removeGiving(){
        lstGiving = new List<Giving>();
        resetPaging();
        LoadSummary();
        return null;
    }
    
    Void PageLoad(){
        Id = ApexPages.currentPage().getParameters().get('id');    
        if(ApexPages.currentPage().getParameters().get('list')=='1')
            blnList = true;
        else
            blnList = false;
        CurrentURL = ApexPages.currentPage().getHeaders().get('Host');
        resetPaging();    
        String strObj;
        if(Id != null && Id.trim().length()>0){
            strObj = Id.trim().replace('/','').substring(0,3);
            if(strObj != null && strObj.trim().length()>0){
                if(strObj.trim() == '001'){
                    RelatedTo = 'Account';
                    Account objAccount = [Select name from Account where Id=:Id];
                    RelatedToName = objAccount.name;
                }
                if(strObj.trim() == '003'){
                    RelatedTo = 'Contact';
                    Contact objContact = [Select name from Contact where Id=:Id];
                    RelatedToName = objContact.name;
                }
                if(strObj.trim() == '701'){
                    RelatedTo = 'Campaign';
                    Campaign objCampaign = [Select name from Campaign where Id=:Id];
                    RelatedToName = objCampaign.name;
                }
            }
            LoadSummary();
        }
        system.debug('####Related to : ' + RelatedTo);
    }
    Void LoadChilds(){
        if(lstParent != null && lstParent.size()>0){
            Set<ID> parentIds = new Set<ID>();
            for(Opportunity parent:lstParent){
                parentIds.add(parent.Id);
            }
            lstChild = new List<Opportunity>();
            lstChild = [Select Id, Name, CampaignId, AccountId, Recurring_Donation_Opportunity__c, 
            Oppty_Related_Contact__c, CloseDate, Gift_Date_Time__c, 
            Gift_Kind__c, Gift_Type__c, Giving_Amount__c, 
            Payment_Amount__c, Installment_Amount__c, StageName,Benefit_Counts__c,Campaign_Name__c
            From Opportunity
            Where Recurring_Donation_Opportunity__c In: ParentIds order by payment_number__c];
        }
    }
    Void LoadParents(){
        lstParent = new List<Opportunity>();
        if(RelatedTo == 'Account')
            lstParent = [Select Id, Name, CampaignId, AccountId, Recurring_Donation_Opportunity__c, 
            Oppty_Related_Contact__c, CloseDate, Gift_Date_Time__c, 
            Gift_Kind__c, Gift_Type__c, Giving_Amount__c, 
            Payment_Amount__c, Installment_Amount__c, StageName,Benefit_Counts__c,Campaign_Name__c
            From Opportunity
            Where AccountId =: Id and Recurring_Donation_Opportunity__c = null order by closedate desc];
        
        else if(RelatedTo == 'Contact')
            lstParent = [Select Id, Name, CampaignId, AccountId, Recurring_Donation_Opportunity__c, 
            Oppty_Related_Contact__c, CloseDate, Gift_Date_Time__c, 
            Gift_Kind__c, Gift_Type__c, Giving_Amount__c, 
            Payment_Amount__c, Installment_Amount__c, StageName,Benefit_Counts__c,Campaign_Name__c
            From Opportunity
            Where Oppty_Related_Contact__c =: Id and Recurring_Donation_Opportunity__c = null order by closedate desc];
        
        else if(RelatedTo == 'Campaign')
            lstParent = [Select Id, Name, CampaignId, AccountId, Recurring_Donation_Opportunity__c, 
            Oppty_Related_Contact__c, CloseDate, Gift_Date_Time__c, 
            Gift_Kind__c, Gift_Type__c, Giving_Amount__c, 
            Payment_Amount__c, Installment_Amount__c, StageName,Benefit_Counts__c,Campaign_Name__c
            From Opportunity
            Where CampaignId =: Id and Recurring_Donation_Opportunity__c = null order by closedate desc];
    }
    
    Void LoadSummary(){
        if(lstGiving != null && lstGiving.size()>0) return;
        LoadParents();
        LoadChilds();
        lstGiving = new List<Giving>();
        if(lstParent != null && lstParent.size()>0){
            for(Opportunity parent:lstParent){
                Giving objGivingParent = new Giving();
                objGivingParent.IsParent = true;
                objGivingParent.GivingID = parent.id;
                objGivingParent.GiftDate = parent.closedate;
                objGivingParent.GiftKind = parent.Gift_Kind__c;
                objGivingParent.GiftType = parent.Gift_Type__c;
                objGivingParent.GivingAmount = parent.Giving_Amount__c;
                objGivingParent.PaidAmount = parent.Payment_Amount__c;
                objGivingParent.Stage = parent.StageName;
                objGivingParent.GivingType = 'Parent';
                if(parent.Benefit_Counts__c>0) {
                    objGivingParent.IsBenefits = true;
                }
                else {
                    objGivingParent.IsBenefits = false;
                }
                objGivingParent.CampaignType = parent.Campaign_Name__c;
                
                List<Giving> lstChildGiving = new List<Giving>();
                if(lstChild != null && lstChild.size()>0){
                    for(Opportunity child: lstChild){
                        if(child.Recurring_Donation_Opportunity__c == parent.Id){
                            Giving objGivingChild = new Giving();
                            objGivingChild.GivingName = child.name;
                            objGivingChild.GivingType = '';
                            objGivingChild.IsParent = false;
                            objGivingChild.GivingID = child.id;
                            objGivingChild.ParentID = parent.id;
                            objGivingChild.GiftDate = child.closedate;
                            objGivingChild.GiftKind = child.Gift_Kind__c;
                            objGivingChild.GiftType = child.Gift_Type__c;
                            objGivingChild.GivingAmount = child.Giving_Amount__c;
                            objGivingChild.PaidAmount = child.Payment_Amount__c;
                            objGivingChild.InstallmentAmount = child.Installment_Amount__c;
                            objGivingChild.Stage = child.StageName;
                            if(child.Benefit_Counts__c>0) {
                                objGivingChild.IsBenefits = true;
                            }
                            else {
                                objGivingChild.IsBenefits = false;
                            }
                            objGivingChild.CampaignType = child.Campaign_Name__c;
                            
                            lstChildGiving.add(objGivingChild);
                        }
                    }
                }
                if(lstChildGiving != null && lstChildGiving.size()>0){
                    objGivingParent.GivingName = parent.name + ' (' + String.valueOf(lstChildGiving.size()) + ' installments)' ;
                    objGivingParent.HasChild = true;
                }
                else{                    
                    objGivingParent.GivingName = parent.name;
                    objGivingParent.HasChild = false;
                }
                objGivingParent.InstallmentAmount = 0;
                lstGiving.add(objGivingParent);
                if(lstChildGiving != null && lstChildGiving.size()>0){
                    for(Giving child:lstChildGiving){
                        lstGiving.add(child);
                    }
                }
            }
        }
    }
    public PageReference Show5More() {
        pageSize+=5;
        return null;
    }    
    public PageReference GoToList() {
        PageReference P = new Pagereference('/apex/GiftSummary?id=' + ApexPages.CurrentPage().getParameters().get('Id'));
        P.setRedirect(True);
        return P;
    }
    Public List<Giving> getGivingList(){
        try{
            system.debug('##### getGivingList');
            totalRecords = lstGiving.size();
            
            if (pageNumber == null || pageNumber == 0) 
            {
                pageNumber = 2;
                PreviousPage();
            }
            FromRecords = ((pageNumber - 1) * pageSize) + 1;
            ToRecords = FromRecords + pageSize -1 ;
            
            if (ToRecords>totalRecords) ToRecords = totalRecords;
    
            if (lstGiving.size() <= pageSize)
            {
                totalPage = 1;
                nextPage = true;
                previousPage = true;       
            }
            else
            {
                totalPage = Integer.valueof(lstGiving.size()/pageSize);
                if (Math.mod(lstGiving.size(), pageSize) > 0)
                {
                    totalPage++;
                }
            }
            
            integer totalCountForPage = pageNumber * pageSize;
            if (lstGiving.size() < pageSize)
            {
                totalCountForPage = lstGiving.size();
            }
            lstGivingPaging = new List<Giving>();
            for (integer i=((pageNumber - 1) * pageSize);i<totalCountForPage;i++)
            {
                if (i < lstGiving.size()) {
                    Giving objGiving = new Giving();
                    objGiving = lstGiving[i];
                    lstGivingPaging.add(objGiving);
                }
            }
            integer pending=0;
            pending = totalRecords - totalCountForPage;
            if(pending<0)pending=0;
            showMoreLinks = true;
            if(pending > pageSize)
                showMoreLabel = 'Show ' + String.valueOf(pageSize) + ' more »';
            else
                showMoreLabel = 'Show ' + String.valueOf(pending) + ' more »';
            if(pending == 0)
                showMoreLinks = false;
            if (totalRecords==0) FromRecords=0;
        }
        catch(Exception ex) {
        }
        return lstGivingPaging;
    }
    public boolean showMoreLinks{get;set;}
    Public Class Giving{
        Public String GivingName{get;set;}
        Public Boolean IsParent{get;set;}
        Public String GivingType{get;set;}
        Public Boolean HasChild{get;set;}//
        Public ID GivingID{get;set;}
        Public ID ParentID{get;set;}//
        Public Date GiftDate{get;set;}
       
        Public String GiftKind{get;set;}
        Public String GiftType{get;set;}
        Public Decimal GivingAmount{get;set;}
        Public Decimal PaidAmount{get;set;}
        Public Decimal InstallmentAmount{get;set;} //(should be $0 on parent pledge)
        Public String Stage{get;set;}
        public Boolean IsBenefits{get;set;}
        public String CampaignType{get;set;}
    }

    public void NextPage()
    {
        if (pageNumber < totalPage ) 
            pageNumber++;
            
        if (pageNumber < totalPage) 
        {
            nextPage = false;
            if (pageNumber > 1) 
            {
                previousPage = false;
            } 
        }
        else 
        {
            nextPage = true;
            previousPage = false;
        }
    }
    public void PreviousPage()
    {
        if (pageNumber > 0) 
        {
            pageNumber--;
        }
        if (pageNumber > 1) 
        {
            previousPage = false;
            if (pageNumber < totalPage) 
            {
                nextPage = false;
            }
        }
        else 
        {
            previousPage = true;
            nextPage = false;
        }
    }
    Public GiftSummary(){
        PageLoad();
    }
    static testMethod void GiftSummary(){
    
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cont = new Contact(LastName = 'TestLastName',AccountId = a.id);
        insert cont;
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        
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
        
        ApexPages.currentPage().getParameters().put('id', a.Id);                
        ApexPages.currentPage().getParameters().put('list','1');
        
        Giving giv = New Giving();
               
        giv.IsParent =true;
        giv.GivingID = '006Q0000008cKJz';
        giv.GiftDate = system.Today();
        giv.GiftKind = 'One Payment';
        giv.GiftType = 'test';
        giv.GivingAmount = 10;
        giv.PaidAmount = 10;
        giv.InstallmentAmount = 10;
        giv.Stage = 'test';
        giv.GivingType = 'parent';
        
  
         
        GiftSummary clsTest= new GiftSummary();
        
        clsTest.blnList = true;
        clsTest.resetPaging();
        clsTest.blnList = false;
        clsTest.resetPaging();
       
        clsTest.removeGiving();
       
        clsTest.PageLoad();
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        clsTest.PageLoad();
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        clsTest.PageLoad();
        
        ApexPages.currentPage().getParameters().put('id', cont.Id);
        clsTest.PageLoad();        
        
        clsTest.LoadChilds();
        clsTest.LoadParents();
        clsTest.LoadSummary();
        clsTest.Show5More();
        clsTest.GoToList();
        clsTest.getGivingList();
        clsTest.NextPage();
        clsTest.PreviousPage();
    }
}