global class BatchHouseholdAddressPref implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchHouseholdAddressPref(){
        this.query = 'Select h.Preferred_Address__c, h.Id, (Select Name, tempPreferred__c From Addresses__r) From Account h where h.Preferred_Address__c = null and h.Id in (Select Account_Household__c from address__c where Account_Household__c != null)';
    }
    
    global BatchHouseholdAddressPref(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
		//Orphan__c[] orphans = new List<Orphan__c>();      	
        for(Sobject s : scope){
            Account household = (Account) s;
            try {
	            if(household.addresses__r.size() == 1) {
	                household.preferred_Address__c = household.addresses__r[0].id;
	            }
	            else if(household.addresses__r.size() > 1) {
	                for(Address__c address : household.addresses__r) { 
	                    if(address.tempPreferred__c) {
	                        household.preferred_Address__c = address.Id;
	                        break;
	                    }
	                }
	                if(household.preferred_Address__c == null) {
	                    household.preferred_Address__c = household.addresses__r[0].id; 
	                }
	            }
        	}
        	catch (Exception ex) {
        		/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Household__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchHouseholdAddressPref',
        			ta_id__c=String.valueOf(household.TA_Account_Id__c),
        			object_id__c=s.id)
        		);
        		*/
        	}	            
        }
        update scope;
		//if(orphans.size()>0) insert orphans;          
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchHouseholdAddressPref', chainFlag);
    }
    
    public static testMethod void testBatch() {
    	Account h1 = new Account(
           Name = 'Mr. & Mrs. Joe Dirt', 
           TaAccountId__c = 900123451
        );
        insert h1;
        Address__c a11 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '900123451_00_I_01', 
            Account_Household__c = h1.id
        );
        insert a11;
        
        Account h2 = new Account(
           Name = 'Mr. & Mrs. Fred Dirt', 
           TaAccountId__c = 900123452
        );
        insert h2;
        Address__c a21 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '900123452_00_I_01', 
            Account_Household__c = h2.id
        );
        insert a21;
        Address__c a22 = new Address__c(
            Name = '10 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '900123452_00_I_02', 
            Account_Household__c = h2.id
        );
        insert a22;
        
        Account h3 = new Account(
           Name = 'Mr. & Mrs. Ralph Dirt', 
           TaAccountId__c = 900123453
        );
        insert h3;
        Address__c a31 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '900123453_00_I_01', 
            Account_Household__c = h3.id
        );
        insert a31;
        Address__c a32 = new Address__c(
            Name = '10 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '900123453_00_I_02', 
            Account_Household__c = h3.id, 
            tempPreferred__c = true
        );
        insert a32;
        
        Test.StartTest();
        BatchHouseholdAddressPref batch = new BatchHouseholdAddressPref();
        batch.query += ' AND h.TaAccountId__c IN (900123451, 900123452, 900123453)';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Account th1 = [SELECT preferred_Address__c FROM Account WHERE TaAccountId__c = :h1.TaAccountId__c][0];
        System.AssertEquals(th1.preferred_Address__c, a11.id);
        
        Account th2 = [SELECT preferred_Address__c FROM Account WHERE TaAccountId__c = :h2.TaAccountId__c][0];
        System.AssertEquals(th2.preferred_Address__c, a21.id);
        
        Account th3 = [SELECT preferred_Address__c FROM Account WHERE TaAccountId__c = :h3.TaAccountId__c][0];
        System.AssertEquals(th3.preferred_Address__c, a32.id);
    }
}