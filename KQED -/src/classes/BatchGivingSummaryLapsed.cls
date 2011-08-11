global class BatchGivingSummaryLapsed {
    Public static void BatchGivingSummaryLapsed() {
        BatchExecGivingSummaryLapsed reassign = new BatchExecGivingSummaryLapsed ('Select ID,Member_Yr_Status__c from Giving_Summary__c where Member_Yr_Status__c=\'Grace\' AND  Lapsed_Date__c!=null AND Lapsed_Date__c<=TODAY');
        ID batchprocessid = Database.executeBatch(reassign,200);
    }
}