Public Class CampaignSubProgram{
    Public List<Campaign> lstCampaign{get;set;}
    Public List<Campaign> lstCampaignDatatable{get;set;}
    Public List<String> lstSelectedFields{get;set;}
    Public String SelectedFields{get;set;}
    //Public String title{get;set;}
    Public String ProgramTitle{get;set;}
    Public String ParentProgramTitle{get;set;}
    Public Integer SubPrograms{get;set;}
    Public boolean blnMain{get;set;}
    Public boolean blnDetail{get;set;}
    Public String Table{get;set;}
    Public Campaign objCampaign{get;set;}
    sObject sCampaign;
    Public List<Campaign> SubProgramUpdateList{ get; set; }
    
    public User u;
    public Boolean SourceCodeFormEdit1{get;set;}
    public Boolean SourceCodeFormEdit2{get;set;}
    public Boolean SourceCodeFormEdit3{get;set;}
    public Boolean SourceCodeFormEdit4{get;set;}
    public Boolean SourceCodeFormEdit5{get;set;}
    public Boolean SourceCodeFormEdit6{get;set;}
    public Boolean SourceCodeFormEdit7{get;set;}
    public Boolean SourceCodeFormEdit8{get;set;}
    public Boolean SourceCodeFormEdit9{get;set;}
    public Boolean SourceCodeFormEdit10{get;set;}
    public Boolean SourceCodeFormEdit11{get;set;}
    public Boolean SourceCodeFormEdit12{get;set;}

    List<Campaign> SubProgramDeleteList = new List<Campaign>();
    List<Campaign> SubProgramUpsertList = new List<Campaign>();
    Set<ID> SubProgramDeleteIds = new Set<ID>();
    
    public CampaignSubProgram(ApexPages.StandardController controller) {
        
        objCampaignList1 = new Campaign();      
        objCampaignList2 = new Campaign();                
        objCampaignList3 = new Campaign();       
        objCampaignList4 = new Campaign();        
        objCampaignList5 = new Campaign();        
        objCampaignList6 = new Campaign();       
        objCampaignList7 = new Campaign();        
        objCampaignList8 = new Campaign();        
        objCampaignList9 = new Campaign();       
        objCampaignList10 = new Campaign();       
        objCampaignList11 = new Campaign();       
        objCampaignList12 = new Campaign();       
        
        objCampaign = (Campaign)controller.getRecord();
        objCampaign.parentid = objCampaign.id;
    
        SourceCodeFormEdit1 = true;
        SourceCodeFormEdit2 = true;
        SourceCodeFormEdit3 = true;
        SourceCodeFormEdit4 = true;
        SourceCodeFormEdit5 = true;
        SourceCodeFormEdit6 = true;
        SourceCodeFormEdit7 = true;
        SourceCodeFormEdit8 = true;
        SourceCodeFormEdit9 = true;
        SourceCodeFormEdit10 = true;
        SourceCodeFormEdit11 = true;
        SourceCodeFormEdit12 = true;
        
               
        u = [Select Id, Profile.Name from User where Id =: System.Userinfo.getUserId()];        
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
            
        SubProgramUpdateList= [Select ID,Parentid,Parent.Name,Name,Product_Program__c,Campaign_Name__c,Campaign_Description__c,
                               Financial_segment_Level1__c,Program_Count__c,Campaign.Giving_Segment__c,Station__c,Solicitation_Type__c,Effort_for_Project__c,
                               Status,IsActive,Channel_Technique__c,Industry_Sub_Category__c,Sub_Channel__c,Industry__c,Category__c,Job__c,Creative_Package__c,
                               Offer_Message__c,Response_Mechanism__c,Designation__c,Support_Designation__c,Override_Gift__c,WGBH_Accounting_Unit__c,WGBH_AUAC__c,Audience_Segment__c,Segment_Age_Range__c,Segment_Gender__c,Segment_Notes__c,Cost_Per_X__c,Ttl_Cost__c,
                               Email_Response__c,Web_Inbound__c,Inbound_Calls__c,ROI__c,Start_Time_Date__c,End_Time_Date__c,
                               Prime_Time_Selected__c,Show_Breaks__c,Break_Challenges__c,Placement__c,
                               ProgramBreak_StartDateTime__c,ProgramBreak_EndDateTime__c,Source_Code__c,CDP_Grouping__c,
                               CDP_Grouping_Code__c,Break_Actual_Duration__c,List_File_Code__c,List_File_Name__c,Drop_Date_and_Time__c,
                               Drop_Quantity__c,Package_Code__c,Package_Description__c,TV_Radio_Show_Program__c,
                               Audience_Goal__c,Revenue_Goal__c,Net_Goal__c,TV_Radio_Show_Program__r.Name               
                               from Campaign Where Parentid=:ApexPages.currentPage().getParameters().get('Id') ORDER BY ID];
            SubPrograms = SubProgramUpdateList.size(); 
            if(SubProgramUpdateList.size() > 0){
                blnMain = false;
                blnDetail = true;
                lstCampaignDatatable= new List<Campaign>();       
                lstCampaignDatatable.add(new Campaign(Name='Campaign')); 
                
                if(SubProgramUpdateList.size() == 1){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                }
                if(SubProgramUpdateList.size() == 2){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                     SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                }
                if(SubProgramUpdateList.size() == 3){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }                    
                }
                if(SubProgramUpdateList.size() == 4){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                }
                if(SubProgramUpdateList.size() == 5){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                }
                if(SubProgramUpdateList.size() == 6){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                }                
                if(SubProgramUpdateList.size() == 7){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                }
                
                if(SubProgramUpdateList.size() == 8){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;                    
                    objCampaignList8 = new Campaign();
                    objCampaignList8 = SubProgramUpdateList[7];
                    objCampaignList8Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                    SourceCodeFormEdit8 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList8.IsActive == true && objCampaignList8.Status == 'In Progress') {
                        SourceCodeFormEdit8 = true;                
                    }
                }
                
                if(SubProgramUpdateList.size() == 9){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;                    
                    objCampaignList8 = new Campaign();
                    objCampaignList8 = SubProgramUpdateList[7];
                    objCampaignList8Display = true;                    
                    objCampaignList9 = new Campaign();
                    objCampaignList9 = SubProgramUpdateList[8];
                    objCampaignList9Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                    SourceCodeFormEdit8 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList8.IsActive == true && objCampaignList8.Status == 'In Progress') {
                        SourceCodeFormEdit8 = true;                
                    }
                    SourceCodeFormEdit9 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList9.IsActive == true && objCampaignList9.Status == 'In Progress') {
                        SourceCodeFormEdit9 = true;                
                    }
                }
                
                if(SubProgramUpdateList.size() == 10){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;                    
                    objCampaignList8 = new Campaign();
                    objCampaignList8 = SubProgramUpdateList[7];
                    objCampaignList8Display = true;                    
                    objCampaignList9 = new Campaign();
                    objCampaignList9 = SubProgramUpdateList[8];
                    objCampaignList9Display = true;                    
                    objCampaignList10 = new Campaign();
                    objCampaignList10 = SubProgramUpdateList[9];
                    objCampaignList10Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                    SourceCodeFormEdit8 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList8.IsActive == true && objCampaignList8.Status == 'In Progress') {
                        SourceCodeFormEdit8 = true;                
                    }
                    SourceCodeFormEdit9 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList9.IsActive == true && objCampaignList9.Status == 'In Progress') {
                        SourceCodeFormEdit9 = true;                
                    }
                    SourceCodeFormEdit10 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList10.IsActive == true && objCampaignList10.Status == 'In Progress') {
                        SourceCodeFormEdit10 = true;                
                    }
                }
                
                if(SubProgramUpdateList.size() == 11){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;                    
                    objCampaignList8 = new Campaign();
                    objCampaignList8 = SubProgramUpdateList[7];
                    objCampaignList8Display = true;                    
                    objCampaignList9 = new Campaign();
                    objCampaignList9 = SubProgramUpdateList[8];
                    objCampaignList9Display = true;                    
                    objCampaignList10 = new Campaign();
                    objCampaignList10 = SubProgramUpdateList[9];
                    objCampaignList10Display = true;                    
                    objCampaignList11 = new Campaign();
                    objCampaignList11 = SubProgramUpdateList[10];
                    objCampaignList11Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                    SourceCodeFormEdit8 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList8.IsActive == true && objCampaignList8.Status == 'In Progress') {
                        SourceCodeFormEdit8 = true;                
                    }
                    SourceCodeFormEdit9 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList9.IsActive == true && objCampaignList9.Status == 'In Progress') {
                        SourceCodeFormEdit9 = true;                
                    }
                    SourceCodeFormEdit10 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList10.IsActive == true && objCampaignList10.Status == 'In Progress') {
                        SourceCodeFormEdit10 = true;                
                    }
                    SourceCodeFormEdit11 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList11.IsActive == true && objCampaignList11.Status == 'In Progress') {
                        SourceCodeFormEdit11 = true;                
                    }
                }
                
                if(SubProgramUpdateList.size() == 12){                
                    objCampaignList1 = new Campaign();
                    objCampaignList1 = SubProgramUpdateList[0];
                    objCampaignList1Display = true;
                    objCampaignList2 = new Campaign();
                    objCampaignList2 = SubProgramUpdateList[1];
                    objCampaignList2Display = true;
                    objCampaignList3 = new Campaign();
                    objCampaignList3 = SubProgramUpdateList[2];
                    objCampaignList3Display = true;
                    objCampaignList4 = new Campaign();
                    objCampaignList4 = SubProgramUpdateList[3];
                    objCampaignList4Display = true;
                    objCampaignList5 = new Campaign();
                    objCampaignList5 = SubProgramUpdateList[4];
                    objCampaignList5Display = true;
                    objCampaignList6 = new Campaign();
                    objCampaignList6 = SubProgramUpdateList[5];
                    objCampaignList6Display = true;                    
                    objCampaignList7 = new Campaign();
                    objCampaignList7 = SubProgramUpdateList[6];
                    objCampaignList7Display = true;                    
                    objCampaignList8 = new Campaign();
                    objCampaignList8 = SubProgramUpdateList[7];
                    objCampaignList8Display = true;                    
                    objCampaignList9 = new Campaign();
                    objCampaignList9 = SubProgramUpdateList[8];
                    objCampaignList9Display = true;                    
                    objCampaignList10 = new Campaign();
                    objCampaignList10 = SubProgramUpdateList[9];
                    objCampaignList10Display = true;                    
                    objCampaignList11 = new Campaign();
                    objCampaignList11 = SubProgramUpdateList[10];
                    objCampaignList11Display = true;                    
                    objCampaignList12 = new Campaign();
                    objCampaignList12 = SubProgramUpdateList[11];
                    objCampaignList12Display = true;
                    SourceCodeFormEdit1 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList1.IsActive == true && objCampaignList1.Status == 'In Progress') {
                        SourceCodeFormEdit1 = true;                
                    }
                    SourceCodeFormEdit2 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList2.IsActive == true && objCampaignList2.Status == 'In Progress') {
                        SourceCodeFormEdit2 = true;                
                    }
                    SourceCodeFormEdit3 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList3.IsActive == true && objCampaignList3.Status == 'In Progress') {
                        SourceCodeFormEdit3 = true;                
                    }
                    SourceCodeFormEdit4 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList4.IsActive == true && objCampaignList4.Status == 'In Progress') {
                        SourceCodeFormEdit4 = true;                
                    }
                    SourceCodeFormEdit5 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList5.IsActive == true && objCampaignList5.Status == 'In Progress') {
                        SourceCodeFormEdit5 = true;                
                    }
                    SourceCodeFormEdit6 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList6.IsActive == true && objCampaignList6.Status == 'In Progress') {
                        SourceCodeFormEdit6 = true;                
                    }
                    SourceCodeFormEdit7 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList7.IsActive == true && objCampaignList7.Status == 'In Progress') {
                        SourceCodeFormEdit7 = true;                
                    }
                    SourceCodeFormEdit8 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList8.IsActive == true && objCampaignList8.Status == 'In Progress') {
                        SourceCodeFormEdit8 = true;                
                    }
                    SourceCodeFormEdit9 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList9.IsActive == true && objCampaignList9.Status == 'In Progress') {
                        SourceCodeFormEdit9 = true;                
                    }
                    SourceCodeFormEdit10 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList10.IsActive == true && objCampaignList10.Status == 'In Progress') {
                        SourceCodeFormEdit10 = true;                
                    }
                    SourceCodeFormEdit11 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList11.IsActive == true && objCampaignList11.Status == 'In Progress') {
                        SourceCodeFormEdit11 = true;                
                    }
                    SourceCodeFormEdit12 = false;
                    if(u.Profile.Name == 'System Administrator' && objCampaignList12.IsActive == true && objCampaignList12.Status == 'In Progress') {
                        SourceCodeFormEdit12 = true;                
                    }
                }
            }
        }
        else{
            PageLoad();
        }
         ////Campaign SubProgram Count
        CamapignProgramCountParentId = [Select Name,id,ParentID,Total_Program_Count__c,Parents_Program_Count_Total__c from Campaign where 
        ID=:ApexPages.CurrentPage().getParameters().get('id')];
        
        if(CamapignProgramCountParentId.size() > 0){
        
            if(CamapignProgramCountParentId[0].ParentID != null){
            CamapignProgramCount = [Select Name,id,ParentID,Parents_Program_Count_Total__c from Campaign where 
            ID=:CamapignProgramCountParentId[0].ParentID];
                system.debug('##TotalProgramCount44->' + CamapignProgramCountParentId[0].ParentID);
                TotalProgramCount = integer.valueof(CamapignProgramCount[0].Parents_Program_Count_Total__c);
                if(CamapignProgramCount[0].Parents_Program_Count_Total__c == null){
                   TotalProgramCount = 0;     
                }
                system.debug('##TotalProgramCount1->' + TotalProgramCount);
            }
            else {
                if(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c == null){
                    TotalProgramCount = 0;
                }
                else {
                    TotalProgramCount = integer.valueof(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c);
                }                
            }     
        }
        else {
            if(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c == null){
                TotalProgramCount = 0;
                system.debug('##TotalProgramCount2->' + TotalProgramCount); 
            }
            else {
                TotalProgramCount = integer.valueof(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c);
                system.debug('##TotalProgramCount3->' + TotalProgramCount); 
            }
        }
        
        //TotalProgramCountInc = TotalProgramCount + SubPrograms;         
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
            TotalProgramCountInc = TotalProgramCount;         
        }
       
        /////End 
        
    }
    Public CampaignSubProgram(){
        //PageLoad();
        if(ApexPages.currentPage().getParameters().get('mode')=='edit'){
           
        }
        else{
            PageLoad();
        }
    }
    Public void PageLoad(){
        blnMain = true;
        blnDetail = false;      
        //title = 'Sub-Programs';
        //LoadDefaultFields();
        lstCampaign = new List<Campaign>();
        lstSelectedFields = new List<String>();
    }
    public Boolean chkProgramTitle{get;set;}
    public Boolean chkParentProgramTitle{get;set;}
    public Boolean chkProduct{get;set;}
    public Boolean chkCampaign{get;set;}
    public Boolean chkCampaignDesc{get;set;}
    public Boolean chkFinancialSegementL1{get;set;}
    public Boolean chkAccountUnit{get;set;}
    public Boolean chkAccountUnitActivity{get;set;}
    
    public Boolean chkGivingSegment{get;set;}
    public Boolean chkStation{get;set;}
    public Boolean chkSolicitationType{get;set;}
    public Boolean chkEffort{get;set;}
    public Boolean chkChannel{get;set;}
    public Boolean chkSubChannel{get;set;}
    
    public Boolean chkIndustry{get;set;}
    public Boolean chkCategory{get;set;}
    public Boolean chkJobNumber{get;set;}    
    public Boolean chkCreativePackage{get;set;}
    public Boolean chkOfferMessage{get;set;}
    public Boolean chkResponseMechanism{get;set;}
    public Boolean chkAudienceSegment{get;set;}
    public Boolean chkAgeRange{get;set;}
    public Boolean chkGender{get;set;}
    
    public Boolean chkSegmentNotes{get;set;}
    public Boolean chkCostPerX{get;set;}
    public Boolean chkDesignation{get;set;}
    public Boolean chkSupportDesignation{get;set;}
    public Boolean chkOverridegift{get;set;}
    public Boolean chkListFileCode{get;set;}
    public Boolean chkListFileName{get;set;}
    public Boolean chkListDropDate{get;set;}
    public Boolean chkListDropQty{get;set;}
    public Boolean chkListPackagecode{get;set;}
    public Boolean chkListPackageDesc{get;set;}
    public Boolean chkProgramBreakName{get;set;}
    public Boolean chkCDPGrouping{get;set;}
    public Boolean chkCDPGroupingCode{get;set;}
    public Boolean chkPrimeTimeSelected{get;set;}
    public Boolean chkShowBreak{get;set;}
    public Boolean chkBreakChallenges{get;set;}
    public Boolean chkProgramBreakStDate{get;set;}
    public Boolean chkProgramBreakEndDate{get;set;}
    public Boolean chkPlacement{get;set;}
    public Boolean chkBreakDuration{get;set;}
    public Boolean chkTotalCost{get;set;}
    public Boolean chkEmailResponse{get;set;}
    public Boolean chkWebInbound{get;set;}
    public Boolean chkInboundCalls{get;set;}
    public Boolean chkAudienceGoal{get;set;}
    public Boolean chkRevenueGoal{get;set;}
    public Boolean chkNetGoal{get;set;}
    
    public Boolean chkROI{get;set;}
    public Boolean chkStartDate{get;set;}
    public Boolean chkEndDate{get;set;}
    public Boolean chkStatus{get;set;}
    public Boolean chkActive{get;set;}
    
    public Boolean objCampaignList1Display{get;set;}
    public Boolean objCampaignList2Display{get;set;}
    public Boolean objCampaignList3Display{get;set;}
    public Boolean objCampaignList4Display{get;set;}
    public Boolean objCampaignList5Display{get;set;}
    public Boolean objCampaignList6Display{get;set;}
    public Boolean objCampaignList7Display{get;set;}
    public Boolean objCampaignList8Display{get;set;}
    public Boolean objCampaignList9Display{get;set;}
    public Boolean objCampaignList10Display{get;set;}
    public Boolean objCampaignList11Display{get;set;}
    public Boolean objCampaignList12Display{get;set;}
    
    public Boolean objCampaignList1IsDelete{get;set;}
    public Boolean objCampaignList2IsDelete{get;set;}
    public Boolean objCampaignList3IsDelete{get;set;}
    public Boolean objCampaignList4IsDelete{get;set;}
    public Boolean objCampaignList5IsDelete{get;set;}
    public Boolean objCampaignList6IsDelete{get;set;}
    public Boolean objCampaignList7IsDelete{get;set;}
    public Boolean objCampaignList8IsDelete{get;set;}
    public Boolean objCampaignList9IsDelete{get;set;}
    public Boolean objCampaignList10IsDelete{get;set;}
    public Boolean objCampaignList11IsDelete{get;set;}
    public Boolean objCampaignList12IsDelete{get;set;}
    
    public Campaign objCampaignList1{get;set;}
    public Campaign objCampaignList2{get;set;}
    public Campaign objCampaignList3{get;set;}
    public Campaign objCampaignList4{get;set;}
    public Campaign objCampaignList5{get;set;}
    public Campaign objCampaignList6{get;set;}
    public Campaign objCampaignList7{get;set;}
    public Campaign objCampaignList8{get;set;}
    public Campaign objCampaignList9{get;set;}
    public Campaign objCampaignList10{get;set;}
    public Campaign objCampaignList11{get;set;}
    public Campaign objCampaignList12{get;set;}  
    
    public String selectedColumnRemove{get;set;}
    
     public PageReference UpdateSubProgram()                   
    {        
          PageReference UpdateCampaignSubProgram = new PageReference('/apex/CampaignSubProgram?mode=edit&id=' + ApexPages.currentPage().getParameters().get('Id')); 
          UpdateCampaignSubProgram.setRedirect(true);       
          return UpdateCampaignSubProgram;    
    }
     /* begin AddSubProgram*/
    public void SubProgramAdd()
    {         
        
        
        
        if(SubPrograms <= 12){
                      
           if(SubPrograms == 1){
               objCampaignList2 = new Campaign();
               objCampaignList2.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList2 = objCampaign.clone(false,true);
               objCampaignList2.Name = objCampaign.Name;               
               //objCampaignList2.Program_Count__c='002';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList2.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList2.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList2Display = true;               
           }
           if(SubPrograms == 2){
               objCampaignList3 = new Campaign();
               objCampaignList3.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList3 = objCampaign.clone(false,true);
               objCampaignList3.Name = objCampaign.Name;
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList3.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList3.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList3Display = true;              
           }
           if(SubPrograms == 3){
               objCampaignList4 = new Campaign();
               objCampaignList4.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList4 = objCampaign.clone(false,true);
               objCampaignList4.Name = objCampaign.Name;
               //objCampaignList4.Program_Count__c='004';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList4.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList4.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList4Display = true;               
           }
           if(SubPrograms == 4){
               objCampaignList5 = new Campaign();
               objCampaignList5.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList5 = objCampaign.clone(false,true);
               objCampaignList5.Name = objCampaign.Name;
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList5.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList5.Program_Count__c='0'+ TotalProgramCountInc;
               }
               //objCampaignList5.Program_Count__c='005';
               objCampaignList5Display = true;               
           }
           if(SubPrograms == 5){
               objCampaignList6 = new Campaign();
               objCampaignList6.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList6 = objCampaign.clone(false,true);
               objCampaignList6.Name = objCampaign.Name;
               //objCampaignList6.Program_Count__c='006';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList6.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList6.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList6Display = true;               
           }
           if(SubPrograms == 6){
               objCampaignList7 = new Campaign();
               objCampaignList7.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList7 = objCampaign.clone(false,true);
               objCampaignList7.Name = objCampaign.Name;
               //objCampaignList7.Program_Count__c='007'; 
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList7.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList7.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList7Display = true;               
           }
           if(SubPrograms == 7){
               objCampaignList8 = new Campaign();
               objCampaignList8.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList8 = objCampaign.clone(false,true);
               objCampaignList8Display = true;
               objCampaignList8.Name = objCampaign.Name; 
               //objCampaignList8.Program_Count__c='008';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList8.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList8.Program_Count__c='0'+ TotalProgramCountInc;
               }             
           }
           if(SubPrograms == 8){
               objCampaignList9 = new Campaign();
               objCampaignList9.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList9 = objCampaign.clone(false,true);
               objCampaignList9.Name = objCampaign.Name;
               //objCampaignList9.Program_Count__c='009';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList9.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList9.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList9Display = true;               
           }
           if(SubPrograms == 9){
               objCampaignList10 = new Campaign();
               objCampaignList10.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList10 = objCampaign.clone(false,true);
               objCampaignList10.Name = objCampaign.Name;
               //objCampaignList10.Program_Count__c='010';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList10.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList10.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList10Display = true;               
           }
           if(SubPrograms == 10){
               objCampaignList11 = new Campaign();
               objCampaignList11.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList11 = objCampaign.clone(false,true);
               objCampaignList11.Name = objCampaign.Name;
               //objCampaignList11.Program_Count__c='011';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList11.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList11.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList11Display = true;               
           }
           if(SubPrograms == 11){
               objCampaignList12 = new Campaign();
               objCampaignList12.ParentId = ApexPages.currentPage().getParameters().get('id');
               objCampaignList12 = objCampaign.clone(false,true);
               objCampaignList12.Name = objCampaign.Name;
               //objCampaignList12.Program_Count__c='012';
               TotalProgramCountInc = TotalProgramCountInc + 1;
               objCampaignList12.Program_Count__c='00'+ TotalProgramCountInc;
               if(TotalProgramCountInc > 9){
                   objCampaignList12.Program_Count__c='0'+ TotalProgramCountInc;
               }
               objCampaignList12Display = true;               
           }
           
           SubPrograms = Integer.valueOf(SubPrograms)+1; 
        }
    }
    /* End AddSubProgram*/

     /* begin delete */
    public void SubProgramRemove()
    {
        SubPrograms = Integer.valueOf(SubPrograms)-1;
        system.debug('##selectedColumnRemove ---->'+selectedColumnRemove);
        if(selectedColumnRemove == '1'){
            objCampaignList1IsDelete = true;
            if(objCampaignList1.Id!=null) SubProgramDeleteIds.add(objCampaignList1.Id);
            objCampaignList1 = objCampaignList2;//.clone(false,true);
            //objCampaignList1.Program_Count__c='001';
            objCampaignList2 = objCampaignList3;//.clone(false,true);
            //objCampaignList2.Program_Count__c='002';
            objCampaignList3 = objCampaignList4;//.clone(false,true);
            //objCampaignList3.Program_Count__c='003';
            objCampaignList4 = objCampaignList5;//.clone(false,true);
            //objCampaignList4.Program_Count__c='004';
            objCampaignList5 = objCampaignList6;//.clone(false,true);
            //objCampaignList5.Program_Count__c='005';
            
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';
            //objCampaignList6 = null;
            //TotalProgramCountInc = TotalProgramCountInc - 1;       
        }
        if(selectedColumnRemove == '2'){            
            objCampaignList2IsDelete = true;
            if(objCampaignList2.Id!=null) SubProgramDeleteIds.add(objCampaignList2.Id);
            objCampaignList2 = objCampaignList3;//.clone(false,true);
            //objCampaignList2.Program_Count__c='002';
            objCampaignList3 = objCampaignList4;//.clone(false,true);
            //objCampaignList3.Program_Count__c='003';
            objCampaignList4 = objCampaignList5;//.clone(false,true);
            ////objCampaignList4.Program_Count__c='004';
            objCampaignList5 = objCampaignList6;//.clone(false,true);
            //objCampaignList5.Program_Count__c='005';
            
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';
        }
        if(selectedColumnRemove == '3'){
            objCampaignList3IsDelete = true;
            if(objCampaignList3.Id!=null) SubProgramDeleteIds.add(objCampaignList3.Id);
            objCampaignList3 = objCampaignList4;//.clone(false,true);
            //objCampaignList3.Program_Count__c='003';
            objCampaignList4 = objCampaignList5;//.clone(false,true);
            //objCampaignList4.Program_Count__c='004';
            objCampaignList5 = objCampaignList6;//.clone(false,true);
            //objCampaignList5.Program_Count__c='005';
            
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';
       
        }
        if(selectedColumnRemove == '4'){
            objCampaignList4IsDelete = true;
            if(objCampaignList4.Id!=null) SubProgramDeleteIds.add(objCampaignList4.Id);
            
            objCampaignList4 = objCampaignList5;//.clone(false,true);
            //objCampaignList4.Program_Count__c='004';
            objCampaignList5 = objCampaignList6;//.clone(false,true);
            //objCampaignList5.Program_Count__c='005';
            
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';
        }
        if(selectedColumnRemove == '5'){
            objCampaignList5IsDelete = true;
            if(objCampaignList5.Id!=null) SubProgramDeleteIds.add(objCampaignList5.Id);
            
            objCampaignList5 = objCampaignList6;//.clone(false,true);
            //objCampaignList5.Program_Count__c='005';
          
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';
        }
        
        if(selectedColumnRemove == '6'){
            objCampaignList6IsDelete = true;
            if(objCampaignList6.Id!=null) SubProgramDeleteIds.add(objCampaignList6.Id); 
            
            objCampaignList6 = objCampaignList7;//.clone(false,true);
            //objCampaignList6.Program_Count__c='006';
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';             
        }
        
        if(selectedColumnRemove == '7'){
            objCampaignList7IsDelete = true;
            if(objCampaignList7.Id!=null) SubProgramDeleteIds.add(objCampaignList7.Id);  
            
            objCampaignList7 = objCampaignList8;//.clone(false,true);
            //objCampaignList7.Program_Count__c='007';
            objCampaignList8 = objCampaignList9;//.clone(false,true);
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';             


        }
        
        if(selectedColumnRemove == '8'){
            objCampaignList8IsDelete = true;
            if(objCampaignList8.Id!=null) SubProgramDeleteIds.add(objCampaignList8.Id);  
            
            //objCampaignList8.Program_Count__c='008';
            objCampaignList9 = objCampaignList10;//.clone(false,true);
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';               
        }
        
        if(selectedColumnRemove == '9'){
            objCampaignList9IsDelete = true;
            if(objCampaignList9.Id!=null) SubProgramDeleteIds.add(objCampaignList9.Id);  
            
            //objCampaignList9.Program_Count__c='009';
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';             
        }
        
        if(selectedColumnRemove == '10'){
            objCampaignList10IsDelete = true;
            if(objCampaignList10.Id!=null) SubProgramDeleteIds.add(objCampaignList10.Id);
            
            objCampaignList10 = objCampaignList11;//.clone(false,true);
            //objCampaignList10.Program_Count__c='010';
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';            
        }
        
        if(selectedColumnRemove == '11'){
            objCampaignList11IsDelete = true;
            if(objCampaignList11.Id!=null) SubProgramDeleteIds.add(objCampaignList11.Id);
            
            objCampaignList11 = objCampaignList12;//.clone(false,true);
            //objCampaignList11.Program_Count__c='011';             
        }
         if(selectedColumnRemove == '12'){
            objCampaignList12IsDelete = true;
            if(objCampaignList12.Id!=null) SubProgramDeleteIds.add(objCampaignList12.Id);
        }
              
        if(SubPrograms == 1){
            objCampaignList1Display = true;
            objCampaignList2Display = false;
            objCampaignList3Display = false;
            objCampaignList4Display = false;
            objCampaignList5Display = false;
            objCampaignList6Display = false;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;              
        }
        if(SubPrograms == 2){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = false;
            objCampaignList4Display = false;
            objCampaignList5Display = false;
            objCampaignList6Display = false;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        if(SubPrograms == 3){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = false;
            objCampaignList5Display = false;
            objCampaignList6Display = false;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        if(SubPrograms == 4){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = false;
            objCampaignList6Display = false;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        if(SubPrograms == 5){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;           
            objCampaignList6Display = false;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        if(SubPrograms == 6){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = false;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        
        if(SubPrograms == 7){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = false;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        
        if(SubPrograms == 8){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = true;
            objCampaignList9Display = false;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        
        if(SubPrograms == 9){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = true;
            objCampaignList9Display = true;
            objCampaignList10Display = false;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        } 
        
        if(SubPrograms == 10){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = true;
            objCampaignList9Display = true;
            objCampaignList10Display = true;
            objCampaignList11Display = false;
            objCampaignList12Display = false;
        }
        
        if(SubPrograms == 11){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = true;
            objCampaignList9Display = true;
            objCampaignList10Display = true;
            objCampaignList11Display = true;
            objCampaignList12Display = false;
        }
        
        if(SubPrograms == 12){
            objCampaignList1Display = true;
            objCampaignList2Display = true;
            objCampaignList3Display = true;
            objCampaignList4Display = true;
            objCampaignList5Display = true;
            objCampaignList6Display = true;            
            objCampaignList7Display = true;
            objCampaignList8Display = true;
            objCampaignList9Display = true;
            objCampaignList10Display = true;
            objCampaignList11Display = true;
            objCampaignList12Display = true;
        }        
                
    }/*End del*/
    public Integer TotalProgramCount{get;set;}
    public Integer TotalProgramCountInc{get;set;}
    Public List<Campaign>  CamapignProgramCount{ get; set; }
    Public List<Campaign>  CamapignProgramCountParentId{ get; set; }
    Public List<Campaign>  CamapignProgramCountParent{ get; set; }    
    Public PageReference CreateSubProgram(){
        blnMain = false;
        blnDetail = true;        
        lstCampaignDatatable= new List<Campaign>();
         
        //CamapignProgramCount = [Select Name,id,ParentID,Total_Program_Count__c from Campaign where 
        //ParentID=:ApexPages.CurrentPage().getParameters().get('id') OR parent.ParentID=:ApexPages.CurrentPage().getParameters().get('id')];
        
        CamapignProgramCountParentId = [Select Name,id,ParentID,Total_Program_Count__c,Parents_Program_Count_Total__c from Campaign where 
        ID=:ApexPages.CurrentPage().getParameters().get('id')];
        
        if(CamapignProgramCountParentId.size() > 0){
        
            if(CamapignProgramCountParentId[0].ParentID != null){
            CamapignProgramCount = [Select Name,id,ParentID,Parents_Program_Count_Total__c from Campaign where 
            ID=:CamapignProgramCountParentId[0].ParentID];
                system.debug('##TotalProgramCount44->' + CamapignProgramCountParentId[0].ParentID);
                TotalProgramCount = integer.valueof(CamapignProgramCount[0].Parents_Program_Count_Total__c);
                if(CamapignProgramCount[0].Parents_Program_Count_Total__c == null){
                   TotalProgramCount = 0;     
                }
                //system.debug('##TotalProgramCount1->' + TotalProgramCount);
            }
            else {
                if(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c == null){
                    TotalProgramCount = 0;
                }
                else {
                    TotalProgramCount = integer.valueof(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c);
                }                
            }     
        }
        else {
            if(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c == null){
                TotalProgramCount = 0;
                //system.debug('##TotalProgramCount2->' + TotalProgramCount); 
            }
            else {
                TotalProgramCount = integer.valueof(CamapignProgramCountParentId[0].Parents_Program_Count_Total__c);
                //system.debug('##TotalProgramCount3->' + TotalProgramCount); 
            }
        }
        
        
        //CamapignProgramCountParent = [Select Name,id,Total_Program_Count__c from Campaign where 
        //parent.ParentID=:CamapignProgramCountParentId[0].ParentID];                                                                                                           
      //TotalProgramCount = 0;
        //TotalProgramCount = integer.valueof(CamapignProgramCount[0].Parents_Program_Count_Total__c);          
        TotalProgramCountInc = TotalProgramCount + SubPrograms;          
        
        system.debug('##TotalProgramCount' + TotalProgramCount);
        system.debug('##TotalProgramCountq' + TotalProgramCountInc);    
        lstCampaignDatatable.add(new Campaign(Name='Campaign'));             
               
            objCampaignList1 = new Campaign();
            objCampaignList1 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){
                objCampaignList1.Program_Count__c='0'+ string.valueof(TotalProgramCount + 1);                
            }
            else {
                objCampaignList1.Program_Count__c='00'+ string.valueof(TotalProgramCount + 1);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 1 > 9){
                    objCampaignList1.Program_Count__c='0'+ string.valueof(TotalProgramCount + 1);
                }                
            }
            objCampaignList2 = new Campaign();
            objCampaignList2 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){
                objCampaignList2.Program_Count__c='0'+ string.valueof(TotalProgramCount + 2);                
            }
            else {
                objCampaignList2.Program_Count__c='00'+ string.valueof(TotalProgramCount + 2);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 2 > 9){
                    objCampaignList2.Program_Count__c='0'+ string.valueof(TotalProgramCount + 2);
                }                 
            }         
            objCampaignList3 = new Campaign();            
            objCampaignList3 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){           
                objCampaignList3.Program_Count__c='0'+ string.valueof(TotalProgramCount + 3);                
            }
            else {
                objCampaignList3.Program_Count__c='00'+ string.valueof(TotalProgramCount + 3);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 3 > 9){
                    objCampaignList3.Program_Count__c='0'+ string.valueof(TotalProgramCount + 3);
                }                
            }
            objCampaignList4 = new Campaign();
            objCampaignList4 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){            
                objCampaignList4.Program_Count__c='0'+ string.valueof(TotalProgramCount + 4);                
            }
            else {
                objCampaignList4.Program_Count__c='00'+ string.valueof(TotalProgramCount + 4);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 4 > 9){
                    objCampaignList4.Program_Count__c='0'+ string.valueof(TotalProgramCount + 4);
                }                
            }
            
            objCampaignList5 = new Campaign();
            objCampaignList5 = objCampaign.clone(false,true);
            
            if(TotalProgramCount > 9){               
                objCampaignList5.Program_Count__c='0'+ string.valueof(TotalProgramCount + 5);                
            }
            else {
                objCampaignList5.Program_Count__c='00'+ string.valueof(TotalProgramCount + 5);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 5 > 9){
                    objCampaignList5.Program_Count__c='0'+ string.valueof(TotalProgramCount + 5);
                }                
            }
            
            objCampaignList6 = new Campaign();
            objCampaignList6 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){            
                objCampaignList6.Program_Count__c='0'+ string.valueof(TotalProgramCount + 6);
            }
            else {
                objCampaignList6.Program_Count__c='00'+ string.valueof(TotalProgramCount + 6);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 6 > 9){
                    objCampaignList6.Program_Count__c='0'+ string.valueof(TotalProgramCount + 6);
                }
            }
            
            objCampaignList7 = new Campaign();
            objCampaignList7 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){                
                objCampaignList7.Program_Count__c='0'+ string.valueof(TotalProgramCount + 7);
            }
            else {
                objCampaignList7.Program_Count__c='00'+ string.valueof(TotalProgramCount + 7);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 7 > 9){
                    objCampaignList7.Program_Count__c='0'+ string.valueof(TotalProgramCount + 7);
                }
            }
            objCampaignList8 = new Campaign();
            objCampaignList8 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){                
                objCampaignList8.Program_Count__c='0'+ string.valueof(TotalProgramCount + 8);
            }
            else {
                objCampaignList8.Program_Count__c='00'+ string.valueof(TotalProgramCount + 8);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 8 > 9){
                    objCampaignList8.Program_Count__c='0'+ string.valueof(TotalProgramCount + 8);
                }
            }
            
            objCampaignList9 = new Campaign();
            objCampaignList9 = objCampaign.clone(false,true);
            if(TotalProgramCount > 9){            
                objCampaignList9.Program_Count__c='0'+ string.valueof(TotalProgramCount + 9);
            }
            else {
                objCampaignList9.Program_Count__c='00'+ string.valueof(TotalProgramCount + 9);
                if(TotalProgramCountInc > 9 && TotalProgramCount + 9 > 9){
                    objCampaignList9.Program_Count__c='0'+ string.valueof(TotalProgramCount + 9);
                }
            }
            objCampaignList10 = new Campaign();
            objCampaignList10 = objCampaign.clone(false,true);            
            objCampaignList10.Program_Count__c='0'+ string.valueof(TotalProgramCount + 10);
            
            objCampaignList11 = new Campaign();
            objCampaignList11 = objCampaign.clone(false,true);            
            objCampaignList11.Program_Count__c='0'+ string.valueof(TotalProgramCount + 11);
            
            objCampaignList12 = new Campaign();
            objCampaignList12 = objCampaign.clone(false,true);            
            objCampaignList12.Program_Count__c='0'+ string.valueof(TotalProgramCount + 12);
            
                
            if(chkProgramTitle == false){
                objCampaignList1.Name ='';
                objCampaignList2.Name ='';
                objCampaignList3.Name ='';
                objCampaignList4.Name ='';
                objCampaignList5.Name ='';
                objCampaignList6.Name ='';                
                objCampaignList7.Name =''; 
                objCampaignList8.Name =''; 
                objCampaignList9.Name =''; 
                objCampaignList10.Name =''; 
                objCampaignList11.Name =''; 
                objCampaignList12.Name ='';     
            }
            if(chkProduct == false){
                objCampaignList1.Product_Program__c ='';
                objCampaignList2.Product_Program__c ='';
                objCampaignList3.Product_Program__c ='';
                objCampaignList4.Product_Program__c ='';
                objCampaignList5.Product_Program__c ='';
                objCampaignList6.Product_Program__c ='';                
                objCampaignList7.Product_Program__c ='';
                objCampaignList8.Product_Program__c ='';
                objCampaignList9.Product_Program__c ='';
                objCampaignList10.Product_Program__c ='';
                objCampaignList11.Product_Program__c ='';
                objCampaignList12.Product_Program__c ='';                 
            }
            if(chkCampaign == false){
                objCampaignList1.Campaign_Name__c =''; 
                objCampaignList2.Campaign_Name__c ='';
                objCampaignList3.Campaign_Name__c ='';
                objCampaignList4.Campaign_Name__c ='';
                objCampaignList5.Campaign_Name__c ='';
                objCampaignList6.Campaign_Name__c ='';                
                objCampaignList7.Campaign_Name__c ='';
                objCampaignList8.Campaign_Name__c ='';
                objCampaignList9.Campaign_Name__c ='';
                objCampaignList10.Campaign_Name__c ='';
                objCampaignList11.Campaign_Name__c ='';
                objCampaignList12.Campaign_Name__c ='';
            }
            if(chkCampaignDesc == false){
                objCampaignList1.Campaign_Description__c ='';
                objCampaignList2.Campaign_Description__c ='';
                objCampaignList3.Campaign_Description__c ='';
                objCampaignList4.Campaign_Description__c ='';
                objCampaignList5.Campaign_Description__c ='';
                objCampaignList6.Campaign_Description__c ='';                
                objCampaignList7.Campaign_Description__c ='';
                objCampaignList8.Campaign_Description__c ='';
                objCampaignList9.Campaign_Description__c ='';
                objCampaignList10.Campaign_Description__c ='';
                objCampaignList11.Campaign_Description__c ='';
                objCampaignList12.Campaign_Description__c =''; 
            }
            if(chkFinancialSegementL1 == false){
                objCampaignList1.Financial_segment_Level1__c ='';
                objCampaignList2.Financial_segment_Level1__c ='';
                objCampaignList3.Financial_segment_Level1__c ='';
                objCampaignList4.Financial_segment_Level1__c ='';
                objCampaignList5.Financial_segment_Level1__c ='';
                objCampaignList6.Financial_segment_Level1__c ='';                
                objCampaignList7.Financial_segment_Level1__c ='';
                objCampaignList8.Financial_segment_Level1__c ='';
                objCampaignList9.Financial_segment_Level1__c ='';
                objCampaignList10.Financial_segment_Level1__c ='';
                objCampaignList11.Financial_segment_Level1__c ='';
                objCampaignList12.Financial_segment_Level1__c =''; 
            }
            
            if(chkAccountUnit == false){
                objCampaignList1.WGBH_Accounting_Unit__c =null;
                objCampaignList2.WGBH_Accounting_Unit__c =null;
                objCampaignList3.WGBH_Accounting_Unit__c =null;
                objCampaignList4.WGBH_Accounting_Unit__c =null;
                objCampaignList5.WGBH_Accounting_Unit__c =null;
                objCampaignList6.WGBH_Accounting_Unit__c =null;                
                objCampaignList7.WGBH_Accounting_Unit__c =null;
                objCampaignList8.WGBH_Accounting_Unit__c =null;
                objCampaignList9.WGBH_Accounting_Unit__c =null;
                objCampaignList10.WGBH_Accounting_Unit__c =null;
                objCampaignList11.WGBH_Accounting_Unit__c =null;
                objCampaignList12.WGBH_Accounting_Unit__c =null; 
            }
            
            if(chkAccountUnitActivity == false){
                objCampaignList1.WGBH_AUAC__c =null;
                objCampaignList2.WGBH_AUAC__c =null;
                objCampaignList3.WGBH_AUAC__c =null;
                objCampaignList4.WGBH_AUAC__c =null;
                objCampaignList5.WGBH_AUAC__c =null;
                objCampaignList6.WGBH_AUAC__c =null;                
                objCampaignList7.WGBH_AUAC__c =null;
                objCampaignList8.WGBH_AUAC__c =null;
                objCampaignList9.WGBH_AUAC__c =null;
                objCampaignList10.WGBH_AUAC__c =null;
                objCampaignList11.WGBH_AUAC__c =null;
                objCampaignList12.WGBH_AUAC__c =null;
            }            
            
            if(chkGivingSegment == false){
                objCampaignList1.Giving_Segment__c ='';
                objCampaignList2.Giving_Segment__c ='';
                objCampaignList3.Giving_Segment__c ='';
                objCampaignList4.Giving_Segment__c ='';
                objCampaignList5.Giving_Segment__c ='';
                objCampaignList6.Giving_Segment__c ='';                
                objCampaignList7.Giving_Segment__c ='';
                objCampaignList8.Giving_Segment__c ='';
                objCampaignList9.Giving_Segment__c ='';
                objCampaignList10.Giving_Segment__c ='';
                objCampaignList11.Giving_Segment__c ='';
                objCampaignList12.Giving_Segment__c ='';                 
            }
            if(chkStation == false){
                objCampaignList1.Station__c ='';
                objCampaignList2.Station__c ='';
                objCampaignList3.Station__c ='';
                objCampaignList4.Station__c ='';
                objCampaignList5.Station__c ='';
                objCampaignList6.Station__c ='';                
                objCampaignList7.Station__c ='';
                objCampaignList8.Station__c ='';
                objCampaignList9.Station__c ='';
                objCampaignList10.Station__c ='';
                objCampaignList11.Station__c ='';
                objCampaignList12.Station__c ='';
            }
            if(chkSolicitationType == false){
                objCampaignList1.Solicitation_Type__c =''; 
                objCampaignList2.Solicitation_Type__c ='';
                objCampaignList3.Solicitation_Type__c ='';
                objCampaignList4.Solicitation_Type__c ='';
                objCampaignList5.Solicitation_Type__c ='';
                objCampaignList6.Solicitation_Type__c ='';                
                objCampaignList7.Solicitation_Type__c ='';
                objCampaignList8.Solicitation_Type__c ='';
                objCampaignList9.Solicitation_Type__c ='';
                objCampaignList10.Solicitation_Type__c ='';
                objCampaignList11.Solicitation_Type__c ='';
                objCampaignList12.Solicitation_Type__c ='';
            }
            if(chkEffort == false){
                objCampaignList1.Effort_for_Project__c ='';
                objCampaignList2.Effort_for_Project__c ='';
                objCampaignList3.Effort_for_Project__c ='';
                objCampaignList4.Effort_for_Project__c ='';
                objCampaignList5.Effort_for_Project__c ='';
                objCampaignList6.Effort_for_Project__c ='';                
                objCampaignList7.Effort_for_Project__c ='';
                objCampaignList8.Effort_for_Project__c ='';
                objCampaignList9.Effort_for_Project__c ='';
                objCampaignList10.Effort_for_Project__c ='';
                objCampaignList11.Effort_for_Project__c ='';
                objCampaignList12.Effort_for_Project__c ='';
            }
            if(chkChannel == false){
                objCampaignList1.Channel_Technique__c =''; 
                objCampaignList2.Channel_Technique__c ='';
                objCampaignList3.Channel_Technique__c ='';
                objCampaignList4.Channel_Technique__c ='';
                objCampaignList5.Channel_Technique__c ='';
                objCampaignList6.Channel_Technique__c ='';                
                objCampaignList7.Channel_Technique__c ='';
                objCampaignList8.Channel_Technique__c ='';
                objCampaignList9.Channel_Technique__c ='';
                objCampaignList10.Channel_Technique__c ='';
                objCampaignList11.Channel_Technique__c ='';
                objCampaignList12.Channel_Technique__c ='';
                
            }
            if(chkSubChannel == false){
                objCampaignList1.Sub_Channel__c ='';
                objCampaignList2.Sub_Channel__c ='';
                objCampaignList3.Sub_Channel__c ='';
                objCampaignList4.Sub_Channel__c ='';
                objCampaignList5.Sub_Channel__c ='';
                objCampaignList6.Sub_Channel__c ='';                
                objCampaignList7.Sub_Channel__c ='';
                objCampaignList8.Sub_Channel__c ='';
                objCampaignList9.Sub_Channel__c ='';
                objCampaignList10.Sub_Channel__c ='';
                objCampaignList11.Sub_Channel__c ='';
                objCampaignList12.Sub_Channel__c =''; 
            }
            
            if(chkIndustry == false){
                objCampaignList1.Industry__c ='';
                objCampaignList2.Industry__c ='';
                objCampaignList3.Industry__c ='';
                objCampaignList4.Industry__c ='';
                objCampaignList5.Industry__c ='';
                objCampaignList6.Industry__c ='';                
                objCampaignList7.Industry__c ='';
                objCampaignList8.Industry__c ='';
                objCampaignList9.Industry__c ='';
                objCampaignList10.Industry__c ='';
                objCampaignList11.Industry__c ='';
                objCampaignList12.Industry__c =''; 
            }
            if(chkCategory == false){
                objCampaignList1.Industry_Sub_Category__c ='';
                objCampaignList2.Industry_Sub_Category__c ='';
                objCampaignList3.Industry_Sub_Category__c ='';
                objCampaignList4.Industry_Sub_Category__c ='';
                objCampaignList5.Industry_Sub_Category__c ='';
                objCampaignList6.Industry_Sub_Category__c ='';                
                objCampaignList7.Industry_Sub_Category__c ='';
                objCampaignList8.Industry_Sub_Category__c ='';
                objCampaignList9.Industry_Sub_Category__c ='';
                objCampaignList10.Industry_Sub_Category__c ='';
                objCampaignList11.Industry_Sub_Category__c ='';
                objCampaignList12.Industry_Sub_Category__c =''; 
            }           
            if(chkJobNumber == false){
                objCampaignList1.Job__c ='';
                objCampaignList2.Job__c ='';
                objCampaignList3.Job__c ='';
                objCampaignList4.Job__c ='';
                objCampaignList5.Job__c ='';
                objCampaignList6.Job__c ='';                
                objCampaignList7.Job__c ='';
                objCampaignList8.Job__c ='';
                objCampaignList9.Job__c ='';
                objCampaignList10.Job__c ='';
                objCampaignList11.Job__c ='';
                objCampaignList12.Job__c =''; 
            }
            if(chkCreativePackage == false){
                objCampaignList1.Creative_Package__c ='';
                objCampaignList2.Creative_Package__c ='';
                objCampaignList3.Creative_Package__c ='';
                objCampaignList4.Creative_Package__c ='';
                objCampaignList5.Creative_Package__c ='';
                objCampaignList6.Creative_Package__c ='';                
                objCampaignList7.Creative_Package__c ='';
                objCampaignList8.Creative_Package__c ='';
                objCampaignList9.Creative_Package__c ='';
                objCampaignList10.Creative_Package__c ='';
                objCampaignList11.Creative_Package__c ='';
                objCampaignList12.Creative_Package__c ='';
            }
            if(chkOfferMessage == false){
                objCampaignList1.Offer_Message__c ='';
                objCampaignList2.Offer_Message__c ='';
                objCampaignList3.Offer_Message__c ='';
                objCampaignList4.Offer_Message__c ='';
                objCampaignList5.Offer_Message__c ='';
                objCampaignList6.Offer_Message__c ='';                
                objCampaignList7.Offer_Message__c ='';
                objCampaignList8.Offer_Message__c ='';
                objCampaignList9.Offer_Message__c ='';
                objCampaignList10.Offer_Message__c ='';
                objCampaignList11.Offer_Message__c ='';
                objCampaignList12.Offer_Message__c ='';           
            }
            if(chkResponseMechanism == false){
                objCampaignList1.Response_Mechanism__c ='';
                objCampaignList2.Response_Mechanism__c ='';
                objCampaignList3.Response_Mechanism__c ='';
                objCampaignList4.Response_Mechanism__c ='';
                objCampaignList5.Response_Mechanism__c ='';
                objCampaignList6.Response_Mechanism__c ='';                
                objCampaignList7.Response_Mechanism__c ='';
                objCampaignList8.Response_Mechanism__c ='';
                objCampaignList9.Response_Mechanism__c ='';
                objCampaignList10.Response_Mechanism__c ='';
                objCampaignList11.Response_Mechanism__c ='';
                objCampaignList12.Response_Mechanism__c =''; 
            }
            if(chkAudienceSegment == false){
                objCampaignList1.Audience_Segment__c ='';
                objCampaignList2.Audience_Segment__c ='';
                objCampaignList3.Audience_Segment__c ='';
                objCampaignList4.Audience_Segment__c ='';
                objCampaignList5.Audience_Segment__c ='';
                objCampaignList6.Audience_Segment__c ='';                
                objCampaignList7.Audience_Segment__c ='';
                objCampaignList8.Audience_Segment__c ='';
                objCampaignList9.Audience_Segment__c ='';
                objCampaignList10.Audience_Segment__c ='';
                objCampaignList11.Audience_Segment__c ='';
                objCampaignList12.Audience_Segment__c ='';
                 
            }
                        
            if(chkSegmentNotes == false){
                objCampaignList1.Segment_Notes__c ='';
                objCampaignList2.Segment_Notes__c ='';
                objCampaignList3.Segment_Notes__c ='';
                objCampaignList4.Segment_Notes__c ='';
                objCampaignList5.Segment_Notes__c ='';
                objCampaignList6.Segment_Notes__c ='';                
                objCampaignList7.Segment_Notes__c ='';
                objCampaignList8.Segment_Notes__c ='';
                objCampaignList9.Segment_Notes__c ='';
                objCampaignList10.Segment_Notes__c ='';
                objCampaignList11.Segment_Notes__c ='';
                objCampaignList12.Segment_Notes__c =''; 
            }
            
            if(chkDesignation == false){
                objCampaignList1.Designation__c ='';
                objCampaignList2.Designation__c ='';
                objCampaignList3.Designation__c ='';
                objCampaignList4.Designation__c ='';
                objCampaignList5.Designation__c ='';
                objCampaignList6.Designation__c ='';                
                objCampaignList7.Designation__c ='';
                objCampaignList8.Designation__c ='';
                objCampaignList9.Designation__c ='';
                objCampaignList10.Designation__c ='';
                objCampaignList11.Designation__c ='';
                objCampaignList12.Designation__c =''; 
            }
            
            if(chkSupportDesignation == false){
                objCampaignList1.Support_Designation__c ='';
                objCampaignList2.Support_Designation__c ='';
                objCampaignList3.Support_Designation__c ='';
                objCampaignList4.Support_Designation__c ='';
                objCampaignList5.Support_Designation__c ='';
                objCampaignList6.Support_Designation__c ='';                
                objCampaignList7.Support_Designation__c ='';
                objCampaignList8.Support_Designation__c ='';
                objCampaignList9.Support_Designation__c ='';
                objCampaignList10.Support_Designation__c ='';
                objCampaignList11.Support_Designation__c ='';
                objCampaignList12.Support_Designation__c =''; 
            }            
            
            if(chkOverridegift == false){
                objCampaignList1.Override_Gift__c ='';
                objCampaignList2.Override_Gift__c ='';
                objCampaignList3.Override_Gift__c ='';
                objCampaignList4.Override_Gift__c ='';
                objCampaignList5.Override_Gift__c ='';
                objCampaignList6.Override_Gift__c ='';                
                objCampaignList7.Override_Gift__c ='';
                objCampaignList8.Override_Gift__c ='';
                objCampaignList9.Override_Gift__c ='';
                objCampaignList10.Override_Gift__c ='';
                objCampaignList11.Override_Gift__c ='';
                objCampaignList12.Override_Gift__c =''; 
            }
            
             if(chkListFileCode == false){
                objCampaignList1.List_File_Code__c ='';
                objCampaignList2.List_File_Code__c ='';
                objCampaignList3.List_File_Code__c ='';
                objCampaignList4.List_File_Code__c ='';
                objCampaignList5.List_File_Code__c ='';
                objCampaignList6.List_File_Code__c ='';                
                objCampaignList7.List_File_Code__c ='';
                objCampaignList8.List_File_Code__c ='';
                objCampaignList9.List_File_Code__c ='';
                objCampaignList10.List_File_Code__c ='';
                objCampaignList11.List_File_Code__c ='';
                objCampaignList12.List_File_Code__c =''; 
            }
            
            if(chkListFileName == false){
                objCampaignList1.List_File_Name__c ='';
                objCampaignList2.List_File_Name__c ='';
                objCampaignList3.List_File_Name__c ='';
                objCampaignList4.List_File_Name__c ='';
                objCampaignList5.List_File_Name__c ='';
                objCampaignList6.List_File_Name__c ='';                
                objCampaignList7.List_File_Name__c ='';
                objCampaignList8.List_File_Name__c ='';
                objCampaignList9.List_File_Name__c ='';
                objCampaignList10.List_File_Name__c ='';
                objCampaignList11.List_File_Name__c ='';
                objCampaignList12.List_File_Name__c =''; 
            }
            
             if(chkListDropDate == false){
                objCampaignList1.Drop_Date_and_Time__c =null;
                objCampaignList2.Drop_Date_and_Time__c =null;
                objCampaignList3.Drop_Date_and_Time__c =null;
                objCampaignList4.Drop_Date_and_Time__c =null;
                objCampaignList5.Drop_Date_and_Time__c =null;
                objCampaignList6.Drop_Date_and_Time__c =null;                
                objCampaignList7.Drop_Date_and_Time__c =null;
                objCampaignList8.Drop_Date_and_Time__c =null;
                objCampaignList9.Drop_Date_and_Time__c =null;
                objCampaignList10.Drop_Date_and_Time__c =null;
                objCampaignList11.Drop_Date_and_Time__c =null;
                objCampaignList12.Drop_Date_and_Time__c =null; 
            }
            
            if(chkListDropQty == false){
                objCampaignList1.Drop_Quantity__c =null;
                objCampaignList2.Drop_Quantity__c =null;
                objCampaignList3.Drop_Quantity__c =null;
                objCampaignList4.Drop_Quantity__c =null;
                objCampaignList5.Drop_Quantity__c =null;
                objCampaignList6.Drop_Quantity__c =null;                
                objCampaignList7.Drop_Quantity__c =null;
                objCampaignList8.Drop_Quantity__c =null;
                objCampaignList9.Drop_Quantity__c =null;
                objCampaignList10.Drop_Quantity__c =null;
                objCampaignList11.Drop_Quantity__c =null;
                objCampaignList12.Drop_Quantity__c =null; 
            }
            
            if(chkListPackagecode == false){
                objCampaignList1.Package_Code__c ='';
                objCampaignList2.Package_Code__c ='';
                objCampaignList3.Package_Code__c ='';
                objCampaignList4.Package_Code__c ='';
                objCampaignList5.Package_Code__c ='';
                objCampaignList6.Package_Code__c ='';                
                objCampaignList7.Package_Code__c ='';
                objCampaignList8.Package_Code__c ='';
                objCampaignList9.Package_Code__c ='';
                objCampaignList10.Package_Code__c ='';
                objCampaignList11.Package_Code__c ='';
                objCampaignList12.Package_Code__c =''; 
            }
            
            if(chkListPackageDesc == false){
                objCampaignList1.Package_Description__c ='';
                objCampaignList2.Package_Description__c ='';
                objCampaignList3.Package_Description__c ='';
                objCampaignList4.Package_Description__c ='';
                objCampaignList5.Package_Description__c ='';
                objCampaignList6.Package_Description__c ='';                
                objCampaignList7.Package_Description__c ='';
                objCampaignList8.Package_Description__c ='';
                objCampaignList9.Package_Description__c ='';
                objCampaignList10.Package_Description__c ='';
                objCampaignList11.Package_Description__c ='';
                objCampaignList12.Package_Description__c =''; 
            }
            
             if(chkProgramBreakName == false){
                objCampaignList1.TV_Radio_Show_Program__c =null;
                objCampaignList2.TV_Radio_Show_Program__c =null;
                objCampaignList3.TV_Radio_Show_Program__c =null;
                objCampaignList4.TV_Radio_Show_Program__c =null;
                objCampaignList5.TV_Radio_Show_Program__c =null;
                objCampaignList6.TV_Radio_Show_Program__c =null;                
                objCampaignList7.TV_Radio_Show_Program__c =null;
                objCampaignList8.TV_Radio_Show_Program__c =null;
                objCampaignList9.TV_Radio_Show_Program__c =null;
                objCampaignList10.TV_Radio_Show_Program__c =null;
                objCampaignList11.TV_Radio_Show_Program__c =null;
                objCampaignList12.TV_Radio_Show_Program__c =null; 
            }
            
            if(chkCDPGrouping == false){
                objCampaignList1.CDP_Grouping__c ='';
                objCampaignList2.CDP_Grouping__c ='';
                objCampaignList3.CDP_Grouping__c ='';
                objCampaignList4.CDP_Grouping__c ='';
                objCampaignList5.CDP_Grouping__c ='';
                objCampaignList6.CDP_Grouping__c ='';                
                objCampaignList7.CDP_Grouping__c ='';
                objCampaignList8.CDP_Grouping__c ='';
                objCampaignList9.CDP_Grouping__c ='';
                objCampaignList10.CDP_Grouping__c ='';
                objCampaignList11.CDP_Grouping__c ='';
                objCampaignList12.CDP_Grouping__c =''; 
            }
            
            if(chkCDPGroupingCode == false){
                objCampaignList1.CDP_Grouping_Code__c ='';
                objCampaignList2.CDP_Grouping_Code__c ='';
                objCampaignList3.CDP_Grouping_Code__c ='';
                objCampaignList4.CDP_Grouping_Code__c ='';
                objCampaignList5.CDP_Grouping_Code__c ='';
                objCampaignList6.CDP_Grouping_Code__c ='';                
                objCampaignList7.CDP_Grouping_Code__c ='';
                objCampaignList8.CDP_Grouping_Code__c ='';
                objCampaignList9.CDP_Grouping_Code__c ='';
                objCampaignList10.CDP_Grouping_Code__c ='';
                objCampaignList11.CDP_Grouping_Code__c ='';
                objCampaignList12.CDP_Grouping_Code__c =''; 
            }
            
             if(chkPrimeTimeSelected == false){
                objCampaignList1.Prime_Time_Selected__c =false;
                objCampaignList2.Prime_Time_Selected__c =false;
                objCampaignList3.Prime_Time_Selected__c =false;
                objCampaignList4.Prime_Time_Selected__c =false;
                objCampaignList5.Prime_Time_Selected__c =false;
                objCampaignList6.Prime_Time_Selected__c =false;                
                objCampaignList7.Prime_Time_Selected__c =false;
                objCampaignList8.Prime_Time_Selected__c =false;
                objCampaignList9.Prime_Time_Selected__c =false;
                objCampaignList10.Prime_Time_Selected__c =false;
                objCampaignList11.Prime_Time_Selected__c =false;
                objCampaignList12.Prime_Time_Selected__c =false; 
            }
            
             if(chkShowBreak == false){
                objCampaignList1.Show_Breaks__c ='';
                objCampaignList2.Show_Breaks__c ='';
                objCampaignList3.Show_Breaks__c ='';
                objCampaignList4.Show_Breaks__c ='';
                objCampaignList5.Show_Breaks__c ='';
                objCampaignList6.Show_Breaks__c ='';                
                objCampaignList7.Show_Breaks__c ='';
                objCampaignList8.Show_Breaks__c ='';
                objCampaignList9.Show_Breaks__c ='';
                objCampaignList10.Show_Breaks__c ='';
                objCampaignList11.Show_Breaks__c ='';
                objCampaignList12.Show_Breaks__c =''; 
            }
            
            if(chkBreakChallenges == false){
                objCampaignList1.Break_Challenges__c ='';
                objCampaignList2.Break_Challenges__c ='';
                objCampaignList3.Break_Challenges__c ='';
                objCampaignList4.Break_Challenges__c ='';
                objCampaignList5.Break_Challenges__c ='';
                objCampaignList6.Break_Challenges__c ='';                
                objCampaignList7.Break_Challenges__c ='';
                objCampaignList8.Break_Challenges__c ='';
                objCampaignList9.Break_Challenges__c ='';
                objCampaignList10.Break_Challenges__c ='';
                objCampaignList11.Break_Challenges__c ='';
                objCampaignList12.Break_Challenges__c =''; 
            }
            
            if(chkProgramBreakStDate == false){
                objCampaignList1.ProgramBreak_StartDateTime__c =null;
                objCampaignList2.ProgramBreak_StartDateTime__c =null;
                objCampaignList3.ProgramBreak_StartDateTime__c =null;
                objCampaignList4.ProgramBreak_StartDateTime__c =null;
                objCampaignList5.ProgramBreak_StartDateTime__c =null;
                objCampaignList6.ProgramBreak_StartDateTime__c =null;                
                objCampaignList7.ProgramBreak_StartDateTime__c =null;
                objCampaignList8.ProgramBreak_StartDateTime__c =null;
                objCampaignList9.ProgramBreak_StartDateTime__c =null;
                objCampaignList10.ProgramBreak_StartDateTime__c =null;
                objCampaignList11.ProgramBreak_StartDateTime__c =null;
                objCampaignList12.ProgramBreak_StartDateTime__c =null; 
            }
            
            if(chkProgramBreakEndDate == false){
                objCampaignList1.ProgramBreak_EndDateTime__c =null;
                objCampaignList2.ProgramBreak_EndDateTime__c =null;
                objCampaignList3.ProgramBreak_EndDateTime__c =null;
                objCampaignList4.ProgramBreak_EndDateTime__c =null;
                objCampaignList5.ProgramBreak_EndDateTime__c =null;
                objCampaignList6.ProgramBreak_EndDateTime__c =null;                
                objCampaignList7.ProgramBreak_EndDateTime__c =null;
                objCampaignList8.ProgramBreak_EndDateTime__c =null;
                objCampaignList9.ProgramBreak_EndDateTime__c =null;
                objCampaignList10.ProgramBreak_EndDateTime__c =null;
                objCampaignList11.ProgramBreak_EndDateTime__c =null;
                objCampaignList12.ProgramBreak_EndDateTime__c =null; 
            }
            
            if(chkPlacement == false){
                objCampaignList1.Placement__c ='';
                objCampaignList2.Placement__c ='';
                objCampaignList3.Placement__c ='';
                objCampaignList4.Placement__c ='';
                objCampaignList5.Placement__c ='';
                objCampaignList6.Placement__c ='';                
                objCampaignList7.Placement__c ='';
                objCampaignList8.Placement__c ='';
                objCampaignList9.Placement__c ='';
                objCampaignList10.Placement__c ='';
                objCampaignList11.Placement__c ='';
                objCampaignList12.Placement__c =''; 
            }
            
            if(chkBreakDuration == false){
                objCampaignList1.Break_Actual_Duration__c ='';
                objCampaignList2.Break_Actual_Duration__c ='';
                objCampaignList3.Break_Actual_Duration__c ='';
                objCampaignList4.Break_Actual_Duration__c ='';
                objCampaignList5.Break_Actual_Duration__c ='';
                objCampaignList6.Break_Actual_Duration__c ='';                
                objCampaignList7.Break_Actual_Duration__c ='';
                objCampaignList8.Break_Actual_Duration__c ='';
                objCampaignList9.Break_Actual_Duration__c ='';
                objCampaignList10.Break_Actual_Duration__c ='';
                objCampaignList11.Break_Actual_Duration__c ='';
                objCampaignList12.Break_Actual_Duration__c =''; 
            }
            
            if(chkCostPerX == false){
                objCampaignList1.Cost_Per_X__c =null;
                objCampaignList2.Cost_Per_X__c =null; 
                objCampaignList3.Cost_Per_X__c =null; 
                objCampaignList4.Cost_Per_X__c =null; 
                objCampaignList5.Cost_Per_X__c =null; 
                objCampaignList6.Cost_Per_X__c =null;                
                objCampaignList7.Cost_Per_X__c =null;
                objCampaignList8.Cost_Per_X__c =null;
                objCampaignList9.Cost_Per_X__c =null;
                objCampaignList10.Cost_Per_X__c =null;
                objCampaignList11.Cost_Per_X__c =null;
                objCampaignList12.Cost_Per_X__c =null;  
            }
            if(chkTotalCost == false){
                objCampaignList1.Ttl_Cost__c =null;
                objCampaignList2.Ttl_Cost__c =null;
                objCampaignList3.Ttl_Cost__c =null;
                objCampaignList4.Ttl_Cost__c =null;
                objCampaignList5.Ttl_Cost__c =null;
                objCampaignList6.Ttl_Cost__c =null;                
                objCampaignList7.Ttl_Cost__c =null;
                objCampaignList8.Ttl_Cost__c =null;
                objCampaignList9.Ttl_Cost__c =null;
                objCampaignList10.Ttl_Cost__c =null;
                objCampaignList11.Ttl_Cost__c =null;
                objCampaignList12.Ttl_Cost__c =null; 
            }
            if(chkEmailResponse == false){
                objCampaignList1.Email_Response__c =null;
                objCampaignList2.Email_Response__c =null;
                objCampaignList3.Email_Response__c =null;
                objCampaignList4.Email_Response__c =null;
                objCampaignList5.Email_Response__c =null;
                objCampaignList6.Email_Response__c =null;                
                objCampaignList7.Email_Response__c =null;
                objCampaignList8.Email_Response__c =null;
                objCampaignList9.Email_Response__c =null;
                objCampaignList10.Email_Response__c =null;
                objCampaignList11.Email_Response__c =null;
                objCampaignList12.Email_Response__c =null;
            }
            if(chkWebInbound == false){
                objCampaignList1.Web_Inbound__c =null;
                objCampaignList2.Web_Inbound__c =null;
                objCampaignList3.Web_Inbound__c =null;
                objCampaignList4.Web_Inbound__c =null;
                objCampaignList5.Web_Inbound__c =null;
                objCampaignList6.Web_Inbound__c =null;                
                objCampaignList7.Web_Inbound__c =null;
                objCampaignList8.Web_Inbound__c =null;
                objCampaignList9.Web_Inbound__c =null;
                objCampaignList10.Web_Inbound__c =null;
                objCampaignList11.Web_Inbound__c =null;
                objCampaignList12.Web_Inbound__c =null; 
            }
            if(chkInboundCalls == false){
                objCampaignList1.Inbound_Calls__c =null;
                objCampaignList2.Inbound_Calls__c =null;
                objCampaignList3.Inbound_Calls__c =null;
                objCampaignList4.Inbound_Calls__c =null;
                objCampaignList5.Inbound_Calls__c =null;
                objCampaignList6.Inbound_Calls__c =null;                
                objCampaignList7.Inbound_Calls__c =null;
                objCampaignList8.Inbound_Calls__c =null;
                objCampaignList9.Inbound_Calls__c =null;
                objCampaignList10.Inbound_Calls__c =null;
                objCampaignList11.Inbound_Calls__c =null;
                objCampaignList12.Inbound_Calls__c =null;               
            }
            
            if(chkAudienceGoal == false){
                objCampaignList1.Audience_Goal__c =null;
                objCampaignList2.Audience_Goal__c =null;
                objCampaignList3.Audience_Goal__c =null;
                objCampaignList4.Audience_Goal__c =null;
                objCampaignList5.Audience_Goal__c =null;
                objCampaignList6.Audience_Goal__c =null;                
                objCampaignList7.Audience_Goal__c =null;
                objCampaignList8.Audience_Goal__c =null;
                objCampaignList9.Audience_Goal__c =null;
                objCampaignList10.Audience_Goal__c =null;
                objCampaignList11.Audience_Goal__c =null;
                objCampaignList12.Audience_Goal__c =null;               
            }
            
            if(chkRevenueGoal == false){
                objCampaignList1.Revenue_Goal__c =null;
                objCampaignList2.Revenue_Goal__c =null;
                objCampaignList3.Revenue_Goal__c =null;
                objCampaignList4.Revenue_Goal__c =null;
                objCampaignList5.Revenue_Goal__c =null;
                objCampaignList6.Revenue_Goal__c =null;                
                objCampaignList7.Revenue_Goal__c =null;
                objCampaignList8.Revenue_Goal__c =null;
                objCampaignList9.Revenue_Goal__c =null;
                objCampaignList10.Revenue_Goal__c =null;
                objCampaignList11.Revenue_Goal__c =null;
                objCampaignList12.Revenue_Goal__c =null;               
            }
            
            if(chkNetGoal == false){
                objCampaignList1.Net_Goal__c =null;
                objCampaignList2.Net_Goal__c =null;
                objCampaignList3.Net_Goal__c =null;
                objCampaignList4.Net_Goal__c =null;
                objCampaignList5.Net_Goal__c =null;
                objCampaignList6.Net_Goal__c =null;                
                objCampaignList7.Net_Goal__c =null;
                objCampaignList8.Net_Goal__c =null;
                objCampaignList9.Net_Goal__c =null;
                objCampaignList10.Net_Goal__c =null;
                objCampaignList11.Net_Goal__c =null;
                objCampaignList12.Net_Goal__c =null;               
            }
            
            if(chkROI == false){
                objCampaignList1.ROI__c ='';
                objCampaignList2.ROI__c ='';
                objCampaignList3.ROI__c ='';
                objCampaignList4.ROI__c ='';
                objCampaignList5.ROI__c ='';
                objCampaignList6.ROI__c ='';                
                objCampaignList7.ROI__c ='';
                objCampaignList8.ROI__c ='';
                objCampaignList9.ROI__c ='';
                objCampaignList10.ROI__c ='';
                objCampaignList11.ROI__c ='';
                objCampaignList12.ROI__c ='';
            }
            if(chkStartDate == false){
                objCampaignList1.Start_Time_Date__c =null;
                objCampaignList2.Start_Time_Date__c =null;
                objCampaignList3.Start_Time_Date__c =null;
                objCampaignList4.Start_Time_Date__c =null;
                objCampaignList5.Start_Time_Date__c =null;
                objCampaignList6.Start_Time_Date__c =null;                
                objCampaignList7.Start_Time_Date__c =null;
                objCampaignList8.Start_Time_Date__c =null;
                objCampaignList9.Start_Time_Date__c =null;
                objCampaignList10.Start_Time_Date__c =null;
                objCampaignList11.Start_Time_Date__c =null;
                objCampaignList12.Start_Time_Date__c =null;
            }
            if(chkEndDate == false){
                objCampaignList1.End_Time_Date__c =null;
                objCampaignList2.End_Time_Date__c =null;
                objCampaignList3.End_Time_Date__c =null;
                objCampaignList4.End_Time_Date__c =null;
                objCampaignList5.End_Time_Date__c =null;
                objCampaignList6.End_Time_Date__c =null;                
                objCampaignList7.End_Time_Date__c =null;
                objCampaignList8.End_Time_Date__c =null;
                objCampaignList9.End_Time_Date__c =null;
                objCampaignList10.End_Time_Date__c =null;
                objCampaignList11.End_Time_Date__c =null;
                objCampaignList12.End_Time_Date__c =null;
                                
            }
            if(chkStatus == false){
                objCampaignList1.Status ='';
                objCampaignList2.Status ='';
                objCampaignList3.Status ='';
                objCampaignList4.Status ='';
                objCampaignList5.Status ='';
                objCampaignList6.Status ='';                
                objCampaignList7.Status ='';
                objCampaignList8.Status ='';
                objCampaignList9.Status ='';
                objCampaignList10.Status ='';
                objCampaignList11.Status ='';
                objCampaignList12.Status =''; 
            }
            if(chkActive == false){
                objCampaignList1.IsActive =false;
                objCampaignList2.IsActive =false;
                objCampaignList3.IsActive =false;
                objCampaignList4.IsActive =false;
                objCampaignList5.IsActive =false;
                objCampaignList6.IsActive =false;                
                objCampaignList7.IsActive =false;
                objCampaignList8.IsActive =false;
                objCampaignList9.IsActive =false;
                objCampaignList10.IsActive =false;
                objCampaignList11.IsActive =false;
                objCampaignList12.IsActive =false;
                 
            }
            
                       
            if(SubPrograms == 1){
                objCampaignList1Display = true;             
            }
            if(SubPrograms == 2){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
            }
            if(SubPrograms == 3){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
            }
            if(SubPrograms == 4){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
            }
            if(SubPrograms == 5){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
            }
            if(SubPrograms == 6){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
            }
            
            if(SubPrograms == 7){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
            }
            
            if(SubPrograms == 8){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
                objCampaignList8Display = true;
            }
             
            if(SubPrograms == 9){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
                objCampaignList8Display = true;
                objCampaignList9Display = true;
            }
            
            if(SubPrograms == 10){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
                objCampaignList8Display = true;
                objCampaignList9Display = true;
                objCampaignList10Display = true;                            
            } 
            
            if(SubPrograms == 11){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
                objCampaignList8Display = true;
                objCampaignList9Display = true;
                objCampaignList10Display = true;
                objCampaignList11Display = true;                              
            }
            
            if(SubPrograms == 12){
                objCampaignList1Display = true;
                objCampaignList2Display = true;
                objCampaignList3Display = true;
                objCampaignList4Display = true;
                objCampaignList5Display = true;
                objCampaignList6Display = true;
                objCampaignList7Display = true;
                objCampaignList8Display = true;
                objCampaignList9Display = true;
                objCampaignList10Display = true;
                objCampaignList11Display = true;
                objCampaignList12Display = true;                            
            }           
        return null;
        
        
    }
    
    Public PageReference SaveSubProgram(){
        
       
        if(SubProgramDeleteIds.size()>0) {
            SubProgramDeleteList = [Select ID from Campaign where ID IN: SubProgramDeleteIds];
            delete SubProgramDeleteList;
        }        
        
        if(objCampaignList1Display == true){           
             SubProgramUpsertList.add(objCampaignList1); 
        }
        if(objCampaignList2Display == true){           
           
            SubProgramUpsertList.add(objCampaignList2);
        }
        if(objCampaignList3Display == true){
           
            SubProgramUpsertList.add(objCampaignList3);
        }
        if(objCampaignList4Display == true){
           
            SubProgramUpsertList.add(objCampaignList4);
        }
        if(objCampaignList5Display == true){
            
            SubProgramUpsertList.add(objCampaignList5);
        }
        if(objCampaignList6Display == true){
           
            SubProgramUpsertList.add(objCampaignList6);
        }
        if(objCampaignList7Display == true){
           
            SubProgramUpsertList.add(objCampaignList7);
        }
        if(objCampaignList8Display == true){
           
            SubProgramUpsertList.add(objCampaignList8);
        }
        if(objCampaignList9Display == true){
            
            SubProgramUpsertList.add(objCampaignList9);
        }
        
        if(objCampaignList10Display == true){
           
            SubProgramUpsertList.add(objCampaignList10);
        }
        if(objCampaignList11Display == true){
            
            SubProgramUpsertList.add(objCampaignList11);
        }
        if(objCampaignList12Display == true){
            
            SubProgramUpsertList.add(objCampaignList12);
        }
        
        if(SubProgramUpsertList.size() > 0){
           upsert SubProgramUpsertList; 
        }        
        
        Campaign objCampaignUpdate = [Select ID,Total_Program_Count__c,ParentID,Parents_Program_Count_Total__c from Campaign where ID=:ApexPages.currentPage().getParameters().get('Id')];
        objCampaignUpdate.Total_program_count__c = SubProgramUpsertList.size();
        objCampaignUpdate.Parents_Program_Count_Total__c = TotalProgramCountInc;
        update objCampaignUpdate;
        
         
     /*   Campaign objCampaignUpdateParent = [Select ID,Total_Program_Count__c from Campaign where parent.ParentId=:ApexPages.currentPage().getParameters().get('Id')];
        objCampaignUpdateParent.Parents_Program_Count_Total__c = TotalProgramCountInc;
        update objCampaignUpdateParent;*/
        //system.debug('##objCampaignUpdate.ParentID'+ objCampaignUpdate.ParentID);
        if(objCampaignUpdate.ParentID != null){
        Campaign objCampaignUpdateParent = [Select Name,id,ParentID,Parents_Program_Count_Total__c from Campaign where 
        ID=:objCampaignUpdate.ParentID];
        objCampaignUpdateParent.Parents_Program_Count_Total__c = TotalProgramCountInc;
        update objCampaignUpdateParent;
        }         
        
        PageReference CampaignProgramView= new PageReference('/apex/CampaignSubProgramView?mode=edit&id=' + ApexPages.currentPage().getParameters().get('Id')); 
        CampaignProgramView.setRedirect(true);       
        return CampaignProgramView;
        
    }
    Public PageReference CancelSubProgram(){
        PageReference CampaignProgramView= new PageReference('/apex/CampaignProgramView?id=' + ApexPages.currentPage().getParameters().get('Id')); 
        CampaignProgramView.setRedirect(true);       
        return CampaignProgramView;
    }

    public string strIndex{get;set;}
    
    public PageReference chagneGroupCode(){
        Campaign cTemp = new Campaign();
        //strIndex = '1';
        //system.debug('##strIndex'+Apexpages.currentpage().getParameters().get('objname'));
        if(strIndex == '1') cTemp = objCampaignList1;
        if(strIndex == '2') cTemp = objCampaignList2;
        if(strIndex == '3') cTemp = objCampaignList3;
        if(strIndex == '4') cTemp = objCampaignList4;
        if(strIndex == '5') cTemp = objCampaignList5;
        if(strIndex == '6') cTemp = objCampaignList6;
        
        if(strIndex == '7') cTemp = objCampaignList7;
        if(strIndex == '8') cTemp = objCampaignList8;
        if(strIndex == '9') cTemp = objCampaignList9;
        if(strIndex == '10') cTemp = objCampaignList10;
        if(strIndex == '11') cTemp = objCampaignList11;
        if(strIndex == '12') cTemp = objCampaignList12;
        
        
        if(cTemp.CDP_Grouping__c == 'Renewal Notice 1'){
             cTemp.CDP_Grouping_Code__c = strIndex;
         }
         else if(cTemp.CDP_Grouping__c == 'Renewal Mail Effort Unknown'){
             cTemp.CDP_Grouping_Code__c = 'R1';
         }
         else if(cTemp.CDP_Grouping__c == 'Other Renewal Mail'){
             cTemp.CDP_Grouping_Code__c = 'RM';
         }
         else if(cTemp.CDP_Grouping__c == 'Acquisition Mail'){
             cTemp.CDP_Grouping_Code__c = 'C';
         }
         else if(cTemp.CDP_Grouping__c == 'Additional Mail'){
             cTemp.CDP_Grouping_Code__c = 'A';
         }
         else if(cTemp.CDP_Grouping__c == 'Lapsed Mail'){
             cTemp.CDP_Grouping_Code__c = 'L';
         }
         else if(cTemp.CDP_Grouping__c == 'Other Mail'){
             cTemp.CDP_Grouping_Code__c = 'MA';
         }
         else if(cTemp.CDP_Grouping__c == 'Renewal Telemarketing'){
             cTemp.CDP_Grouping_Code__c = 'TR';
         }
         else if(cTemp.CDP_Grouping__c == 'Acquisition Telemarketing'){
             cTemp.CDP_Grouping_Code__c = 'TC';
         }
         else if(cTemp.CDP_Grouping__c == 'Additional Telemarketing'){
             cTemp.CDP_Grouping_Code__c = 'TA';
         }
         else if(cTemp.CDP_Grouping__c == 'Lapsed Telemarketing'){
             cTemp.CDP_Grouping_Code__c = 'TL';
         }
         else if(cTemp.CDP_Grouping__c == 'Other Telemarketing'){
             cTemp.CDP_Grouping_Code__c = 'TO';
         }
         else if(cTemp.CDP_Grouping__c == 'On-Air Pledge'){
             cTemp.CDP_Grouping_Code__c = 'P';
         }
         else if(cTemp.CDP_Grouping__c == 'Sweepstakes'){
             cTemp.CDP_Grouping_Code__c = 'S';
         }
         else if(cTemp.CDP_Grouping__c == 'Acquisition Sweeps'){
             cTemp.CDP_Grouping_Code__c = 'S1';
         }
         else if(cTemp.CDP_Grouping__c == 'Web/Internet'){
             cTemp.CDP_Grouping_Code__c = 'W';
         }
         else if(cTemp.CDP_Grouping__c == 'Sustainer'){
             cTemp.CDP_Grouping_Code__c = 'SG';
         }
         else if(cTemp.CDP_Grouping__c == '900 Number'){
             cTemp.CDP_Grouping_Code__c = '9';
         }
         else if(cTemp.CDP_Grouping__c == 'Matching Gifts'){
             cTemp.CDP_Grouping_Code__c = 'MG';
         }
         else if(cTemp.CDP_Grouping__c == 'Miscellaneous/Other'){
             cTemp.CDP_Grouping_Code__c = 'X';
         }
         else if(cTemp.CDP_Grouping__c == 'Customer Service'){
             cTemp.CDP_Grouping_Code__c = 'CS';
         }
         else if(cTemp.CDP_Grouping__c == 'Web Pledge'){
             cTemp.CDP_Grouping_Code__c = 'WP';
         }
         else if(cTemp.CDP_Grouping__c == 'Web Email'){
             cTemp.CDP_Grouping_Code__c = 'WE';
         }
         else if(cTemp.CDP_Grouping__c == 'Major Donors'){
             cTemp.CDP_Grouping_Code__c = 'MD';
         }
         else if(cTemp.CDP_Grouping__c == 'Planned Giving'){
             cTemp.CDP_Grouping_Code__c = 'PG';
         }
         else if(cTemp.CDP_Grouping__c == 'Events'){
             cTemp.CDP_Grouping_Code__c = 'EV';
         }
         else if(cTemp.CDP_Grouping__c == 'Capital Campaigns'){
             cTemp.CDP_Grouping_Code__c = 'CC';
         }
         else if(cTemp.CDP_Grouping__c == 'Local Underwriting'){
             cTemp.CDP_Grouping_Code__c = 'LU';
         }
         else if(cTemp.CDP_Grouping__c == 'National Underwriting'){
             cTemp.CDP_Grouping_Code__c = 'NU';
         }
         else if(cTemp.CDP_Grouping__c == 'Memorial/Honorarium'){
             cTemp.CDP_Grouping_Code__c = 'MM';
         }
         else if(cTemp.CDP_Grouping__c == 'Publications/Newsletters'){
             cTemp.CDP_Grouping_Code__c = 'PU';
         }
         
         
         
         return null;
     }
    
    Public SubProgram objSubProgram{get;set;}
    Public Class SubProgram{
       Public List<Campaign> objCampaign{get;set;}
       Public List<fields> lstFields{get;set;}
    }
    Public Class fields{
       Public String Label{get;set;}
       Public String Name{get;set;}
       Public Boolean Selected{get;set;}
    }    
    
    Private boolean checkSelectedField(String Field){
        if(lstSelectedFields != null && lstSelectedFields.size()>0){
            for(String s:lstSelectedFields){
                if(s.trim().toUpperCase() == Field.trim().toUpperCase())
                    return true;
            }
        }
        return false;
    }
    Private List<String> getFieldsInArray(String ObjectName) {        
        List<String> fields = new List<String>();
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( ObjectName ).getDescribe().fields.getMap();            
        System.assert( accountFieldMap != null );                  
        for( String fieldName : accountFieldMap.keySet() ) {
            Schema.DescribeFieldResult field = accountFieldMap.get( fieldName ).getDescribe();                
            //String fieldType = ( '' + field.getType() ).replace( 'Schema.DisplayType.', '' );                
            system.debug('Field list --> ' + field.getLocalName());
            fields.add( field.getLocalName());
        }     
        return fields;         
   }    
   public class clsField{
       Public String fields{get;set;}
       
   }
    Public List<clsField> objField{get;set;}
    Public List<String> getfieldName(){
        List<String> lstFieldName = new List<String>();
        for(fields sp: objSubProgram.lstFields){
            lstFieldName.add(sp.Label);
        }
        return lstFieldName;
    }
    public SubProgram getfieldList1()  
    {//objSubProgram
        //lstCampaign = objSubProgram.objCampaign;
        return objSubProgram;       
    }  
    public List<Campaign> getfieldList()  
    {//objSubProgram
        lstCampaign = objSubProgram.objCampaign;
        return lstCampaign;       
    }  
  
 
   Private fields addFieldDetail(String Label, String Name){
       fields objFields = new fields();
       objFields.Label = Label;
       objFields.Name = Name;
       objFields.Selected = false;    
       return objFields;   
   }
   
