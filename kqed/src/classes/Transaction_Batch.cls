global class Transaction_Batch {
    Public static void Transaction_Batch() {
        BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch 
        ('Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c,CC_EFT_Alias__r.GUID__c,CC_EFT_Alias__r.Merchant_Account__r.Merchant_ID__c, CC_EFT_Alias__r.Merchant_Account__r.Merchant_Key__c from Opportunity Where Status__c = \'PROCESS\' AND (payment_method__c =\'Charge Card\' or payment_method__c = \'Electronic Funds Transfer\') AND (Payment_Date__c = Today or schedule_start_date__c = Today)');
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
    
    static testMethod void  TestTransaction_Batch() {
      
        Opportunity o1 = new Opportunity();
        o1.Name = 'test';
        o1.StageName = 'Pledge';
        o1.CloseDate = system.today().addDays(10);
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 20;                
        insert o1;
        
        Test.startTest();
        Transaction_Batch.Transaction_Batch();
        Test.StopTest();     
        
    }
}