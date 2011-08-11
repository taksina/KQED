global class BatchExecTransaction_Batch implements Database.Batchable<sObject> {
    global final String Query;
 
    global BatchExecTransaction_Batch(String q){Query=q;}

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
            System.debug('pledgeid: '+ ObjPledge.Id );

            TB.Process_date__c = ObjPledge.Payment_Date__c;
            TB.GUID__c = ObjPledge.CC_EFT_Alias__r.GUID__c;
            TB.Payment_Amount__c = ObjPledge.Payment_Amount__c;
            TB.Pledge_Number__c = ObjPledge.SFDC_GIVING_NUMBER__c;
            TB.Opportunity_Id__c = ObjPledge.Id;
            TB.Merchant_ID__c = ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c;
            TB.Merchant_Key__c =  ObjPledge.CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c;
            TB.Transaction_Type__c = 'PAYMENT';
            TB.Status__c = 'PROCESS';
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

    static testMethod void TestBatchExecTransaction_Batch() {
       Test.startTest();
        Opportunity o = new Opportunity();
        o.Name = 'test';
        o.StageName = 'Pledge';
        o.CloseDate = system.today().addDays(10);
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 15;
        insert o;
        
        Opportunity o1 = new Opportunity();
        o1.Name = 'test';
        o1.StageName = 'Pledge';
        o1.CloseDate = system.today().addDays(10);
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 16;                
        insert o1;
        
       
        BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch ('Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c from Opportunity Where Payment_Date__c = Today Limit 2');
        ID batchprocessid = Database.executeBatch(reassign,2);
 
        Test.StopTest();     
        
    }
}