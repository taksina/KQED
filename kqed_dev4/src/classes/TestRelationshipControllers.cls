@isTest
private class TestRelationshipControllers {
    public static testMethod void testAddRelationshipController() {
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
    
        
        Map<String, String> urlParams = new Map<String,String>{
            'id' => account.Id
        };
        Id [] fixedSeatchResult = new Id[2];
        fixedSeatchResult[0] = con1.Id;
        fixedSeatchResult[1] = con2.Id;
        Test.setFixedSearchResults(fixedSeatchResult);
        Test.setCurrentPage(getPageReference('NewRelationship',urlParams));
        AddRelationShipController controller = new AddRelationShipController();
        controller.searchObj = 'People';
        controller.searchString = 'firstName2';
        controller.search();
        //controller.constructDisplayList();
        for(AddRelationShipController.DisplayElement de: controller.displayList){
            de.selected = true;
        }
        //controller.urlParam = con1.Id;
        controller.prepareRelations();
        List<SelectOption> list1 = controller.getrelationshipType();
        List<SelectOption> list2 = controller.getrelationStrength();
        //pageReference pref = controller.saveRelations();
        pageReference pref2 = controller.redirectBack();
        controller.saveRelations();
        controller.createReciprocalRelationship();
    }
    
    
    public static testMethod void testRelationshipEditController(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
        
        Relationships__c relation1 = new Relationships__c();
        relation1.Organization__c = account.Id;
        relation1.Related_To_People__c = con2.Id;
        relation1.Relationship__c = 'Advisor';
        relation1.Reciprocal_Relationship__c = 'Advisee';
        relation1.Strength__c = 'Moderate';
        insert relation1;
        Map<String, String> urlParams = new Map<String,String>{
            'id' => account.Id
        };
        
        Test.setCurrentPage(getPageReference('RelationshipEdit', urlParams));
        ApexPages.standardController  stdController = new ApexPages.standardController(relation1);
        RelationshipEditController controller = new RelationshipEditController(stdController);
        
        
        
    }
    
    public static testMethod void testRelationshipEditController2(){
        Account account = new Account(Name = 'Test Account');
        insert account;
        
        // Inserting a People record
        Contact con1 = new Contact(FirstName = 'firstName1', LastName = 'lastName1', AccountId = account.Id);
        insert con1;
        
        Contact con2 = new Contact(FirstName = 'firstName2', LastName = 'lastName2', AccountId = account.Id);
        insert con2;
        
        Relationships__c relation1 = new Relationships__c();
        //relation1.Organization__c = account.Id;
        relation1.People__c = con1.Id;
        relation1.Related_To_People__c = con2.Id;
        relation1.Relationship__c = 'Advisor';
        relation1.Reciprocal_Relationship__c = 'Advisee';
        relation1.Strength__c = 'Moderate';
        insert relation1;
        Map<String, String> urlParams = new Map<String,String>{
            'id' => account.Id
        };
        
        Test.setCurrentPage(getPageReference('RelationshipEdit', urlParams));
        ApexPages.standardController  stdController = new ApexPages.standardController(relation1);
        RelationshipEditController controller = new RelationshipEditController(stdController);
        controller.retId = con1.Id;
        controller.save();
        controller.cancel();
        
        
    }
    
    public static PageReference getPageReference(String page, Map<String, String> params) {
        String url = '/apex/'+page+'?';
        for (String param : params.keySet()) {
            url += param + '=' + params.get(param) + '&';
        }
        PageReference p = new PageReference(url);
        return p;
    }

}