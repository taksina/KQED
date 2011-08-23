global class BatchTransactionInsert {
    Public static void BatchTransactionInsert() {
        BatchExecTransactionInsert reassign = new BatchExecTransactionInsert ('Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c from Opportunity Where Payment_Date__c = Today');
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
    
}