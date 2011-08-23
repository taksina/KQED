public without sharing class extCandidate 
{
    public candidate__c c {get;set;}
    public Integer intApps {get;set;}
    
    
    public extCandidate(ApexPages.StandardController controller) 
    {
        
        String idCand = Apexpages.currentpage().getParameters().get('cand');
        Map<String, Schema.SObjectField> FieldMap = Schema.SObjectType.candidate__c.fields.getMap();
        Set<String> setFields = FieldMap.keySet();
            
        String strSoQL = 'Select Id';
        for (String fname : setFields) 
        {
            if (fname != 'Id')
            {
                strSoQL += ', ' +fname;
            }
        }
        
        if (idCand != null &&idCand != '')
        {
            //Get all of the Candidate fields and types
            
            strSoQL += ' from candidate__c where Id = \'' +idCand +'\'';
            System.debug('ABOUT TO QUERY ' +strSoQL);
            c = Database.query(strSoQL);
            
            intApps = [Select count() from Job_Application__c where Candidate__c =: idCand];
        } 
        else 
        {
            c = new candidate__c();
        }
        
    }
    
    public static testMethod void testExtCandidateWithCandidate()
    {
        
        Test.startTest();
        Candidate__c testCan       = new Candidate__c();
        //initialize testCan
        testCan.First_Name__c      = 'William';
        testCan.Last_Name__c       = 'Shakespeare';
        testCan.Street_Address1__c = '55 Riverside Drive';
        testCan.City__c            = 'Stratford on Avon';
        testCan.Email__c           = 'WillieShakes521@gmail.com';
        testCan.Zip_Postal_Code__c = '12345';
        testCan.Phone__c           = '6173003434';
        testCan.Recent_Salary__c   = 34000.0;
        testCan.Desired_Salary__c  = 1000.0;
        //insert
        insert testCan;
        extCandidate ext = new extCandidate(new ApexPages.StandardController(testCan));
        
        Test.stopTest();
    }
    
    public static testMethod void testExtCandidateWithoutCandidate()
    {
        Test.startTest();
        Candidate__c testCan       = new Candidate__c();
        extCandidate ext = new extCandidate(new ApexPages.StandardController(testCan));
        Test.stopTest();
    }
    

}