trigger InteractionTrigger on Case (after insert, before update) {
        Case firstRecord = (Case) Trigger.new[0];
        if(Trigger.isUpdate) {
            /** Test for bulk_load update from true -> false; **/
            Case oldClazz = Trigger.oldMap.get(firstRecord.Id);
            if(oldClazz.bulk_load__c==true && firstRecord.bulk_load__c==false) 
                return; 
            /** Test for Batch processing; **/  
            if(Trigger.new.size()>1) // Having problems with bulk_load flags being removed on orphaned cases.
                return;                                 

        }
}