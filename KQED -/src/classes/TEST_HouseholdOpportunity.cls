@isTest
private class TEST_HouseholdOpportunity {
    
    static testMethod void HouseholdOpportunity() {
        HouseholdOpportunity testHouseholdOpportunity = new HouseholdOpportunity();
    }
    //test for individual account model
    
    static testMethod void opportunityWithHousehold() {
        
        String householdContactRolesOn = system.label.Household_Contact_Role_Processor_On;  
        //create contact
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        Contact con = new Contact(
            FirstName=newContactfirstName,
            LastName=newContactLastName,
            SystemHouseholdProcessor__c = 'All New or Edited Contacts',
            SystemAccountProcessor__c = 'One-to-One'
        );
        insert con;
        Contact[] createdContacts = [select AccountId,Account_Household__c from Contact where id=:con.id];
        Id accountId = createdContacts[0].AccountId;
        Id householdId = createdContacts[0].Account_Household__c;
        //create household member
        Contact con2 = new Contact(
            FirstName=newContactfirstName,
            LastName=newContactLastName,
            SystemHouseholdProcessor__c = 'All New or Edited Contacts',
            Account_Household__c = householdId
        );
        insert con2;
        //create opportunity
        Opportunity o = new Opportunity(
            Name='test oppty',
            CloseDate=date.newInstance(2001,12,12),
            StageName='Closed Won',
            Amount=100,
            AccountId=accountId,
            systemHouseholdContactRoleProcessor__c = householdContactRolesOn
        );
        insert o;
        //check for contact roles
        List<OpportunityContactRole> createdRoles = [select Role, ContactId, IsPrimary from OpportunityContactRole where OpportunityId = :o.id order by ContactId];
        //system.AssertEquals(2,createdRoles.size()); //TODO - fixme
        //system.AssertEquals('Donor',createdRoles[0].Role); //TODO - fixme
        //system.Assert(createdRoles[0].IsPrimary); //TODO - fixme
        //system.AssertEquals('Household Credit',createdRoles[1].Role); //TODO - fixme
    }
    
    static testMethod void opportunityWithHouseholdNoRoles() {
            
        String householdContactRolesOff = system.label.Household_Contact_Role_Processor_Off;
        //create contact
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        Contact con = new Contact(
            FirstName=newContactfirstName,
            LastName=newContactLastName,
            SystemHouseholdProcessor__c = 'All New or Edited Contacts',
            SystemAccountProcessor__c = 'One-to-One'
        );
        insert con;
        Contact[] createdContacts = [select AccountId,Account_Household__c from Contact where id=:con.id];
        Id accountId = createdContacts[0].AccountId;
        Id householdId = createdContacts[0].Account_Household__c;
        //create household member
        Contact con2 = new Contact(
            FirstName=newContactfirstName,
            LastName=newContactLastName,
            SystemHouseholdProcessor__c = 'All New or Edited Contacts',
            Account_Household__c = householdId
        );
        insert con2;
        //create opportunity
        Opportunity o = new Opportunity(
            Name='test oppty',
            CloseDate=date.newInstance(2001,12,12),
            StageName='Closed Won',
            Amount=100,
            AccountId=accountId,
            systemHouseholdContactRoleProcessor__c = householdContactRolesOff
        );
        insert o;
        //check for contact roles
        List<OpportunityContactRole> createdRoles = [select Role, ContactId, IsPrimary from OpportunityContactRole where OpportunityId = :o.id order by ContactId];
        system.AssertEquals(0,createdRoles.size());
    }
    
    static testMethod void opportunityRegularAccount() {
        String householdContactRolesOn = system.label.Household_Contact_Role_Processor_On;
        //create contact
        Account acct = new Account(
            Name = 'fake account'
        );
        insert acct;
        Id accountId = acct.Id;
        String newContactfirstName = 'test';
        String newContactLastName = 'Contact_forTests';
        Contact con = new Contact(
            FirstName=newContactfirstName,
            LastName=newContactLastName,
            SystemHouseholdProcessor__c = 'All New or Edited Contacts',
            accountId = accountId
        );
        insert con;
        Contact[] createdContacts = [select AccountId,Account_Household__c from Contact where id=:con.id];
        
        Id householdId = createdContacts[0].Account_Household__c;
        
        //create opportunity
        Opportunity o = new Opportunity(
            Name='test oppty',
            CloseDate=date.newInstance(2001,12,12),
            StageName='Closed Won',
            Amount=100,
            AccountId=accountId,
            systemHouseholdContactRoleProcessor__c = householdContactRolesOn
        );
        insert o;
        //check for contact roles
        List<OpportunityContactRole> createdRoles = [select Role, ContactId, IsPrimary from OpportunityContactRole where OpportunityId = :o.id order by ContactId];
        system.AssertEquals(0,createdRoles.size());
    }
    
    
}