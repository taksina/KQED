global class BatchOppRdCloser implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;
    
    global BatchOppRdCloser(){
    	// original - 
        // 'WHERE tatransactions_id__c != null and transaction_type_value__c = \'PL\' and gift_kind_value__c IN (\'IN\', \'SG\') and pledge_status_value__c = \'FF\' and  ' + 
        // 'Recurring_Donation__c = null and household__c = null and AccountId = null and Oppty_Related_Contact__c = null';    	
        this.query = 'SELECT ta_opportunity_id__c, ' + //last_payment_date__c, ' +
        			 	' gift_kind__c, ' + //pledge_status_value__c, ' +
        			 	' Recurring_Donation_Opportunity__c, AccountId, Oppty_Related_Contact__c, ' +
        			 	' batch_process_count__c ' +        			 	
                     'FROM Opportunity  ' + 
        			 'Where batch_process_count__c = 3';
    }
    
    global BatchOppRdCloser(Boolean chainFlag){
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
            Opportunity opp = (Opportunity) s;
            //Batch condition.
            if(	opp.ta_opportunity_id__c != null && 
            	//opp.transaction_type_value__c == 'PL' && 
            	( opp.gift_kind__c == 'IN' || opp.gift_kind__c == 'SG' ) && 
            	//opp.pledge_status_value__c == 'FF' &&  
        		opp.Recurring_Donation_Opportunity__c == null &&        			
        		//opp.household__c == null &&       			
        		opp.AccountId == null &&      			
        		opp.Oppty_Related_Contact__c == null) {
            	scope2.add(s);	
            }
            else {
            	scope3.add(s);	            	
            	opp.batch_process_count__c--;	
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
        List<String> rdTaIds = new List<String>();
        
        // 0     1  2    3    4  5
        //328858_02_I_PLEDGE#_03_01
        //Orphan__c[] orphans = new List<Orphan__c>();         
        for(Sobject s : scope){         
            Opportunity opp = (Opportunity) s;
            try {
                String[] oData = opp.ta_opportunity_id__c.split('_');
                rdTaIds.add(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3] + '_' + oData[4]);
            }
            catch (Exception ex) {
            	/*
                orphans.add( new Orphan__c(
                    orphan_type__c='Object',
                    classname__c='Opportunity',
                    exception_message__c=ex.getMessage(),
                    batchname__c='BatchOppRdCloser',
                    ta_id__c=opp.TaTransactions_Id__c,
                    object_id__c=s.id)
                );
                */
            }               
        }
        
        List<Opportunity> rds = [SELECT id, ta_opportunity_id__c, Amount, Paid_Amount__c, //last_payment_date__c, 
                                                (Select Name, StageName, Amount, new_installment_amount__c, CloseDate From Giving_Installments__r) 
                                           FROM Opportunity WHERE ta_opportunity_id__c IN :rdTaIds];
        Map<String, Opportunity> rdsMap = new Map<String, Opportunity>();
        for(Opportunity rd : rds) {
            rdsMap.put(rd.ta_opportunity_id__c, rd);
        }
        
        List<Opportunity> oppsToDelete = new List<Opportunity>();
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        List<Opportunity> rdsToUpdate = new List<Opportunity>();
        
        for(Sobject s : scope){
            Opportunity pledgeOpp = (Opportunity) s;
            try {
                String[] oData = pledgeOpp.ta_opportunity_id__c.split('_');
                Opportunity rd = rdsMap.get(oData[0] + '_' + oData[1] + '_' + oData[2] + '_' + oData[3] + '_' + oData[4]);
                if(rd != null && rd.paid_amount__c < rd.Amount /*&& pledgeOpp.last_payment_date__c != null*/ ) {
                	rd.paid_amount__c = rd.Amount;
                	//rd.last_payment_date__c = pledgeOpp.last_payment_date__c;
                    List<Opportunity> opportunities = rd.Giving_Installments__r;
                    if(opportunities != null && opportunities.size() > 0) {
	                    for(Opportunity opp : opportunities) {
	                    	if(opp.StageName == 'Pledged') {
		                        opp.Amount = opp.new_installment_amount__c;
		                        //opp.CloseDate = pledgeOpp.last_payment_date__c;
	                            opp.StageName = 'Closed Won';
	                    	}
	                    	else if(opp.StageName == 'Partial Close') {
                                opp.StageName = 'Closed Won';
                            } 
	                    }
	                    oppsToUpdate.addAll(opportunities);
                    }
                    oppsToDelete.add(pledgeOpp);
                    rdsToUpdate.add(rd);
                    pledgeOpp.batch_process_count__c--;
                }
            }
            catch (Exception ex) {
            	System.debug(ex);
            	/*
                orphans.add( new Orphan__c(
                    orphan_type__c='Object',
                    classname__c='Opportunity',
                    exception_message__c=ex.getMessage(),
                    batchname__c='BatchOppRdCloser',
                    ta_id__c=pledgeOpp.TaTransactions_Id__c,
                    object_id__c=s.id)
                );
                */
            }                   
        }
        
        update oppsToUpdate;
        delete oppsToDelete;
        update rdsToUpdate;
        //if(orphans.size()>0) insert orphans;           
    }
    
    public static testMethod void testBatch() {
    	Opportunity o = new Opportunity(
           ta_opportunity_id__c = '23456_01_I_1230987_03_01',
           Name = 'Test Pledge Opporutnity 1',
           StageName = 'Closed Won',
           CloseDate = Date.today() - 5, 
           Gift_Date_Time__c = Date.today() - 5, 
           //last_payment_date__c = Date.today() - 5, 
           new_installment_amount__c = 100, 
           amount = 300, 
           payment_number__c = 1, 
           //pledge_status_value__c = 'FF', 
           gift_kind__c = 'IN', 
           //transaction_type_value__c = 'PL', 
           bulk_load__c = true,
           batch_process_count__c = 3
        );
        insert o;
        Opportunity rd1 = new Opportunity(
           ta_opportunity_id__c = '23456_01_I_1230987_03',
           Name = 'Test RD 1',
           Gift_Date_Time__c = Date.today(),
           paid_amount__c = 200, 
           Amount = 300, 
           bulk_load__c = true
        );
        insert rd1;
        Opportunity o11 = new Opportunity(
           ta_opportunity_id__c = '23456_01_I_1230987_03_01_installment',
           Name = 'Test Opporutnity 1',
           StageName = 'Pledged',
           CloseDate = Date.today() - 5, 
           Gift_Date_Time__c = Date.today() - 5, 
           Recurring_Donation_Opportunity__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 1,
           batch_process_count__c = 3
        );
        insert o11;
        Opportunity o12 = new Opportunity(
           ta_opportunity_id__c = '23456_01_I_1230987_03_02_installment',
           Name = 'Test Opporutnity 2',
           StageName = 'Partial Close',
           CloseDate = Date.today() - 5, 
           Gift_Date_Time__c = Date.today() - 5, 
           Recurring_Donation_Opportunity__c = rd1.Id, 
           new_installment_amount__c = 100, 
           amount = 100, 
           payment_number__c = 2,
           batch_process_count__c = 3
        );
        
        Test.StartTest();
        BatchOppRdCloser batch = new BatchOppRdCloser();
        batch.query += ' AND ta_opportunity_id__c = \'23456_01_I_1230987_03_01\' LIMIT 3 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Opportunity trd1 = [SELECT Amount, paid_amount__c /*, last_payment_date__c*/ FROM Opportunity WHERE ta_opportunity_id__c = :rd1.ta_opportunity_id__c][0];
        System.AssertEquals(trd1.Amount, trd1.paid_amount__c);
        //System.AssertEquals(trd1.last_payment_date__c, o.last_payment_date__c);
    }    

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchOppRdCloser', chainFlag);
    }
}