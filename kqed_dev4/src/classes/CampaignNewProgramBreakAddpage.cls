public class CampaignNewProgramBreakAddpage{


    Public List<Campaign>  CamapignProgramCount{ get; set; }
    Public Campaign  CamapignRecord{ get; set; }
    Public Campaign  ParentCamapignRecord{ get; set; }
    Public Integer CamapignProgramCountValue{ get; set; }
    
    public CampaignNewProgramBreakAddpage() {
        CamapignRecord = new Campaign();
        //CamapignProgramCount = new  List<Campaign>();
        CamapignRecord.RecordTypeID = ApexPages.CurrentPage().getParameters().get('RecordType');

        ParentCamapignRecord = [Select Name,id,Program_Count__c from Campaign where ID=:ApexPages.CurrentPage().getParameters().get('parentid')];

        CamapignProgramCount = [Select Name,id,Campaing_Program_Break_Count__c from Campaign where CampaignProgramBreak__c=:ApexPages.CurrentPage().getParameters().get('parentid') ORDER BY Campaing_Program_Break_Count__c DESC LIMIT 1];
        
        
        if(CamapignProgramCount.size()==0){
            //CamapignProgramCount.Campaing_Program_Break_Count__c = 1;
            CamapignRecord.Campaing_Program_Break_Count__c = 1;
            CamapignRecord.Program_Break_Name__c ='Program Break 1';
        }
        else {

            CamapignRecord.Campaing_Program_Break_Count__c = CamapignProgramCount[0].Campaing_Program_Break_Count__c + 1;
            CamapignRecord.Program_Break_Name__c ='Program Break '+ string.valueof(CamapignRecord.Campaing_Program_Break_Count__c);
        }
        //CamapignRecord.Program_Break_Name__c ='Program Break'+ CamapignProgramCount.Campaing_Program_Break_Count__c;
    }

     public PageReference save() {           
       
        CamapignRecord.Name = CamapignRecord.Program_Break_Name__c;
        CamapignRecord.CampaignProgramBreak__c = ApexPages.CurrentPage().getParameters().get('parentid');
        insert CamapignRecord;        
        
        PageReference P = new PageReference('/apex/CampaignProgramView?id='+ApexPages.CurrentPage().getParameters().get('parentid'));
        P.setRedirect(true); 
        return P;
       
    }
    public PageReference Cancel() {
        //return null;
        PageReference P = new PageReference('/apex/CampaignProgramView?id='+ApexPages.CurrentPage().getParameters().get('parentid'));
        P.setRedirect(true); 
        return P;
    }

    static testMethod void myTest() {
        RecordType r = [Select ID from RecordType where DeveloperName='Event'];
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        
        Campaign c = new Campaign();
        c.Name = 'test';
        insert c;
        
        ApexPages.CurrentPage().getParameters().put('ParentID',c.Id);
        
        CampaignNewProgramBreakAddpage clsTest = new CampaignNewProgramBreakAddpage();
        clsTest.save();
        clsTest.Cancel();

    }    
   
}