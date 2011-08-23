global class BatchRelationshipPairing implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchRelationshipPairing(){
        this.query = 'Select r.TA_relationship_id__c, r.Related_To_People__c, r.Related_To_Organization__c, r.Related_To_accHousehold__c, r.People__c, r.Organization__c, r.Id, r.Account_Household__c,'+ 
        'r.relationship_type__c, r.reverse_relationship_type__c, r.Primary_Rel__c, r.isReciprocal__c, r.Parent__c From Relationships__c r';
    }
    
    global BatchRelationshipPairing(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        Map<String, Relationships__c> relMap = new Map<String, Relationships__c>();
        Map<String, String> taIdMap1 = new Map<String, String>(); 
        Map<String, String> taIdMap2 = new Map<String, String>();
        
        // 0   1 2    3    4  5  6   7
        //xxx_00_C_Type1_yyy_00_I_Type2
        //Orphan__c[] orphans = new List<Orphan__c>();          
        for(Sobject s : scope){
            Relationships__c rel = (Relationships__c) s;
            try {
                relMap.put(rel.TA_relationship_id__c, rel);
                
                String[] relData = rel.TA_relationship_id__c.split('_');
                String reverseTaId = relData[4] + '_' +  relData[5] + '_' + relData[6] + '_' + relData[7] + '_' + relData[0] + '_' + relData[1] + '_' + relData[2] + '_' + relData[3];
                taIdMap1.put(rel.TA_relationship_id__c, reverseTaId);
                taIdMap2.put(reverseTaId, rel.TA_relationship_id__c);
                
                System.debug('relId: '+rel.TA_relationship_id__c+', revRelId:'+reverseTaId);
            }
            catch (Exception ex) {
                /*orphans.add( new Orphan__c(
                    orphan_type__c='Object',
                    classname__c='Relationships__c',
                    exception_message__c=ex.getMessage(),
                    batchname__c='BatchRelationshipPairing',
                    ta_id__c=rel.TA_relationship_id__c,
                    object_id__c=s.id)
                );*/
            }               
        }
        
        System.debug('size before: '+taIdMap1.size());
        for(Integer relIndex = 0; relIndex < taIdMap1.size(); relIndex ++) {
            String relValue = taIdMap1.values()[relIndex];
            for(String revRelValue : taIdMap2.values()) {
                if(relValue == revRelValue) {
                    relMap.remove(relValue);
                    taIdMap1.remove(relValue);
                }
            }
        }
        System.debug('size after: '+taIdMap1.size());
        List<Relationships__c> reverseRels = [Select r.TA_relationship_id__c,r.Related_To_accHousehold__c, r.Related_To_People__c, r.Related_To_Organization__c,  r.People__c, r.Organization__c, r.Id, r.Account_Household__c, 
        r.relationship_type__c, r.reverse_relationship_type__c, r.Primary_Rel__c, r.isReciprocal__c, r.Parent__c From Relationships__c r WHERE r.TA_relationship_id__c IN :taIdMap1.values()];
        
        for(Relationships__c revRel : reverseRels) {
            Relationships__c rel = relMap.get(taIdMap2.get(revRel.TA_relationship_id__c));
            
            rel.Primary_Rel__c = true;
            revRel.Primary_Rel__c = false;
            
            rel.isReciprocal__c = false;
            revRel.isReciprocal__c = true;
            
            rel.Parent__c = null;
            revRel.Parent__c = rel.Id;
        }
        
        update relMap.values();
        update reverseRels;
        //if(orphans.size()>0) insert orphans;        
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchRelationshipPairing', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Relationships__c r1 = new Relationships__c(
            TA_relationship_id__c = '12345_00_C_Type1_54321_00_I_Type2'
        );
        insert r1;
        
        Relationships__c r2 = new Relationships__c(
            TA_relationship_id__c = '54321_00_I_Type2_12345_00_C_Type1'
        );
        insert r2;
        
        Test.StartTest();
        BatchRelationshipPairing batch = new BatchRelationshipPairing();
        batch.query += ' WHERE r.TA_relationship_id__c IN (\'12345_00_C_Type1_54321_00_I_Type2\', \'54321_00_I_Type2_12345_00_C_Type1\')';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Relationships__c tr1 = [SELECT Parent__c FROM Relationships__c WHERE TA_relationship_id__c = :r1.TA_relationship_id__c][0];
        Relationships__c tr2 = [SELECT Parent__c FROM Relationships__c WHERE TA_relationship_id__c = :r2.TA_relationship_id__c][0];
        System.debug('tr1: '+tr1.Parent__c+', tr2:'+tr2.Parent__c);
        //System.Assert(tr1.parent__c == tr2.id || tr1.id == tr2.parent__c);
    }
}