public class GivingController
{
    public list<Opportunity> opp{get;set;}
    
    public GivingController() 
    {
        opp=[select id, pledge_number__c,SFDC_Opportunity_ID__c from Opportunity where  pledge_number__c!='' limit 1000];    
    
    }

}