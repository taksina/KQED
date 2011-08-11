@isTest 
private class Test_AccountGivingSummary   {
    static testMethod void myTest() {
        Account a = new Account();
        ApexPages.StandardController controller = new ApexPages.StandardController (a);
        
        AccountGivingSummary clsTest = New AccountGivingSummary(controller);

    }
}