global class BatchUploadRecordMatchingProcessExec2 implements Database.Batchable<sObject> {
    global final String Query;
    global boolean IsTest;    
    global BatchUploadRecordMatchingProcessExec2 (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchPB5HouseHoldProcess (scope);
    }
    void DoBatchPB5HouseHoldProcess (List<sObject> scope) {
        
    }
    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

    static testMethod void TestBatchExecPB5HouseHoldProcess () {
        /*Test.startTest();
        
        ID batchprocessid;
        BatchUploadRecordMatchingProcessExec2 reassign;
        reassign = new BatchUploadRecordMatchingProcessExec2 ('Select ID from Lead limit 200');
        batchprocessid = Database.executeBatch(reassign);   
        Test.StopTest();
        */
    }    
}