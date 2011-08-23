global class Payment_Batch {
    Public static void Payment_Batch() {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Opportunity_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' FROM transaction_batch__c WHERE (Status__c= \'PROCESS\' or Status__c = \'FAIL\' )  AND Transaction_Type__c = \'PAYMENT\' AND Submit_Count__c < 3';
        BatchExecPayment_Batch reassign = new BatchExecPayment_Batch (strQ);

        ID batchprocessid = Database.executeBatch(reassign,1);
    }
    
    /*static testMethod void  TestPayment_Batch() {
      
        Opportunity o1 = new Opportunity();
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 20;                
        insert o1;
        
        Test.startTest();
        Transaction_Batch Controller = new Transaction_Batch();
        Controller.Transaction_Batch();
        Test.StopTest();     
        
    }*/
}