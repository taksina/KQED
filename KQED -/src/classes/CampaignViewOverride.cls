public class CampaignViewOverride {

    public CampaignViewOverride (ApexPages.StandardController controller) {

    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    public PageReference RedirectToViewCampaign() {
        string URL='';

        string CampaignID = ApexPages.CurrentPage().getParameters().get('ID');
        
        Campaign c = [Select RecordTypeID from Campaign where ID=:CampaignID];

        RecordType r = [Select DeveloperName from RecordType where ID=:c.RecordTypeID];
        
        boolean IsOnAirType = false;
        
        if(r.DeveloperName == 'Not_On_Air' || r.DeveloperName == 'On_Air') {
            IsOnAirType = true;
        }

        if (IsOnAirType==true) {
            URL += '/apex/CampaignProgramView?Id=' + CampaignID;

        }
        else {
            URL += '/' + CampaignID + '?nooverride=1';
            
        }
       
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }    
    static testMethod void TestCampaignViewOverride() {
        RecordType r = [Select ID from RecordType where DeveloperName = 'Event' limit 1];

        Campaign c = new Campaign();
        c.Name = 'TestCampaign';
        c.RecordTypeID = r.Id;
        insert c;
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        CampaignViewOverride clsTest = new CampaignViewOverride(controller);
        
        string URL = clsTest.getCurrentURL();
                
        
        PageReference P = clsTest.RedirectToViewCampaign();

    }       
}