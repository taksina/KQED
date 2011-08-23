global class BatchExecUpdateContactStatusCall {
    Public static void BatchExecUpdateContactStatusCall () {
        ID batchprocessid;
        BatchExecUpdateContactStatus status;
        
        status = new BatchExecUpdateContactStatus('Select ID,STS__c,Contact_Status__c from Contact where TaContactId__c != null && TaContactId__c != \'\'');
        batchprocessid = Database.executeBatch(status,200);
    }
}