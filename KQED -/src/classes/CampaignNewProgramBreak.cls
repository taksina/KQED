public class CampaignNewProgramBreak{

    public CampaignNewProgramBreak(ApexPages.StandardSetController controller) {

    }


    public CampaignNewProgramBreak(ApexPages.StandardController controller) {

    }
    
    public PageReference RedirectToNewProgramBreak() {
        /*string URL='';

        string retURL = '/' + ApexPages.CurrentPage().getParameters().get('id');
        
        RecordType r = [Select Id,Name,DeveloperName from RecordType where DeveloperName = 'Campaign_Program_Break' limit 1];
        
        string RecordType = r.Id;
        
        string ent = 'Campaign';
        
        
        Campaign c = [Select Name from Campaign where ID=:ApexPages.CurrentPage().getParameters().get('id')];

        URL += '/apex/CampaignProgramBreak?parentid=' + ApexPages.CurrentPage().getParameters().get('id') +'&retURL=' + retURL + '&RecordType=' + RecordType;
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;*/
        return null;
    }    

    static testMethod void TestCampaignNewProgramBreak() {
        Campaign c = new Campaign();
        c.Name='TestCampaign';
        insert c;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);

        List<Campaign> lstC = new List<Campaign>();
        
        ApexPages.StandardSetController controller1 = new ApexPages.StandardSetController(lstC);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        CampaignNewProgramBreak clsTest = new CampaignNewProgramBreak(controller);
        
        CampaignNewProgramBreak clsTest1 = new CampaignNewProgramBreak(controller1);
        
        PageReference P = clsTest.RedirectToNewProgramBreak();


    }
}