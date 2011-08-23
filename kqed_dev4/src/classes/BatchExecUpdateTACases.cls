global class BatchExecUpdateTACases implements Database.Batchable<sObject> {
    global final String Query;
    global BatchExecUpdateTACases (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchUpdateTACases(scope);
    }
    
    void DoBatchUpdateTACases(List<sObject> scope) {
        Set<ID> CaseHistoryId = new Set<ID>();
        List<Case> lstCase = (List<Case>) scope;
        
        for(Case c: lstCase) {
            c.Status = 'Closed Case';
        }
        Update lstCase;
    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

   /* static testMethod void TestBatchLeadConvertDistribute() {
       Test.startTest();
        ID batchprocessid;
        BatchExecRemoveCaseHistory reassign;
        reassign = new BatchExecRemoveCaseHistory ('Select ID from Lead limit 200',false);
        batchprocessid = Database.executeBatch(reassign);   
        Test.StopTest();     
    }*/    
}