////////////////////////////TEST METHODS/////////////////////////////////
    static testMethod void myTest() {
        Campaign c = new Campaign();
        c.Name = 'Test';
        insert c;
        CampaignSubProgram clsTest;
        
        ApexPages.currentPage().getParameters().put('mode','edit');
        ApexPages.currentPage().getParameters().put('id',c.Id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        clsTest = new CampaignSubProgram();

        clsTest.PageLoad();
        
        Campaign c1 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c1;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c2 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c2;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c3 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c3;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c4 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c4;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c5 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c5;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c6 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c6;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c7 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c7;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c8 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c8;        
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c9 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c9;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c10 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c10;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c11 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c11;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        Campaign c12 = new Campaign(Name = 'test',ParentID=c.Id);
        insert c12;
        clsTest = new CampaignSubProgram(controller);
        clsTest.SubProgramAdd();
        
        //ApexPages.currentPage().getParameters().put('id', c.Id);
        clstest.UpdateSubProgram();
        
        //clsTest.LoadDefaultFields();

        clsTest.chkProgramTitle= FALSE;
        clsTest.chkParentProgramTitle= FALSE;
        clsTest.chkProduct= FALSE;
        clsTest.chkCampaign= FALSE;
        clsTest.chkCampaignDesc= FALSE;
        clsTest.chkFinancialSegementL1= FALSE;
        clsTest.chkAccountUnit= FALSE;
        clsTest.chkAccountUnitActivity= FALSE;
        clsTest.chkGivingSegment= FALSE;
        clsTest.chkStation= FALSE;
        clsTest.chkSolicitationType= FALSE;
        clsTest.chkEffort= FALSE;
        clsTest.chkChannel= FALSE;
        clsTest.chkSubChannel= FALSE;
        clsTest.chkIndustry= FALSE;
        clsTest.chkCategory= FALSE;
        clsTest.chkJobNumber= FALSE;
        clsTest.chkCreativePackage= FALSE;
        clsTest.chkOfferMessage= FALSE;
        clsTest.chkResponseMechanism= FALSE;
        clsTest.chkAudienceSegment= FALSE;
        clsTest.chkAgeRange= FALSE;

        clsTest.chkGender= FALSE;
        clsTest.chkSegmentNotes= FALSE;
        clsTest.chkCostPerX= FALSE;
        clsTest.chkDesignation= FALSE;
        clsTest.chkSupportDesignation= FALSE;
        clsTest.chkOverridegift= FALSE;
        clsTest.chkListFileCode= FALSE;
        clsTest.chkListFileName= FALSE;
        clsTest.chkListDropDate= FALSE;
        clsTest.chkListDropQty= FALSE;
        clsTest.chkListPackagecode= FALSE;
        
        clsTest.chkProgramBreakName= FALSE;
        clsTest.chkCDPGrouping= FALSE;
        clsTest.chkCDPGroupingCode= FALSE;
        clsTest.chkPrimeTimeSelected= FALSE;
        clsTest.chkShowBreak= FALSE;
        clsTest.chkBreakChallenges= FALSE;
        clsTest.chkProgramBreakStDate= FALSE;
        clsTest.chkProgramBreakEndDate= FALSE;
        clsTest.chkBreakDuration= FALSE;
        clsTest.chkPlacement= FALSE;
        
        clsTest.chkTotalCost= FALSE;
        clsTest.chkEmailResponse= FALSE;
        clsTest.chkWebInbound= FALSE;
        clsTest.chkInboundCalls= FALSE;
        clsTest.chkAudienceGoal= FALSE;
        clsTest.chkRevenueGoal= FALSE;
        clsTest.chkNetGoal= FALSE;
        clsTest.chkROI= FALSE;
        clsTest.chkStartDate= FALSE;
        clsTest.chkEndDate= FALSE;
        clsTest.chkStatus= FALSE;
        clsTest.chkActive= FALSE;
                
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '1';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '2';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '3';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '4';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '5';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '6';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();                                
        clsTest.selectedColumnRemove = '7';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '8';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '9';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '10';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '11';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        clsTest.selectedColumnRemove = '12';
        clsTest.SubProgramRemove();
        clsTest.CreateSubProgram();
        
        
        clsTest.strIndex = '1';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '2';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '3';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '4';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '5';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '6';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '7';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '8';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '9';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '10';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '11';
        clsTest.chagneGroupCode();
        clsTest.strIndex = '12';
        clsTest.chagneGroupCode();        
        
    }
   
   
}