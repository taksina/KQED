global class BatchExecTransactionInsert implements Database.Batchable<sObject> {
    global final String Query;
 
    global BatchExecTransactionInsert(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchTransactionbatchInsert(scope);
    }
    
    void DoBatchTransactionbatchInsert(List<sObject> scope) {
        List<Transaction_Batch__c> lstbatch = new List<Transaction_Batch__c>();
        
        Transaction_Batch__c TB;
        
        for(sObject s : scope) {
            Opportunity ObjPledge = (Opportunity)s;
            TB = new Transaction_Batch__c();
            
            TB.Process_date__c = ObjPledge.Payment_Date__c;
            TB.Payment_Amount__c = ObjPledge.Payment_Amount__c;
            TB.Pledge_Number__c = ObjPledge.SFDC_GIVING_NUMBER__c;
            TB.Opportunity_Id__c = ObjPledge.Id;
            
            lstbatch.add(TB);
        }
        
        if(lstbatch != null && lstbatch.size()>0) 
        {
            Insert lstbatch;
        }

    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

    /*static testMethod void TestBatchExecTransactionInsert() {
       Test.startTest();
        Lead l = new Lead();
        l.FirstName = 'TestFirstName';
        l.LastName = 'TestLastName';
        l.Line_of_Business__c = 'Life';
        l.Company = 'Test';
        l.Email = 'test@test.com';
        insert l;
        
        Lead l1 = new Lead();
        l1.FirstName = 'TestFirstName';
        l1.LastName = 'TestLastName';
        l1.Line_of_Business__c = 'Life';
        l1.Company = 'Test';
        l1.Email = 'test@test.com';
        insert l1;
        
        ID batchprocessid;
        BatchExecLeadConvertDistribute reassign;
        reassign = new BatchExecLeadConvertDistribute ('Select ID from Lead limit 200',false);
        batchprocessid = Database.executeBatch(reassign);   
        Test.StopTest();     
        
    }     */
}