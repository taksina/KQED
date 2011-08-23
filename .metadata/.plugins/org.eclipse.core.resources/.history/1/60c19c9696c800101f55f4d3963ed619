public class CampaignProgramCreate {
    public Campaign objCamp{get;set;}    
    public CampaignStatistics CStatistics {get;set;}    
    public String cFieldTitle{get;set;}
    public List<CampaignChildMemberList> objChildMemberList{get;set;}
    public String cFieldHelpText{get;set;}
    public String cFiledId{get;set;}
    Public List<Campaign> lstCampaingParentChildProgram{ get;set;}    
    Public List<CampaignMember> lstCampaingChildMemberlist{get;set;}
    Public List<CampaignMember> lstCampaingChildMemberDisplay{get;set;}    
    Public List<Campaign> lstCampaingDisplay{get;set;}
    
    ApexPages.StandardController con;    
    public Boolean FormEdit{get;set;}    
    public Boolean SubProgramCreateStatus{get;set;}    
    public CampaignProgramCreate(){}    
    public User u;
    public Boolean SourceCodeFormEdit{get;set;}
    
    public CampaignProgramCreate(ApexPages.StandardController controller) {
        this.con = controller;
        objCamp = (Campaign)con.getRecord();
        objCamp.RecordTypeID = ApexPages.currentPage().getParameters().get('RecordType');
        FormEdit = false;
        SourceCodeFormEdit = true;
        
        if(ApexPages.currentPage().getParameters().get('Id')!=null){
             
            SourceCodeFormEdit = false;   
            u = [Select Id, Profile.Name from User where Id =: System.Userinfo.getUserId()];
           
            if(u.Profile.Name == 'System Administrator' && objCamp.IsActive == true && objCamp.Status == 'In Progress') {
                SourceCodeFormEdit = true;                
            }           
           FormEdit = true;
           if(ApexPages.currentPage().getParameters().get('mode')=='template'){
               FormEdit = false;
               //objCamp.Source_Code__c = '';
           }
           
           List<Campaign> ChildCampaingCount  = new List<Campaign>(); 
           ChildCampaingCount  = [Select id From Campaign Where Parentid=:ApexPages.currentPage().getParameters().get('Id')]; 
           
           SubProgramCreateStatus = true;
           if(ChildCampaingCount.size() >= 6){
               SubProgramCreateStatus = false;
           }
           
           lstCampaingParentChildProgram = new  List<Campaign>();
            
            lstCampaingParentChildProgram = [Select ID,ParentID,Name,Product_Program__c,Campaign_Name__c,Program_Count__c ,Station__c,Effort_for_Project__c,Start_Time_Date__c,End_Time_Date__c,Source_Code__c,
            (Select ID,ParentID,Name,Product_Program__c,Campaign_Name__c,Program_Count__c,Station__c,Effort_for_Project__c,Start_Time_Date__c,End_Time_Date__c,Source_Code__c            
            From ChildCampaigns ORDER BY Program_Count__c)       
            from Campaign Where parentID=:ApexPages.currentPage().getParameters().get('Id') ORDER BY Program_Count__c];// OR id=:ApexPages.currentPage().getParameters().get('Id')];
                        
            lstCampaingDisplay = new List<Campaign>();            
            lstCampaingDisplay.add(objCamp);
            
            for(Campaign c: lstCampaingParentChildProgram) {
                lstCampaingDisplay.add(c);
                
                for(Campaign c1: c.ChildCampaigns) {
                    lstCampaingDisplay.add(c1);
                }
            }            
            /////Campaign Child Member
            lstCampaingChildMemberlist = new  List<CampaignMember>();
            List <CampaignMember> lstCampaingChildMemberlist = [Select Id, IsDeleted, CampaignId, LeadId,Lead.FirstName,Lead.LastName,
            Lead.Company, ContactId,Contact.FirstName,Contact.LastName,Contact.Account.Name,Status,HasResponded,
            CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, FirstRespondedDate
            FROM CampaignMember where Campaign.ParentID=:ApexPages.currentPage().getParameters().get('Id')];
            
            objChildMemberList = new List<CampaignChildMemberList>();

            for(CampaignMember c: lstCampaingChildMemberlist) {
                
               CampaignChildMemberList objchildMember = new CampaignChildMemberList();
               if(c.LeadId!=NULL)
               {
                   objchildMember.ID = c.Id;
                   objchildMember.TypeID = c.LeadId;
                   objchildMember.VType = 'Prospect/Lead';
                   objchildMember.FirstName = c.Lead.FirstName;
                   objchildMember.LastName = c.Lead.LastName;
                   objchildMember.Company = c.Lead.Company;
                   objchildMember.Status = c.Status;
                   objchildMember.CampaignId = c.CampaignId;
                   objChildMemberList.add(objchildMember);                   
               }
               
               if(c.ContactId!=NULL)
               {
                   objchildMember.ID = c.Id;
                   objchildMember.TypeID = c.ContactId;
                   objchildMember.VType = 'Contact';
                   objchildMember.FirstName = c.Contact.FirstName;
                   objchildMember.LastName = c.Contact.LastName;
                   objchildMember.Company= c.Contact.Account.Name;
                   objchildMember.Status = c.Status;
                   objchildMember.CampaignId = c.CampaignId;
                   objChildMemberList.add(objchildMember);
               } 
            } 
        }
        CStatistics = new CampaignStatistics();
        CStatistics.HierarchyActualCost = 0.0;
        CStatistics.HierarchyBudgetedCost = 0.0;
        CStatistics.NumberOfContacts = 0;
        CStatistics.HierarchyNumberOfContacts = 0;
        CStatistics.HierarchyNumberOfConvertedLeads = 0;
        CStatistics.HierarchyExpectedRevenue = 0.0;
        CStatistics.NumberOfLeads = 0;
        CStatistics.HierarchyNumberOfLeads = 0;
        CStatistics.HierarchyNumberSent = 0;
        CStatistics.HierarchyNumberOfOpportunities = 0;
        CStatistics.NumberOfResponses = 0;
        CStatistics.HierarchyNumberOfResponses = 0;
        CStatistics.AmountAllOpportunities = 0.0;
        CStatistics.HierarchyAmountAllOpportunities = 0.0;
        CStatistics.AmountWonOpportunities = 0.0;
        CStatistics.HierarchyAmountWonOpportunities = 0.0;
        CStatistics.HierarchyNumberOfWonOpportunities = 0;        
        
        if(ApexPages.currentPage().getParameters().get('Id')!=null) {
            AggregateResult[] groupedResults = [SELECT 
                SUM(HierarchyActualCost) H_ActualCost,
                SUM(HierarchyBudgetedCost) H_BudgetedCost,
                SUM(NumberOfContacts) NumberOfContacts,
                SUM(HierarchyNumberOfContacts)  H_NumOfContacts,
                SUM(HierarchyNumberOfConvertedLeads)  H_NumOfConvertedLeads,
                SUM(HierarchyExpectedRevenue) H_ExpectedRevenue,
                SUM(NumberOfLeads) NumberOfLeads,
                SUM(HierarchyNumberOfLeads)  H_NumOfLeads,
                SUM(HierarchyNumberSent)  H_NumSent,
                SUM(HierarchyNumberOfOpportunities)  H_NumOfOpportunities,
                SUM(NumberOfResponses) NumberOfResponses,
                SUM(HierarchyNumberOfResponses)  H_NumOfResponses,
                SUM(AmountAllOpportunities) AmountAllOpportunities,
                SUM(HierarchyAmountAllOpportunities) H_AmountAllOpportunities,
                SUM(AmountWonOpportunities) AmountWonOpp,
                SUM(HierarchyAmountWonOpportunities) H_AmountWonOpp,
                SUM(HierarchyNumberOfWonOpportunities)  H_NumOfWonOpp
                  FROM Campaign where ParentID=: ApexPages.currentPage().getParameters().get('Id') OR ID=: ApexPages.currentPage().getParameters().get('Id')
                  GROUP BY ParentID];
                 
                 
            if(groupedResults.size()>0) {
                AggregateResult ar = groupedResults[0];
                CStatistics.HierarchyActualCost = (Decimal) ar.get('H_ActualCost');
                CStatistics.HierarchyBudgetedCost = (Decimal) ar.get('H_BudgetedCost');
                CStatistics.NumberOfContacts = (Double) ar.get('NumberOfContacts');
                CStatistics.HierarchyNumberOfContacts = (Double) ar.get('H_NumOfContacts');
                CStatistics.HierarchyNumberOfConvertedLeads = (Double) ar.get('H_NumOfConvertedLeads');
                CStatistics.HierarchyExpectedRevenue = (Decimal) ar.get('H_ExpectedRevenue');
                CStatistics.NumberOfLeads = (Double) ar.get('NumberOfLeads');
                CStatistics.HierarchyNumberOfLeads = (Double) ar.get('H_NumOfLeads');
                CStatistics.HierarchyNumberSent = (Double) ar.get('H_NumSent');
                CStatistics.HierarchyNumberOfOpportunities = (Double) ar.get('H_NumOfOpportunities');
                CStatistics.NumberOfResponses = (Double) ar.get('NumberOfResponses');
                CStatistics.HierarchyNumberOfResponses = (Double) ar.get('H_NumOfResponses');
                CStatistics.AmountAllOpportunities = (Decimal) ar.get('AmountAllOpportunities');
                CStatistics.HierarchyAmountAllOpportunities = (Decimal) ar.get('H_AmountAllOpportunities');
                CStatistics.AmountWonOpportunities = (Decimal) ar.get('AmountWonOpp');
                CStatistics.HierarchyAmountWonOpportunities = (Decimal) ar.get('H_AmountWonOpp');
                CStatistics.HierarchyNumberOfWonOpportunities = (Double) ar.get('H_NumOfWonOpp');
            }
        }
    }
    
    public PageReference EditCampaign()                   
    {        
          PageReference CampaingnEditPage = new PageReference('/apex/CampaignProgramCreate?id=' + ApexPages.currentPage().getParameters().get('Id')); 
          CampaingnEditPage .setRedirect(true);       
          return CampaingnEditPage;    
    }

    public PageReference AdvanceSetup() {
        String strURL = '/camp/campaignmemberstatusdetail.jsp?retURL=/' + ApexPages.currentPage().getParameters().get('Id') + '&id=' + ApexPages.currentPage().getParameters().get('Id');
          PageReference AdvanceSetupPage = new PageReference(strURL); 
          AdvanceSetupPage.setRedirect(true);       
          return AdvanceSetupPage; 
    }    
    
    public PageReference UseAsTemplate()                   
    {        
          PageReference CampaingnEditPage = new PageReference('/apex/CampaignProgramCreate?mode=template&id=' + ApexPages.currentPage().getParameters().get('Id')); 
          CampaingnEditPage.setRedirect(true);       
          return CampaingnEditPage;    
    }
    
    public PageReference CreateSubProgram()                   
    {        
          PageReference CampaignSubProgram = new PageReference('/apex/CampaignSubProgram?id=' + ApexPages.currentPage().getParameters().get('Id')); 
          CampaignSubProgram .setRedirect(true);       
          return CampaignSubProgram;    
    }
    
    public PageReference UpdateSubProgram()                   
    {        
          PageReference UpdateCampaignSubProgram = new PageReference('/apex/CampaignSubProgram?mode=edit&id=' + ApexPages.currentPage().getParameters().get('Id')); 
          UpdateCampaignSubProgram.setRedirect(true);       
          return UpdateCampaignSubProgram;    
    }    

    Public List<Campaign> SubProgramUpdateList{ get; set; }

    
    public PageReference Save(){
        
        Campaign CampaingRecordType = new Campaign();        
        /*Long BreakActualDuration = 0;
        if(objCamp.ProgramBreak_EndDateTime__c!=null && objCamp.ProgramBreak_StartDateTime__c!=null) {
            BreakActualDuration = (objCamp.ProgramBreak_EndDateTime__c.getTime() - objCamp.ProgramBreak_StartDateTime__c.getTime())/(1000*60);
        }
          objCamp.Break_Actual_Duration__c = BreakActualDuration; */
        if(ApexPages.currentPage().getParameters().get('mode')=='template'){
        
           CampaingRecordType  = [Select RecordTypeID From Campaign Where id=:ApexPages.currentPage().getParameters().get('Id')];
           Campaign lstCampaingTemplate = new Campaign();
           lstCampaingTemplate = objCamp.clone(false,true);
           lstCampaingTemplate.Source_Code__c = '';
           lstCampaingTemplate.RecordTypeID = CampaingRecordType.RecordTypeID ;
           insert lstCampaingTemplate;
           
           List<Campaign> SubProgramUpdateList = new List<Campaign>();
           List<Campaign> SubProgramInsertList = new List<Campaign>();
           /////LRT Start:10/05/2011:Insert SubProgram in New Campaing
           SubProgramUpdateList= [Select ID,Parentid,Parent.Name,Name,Product_Program__c,Campaign_Name__c,Campaign_Description__c,
                               Financial_segment_Level1__c,Program_Count__c,Campaign.Giving_Segment__c,Station__c,Solicitation_Type__c,Effort_for_Project__c,
                               Status,IsActive,Channel_Technique__c,Industry_Sub_Category__c,Sub_Channel__c,Industry__c,Category__c,Job__c,Creative_Package__c,
                               Offer_Message__c,Response_Mechanism__c,Designation__c,Support_Designation__c,Override_Gift__c,WGBH_Accounting_Unit__c,WGBH_AUAC__c,Audience_Segment__c,Segment_Age_Range__c,Segment_Gender__c,Segment_Notes__c,Cost_Per_X__c,Ttl_Cost__c,
                               Email_Response__c,Web_Inbound__c,Inbound_Calls__c,ROI__c,Start_Time_Date__c,End_Time_Date__c,
                               Prime_Time_Selected__c,Show_Breaks__c,Break_Challenges__c,Placement__c,
                               ProgramBreak_StartDateTime__c,ProgramBreak_EndDateTime__c,Source_Code__c,CDP_Grouping__c,CDP_Grouping_Code__c,
                               Break_Actual_Duration__c,TV_Radio_Show_Program__c  
                               from Campaign Where Parentid=:ApexPages.currentPage().getParameters().get('Id') ORDER BY ID];
            if(SubProgramUpdateList.size() > 0){
              for(Campaign a : SubProgramUpdateList){             
                   Campaign SubProgramInsertSingle = new Campaign();
                   SubProgramInsertSingle = a.clone(false,true);
                   SubProgramInsertSingle.ParentID = lstCampaingTemplate.Id;
                   SubProgramInsertList.add(SubProgramInsertSingle);
                }
                
                if(SubProgramInsertList.size() > 0){
                   upsert SubProgramInsertList; 
                }             
             } 
            /////LRT End:10/05/2011:Insert SubProgram in New Campaing           
           PageReference CampaignTemplate = new PageReference('/apex/CampaignProgramView?mode=edit&id=' + lstCampaingTemplate.id); 
           CampaignTemplate.setRedirect(true);       
           return CampaignTemplate;            
        }
        else{
            con.save();
            pageReference CampaingnEditPage = con.view();
            return CampaingnEditPage; 
        }       
    }
     public PageReference chagneGroupCode(){
         if(objCamp.CDP_Grouping__c == 'Renewal Notice 1'){
             objCamp.CDP_Grouping_Code__c = 'R1';
         }
         else if(objCamp.CDP_Grouping__c == 'Renewal Mail Effort Unknown'){
             objCamp.CDP_Grouping_Code__c = 'R0';
         }
         else if(objCamp.CDP_Grouping__c == 'Other Renewal Mail'){
             objCamp.CDP_Grouping_Code__c = 'RM';
         }
         else if(objCamp.CDP_Grouping__c == 'Acquisition Mail'){
             objCamp.CDP_Grouping_Code__c = 'C';
         }
         else if(objCamp.CDP_Grouping__c == 'Additional Mail'){
             objCamp.CDP_Grouping_Code__c = 'A';
         }
         else if(objCamp.CDP_Grouping__c == 'Lapsed Mail'){
             objCamp.CDP_Grouping_Code__c = 'L';
         }
         else if(objCamp.CDP_Grouping__c == 'Other Mail'){
             objCamp.CDP_Grouping_Code__c = 'MA';
         }
         else if(objCamp.CDP_Grouping__c == 'Renewal Telemarketing'){
             objCamp.CDP_Grouping_Code__c = 'TR';
         }
         else if(objCamp.CDP_Grouping__c == 'Acquisition Telemarketing'){
             objCamp.CDP_Grouping_Code__c = 'TC';
         }
         else if(objCamp.CDP_Grouping__c == 'Additional Telemarketing'){
             objCamp.CDP_Grouping_Code__c = 'TA';
         }
         else if(objCamp.CDP_Grouping__c == 'Lapsed Telemarketing'){
             objCamp.CDP_Grouping_Code__c = 'TL';
         }
         else if(objCamp.CDP_Grouping__c == 'Other Telemarketing'){
             objCamp.CDP_Grouping_Code__c = 'TO';
         }
         else if(objCamp.CDP_Grouping__c == 'On-Air Pledge'){
             objCamp.CDP_Grouping_Code__c = 'P';
         }
         else if(objCamp.CDP_Grouping__c == 'Sweepstakes'){
             objCamp.CDP_Grouping_Code__c = 'S';
         }
         else if(objCamp.CDP_Grouping__c == 'Acquisition Sweeps'){
             objCamp.CDP_Grouping_Code__c = 'S1';
         }
         else if(objCamp.CDP_Grouping__c == 'Web/Internet'){
             objCamp.CDP_Grouping_Code__c = 'W';
         }
         else if(objCamp.CDP_Grouping__c == 'Sustainer'){
             objCamp.CDP_Grouping_Code__c = 'SG';
         }
         else if(objCamp.CDP_Grouping__c == '900 Number'){
             objCamp.CDP_Grouping_Code__c = '9';
         }
         else if(objCamp.CDP_Grouping__c == 'Matching Gifts'){
             objCamp.CDP_Grouping_Code__c = 'MG';
         }
         else if(objCamp.CDP_Grouping__c == 'Miscellaneous/Other'){
             objCamp.CDP_Grouping_Code__c = 'X';
         }
         else if(objCamp.CDP_Grouping__c == 'Customer Service'){
             objCamp.CDP_Grouping_Code__c = 'CS';
         }
         else if(objCamp.CDP_Grouping__c == 'Web Pledge'){
             objCamp.CDP_Grouping_Code__c = 'WP';
         }
         else if(objCamp.CDP_Grouping__c == 'Web Email'){
             objCamp.CDP_Grouping_Code__c = 'WE';
         }
         else if(objCamp.CDP_Grouping__c == 'Major Donors'){
             objCamp.CDP_Grouping_Code__c = 'MD';
         }
         else if(objCamp.CDP_Grouping__c == 'Planned Giving'){
             objCamp.CDP_Grouping_Code__c = 'PG';
         }
         else if(objCamp.CDP_Grouping__c == 'Events'){
             objCamp.CDP_Grouping_Code__c = 'EV';
         }
         else if(objCamp.CDP_Grouping__c == 'Capital Campaigns'){
             objCamp.CDP_Grouping_Code__c = 'CC';
         }
         else if(objCamp.CDP_Grouping__c == 'Local Underwriting'){
             objCamp.CDP_Grouping_Code__c = 'LU';
         }
         else if(objCamp.CDP_Grouping__c == 'National Underwriting'){
             objCamp.CDP_Grouping_Code__c = 'NU';
         }
         else if(objCamp.CDP_Grouping__c == 'Memorial/Honorarium'){
             objCamp.CDP_Grouping_Code__c = 'MM';
         }
         else if(objCamp.CDP_Grouping__c == 'Publications/Newsletters'){
             objCamp.CDP_Grouping_Code__c = 'PU';
         }
         return null;
     }
    
    public PageReference SaveUpdateSubProgram(){
        con.save();
        pageReference CampaingnEditPage = con.view();
        List<Campaign> lstCampaingSupProgram = new  List<Campaign>();
        
        SubProgramUpdateList= [Select ID,Parentid,Name,Product_Program__c,WGBH_Accounting_Unit__c,WGBH_Accounting_Unit__r.Name,WGBH_AUAC__c,WGBH_AUAC__r.Name,Campaign_Name__c,Campaign_Description__c,
         Financial_segment_Level1__c,Campaign.Giving_Segment__c,Station__c,Solicitation_Type__c,Designation__c,Support_Designation__c,Effort_for_Project__c,
         Status,IsActive,Channel_Technique__c,Sub_Channel__c,Industry__c,Category__c,Job__c,Creative_Package__c,
         Offer_Message__c,Response_Mechanism__c,Segment_Gender__c,Segment_Age_Range__c,Audience_Segment__c,Segment_Notes__c,Cost_Per_X__c,Ttl_Cost__c,
         Email_Response__c,Web_Inbound__c,Inbound_Calls__c,Industry_Sub_Category__c,ROI__c,Start_Time_Date__c,End_Time_Date__c,               
         Prime_Time_Selected__c,Show_Breaks__c,Break_Challenges__c,Placement__c,
         ProgramBreak_StartDateTime__c,ProgramBreak_EndDateTime__c,CDP_Grouping__c,CDP_Grouping_Code__c,
         Break_Actual_Duration__c,TV_Radio_Show_Program__c
         from Campaign Where Parentid=:ApexPages.currentPage().getParameters().get('Id')];
         
         if(SubProgramUpdateList.size() > 0) { 
             for(Campaign su: SubProgramUpdateList) {                             
                    su.Product_Program__c = objCamp.Product_Program__c;
                    su.Break_Actual_Duration__c = objCamp.Break_Actual_Duration__c;
                    su.Campaign_Name__c = objCamp.Campaign_Name__c;
                    su.TV_Radio_Show_Program__c = objCamp.TV_Radio_Show_Program__c;
                    su.Designation__c = objCamp.Designation__c;                        
                    su.Campaign_Description__c = objCamp.Campaign_Description__c;
                    su.Financial_segment_Level1__c = objCamp.Financial_segment_Level1__c;
                    su.Giving_Segment__c = objCamp.Giving_Segment__c;
                    su.Station__c = objCamp.Station__c;
                    su.Solicitation_Type__c = objCamp.Solicitation_Type__c;
                    su.Effort_for_Project__c = objCamp.Effort_for_Project__c;                    
                    su.Status = objCamp.Status;
                    su.IsActive = objCamp.IsActive;
                    su.Industry_Sub_Category__c = objCamp.Industry_Sub_Category__c;                    
                    su.Channel_Technique__c = objCamp.Channel_Technique__c;
                    su.Sub_Channel__c = objCamp.Sub_Channel__c;
                    su.Industry__c = objCamp.Industry__c;
                    //su.Category__c = objCamp.Category__c;
                    su.Job__c = objCamp.Job__c;
                    su.Creative_Package__c = objCamp.Creative_Package__c;
                    su.Offer_Message__c = objCamp.Offer_Message__c;
                    su.Response_Mechanism__c = objCamp.Response_Mechanism__c;
                    su.Audience_Segment__c = objCamp.Audience_Segment__c;
                    su.Segment_Notes__c = objCamp.Segment_Notes__c;                    
                    su.Cost_Per_X__c = objCamp.Cost_Per_X__c;
                    su.Ttl_Cost__c = objCamp.Ttl_Cost__c;
                    su.Email_Response__c = objCamp.Email_Response__c;
                    su.Web_Inbound__c = objCamp.Inbound_Calls__c;
                    su.ROI__c = objCamp.ROI__c;
                    //su.Start_Time_Date__c = objCamp.Start_Time_Date__c;
                    //su.End_Time_Date__c = objCamp.End_Time_Date__c;                    
                    su.Prime_Time_Selected__c = objCamp.Prime_Time_Selected__c; 
                    su.Show_Breaks__c = objCamp.Show_Breaks__c; 
                    su.Break_Challenges__c = objCamp.Break_Challenges__c; 
                    su.Placement__c = objCamp.Placement__c;                    
                    //su.Program_Break_Name__c = objCamp.Program_Break_Name__c;
                    //su.ProgramBreak_StartDateTime__c = objCamp.ProgramBreak_StartDateTime__c;
                    //su.ProgramBreak_EndDateTime__c = objCamp.ProgramBreak_EndDateTime__c;          
                                                    
            }
            update SubProgramUpdateList;           
        }      
        return CampaingnEditPage; 
    }

    static testMethod void TestCampaignProgramCreate() {
        Campaign c = new Campaign();
        c.Name='TestCampaign';
        c.CDP_Grouping__c = 'Renewal Notice 1';
        insert c;
        
        Campaign c1 = new Campaign();
        c1.Name='TestCampaign1';
        c1.CDP_Grouping__c = 'Renewal Notice 1';
        c1.Parentid = c.Id;
        insert c1;
        
               
             
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        RecordType r = [Select ID from RecordType where DeveloperName = 'Event' limit 1];
        
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        ApexPages.CurrentPage().getParameters().put('mode','template');               
        
        CampaignProgramCreate clsTest = new CampaignProgramCreate(controller);

        PageReference P = clsTest.EditCampaign();
        P = clsTest.UseAsTemplate();
        P = clsTest.CreateSubProgram();
        P = clsTest.UpdateSubProgram();
        P = clsTest.Save();
        P = clsTest.SaveUpdateSubProgram();
        P = clsTest.AdvanceSetup();
        P = clsTest.chagneGroupCode();     
       
               
    }
    
    class CampaignChildMemberList{
        public String ID{get;set;}
        public String CampaignId{get;set;}
        public String TypeID{get;set;}
        public String VType{get;set;}
        public String FirstName{get;set;}
        public String LastName{get;set;}
        public String Company{get;set;}
        public String Status{get;set;}      
        public String HouseHoldMember{get;set;}                 
        
        public CampaignChildMemberList(){}     
    }

    class CampaignStatistics {
        public Decimal HierarchyActualCost{get;set;}
        public Decimal HierarchyBudgetedCost{get;set;}
        public Double NumberOfContacts{get;set;}
        public Double HierarchyNumberOfContacts{get;set;}
        public Double HierarchyNumberOfConvertedLeads{get;set;}
        public Decimal HierarchyExpectedRevenue{get;set;}
        public Double NumberOfLeads{get;set;}
        public Double HierarchyNumberOfLeads{get;set;}
        public Double HierarchyNumberSent{get;set;}
        public Double HierarchyNumberOfOpportunities{get;set;}
        public Double NumberOfResponses{get;set;}
        public Double HierarchyNumberOfResponses{get;set;}
        public Decimal AmountAllOpportunities{get;set;}
        public Decimal HierarchyAmountAllOpportunities{get;set;}
        public Decimal AmountWonOpportunities{get;set;}
        public Decimal HierarchyAmountWonOpportunities{get;set;}
        public Double HierarchyNumberOfWonOpportunities{get;set;}
    }
}