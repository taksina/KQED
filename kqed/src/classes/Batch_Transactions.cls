// Insert refund item to transaction batch from refund__c object

global class Batch_Transactions {
    Public Static void Batch_Transactions() {
       BatchExecBatch_Transactions reassign = new BatchExecBatch_Transactions ('select CC_Alias__c,Giving__c,Refund_Amount__c,Refund_Date__c,Refund_Method__c,Refund_Status__c,Refund_Status_Formula__c,RFP_Submitted__c,Giving__r.SFDC_GIVING_NUMBER__c,CC_Alias__r.GUID__c,CC_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_Alias__r.Merchant_Account__r.Merchant_Key__c from Refund__c where Status__c = \'PROCESS\' And Refund_Method__c= \'Charge Card\'');
       //BatchExecRefund_Batch reassign = new BatchExecRefund_Batch ('select CC_Alias__c,Giving__c,Refund_Amount__c,Refund_Date__c,Refund_Method__c,Refund_Status__c,Refund_Status_Formula__c,RFP_Submitted__c,Giving__r.SFDC_GIVING_NUMBER__c,CC_Alias__r.GUID__c,CC_Alias__r.Merchant_Account__r.Merchant_ID__c,CC_Alias__r.Merchant_Account__r.Merchant_Key__c from Refund__c where ID=\'a15Q0000000aizP\'');
        
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
}