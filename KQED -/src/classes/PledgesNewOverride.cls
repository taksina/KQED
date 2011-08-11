public class PledgesNewOverride{


    public PledgesNewOverride(ApexPages.StandardController controller) {

    }
    
    public string getCurrentURL() {
        PageReference currPage = ApexPages.currentPage();
        String currPageURL = currPage.getUrl();
        return currPageURL;//.substring(currPageURL.indexOf('?'),currPageURL.Length());
    }
    Public String retURL{get;set;}
    public String currentURL{get;set;}
    public PageReference RedirectToNewOpportunity() {
        //701/e?retURL=%2F701%2Fo&RecordType=012T0000000D8Yv&ent=Campaign
        string URL='';
        currentURL = ApexPages.currentPage().getHeaders().get('Host');

        retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new = ApexPages.CurrentPage().getParameters().get('save_new');
        string lkid = ApexPages.CurrentPage().getParameters().get('_lkid');
        //CF00NA0000004rv7w=John+Rose&CF00NA0000004rv7w_lkid=003A000000VtU36
        //CF00NA0000005bdAm%3DJohn%2BRose%26CF00NA0000005bdAm_lkid%3D003A000000VtU36
        //substring
        string objType = '';
        RecordType r = [Select DeveloperName from RecordType where ID=:RecordType];
        
        if(r.DeveloperName == 'Annual' || r.DeveloperName == 'Donation' || r.DeveloperName == 'Inkind' || r.DeveloperName == 'Purchase'){
            URL += '/apex/PledgesNewStep1?RecordType=' + RecordType +'&retURL='+ retURL + '&New=1';
            /*
            objType = retURL.trim().replace('/','').substring(0,3);
            if(objType != '003' && objType != '001'){
                return null;
            }
            */
        }else{
            URL += '/006/e?retURL=' + retURL + '&RecordType=' + RecordType + '&ent=' + ent;             
        }  
        URL += '&nooverride=1'; 
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }

    static testMethod void TestPledgesNewOverride() {
         
        Campaign c = new Campaign(Name='TestCampaign');
        
        ApexPages.StandardController controller = new ApexPages.StandardController(c);
        
        ApexPages.currentPage().getParameters().put('id', c.Id);
        
        PledgesNewOverride clsTest = new PledgesNewOverride(controller);
        string URL = clsTest.getCurrentURL();
        
        ApexPages.CurrentPage().getParameters().put('retURL','%2F701%2Fo');
        
        RecordType r = [Select ID from RecordType where DeveloperName = 'Donation' limit 1];
        
        ApexPages.CurrentPage().getParameters().put('RecordType',r.Id);
        ApexPages.CurrentPage().getParameters().put('ent','Campaign');
        ApexPages.CurrentPage().getParameters().put('save_new','1');
                
        
        PageReference P = clsTest.RedirectToNewOpportunity();
        
        RecordType r1 = [Select ID from RecordType where DeveloperName != 'Donation' AND DeveloperName!='Inkind' limit 1];
        ApexPages.CurrentPage().getParameters().put('RecordType',r1.Id);
        PageReference P1 = clsTest.RedirectToNewOpportunity();
        
        clsTest.RedirectToNewOpportunity();

    }    
}