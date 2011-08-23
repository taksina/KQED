public class EditAllPremiumBenefit {

    public EditAllPremiumBenefit(ApexPages.StandardController controller) {
        //https://c.cs3.visual.force.com/apex/EditAllPremiumBenefit?oppId=006Q0000007ujjp&retURL=%2F006Q0000007ujjp&sfdc.override=1&id=006Q0000007ujjp
    }
    Public PageReference PageLoad(){
        String GivingId = ApexPages.currentPage().getParameters().get('id');
        Return redirectPage('/apex/EditPremiumBenefit?editall=1&GivingId=' + GivingId) ;
    }
    PageReference redirectPage(string url){
        PageReference P = new PageReference(url);
        P.setRedirect(true);
        return P;
    }
    
    static testMethod void myTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign(Name = 'Test');
        Insert c;
        
        Giving_Summary__c g = new Giving_Summary__c();
        g.Account__c = a.Id;
        insert g;
        
        
        Opportunity opp = New Opportunity();
        opp.AccountID = a.Id;
        opp.Name = 'Test';
        opp.CloseDate = system.Today().AddDays(15);
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        insert opp;
        
        ApexPages.CurrentPage().getParameters().put('id',opp.id);
        
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        
        EditAllPremiumBenefit clsTest = new EditAllPremiumBenefit(controller);
        
        clsTest.PageLoad();

    }
}