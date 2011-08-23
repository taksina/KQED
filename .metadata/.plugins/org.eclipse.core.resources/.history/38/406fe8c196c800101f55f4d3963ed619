@isTest 
private class Test_trgGivingSummaryBeforeInsertUpdate {
    static testMethod void myTest() {
        Giving_Summary__c g = new Giving_Summary__c();
        g.expiration_date__c = system.Today().addYears(1);
        g.Member_Yr_Status__c = 'Active';
        insert g;
        
        g.Member_Yr_Status__c='Grace';
        g.Lapsed_Period__c = 1;
        update g;
        
    }
}