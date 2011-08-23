public class CampaignNewOverride {


    public CampaignNewOverride(ApexPages.StandardController controller) {

    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    public PageReference RedirectToNewCampaign() {
        //701/e?retURL=%2F701%2Fo&RecordType=012T0000000D8Yv&ent=Campaign
        string URL='';

        string retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new= ApexPages.CurrentPage().getParameters().get('save_new');
                       
        
        
        RecordType r = [Select DeveloperName from RecordType where ID=:RecordType];
        
        boolean IsOnAirType = false;
        
        if(r.DeveloperName == 'Not_On_Air' || r.DeveloperName == 'On_Air') {
            IsOnAirType = true;
        }

        if (IsOnAirType==true) {
            URL += '/apex/CampaignProgramCreate?RecordType=' + RecordType +'&retURL='+ retURL;

        }
        else {
            URL += '/701/e?retURL=' + retURL + '&RecordType=' + RecordType + '&ent=Campaign';
        }
        
        URL += '&nooverride=1';        
          
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }

    static testMethod void TestCampaignNewOverride() {
        Campaign c = new Campaign(Name='TestCampaign');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        CampaignNewOverride clsTest = new CampaignNewOverride(controller);
        string URL = clsTest.getCurrentURL();
        
        ApexPages.CurrentPage().getParameters().put('retURL','%2F701%2Fo');
        
        RecordType r = [Select ID from RecordType where DeveloperName = 'Event' limit 1];
        
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        ApexPages.CurrentPage().getParameters().put('ent','Campaign');
        ApexPages.CurrentPage().getParameters().put('save_new','1');
                
        
        PageReference P = clsTest.RedirectToNewCampaign();
        
        RecordType r1 = [Select ID from RecordType where DeveloperName != 'Event' AND DeveloperName!='Not_On_Air' limit 1];
        ApexPages.CurrentPage().getParameters().put('RecordType',r1.Id);
        PageReference P1 = clsTest.RedirectToNewCampaign();

    }    
}