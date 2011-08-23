@isTest
private class FringeBenefitsControllerTest {
    private static testMethod void testFringeBenefitsController() {
      try {
        /*Account ac = new Account(Name = 'Test', Industry = 'Test', Industry_Category__c = 'Test');
        insert ac;
        
        Location__c loc = new Location__c(Location_ID__c = '12345', 
                          Name = 'Test',
                          Street__c = 'Test',
                          City__c = 'Test',
                          State__c = 'TS',
                          PostalCode__c = '52250',
                          Phone__c = '1234567890',
                          Account__c = ac.Id);
                          
        insert loc;
        
        Member_Benefit__c mb = new Member_Benefit__c(Item_ID__c = '54321',
                                Name = 'Test',
                                Offer__c = '123456',
                                Marketing_Copy__c = 'TEST',
                                Benefit_Link__c = 'TEST',
                                Category__c = 'TEST',
                                Business_Member_Partner__c = ac.Id,
                                Start_Date__c = System.today(),
                                End_Date__c = System.today());
        insert mb;                        
        
        Member_benefit_Location__c mbl = new Member_benefit_Location__c(Location__c = loc.Id, Member_Benefit__c = mb.Id);
        insert mbl;*/
        
        PageReference pr = Page.FringeBenefits;
        pr.getParameters().put('timestamp', '121028083203');
        Test.setCurrentPageReference(Page.FringeBenefits);
        FringeBenefitsController fc = new FringeBenefitsController();
        System.debug(fc.benefits);
      } catch (Exception ex) {
        PageReference pr = Page.FringeBenefits;
        pr.getParameters().put('timestamp', '121028083203');
        Test.setCurrentPageReference(Page.FringeBenefits);
        FringeBenefitsController fc = new FringeBenefitsController();
        System.debug(fc.benefits);
      }
      
        
    }
}