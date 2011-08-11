global class BatchBequestLink implements Database.Batchable<sObject> {
    global String query;
    global Boolean chainFlag = false;

    global BatchBequestLink(){
    	//original - ' Where b.TaBequests_Id__c != null AND ( b.Opportunity__c = null OR ( b.Household__c = null AND b.Organization__c = null ))';
        this.query = 
        	'Select b.giving_vehicle_value__c, b.giving_vehicle__c,  b.activity_type__c, b.TaTransactions_Id__c, b.TaBequests_Id__c, b.RecordTypeId, ' + 
        	'b.Opportunity__c, ' +
        	' b.Organization__r.Name, b.Organization__c, b.Household__r.name_line__c, b.Household__c, b.Contact__r.Name, b.Contact__c ' + 
        	' From Bequest__c b ' +  	
        	' Where b.batch_process_count__c = 1';
    }
    
    global BatchBequestLink(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){       	
        List<String> transTaIds = new List<String>();
        
		//Orphan__c[] orphans = new List<Orphan__c>();  
		/**---------------------------------------------------------------------
		 * UPdate Name
		 */
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s; 				 	
			clazz.Name = clazz.giving_vehicle__c;
        }		
		/**-------------------------------------------------------------------------
		 * Hookup Opportunities
		 */             
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s; 			                  
            if(clazz.TaTransactions_Id__c!=null) {
            	transTaIds.add(clazz.TaTransactions_Id__c);
            }            
        }
        List<Opportunity> opps = [SELECT id, ta_opportunity_id__c FROM Opportunity WHERE ta_opportunity_id__c IN :transTaIds];
        Map<String, ID> transMap = new Map<String, ID>();
        for(Opportunity opp : opps) {
            transMap.put(String.valueOf(opp.ta_opportunity_id__c), opp.Id);
        }
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s;
			/**
			 * Connect to Opportunity
			 */ 
			if(clazz.TaTransactions_Id__c!=null && clazz.opportunity__c == null) {           
        		clazz.Opportunity__c = transMap.get(clazz.TaTransactions_Id__c);
        		if(clazz.Opportunity__c==null) {
        			/*
	        		orphans.add( new Orphan__c(
	        			orphan_type__c='Object',
	        			classname__c='Bequest__c',
	        			exception_message__c='Could not locate Opporutnity ' + clazz.TaTransactions_Id__c,
	        			batchname__c='BatchBequestLink',
	        			ta_id__c=clazz.TaTransactions_Id__c,
	        			object_id__c=s.id)
	        		);
	        		*/	        			
        		}
			}
			else {
				//todo create one.
			}
        }          
                            
		/**-------------------------------------------------------------------------
		 * Hookup Households/Accounts/Contact
		 */                 
        List<Integer> accountTaIds = new List<Integer>();
        List<Integer> householdTaIds = new List<Integer>();
        List<String> contactTaIds = new List<String>();        
        // 0   1 2  3 4
        //xxx_00_C_01      
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s;
        	try {            
	            String[] cData = clazz.tabequests_id__c.split('_');
	            // Lookups	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                accountTaIds.add(Integer.valueOf(cData[0]));
	            }
	            if(cData[2] == 'I') {
	                householdTaIds.add(Integer.valueOf(cData[0]));
	                if(cData[1] != '00') {
	                    contactTaIds.add(cData[0]+'_'+cData[1]+'_'+cData[2]);
	                }
	            }      
        	}
        	catch (Exception ex) {
        		/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Bequest__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchBequestLink',
        			ta_id__c=clazz.tabequests_id__c,
        			object_id__c=s.id)
        		);
        		*/
        	}	            
        }
        List<Account> accounts = [SELECT id, TaAccountId__c,name FROM Account WHERE TaAccountId__c IN :accountTaIds];
        Map<String, Account> accountsMap = new Map<String, Account>();
        for(Account account : accounts) {
            accountsMap.put(String.valueOf(account.TaAccountId__c), account);
        }
        List<Account> households = [SELECT id, TaAccountId__c, Name FROM Account WHERE TaAccountId__c IN :householdTaIds];
        Map<String, Account> householdsMap = new Map<String, Account>();
        for(Account household : households) {
            householdsMap.put(String.valueOf(household.TaAccountId__c), household);
        }
        List<Contact> contacts = [SELECT id, TaContactId__c, name FROM Contact WHERE TaContactId__c IN :contactTaIds];
        Map<String, Contact> contactsMap = new Map<String, Contact>();
        for(Contact contact : contacts) {
            contactsMap.put(contact.TaContactId__c, contact);
        }
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s;
            try {
	            String[] cData = clazz.tabequests_id__c.split('_');
	            
	            if(cData[2] == 'C' || cData[2] == 'G' || cData[2] == 'F' || cData[2] == 'O') {
	                Account orgId = accountsMap.get(cData[0]);
	                if(orgId != null) {
						clazz.name = clazz.giving_vehicle__c + ' - ' + orgId.name; 		                	
	                    clazz.Organization__c = orgId.Id;
	                }
	            }
	            else if(cData[2] == 'I') {
                    Account hhId = householdsMap.get(cData[0]);
                    if(hhId != null) {
						clazz.name = clazz.giving_vehicle__c + ' - ' + hhId.Name;                      	
                        clazz.Organization__c = hhId.Id;
                    }
	            }
                if(cData[1] != '00') {
                    Contact contactId = contactsMap.get(cData[0]+'_'+cData[1]+'_'+cData[2]);
                    if(contactId != null) {
						clazz.name = clazz.giving_vehicle__c + ' - ' + contactId.name;                      	
                        clazz.Contact__c = contactId.id;
                    }
                }           	            
        	}
        	catch (Exception ex) {
        		/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Bequest__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchBequestLink',
        			ta_id__c=clazz.tabequests_id__c,
        			object_id__c=s.id)
        		);
        		*/
        	}	  	            
        }                                            
              
		/**-------------------------------------------------------------------------
		 * Assign correct record types.
		 */                               
		Map<String,RecordType> recordtypeMap = new Map<String,RecordType>();
		recordtypeMap.put('BEQ',[select id from RecordType where name = 'Bequest' LIMIT 1]);
		recordtypeMap.put('CGA',[select id from RecordType where name = 'Charitable Gift Annuity' LIMIT 1]);
		recordtypeMap.put('CLAT',[select id from RecordType where name = 'Charitable Lead Annuity Trust' LIMIT 1]);
		recordtypeMap.put('CLUT',[select id from RecordType where name = 'Charitable Lead Unitrust' LIMIT 1]);
		recordtypeMap.put('CRAT',[select id from RecordType where name = 'Charitable Rem. Annuity Trust' LIMIT 1]);
		recordtypeMap.put('CRUT',[select id from RecordType where name = 'Charitable Rem. Unitrust' LIMIT 1]);
		recordtypeMap.put('DGA',[select id from RecordType where name = 'Deferred Gift Annuity' LIMIT 1]);
		recordtypeMap.put('LE',[select id from RecordType where name = 'Life Estate' LIMIT 1]);
		recordtypeMap.put('PIF',[select id from RecordType where name = 'Pooled Income Fund' LIMIT 1]);
		recordtypeMap.put('RP',recordtypeMap.get('BEQ'));
		recordtypeMap.put('LI',recordtypeMap.get('BEQ'));										
								      
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s;
			try {							
				/**
				 * Set record type
				 */
				RecordType rt = recordtypeMap.get(clazz.giving_vehicle_value__c==null ? 'BEQ' : clazz.giving_vehicle_value__c);
				if(rt==null) {
					/*
	        		orphans.add( new Orphan__c(
	        			orphan_type__c='Object',
	        			classname__c='Bequest__c',
	        			exception_message__c='Could not determine RecordType for vehicle = ' + clazz.giving_vehicle_value__c,
	        			batchname__c='BatchBequestLink',
	        			ta_id__c=clazz.TaBequests_Id__c,
	        			object_id__c=s.id)
	        		);
	        		*/	   					
				}
				else {
					clazz.RecordTypeId = rt.id;
				}				
					  				
        	}
        	catch (Exception ex) {
        		/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Bequest__c',
        			exception_message__c=ex.getMessage(),
        			batchname__c='BatchBequestLink',
        			ta_id__c=clazz.TaBequests_Id__c,
        			object_id__c=s.id)
        		);
        		*/
        	}		            
        }
		/**-------------------------------------------------------------------------
		 * Check for Orphans
		 */ 
        for(Sobject s : scope){
            Bequest__c clazz = (Bequest__c) s;					
			/**
			 * Set record type
			 */
			if(clazz.organization__c==null) {
				/*
        		orphans.add( new Orphan__c(
        			orphan_type__c='Object',
        			classname__c='Bequest__c',
        			exception_message__c='Could not find Household/Organization?',
        			batchname__c='BatchBequestLink',
        			ta_id__c=clazz.TaBequests_Id__c,
        			object_id__c=s.id)
        		);
        		*/	   					
			}
        }		            
        
        update scope;
		//if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
        Account h = new Account(
           Name = 'Mr. & Mrs. Joe Dirt', 
           TaAccountId__c = 23456,
           bulk_load__c=true
        );    	
    	Opportunity o1 = new Opportunity(
    	   ta_opportunity_id__c = '23456_01_I_1230987_03_01',
    	   Name = 'Test Contact Opporutnity',
    	   CloseDate = Date.today(),
    	   StageName = 'Cultivation',
    	   Gift_Date_Time__c = Date.today(), 
    	   bulk_load__c = true
    	);
    	insert o1; 
    	Bequest__c b1 = new Bequest__c(
    	   TaTransactions_Id__c = '23456_01_I_1230987_03_01',
    	   TaBequests_Id__c = '23456_01_I_01', 
    	   giving_vehicle_value__c = 'CLUT',   	   
    	   Name = 'Bequest Name'
    	);
    	insert b1;        	   	
        
        Test.StartTest();
		BatchBequestLink batch = new BatchBequestLink();
		batch.query += ' AND tatransactions_Id__c IN (\'23456_01_I_1230987_03_01\') LIMIT 10 ';
		ID batchprocessid = Database.executeBatch(batch);
		Test.StopTest();
		
		Bequest__c bequest = [SELECT Opportunity__c, recordtypeId FROM Bequest__c WHERE tatransactions_Id__c = :b1.tatransactions_Id__c][0];
		//todo:System.AssertEquals(bequest.Opportunity__c, o1.id);	
		//Orphan__c[] orphans = [SELECT id FROM Orphan__c WHERE classname__c = 'Bequest__c' AND ta_id__c = '23456_01_I_01'];
		//todo: System.AssertEquals(orphans.size(), 0);											
    }
    
    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchBequestLink', chainFlag);
    }
}