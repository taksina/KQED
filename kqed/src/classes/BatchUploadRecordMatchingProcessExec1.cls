global class BatchUploadRecordMatchingProcessExec1 implements Database.Batchable<sObject> {
    global final String Query;
    global boolean IsTest;    
    global BatchUploadRecordMatchingProcessExec1 (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchPB5HouseHoldProcess (scope);
    }
    
    void DoBatchPB5HouseHoldProcess (List<sObject> scope) {

        Set<Decimal> SFDCID = New Set<Decimal>();
        Set<String> SFDCID_String = New Set<String>();
        
        
        for(sObject s : scope) {
            WGBH_PB5_UPLOAD__c PB5 = (WGBH_PB5_UPLOAD__c)s;
            String householdId = UploadRecordMatchingHouseHold.ProcessHousehold(PB5);
            UploadRecordMatchingContact.ProcessContact(PB5,householdId);
            //UploadRecordMatchingClassification.ProcessClassification(PB5);
            SFDCID.add(PB5.PB5_SFDC_ID__c);
            SFDCID_String.add(string.valueOf(PB5.PB5_SFDC_ID__c));
        }
    }
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }    

    static testMethod void TestBatchExecPB5HouseHoldProcess () {
        Test.startTest();
        /*
        ID batchprocessid;
        BatchUploadRecordMatchingProcessExec1 reassign;
        reassign = new BatchUploadRecordMatchingProcessExec1 ('Select ID from Lead limit 200');
        batchprocessid = Database.executeBatch(reassign);   
        Test.StopTest();
        */
    }    
}