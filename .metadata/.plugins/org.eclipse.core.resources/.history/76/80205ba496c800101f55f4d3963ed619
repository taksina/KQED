public class GivingSummary {

    String Id;
    public GivingSummary(ApexPages.StandardController controller) {

    }
    Public PageReference pageLoad(){
        Id = ApexPages.currentPage().getParameters().get('id');
        Account objAcc = new Account();
        objAcc = [Select RecordTypeId From Account Where Id=:Id];
        String recordTypeId = objAcc.RecordTypeId;
        List<RecordType> lstRc = [Select DeveloperName from RecordType Where Id=:recordTypeId];
        if(lstRc.size()>0){                                    //Organization
            if(lstRc[0].DeveloperName.trim().toUpperCase() == 'ORGANIZATION'){
                return redirectPage('/apex/OrganizationGivingSummary?id=' + Id);
            }
            else if(lstRc[0].DeveloperName.trim().toUpperCase() == 'HOUSEHOLD'){
                return redirectPage('/apex/HouseholdGivingSummary?id=' + Id);
            }
            else{
                return redirectPage('/apex/OrganizationGivingSummary?id=' + Id);
            }
            
        }
        return null;
    }
    Public PageReference redirectPage(String url){
        PageReference P;
        P = new PageReference (url);
        P.setRedirect(true);
        return P;
    }
    static testMethod void GivingSummary(){
       
    
         SObject o = new Opportunity();
         ApexPages.StandardController sc = new ApexPages.StandardController(o);
        Account acc = new Account();
      
      
        GivingSummary clsTest = new GivingSummary(sc);
        
        Account a = new Account(Name = 'Test');
        insert a;
        
        ApexPages.currentPage().getParameters().put('id', a.Id);
        clsTest.pageLoad();
        clsTest.redirectPage('https://cs3.salesforce.com/006/o');
        
    }
}