global class BatchContactAddressPref implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchContactAddressPref(){
        this.query = 'Select c.Preferred_Address__c, c.Id, (Select Name, tempPreferred__c From Addresses__r) From Contact c where c.Preferred_Address__c = null and c.Id in (Select contact__c from address__c where contact__c != null)';
    }
    
    global BatchContactAddressPref(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
		//Orphan__c[] orphans = new List<Orphan__c>();      	
        for(Sobject s : scope){
            Contact contact = (Contact) s;
            try {
	            if(contact.addresses__r.size() == 1) {
	                contact.preferred_Address__c = contact.addresses__r[0].id;
	            }
	            else if(contact.addresses__r.size() > 1) {
	                for(Address__c address : contact.addresses__r) { 
	                    if(address.tempPreferred__c) {
	                        contact.preferred_Address__c = address.Id;
	                        break;
	                    }
	                }
	                if(contact.preferred_Address__c == null) {
	                    contact.preferred_Address__c = contact.addresses__r[0].id; 
	                }
	            }
        	}
        	catch (Exception ex) {
        		/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Contact',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchContactAddressPref',
        			ta_id__c=contact.TaContactId__c,
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
        bdie.dispatchBatch('BatchContactAddressPref', chainFlag);
    }
    
    public static testMethod void testBatch() {
        Contact c1 = new Contact(
           FirstName = 'Joe', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_01_I'
        );
        insert c1;
    	Address__c a11 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '12345_01_I_01', 
            Contact__c = c1.id
        );
        insert a11;
        
        Contact c2 = new Contact(
           FirstName = 'Fred', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_02_I'
        );
        insert c2;
        Address__c a21 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '12345_02_I_01', 
            Contact__c = c2.id
        );
        insert a21;
        Address__c a22 = new Address__c(
            Name = '10 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '12345_02_I_02', 
            Contact__c = c2.id
        );
        insert a22;
        
        Contact c3 = new Contact(
           FirstName = 'Ralph', 
           LastName = 'Dirt', 
           TaContactId__c = '12345_03_I'
        );
        insert c3;
        Address__c a31 = new Address__c(
            Name = '1 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '12345_03_I_01', 
            Contact__c = c3.id
        );
        insert a31;
        Address__c a32 = new Address__c(
            Name = '10 Guest Street', 
            City__c = 'Boston', 
            State__c = 'MA', 
            TAAddressId__c = '12345_03_I_02', 
            Contact__c = c3.id, 
            tempPreferred__c = true
        );
        insert a32;
        
        Test.StartTest();
        BatchContactAddressPref batch = new BatchContactAddressPref();
        batch.query += ' AND c.TaContactId__c in ( \'12345_01_I\', \'12345_02_I\', \'12345_03_I\')  LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Contact tc1 = [SELECT preferred_Address__c FROM Contact WHERE TaContactId__c = :c1.TaContactId__c][0];
        System.AssertEquals(tc1.preferred_Address__c, a11.id);
        
        Contact tc2 = [SELECT preferred_Address__c FROM Contact WHERE TaContactId__c = :c2.TaContactId__c][0];
        System.AssertEquals(tc2.preferred_Address__c, a21.id);
        
        Contact tc3 = [SELECT preferred_Address__c FROM Contact WHERE TaContactId__c = :c3.TaContactId__c][0];
        System.AssertEquals(tc3.preferred_Address__c, a32.id);
    }
}