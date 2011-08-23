global class BatchExecUpdateTACasesCall {
    Public static void BatchExecUpdateTACasesCall() {
        ID batchprocessid;
        BatchExecUpdateTACases reassign;
        
        reassign = new BatchExecUpdateTACases ('Select ID,Status from Case where ta_interactions_Id__c!=null && ta_interactions_Id__c!=\'\'');
        batchprocessid = Database.executeBatch(reassign,200);
    }
}