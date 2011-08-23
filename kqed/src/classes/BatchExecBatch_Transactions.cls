global class BatchExecBatch_Transactions implements Database.Batchable<sObject> {
    global final String Query;
 
    global BatchExecBatch_Transactions(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchTransactionsInsert(scope);
    }
    
    void DoBatchTransactionsInsert(List<sObject> scope) {
        List<Transaction_Batch__c> lstbatch = new List<Transaction_Batch__c>();
        
        Transaction_Batch__c TB;
        
        for(sObject s : scope) {
            Refund__c ObjPledge = (Refund__c)s;
            TB = new Transaction_Batch__c();
            
            TB.Process_date__c = ObjPledge.Refund_Date__c;
            TB.GUID__c = ObjPledge.CC_Alias__r.GUID__c;
            TB.Payment_Amount__c = ObjPledge.Refund_Amount__c;
            TB.Pledge_Number__c = ObjPledge.Giving__r.SFDC_GIVING_NUMBER__c;
            TB.Merchant_ID__c = ObjPledge.CC_Alias__r.Merchant_Account__r.Merchant_ID__c;
            TB.Merchant_Key__c =  ObjPledge.CC_Alias__r.Merchant_Account__r.Merchant_Key__c;
            TB.Opportunity_Id__c = ObjPledge.Giving__c;
            TB.Transaction_Type__c = 'REFUND';
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


}