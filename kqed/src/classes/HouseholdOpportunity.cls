public class HouseholdOpportunity {
    public HouseholdOpportunity(){}

    public HouseholdOpportunity(Opportunity[] opportunities, Opportunity[] oldOpportunities, Households.triggerAction ta)
    {
        //Primary Donor
        String primaryDonorContactRole = system.label.Primary_Donor_Contact_Role;//Donor
        //Household member
        String householdMemberContactRole = system.label.Household_Member_Contact_Role;//Household Credit
        Integer i = 0;

        Opportunity newOpportunity = opportunities[0];
        
        if (newOpportunity.Oppty_Related_Contact__c == Null){
            List<id> householdIds = new List<id>();
            householdIds.add(newOpportunity.AccountID);
            
            List<Contact> houseHoldContacts = [Select Id, TaContactId__c From Contact where Account_Household__c= :householdIds.get(0)];
            String strTAContactId;
    
            for(Contact myContact : houseHoldContacts){
                    OpportunityContactRole thisRole = new OpportunityContactRole();
                    thisRole.OpportunityId = newOpportunity.Id;
                    thisRole.ContactId = myContact.Id;
                if (myContact.TaContactId__c != Null){
                    //Create OpportunityContactRole record for each Contact on the Household.
                    //Primary Donor/Contact of household contains _01_ in TaContactId__c value
                    if (myContact.TaContactId__c.contains('_01_')){
                        thisRole.Role = primaryDonorContactRole;
                        thisRole.isPrimary = true;
                        i++;
                    } else{ //non-Primary household member does not contain _01_ in TaContactId__c value 
                            thisRole.Role = householdMemberContactRole;
                            i++;
                    }
                }else{
                    
                    if(i == 0 ){
                        thisRole.Role = primaryDonorContactRole;
                        thisRole.isPrimary = true;
                        i++;                    
                    }else{
                            thisRole.Role = householdMemberContactRole;
                            i++;
                    }
                }
                insert thisRole;
            
            }

        }else{
            OpportunityContactRole thisRole = new OpportunityContactRole();
            thisRole.OpportunityId = newOpportunity.Id;
            thisRole.ContactId = newOpportunity.Oppty_Related_Contact__c;
            thisRole.Role = primaryDonorContactRole;
            thisRole.isPrimary = true;
            
            insert thisRole;
        }
    
    }
     public enum triggerAction {beforeInsert, beforeUpdate, beforeDelete, afterInsert, afterUpdate, afterDelete, afterUndelete}
    static testmethod void MyTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cnt = new Contact(FirstName= 't',LastName='t',AccountID=a.Id,Account_Household__c=a.Id,TaContactId__c='_01_');
        insert cnt;
        
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
        
        Opportunity opp1 = New Opportunity();
        opp1.AccountID = a.Id;
        opp1.Name = 'Test';
        opp1.CloseDate = system.Today().AddDays(15);
        opp1.StageName = 'Pledged';
        opp1.CampaignID = c.Id;
        insert opp1;
            
    
        HouseholdOpportunity clsTest = new HouseholdOpportunity();
        Households h = new Households();
        Households.triggerAction ta;
        Opportunity[] arropp1 = new Opportunity[]{};      
        Opportunity[] arropp2 = new Opportunity[]{};
        
        arropp1.add(opp);
        arropp2.add(opp1);
        HouseholdOpportunity clsTest1 = new HouseholdOpportunity(arropp1,arropp2,ta);
    }
}