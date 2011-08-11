global class UploadRecordMatchingProcess_Scheduled implements Schedulable{ 
    global void execute(SchedulableContext SC) {
        BatchUploadRecordMatchingProcess.BatchUploadRecordMatchingProcess();
    }
}