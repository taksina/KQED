public class EditGiving {

    public EditGiving(ApexPages.StandardController controller) {
        
    }
    
    Public String retURL{get;set;}
    public String currentURL{get;set;}
    Public PageReference chooseDestination(){
        //https://cs3.salesforce.com/006Q0000007vZU0/e?nooverride=1&retURL=%2F006Q0000007vZU0
        String URL = '';
        currentURL = ApexPages.currentPage().getHeaders().get('Host');
        retURL = ApexPages.CurrentPage().getParameters().get('retURL');
        String Id = ApexPages.CurrentPage().getParameters().get('id');
        //string RecordType = ApexPages.CurrentPage().getParameters().get('RecordType');
        string ent = ApexPages.CurrentPage().getParameters().get('ent');
        string save_new = ApexPages.CurrentPage().getParameters().get('save_new');
        string lkid = ApexPages.CurrentPage().getParameters().get('_lkid');
        string objType = '';
        Opportunity objGiving = [Select RecordType.DeveloperName, RecordTypeId From Opportunity Where Id=:Id];
        String DeveloperName = objGiving.RecordType.DeveloperName;
        String RecordType = objGiving.RecordTypeId;
        //https://cs3.salesforce.com/006Q0000007vZU0/e?retURL=%2F006Q0000007vZU0
        if(DeveloperName == 'Annual' || DeveloperName == 'Donation' || DeveloperName == 'Inkind' || DeveloperName == 'Purchase'){
            URL += '/apex/PledgesNewStep1?Id=' + Id + '&RecordType=' + RecordType +'&retURL='+ retURL + '&edit=1';
        }else if(DeveloperName == 'Annual_Installment' || DeveloperName == 'Donation_Installment' || DeveloperName == 'Inkind_Installment' || DeveloperName == 'Purchase_Installment'){
            URL += '/apex/GivingEditInstallment?Id=' + Id +'&retURL='+ retURL;
        }else{
            URL += '/' + Id + '/e?retURL=' + retURL;
        }   
        URL += '&nooverride=1';
        return RedirectPage(URL);
    }
    
    PageReference RedirectPage(String URL){         
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }
     static testMethod void EditGiving(){
     
        Account a = new Account(Name = 'Test');
        insert a;
        
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
        
              
         ApexPages.currentPage().getParameters().put('id', opp.Id);
          
         SObject o = new Opportunity();
         ApexPages.StandardController sc = new ApexPages.StandardController(o);
         
         EditGiving clsTest = new EditGiving(sc);
         clsTest.RedirectPage('https://cs3.salesforce.com/001/o');               
         clsTest.chooseDestination();         
         

     }

}