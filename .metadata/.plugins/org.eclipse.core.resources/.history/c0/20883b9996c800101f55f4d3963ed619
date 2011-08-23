public with sharing class ContactDonationCredit_EXT {
    private final Contact contact;
    public ContactDonationCredit_EXT(ApexPages.StandardController stdController) {
        this.contact = (Contact)stdController.getRecord();
    }
    public String getContactLastDonation() {
        return IndividualAccounts.getContactLastDonationDate(contact.ID);
    }
    public String getContactDonationHistory() {
        return IndividualAccounts.getContactDonationHistoryAmount(contact.ID);
    }     
    
    static testmethod void mytest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact c  = new Contact(FirstName='test',LastName='test',AccountID=a.Id);
        insert c;
        
        ApexPages.StandardController con = new ApexPages.StandardController(c);
        
        ContactDonationCredit_EXT clsTest = new ContactDonationCredit_EXT(con);
    
        clsTest.getContactLastDonation();
        clsTest.getContactDonationHistory();
    }
    
}