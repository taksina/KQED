public with sharing class RunVendorExportController 
{
	public List<Vendor_Exports__c> premiumFulfillment {get; set;}
	public List<Vendor_Exports__c> ackowledgements {get; set;}
	public List<Vendor_Exports__c> reminders {get; set;}
	public List<Vendor_Exports__c> guidePulls {get; set;}
	public List<Vendor_Exports__c> membercardPulls {get; set;}
	public List<Vendor_Exports__c> askAmountUpdates {get; set;}
	
	public RunVendorExportController() 
	{    
		getPremiumFulfillment();
		getAcknowledgements();
		getReminders();
		getGuidePulls();
		getAskAmountUpdates();
	} 
	
	public PageReference runReport()
	{
		return null;
	}
	
	public PageReference getPremiumFulfillment()
    {
        premiumFulfillment = [SELECT Id, Pull_Name__c, Last_Run__c, Pull_Type__c 
        					  FROM Vendor_Exports__c WHERE Pull_Type__c = 'Premium Fulfillment'];
        return null;
    }
    
    public PageReference getAcknowledgements() 
    {
        ackowledgements = [SELECT Id, Pull_Name__c, Last_Run__c, Pull_Type__c 
        					  FROM Vendor_Exports__c WHERE Pull_Type__c = 'Acknowledgements'];
        return null;
    }
    
    public PageReference getReminders() 
    {
        reminders = [SELECT Id, Pull_Name__c, Last_Run__c, Pull_Type__c 
        					  FROM Vendor_Exports__c WHERE Pull_Type__c = 'Reminders'];
        return null;
    }
    
    public PageReference getGuidePulls() 
    {
        guidePulls = [SELECT Id, Pull_Name__c, Last_Run__c, Pull_Type__c 
        					  FROM Vendor_Exports__c WHERE Pull_Type__c = 'GuidePulls'];
        return null;
    }
    
    public PageReference getAskAmountUpdates() 
    {
        askAmountUpdates = [SELECT Id, Pull_Name__c, Last_Run__c, Pull_Type__c 
        					  FROM Vendor_Exports__c WHERE Pull_Type__c = 'Ask Amount Updates'];
        return null;
    }
    

	
}