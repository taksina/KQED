@isTest 
private class Test_trgOppLineAfterInsert {
    static testMethod void myTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cnt = new Contact();
        cnt.firstName = 'Test';
        cnt.lastName = 'test';
        cnt.AccountID = a.Id;
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
        opp.Oppty_Related_Contact__c = cnt.id;
        insert opp;

        RecordType r = [Select ID from RecordType where DeveloperName='benefit_preferences' limit 1];

        Classification__c objC = new Classification__c();
        objC.RecordTypeID = r.ID;
        objC.Account__c = a.ID;
        objC.Contact__c = opp.Oppty_Related_Contact__c;
        objC.Preference__c = 'Club Type';
        objC.Preference_Value__c = 'History Club';
        insert objC;

        Classification__c objC1 = new Classification__c();
        objC1.RecordTypeID = r.ID;
        objC1.Account__c = a.ID;
        objC1.Contact__c = opp.Oppty_Related_Contact__c;
        objC1.Preference__c = 'Club Type';
        objC1.Preference_Value__c = 'History Club';
        insert objC1;        
        
        Product2 objProduct = new Product2();
        objProduct.name = 'TestProduct';
        objProduct.Family = 'Renewable Energy Inverters';
        objProduct.ProductCode = 'TESTPRODUCT';
        objProduct.Description = 'TestProduct';
        objProduct.Club__c = 'Arts & Drama Club';
        Insert objProduct;

        Product2 objProduct1 = new Product2();
        objProduct1.name = 'TestProduct';
        objProduct1.Family = 'Renewable Energy Inverters';
        objProduct1.ProductCode = 'TESTPRODUCT';
        objProduct1.Description = 'TestProduct';
        objProduct1.Club__c = 'History Club';
        Insert objProduct1;        

        Pricebook2 objPB2 = [Select ID from Pricebook2 where Name = 'Standard Price Book' limit 1];

        PriceBookEntry objPB = new PriceBookEntry();
        objPB.UnitPrice = 15;
        objPB.Pricebook2Id = objPB2.Id;
        objPB.Product2Id = objProduct.Id;
        //objPB.UseStandardPrice = true;
        objPB.IsActive = true;
        insert objPB;
        
        PriceBookEntry objPB1 = new PriceBookEntry();
        objPB1.UnitPrice = 15;
        objPB1.Pricebook2Id = objPB2.Id;
        objPB1.Product2Id = objProduct1.Id;
        //objPB.UseStandardPrice = true;
        objPB1.IsActive = true;
        insert objPB1;        
        
        OpportunityLineItem objOppLine = new OpportunityLineItem();
        objOppLine.OpportunityId = opp.Id;
        objOppLine.Quantity = 10;
        objOppLine.UnitPrice = 15;
        objOppLine.PricebookEntryId = objPB.Id;
        Insert objOppLine;   
             
        OpportunityLineItem objOppLine1 = new OpportunityLineItem();
        objOppLine1.OpportunityId = opp.Id;
        objOppLine1.Quantity = 10;
        objOppLine1.UnitPrice = 15;
        objOppLine1.PricebookEntryId = objPB1.Id;
        Insert objOppLine1; 

    }
}