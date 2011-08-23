@isTest 
private class Test_BatchJobTrigger  {
    static testMethod void myTest() {
        Batch_Job__c bj = New Batch_Job__c();
        bj.Batch_Job_Name__c = 'BatchRelationshipLink';
        insert bj;
    
        Batch_Job__c bj1 = New Batch_Job__c();
        bj1.Batch_Job_Name__c = 'BatchRelationshipPairing';
        insert bj1;
    }

}