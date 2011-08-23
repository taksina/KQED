@isTest
private class TestRelationshipTriggers {
    // Test method for RelationshipAfterUpdate Trigger
    public static testMethod void testRelationshipAfterUpdateTrigger1(){
    
        // Inserting an Organization record
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
        
        // Create a relationship between the above two contacts
        Relationships__c relation1 = new Relationships__c();
        relation1.People__c = con1.Id;
        relation1.Related_To_People__c = con2.Id;
        relation1.Primary_Rel__c = true;
        relation1.Strength__c = 'Strong';
        relation1.Type__c = 'People';
        relation1.Relationship__c = 'Advisor';
        relation1.Reciprocal_Relationship__c = 'Advisee';
        insert relation1;
        
        Relationships__c relation2 = new Relationships__c();
        relation2.People__c = con2.Id;
        relation2.Related_To_People__c = con2.Id;
        relation2.Primary_Rel__c = true;
        relation2.Strength__c = 'Strong';
        relation2.Type__c = 'People';
        relation2.isReciprocal__c = true;
        relation2.Relationship__c = 'Advisee';
        relation2.Reciprocal_Relationship__c = 'Advisor';
        relation2.Parent__c = relation1.Id;
        insert relation2;
        
        Test.startTest();
        relation1.Strength__c = 'Moderate';
        relation1.Relationship__c = 'Board Member';
        update relation1;
        Test.stopTest();
             
    
    }    
    
    
    public static testMethod void testRelationshipAfterUpdateTrigger2(){
    
        // Inserting an Organization record
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
        
        // Create a relationship between the above two contacts
        Relationships__c relation1 = new Relationships__c();
        relation1.People__c = con1.Id;
        relation1.Related_To_People__c = con2.Id;
        relation1.Primary_Rel__c = true;
        relation1.Strength__c = 'Strong';
        relation1.Type__c = 'People';
        relation1.Relationship__c = 'Advisor';
        relation1.Reciprocal_Relationship__c = 'Advisee';
        insert relation1;
        
        Relationships__c relation2 = new Relationships__c();
        relation2.People__c = con2.Id;
        relation2.Related_To_People__c = con2.Id;
        relation2.Primary_Rel__c = true;
        relation2.Strength__c = 'Strong';
        relation2.Type__c = 'People';
        relation2.isReciprocal__c = true;
        relation2.Relationship__c = 'Advisee';
        relation2.Reciprocal_Relationship__c = 'Advisor';
        relation2.Parent__c = relation1.Id;
        insert relation2;
    
        
        Test.startTest();
        relation2.Strength__c = 'Strong';
        update relation2;
        Test.stopTest();        
    
    }    
    // Test method for RelationshipAfterDelete Trigger    
    public static testMethod void testRelationshipAfterDeleteTrigger(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
        
        // Create a relationship between the above two contacts
        Relationships__c relation1 = new Relationships__c();
        relation1.People__c = con1.Id;
        relation1.Related_To_People__c = con2.Id;
        relation1.Primary_Rel__c = true;
        relation1.Strength__c = 'Strong';
        relation1.Type__c = 'People';
        relation1.Relationship__c = 'Advisor';
        relation1.Reciprocal_Relationship__c = 'Advisee';
        insert relation1;
        
        Relationships__c relation2 = new Relationships__c();
        relation2.People__c = con2.Id;
        relation2.Related_To_People__c = con2.Id;
        relation2.Primary_Rel__c = true;
        relation2.Strength__c = 'Strong';
        relation2.Type__c = 'People';
        relation2.isReciprocal__c = true;
        relation2.Relationship__c = 'Advisee';
        relation2.Reciprocal_Relationship__c = 'Advisor';
        relation2.Parent__c = relation1.Id;
        insert relation2;   
        
        delete relation1;    
      
    }
}