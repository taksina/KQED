global class Refund_Batch {
    Public static void Refund_Batch() {
        
        String strQ = '';
        
        StrQ = 'SELECT  Batch_Number__c,GUID__c,Merchant_Id__c,Merchant_Key__c,Opportunity_Id__c,Payment_Amount__c,Pledge_Number__c,Process_date__c,Response_Code__c,Response_Message__c,Status__c,Submit_Count__c,Transaction_Type__c ' +
            ' FROM transaction_batch__c WHERE Status__c= \'PROCESS\' AND Transaction_Type__c = \'REFUND\'';
        BatchExecPayment_Batch reassign = new BatchExecPayment_Batch (strQ);

        ID batchprocessid = Database.executeBatch(reassign,1);
    }
}