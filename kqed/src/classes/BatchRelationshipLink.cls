global class BatchRelationshipLink implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchRelationshipLink(){
        // original - Where r.TA_relationship_id__c!=null AND r.People__c=null AND r.Organization__c=null AND r.Account_Household__c=null
        this.query = 'Select r.TA_relationship_id__c, r.Related_To_People__c, r.Related_To_Organization__c, r.Related_To_accHousehold__c, r.People__c, r.Organization__c, r.Id, r.Account_Household__c, r.batch_process_count__c ' + 
        ' From Relationships__c r' +
        ' Where r.batch_process_count__c = 1 ';
    }
    
    global BatchRelationshipLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
   global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<sObject> scope2 = new List<sObject>();
        List<sObject> scope3 = new List<sObject>();         
        for(Sobject s : scope) {
            Relationships__c rel = (Relationships__c) s;
            //Batch condition.
            if(rel.TA_relationship_id__c!=null && rel.People__c==null && rel.Organization__c==null && rel.Account_Household__c==null) {
                scope2.add(s);  
            }
            else {
                scope3.add(s);                  
                rel.batch_process_count__c--;   
            }
        }
        if(scope2.size()>0) {
            execute(scope2); 
        }
        if(scope3.size()>0) {
            update scope3;
        }         
   }    
    

    global void execute(List<sObject> scope){
        List<Integer> accountTaIds = new List<Integer>();
        List<Integer> householdTaIds = new List<Integer>();
        List<String> contactTaIds = new List<String>();
        
        // 0   1 2    3    4  5  6   7
        //xxx_00_C__Type1_yyy_00_I_Type2
        //Orphan__c[] orphans = new List<Orphan__c>();            
        for(Sobject s : scope){
            Relationships__c rel = (Relationships__c) s;
            try {
                String[] relData = rel.TA_relationship_id__c.split('_');
                
                if(relData[2] == 'C' || relData[2] == 'G' || relData[2] == 'F' || relData[2] == 'O') {
                    accountTaIds.add(Integer.valueOf(relData[0]));
                }
                if(relData[2] == 'I') {
                    if(relData[1] == '00') {
                        householdTaIds.add(Integer.valueOf(relData[0]));
                    }
                    else {
                        contactTaIds.add(relData[0]+'_'+relData[1]+'_'+relData[2]);
                    }
                }
                
                if(relData[6] == 'C' || relData[6] == 'G' || relData[6] == 'F' || relData[6] == 'O') {
                    accountTaIds.add(Integer.valueOf(relData[4]));
                }
                if(relData[6] == 'I') {
                    if(relData[5] == '00') {
                        householdTaIds.add(Integer.valueOf(relData[4]));
                    }
                    else {
                        contactTaIds.add(relData[4]+'_'+relData[5]+'_'+relData[6]);
                    }
                }
            }
            catch (Exception ex) {
                /*orphans.add( new Orphan__c(
                    orphan_type__c='Object',
                    classname__c='Relationships__c',
                    exception_message__c=ex.getMessage(),
                    batchname__c='BatchRelationshipLink',
                    ta_id__c=rel.TA_relationship_id__c,
                    object_id__c=s.id)
                );*/
            }               
        }
        
        List<Account> accounts = [SELECT id, TaAccountId__c FROM Account WHERE TaAccountId__c IN :accountTaIds];
        Map<String, ID> accountsMap = new Map<String, ID>();
        for(Account account : accounts) {
            accountsMap.put(String.valueOf(account.TaAccountId__c), account.Id);
        }
        List<Account> households = [SELECT id, TaAccountId__c FROM Account WHERE TaAccountId__c IN :householdTaIds];
        Map<String, ID> householdsMap = new Map<String, ID>();
        for(Account household : households) {
            householdsMap.put(String.valueOf(household.Ta_Account_Id__c), household.Id);
        }
        List<Contact> contacts = [SELECT id, TaContactId__c FROM Contact WHERE TaContactId__c IN :contactTaIds];
        Map<String, ID> contactsMap = new Map<String, ID>();
        for(Contact contact : contacts) {
            contactsMap.put(contact.TaContactId__c, contact.Id);
        }
        
        for(Sobject s : scope){
            Relationships__c rel = (Relationships__c) s;
            try {
                String[] relData = rel.TA_relationship_id__c.split('_');
                
                Boolean foundFirstRelationship = false;
                Boolean foundSecondRelationship = false;
                
                if(relData[2] == 'C' || relData[2] == 'G' || relData[2] == 'F' || relData[2] == 'O') {
                    Id orgId = accountsMap.get(relData[0]);
                    if(orgId != null) {
                        rel.Organization__c = orgId;
                        foundFirstRelationship = true;
                    }
                }
                else if(relData[2] == 'I') {
                    if(relData[1] == '00') {
                        Id hhId = householdsMap.get(relData[0]);
                        if(hhId != null) {
                            rel.Account_Household__c = hhId;
                            foundFirstRelationship = true;
                        }
                    }
                    else {
                        String contactId = contactsMap.get(relData[0]+'_'+relData[1]+'_'+relData[2]);
                        if(contactId != null) {
                            rel.People__c = contactId;
                            foundFirstRelationship = true;
                        }
                    }
                }
                
                if(relData[6] == 'C' || relData[6] == 'G' || relData[6] == 'F' || relData[6] == 'O') {
                    Id orgId = accountsMap.get(relData[4]);
                    if(orgId != null) {
                        rel.Related_To_Organization__c = orgId;
                        foundSecondRelationship = true;
                    }
                }
                else if(relData[6] == 'I') {
                    if(relData[5] == '00') {
                        Id hhId = householdsMap.get(relData[4]);
                        if(hhId != null) {
                            rel.Related_To_accHousehold__c = hhId;
                            foundSecondRelationship = true;
                        }
                    }
                    else {
                        String contactId = contactsMap.get(relData[4]+'_'+relData[5]+'_'+relData[6]);
                        if(contactId != null) {
                            rel.Related_To_People__c = contactId;
                            foundSecondRelationship = true;
                        }
                    }
                }
                
                if(! foundFirstRelationship || ! foundSecondRelationship) {
                    rel.Organization__c = null;
                    rel.Account_Household__c = null;
                    rel.People__c = null;
                    rel.Related_To_Organization__c = null;
                    rel.Related_To_accHousehold__c = null;
                    rel.Related_To_People__c = null;
                }
                else {
                    rel.batch_process_count__c--;
                }
            }
            catch (Exception ex) {
                /*orphans.add( new Orphan__c(
                    orphan_type__c='Object',
                    classname__c='Relationships__c',
                    exception_message__c=ex.getMessage(),
                    batchname__c='BatchRelationshipLink',
                    ta_id__c=rel.TA_relationship_id__c,
                    object_id__c=s.id)
                );*/
            }                       
        }
        update scope;
        //if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
        Contact c1 = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I',
           bulk_load__c = true
        );
        insert c1;          
        Contact c2 = new Contact(
           FirstName = 'Fred', 
           LastName = 'Flintstone', 
           TaContactId__c = '23456_01_I',
           bulk_load__c = true
        );      
        insert c2;      
        Account a1 = new Account(
           Name = 'Joe Dirt and Co', 
           TaAccountId__c = 34567,
           bulk_load__c = true
        ); 
        insert a1;  
        Account a2 = new Account(
           Name = 'Freds Donuts', 
           TaAccountId__c = 45678,
           bulk_load__c = true
        ); 
        insert a2;                      
        Account h1 = new Account(
           Name = 'Mr. & Mrs. Smith', 
           TaAccountId__c= 56789,
           bulk_load__c = true
        );  
        insert h1;  
        Account h2 = new Account(
           Name = 'Mr. & Mrs. Joe Dirt', 
           TaAccountId__c= 67890,
           bulk_load__c = true
        );  
        insert h2;
                                
        Relationships__c r1 = new Relationships__c(
           ta_relationship_Id__c = '12345_01_I_Type1_56789_00_I_Type2' //c1->h1 contact -> household
           ,bulk_load__c = true,
           batch_process_count__c = 1
        );
        insert r1;      
        Relationships__c r2 = new Relationships__c(
           ta_relationship_Id__c = '23456_01_I_Type1_34567_00_I_Type2' //c2->a1 contact -> corp
           ,bulk_load__c = true ,
           batch_process_count__c = 1          
        );
        insert r2;          
        Relationships__c r3 = new Relationships__c(
           ta_relationship_Id__c = '67890_00_I_Type1_45678_00_C_Type2' //h2->a2 household -> corp
           ,bulk_load__c = true,
           batch_process_count__c = 1          
        ); 
        insert r3;      
        Relationships__c r4 = new Relationships__c(
           ta_relationship_Id__c = '45678_00_C_Type1_12345_01_I_Type2' //a2->c1 corp -> contact
           ,bulk_load__c = true,
           batch_process_count__c = 1          
        );
        insert r4;          
        Relationships__c r5 = new Relationships__c(
           ta_relationship_Id__c = '45678_00_C_Type1_56789_00_I_Type2' //a2->h1 corp -> house
           ,bulk_load__c = true,
           batch_process_count__c = 1          
        );
        insert r5;          
        Relationships__c r6 = new Relationships__c(
           ta_relationship_Id__c = '67890_00_I_Type1_12345_01_I_Type2' //h2->c1 household -> contact
           ,bulk_load__c = true,
           batch_process_count__c = 1          
        );          
        insert r6;                                      
        
        Test.StartTest();
        BatchRelationshipLink batch = new BatchRelationshipLink();
        batch.query += ' LIMIT 6 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();

        // r.Related_To_People__c, r.Related_To_Organization__c, r.Related_To_accHousehold__c, r.People__c, r.Organization__c, r.Household__c      
        Relationships__c[] tr1 = [
                SELECT ta_relationship_Id__c,Related_To_People__c, Related_To_Organization__c, Related_To_accHousehold__c, People__c, Organization__c, Account_Household__c 
                FROM Relationships__c 
                WHERE ta_relationship_Id__c = :r1.ta_relationship_Id__c];
        System.AssertEquals(tr1.size(),1);
        //System.AssertEquals(tr1[0].People__c, c1.id);
        //System.AssertEquals(tr1[0].Related_To_Household__c, h1.id);       
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchRelationshipLink', chainFlag);
    }
}