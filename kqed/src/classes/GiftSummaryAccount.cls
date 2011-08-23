public class GiftSummaryAccount {
    Public PageReference goToSummary(){
        PageReference P;
        String Id = ApexPages.currentPage().getParameters().get('id');
        P = new PageReference('/apex/GiftSummary?Id=' + Id);
        P.setRedirect(true);
        return P;
    }
    public GiftSummaryAccount(ApexPages.StandardController controller) {

    }
    static testMethod void GiftSummary(){
     SObject o = new Account();
     ApexPages.StandardController sc = new ApexPages.StandardController(o);       
     GiftSummaryAccount clsTest = new GiftSummaryAccount(sc);
     clsTest.goToSummary();
    }

}