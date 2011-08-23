public class ContactOpportunity {
    public ContactOpportunity(){}
    
    public ContactOpportunity (Opportunity[] opportunities){
        //Primary Donor
        String primaryDonorContactRole = system.label.Primary_Donor_Contact_Role;//Donor
        Opportunity newOpportunity = opportunities[0];
        Contact oppContact = [Select c.id, c.FirstName, c.Account_Household__c from Contact c where c.Id = :newOpportunity.Oppty_Related_Contact__c];
        newOpportunity.AccountID = oppContact.Account_Household__c;

/*      OpportunityContactRole thisRole = new OpportunityContactRole();
        thisRole.OpportunityId = newOpportunity.Id;
        thisRole.ContactId = oppContact.Id;
        thisRole.Role = primaryDonorContactRole;
        thisRole.isPrimary = true;
        
        insert thisRole;
*/      
    }

}