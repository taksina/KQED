global class BatchHouseholdContactPrefDataLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchHouseholdContactPrefDataLink(){
        this.query = 'SELECT Preferred_Address__c, Household_Phone__c, Household_Email__c, ' +  
                         '(SELECT TaContactId__c, WorkPhone__c, WorkEmail__c, Preferred_Email__c, Preferred_Address__c, PreferredPhone__c, MobilePhone, HomePhone, HomeEmail__c, bulk_load__c ' +   
                         'From Contacts__r) ' +  
                         //'WHERE ((WorkPhone__c = null AND MobilePhone = null AND HomePhone = null) OR (WorkEmail__c = null AND HomeEmail__c = null) OR Preferred_Address__c = null)) ' +  
                     'FROM Account ';  
    }
    
    global BatchHouseholdContactPrefDataLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Contact> contacts2bUpdated = new List<Contact>();
        for(Sobject s : scope){
            Account h = (Account) s;
            List<Contact> cs = h.Contacts__r;
            for(Contact c : cs) {
                //Make sure Contact.Preferred_Address__c filtered lookup is optional and not required.
                if(c.Preferred_Address__c == null && h.Preferred_Address__c != null) {
                   c.Preferred_Address__c = h.Preferred_Address__c;
                   c.bulk_load__c = true;
                }
                
                if(c.WorkPhone__c == null && c.MobilePhone == null && c.HomePhone == null && h.Household_Phone__c != null) {
                    c.HomePhone = h.Household_Phone__c;
                    c.PreferredPhone__c = 'Household';
                    c.bulk_load__c = true;
                }
                
                //Update email for first and only Contact
                if(cs.size() == 1 && c.WorkEmail__c == null && c.HomeEmail__c == null && h.Household_Email__c != null) {
                    c.HomeEmail__c = h.Household_Email__c;
                    c.Preferred_Email__c = 'Household';
                    c.bulk_load__c = true;
                }
            }
            contacts2bUpdated.addAll(cs);
        }
        update contacts2bUpdated;
    }

    public static testMethod void testBatch() {
        Test.StartTest();
        BatchHouseholdContactPrefDataLink batch = new BatchHouseholdContactPrefDataLink();
        batch.query += ' LIMIT 2 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();

    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchHouseholdContactPrefDataLink', chainFlag);
    }
}