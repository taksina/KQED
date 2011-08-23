global class BatchExecUpdateContactStatus implements Database.Batchable<sObject> {
    global final String Query;
    global BatchExecUpdateContactStatus (String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoBatchUpdateContactStatus(scope);
    }    
    void DoBatchUpdateContactStatus(List<sObject> scope) {
        List<Contact> lstContact = (List<Contact>) scope;
        
        for(Contact c: lstContact) {
            if(c.STS__c == 'A'){
                c.Contact_Status__c = 'Active';
            }
        }
        Update lstContact;
    }    
    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }        
}