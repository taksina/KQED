trigger BatchJobTrigger on Batch_Job__c (after insert) {
    Batch_Job__c bj = (Batch_Job__c) Trigger.new[0];
    if(bj.Batch_Job_Name__c == 'BatchRelationshipLink') {
        Database.executeBatch(new BatchRelationshipLink(true));
    }
    else if(bj.Batch_Job_Name__c == 'BatchRelationshipPairing') {
        Database.executeBatch(new BatchRelationshipPairing(true));
    }

}