@isTest 
private class Test_trgRefundBeforeInsert {
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
        opp.payment_Amount__c = 100;
        insert opp;
    
        Refund__c r = new Refund__c();
        r.Giving__c = opp.Id;
        r.Refund_Amount__c = 200;
        try {
            insert r;
        }
        catch(Exception ex) {
        }
    
    }
}