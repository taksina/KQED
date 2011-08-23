global class BatchGivingLevelUpdate implements Database.Batchable<sObject>{
    global String query;
    global Boolean chainFlag = false;

    global BatchGivingLevelUpdate(){
        this.query = 'Select Annual_Giving_Level__c, (Select RecordType.Name, current_mem_yr_renew_date__c, expiration_date__c, current_mem_yr_amt__c From Account_Activities__r) From Account';
    }
    
    global BatchGivingLevelUpdate(Boolean chainFlag){
        this();
        this.chainFlag = chainFlag;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope){
        for(Sobject s : scope){
            Account household = (Account) s;
            List<Giving_Summary__c> activities = household.Account_Activities__r;
            if(activities != null && activities.size() > 0) {
                for(Giving_Summary__c activity : activities) {
                	if((activity.RecordType.Name == 'Annual Giving' || activity.RecordType.Name == 'Annual Giving' || activity.RecordType.Name == 'Annual Giving') && 
                	       activity.expiration_date__c != null && activity.expiration_date__c >= System.today() && 
                	       activity.current_mem_yr_renew_date__c != null && activity.current_mem_yr_renew_date__c <= System.today()) {
                	    
                	    household.Annual_Giving_Level__c = '';
                	    household.bulk_load__c = true;
                	    
                	    if(activity.current_mem_yr_amt__c > 0.01 && activity.current_mem_yr_amt__c < 99.99) {
                	    	if(activity.RecordType.Name == 'Annual Giving') {
                	    		household.Annual_Giving_Level__c = 'WGBH Membership';
                	    	}
                	    	else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBY Membership';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'Cape & Islands Membership';
                            }
                            else {
                            	household.Annual_Giving_Level__c = '';
                            }
                	    }
                	    else if(activity.current_mem_yr_amt__c > 100 && activity.current_mem_yr_amt__c < 359.99) {
                            if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBH Mid Level';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBY Mid Level';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'Cape & Islands Mid Level';
                            }
                            else {
                                household.Annual_Giving_Level__c = '';
                            }
                        }
                        else if(activity.current_mem_yr_amt__c > 360 && activity.current_mem_yr_amt__c < 1249.99) {
                            if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBH Leadership';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBY Leadership';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'Cape & Islands Leadership';
                            }
                            else {
                                household.Annual_Giving_Level__c = '';
                            }
                        }
                        else if(activity.current_mem_yr_amt__c > 1250 && activity.current_mem_yr_amt__c < 25000) {
                            if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBH Ralph Lowell Society';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'WGBY Murrow Society';
                            }
                            else if(activity.RecordType.Name == 'Annual Giving') {
                                household.Annual_Giving_Level__c = 'Cape & Islands Major Donor';
                            }
                            else {
                                household.Annual_Giving_Level__c = '';
                            }
                        }
                        else {
                            household.Annual_Giving_Level__c = '';
                        }
                	}
                }
            }
        }
        update scope;
    }

    global void finish(Database.BatchableContext BC){
        BatchDispatcherInboundEmail bdie = new BatchDispatcherInboundEmail();
        bdie.dispatchBatch('BatchGivingLevelUpdate', chainFlag);
    }
    
    public static testMethod void testBatch() {
    	ID annualGivingRtId;
    	List<RecordType> rt = [select Id from RecordType where Name = 'Annual Giving' and SObjectType = 'Giving_Summary__c' limit 1];
    	if ( rt.size() == 1 ) {
    		annualGivingRtId = rt[0].Id;
    	}

        Account h1 = new Account(Name = 'Mr. & Mrs. 1', TaAccountId__c = 900123401, bulk_load__c = true); insert h1;
        Giving_Summary__c a1 = new Giving_Summary__c(TA_AActivity_ID__c = '900123401_I_HA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1, 
                                Account__c = h1.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a1;
        Account h2 = new Account(Name = 'Mr. & Mrs. 2', TaAccountId__c = 900123402); insert h2;
        Giving_Summary__c a2 = new Giving_Summary__c(TA_AActivity_ID__c = '900123402_I_YA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1, 
                                Account__c = h2.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a2;
        Account h3 = new Account(Name = 'Mr. & Mrs. 3', TaAccountId__c = 900123403); insert h3;
        Giving_Summary__c a3 = new Giving_Summary__c(TA_AActivity_ID__c = '900123403_I_IA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1, 
                                Account__c = h3.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a3;
        Account h4 = new Account(Name = 'Mr. & Mrs. 4', TaAccountId__c = 900123404); insert h4;
        Giving_Summary__c a4 = new Giving_Summary__c(TA_AActivity_ID__c = '900123404_I_HA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 101, 
                                Account__c = h4.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a4;
        Account h5 = new Account(Name = 'Mr. & Mrs. 5', TaAccountId__c = 900123405); insert h5;
        Giving_Summary__c a5 = new Giving_Summary__c(TA_AActivity_ID__c = '900123405_I_YA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 101, 
                                Account__c = h5.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a5;
        Account h6 = new Account(Name = 'Mr. & Mrs. 6', TaAccountId__c = 900123406); insert h6;
        Giving_Summary__c a6 = new Giving_Summary__c(TA_AActivity_ID__c = '900123406_I_IA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 101, 
                                Account__c = h6.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a6;
        Account h7 = new Account(Name = 'Mr. & Mrs. 7', TaAccountId__c = 900123407); insert h7;
        Giving_Summary__c a7 = new Giving_Summary__c(TA_AActivity_ID__c = '900123407_I_HA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 361, 
                                Account__c = h7.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a7;
        Account h8 = new Account(Name = 'Mr. & Mrs. 8', TaAccountId__c = 900123408); insert h8;
        Giving_Summary__c a8 = new Giving_Summary__c(TA_AActivity_ID__c = '900123408_I_YA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 361, 
                                Account__c = h8.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a8;
        Account h9 = new Account(Name = 'Mr. & Mrs. 9', TaAccountId__c = 900123409); insert h9;
        Giving_Summary__c a9 = new Giving_Summary__c(TA_AActivity_ID__c = '900123409_I_IA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 361, 
                                Account__c = h9.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a9;
        Account h10 = new Account(Name = 'Mr. & Mrs. 10', TaAccountId__c = 900123410); insert h10;
        Giving_Summary__c a10 = new Giving_Summary__c(TA_AActivity_ID__c = '900123410_I_HA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1251, 
                                Account__c = h10.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a10;
        Account h11 = new Account(Name = 'Mr. & Mrs. 11', TaAccountId__c = 900123411); insert h11;
        Giving_Summary__c a11 = new Giving_Summary__c(TA_AActivity_ID__c = '900123411_I_YA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1251, 
                                Account__c = h11.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a11;
        Account h12 = new Account(Name = 'Mr. & Mrs. 12', TaAccountId__c = 900123412); insert h12;
        Giving_Summary__c a12 = new Giving_Summary__c(TA_AActivity_ID__c = '900123412_I_IA', RecordTypeId = annualGivingRtId, current_mem_yr_amt__c = 1251, 
                                Account__c = h12.id, expiration_date__c = System.today(), current_mem_yr_renew_date__c = System.today()); insert a12;
        
        Test.StartTest();
        BatchGivingLevelUpdate batch = new BatchGivingLevelUpdate();
        batch.query += ' WHERE TaAccountId__c > 900123400 AND TaAccountId__c < 900123413 ';
        ID batchprocessid = Database.executeBatch(batch);
        Test.StopTest();
        
        Account[] hh = [SELECT Annual_Giving_Level__c FROM Account WHERE TaAccountId__c > 900123400 AND TaAccountId__c < 900123413 Order by TaAccountId__c];
        System.AssertEquals(hh[0].Annual_Giving_Level__c, 'WGBH Membership');
        System.AssertEquals(hh[1].Annual_Giving_Level__c, 'WGBY Membership');
        System.AssertEquals(hh[2].Annual_Giving_Level__c, 'Cape & Islands Membership');
        System.AssertEquals(hh[3].Annual_Giving_Level__c, 'WGBH Mid Level');
        System.AssertEquals(hh[4].Annual_Giving_Level__c, 'WGBY Mid Level');
        System.AssertEquals(hh[5].Annual_Giving_Level__c, 'Cape & Islands Mid Level');
        System.AssertEquals(hh[6].Annual_Giving_Level__c, 'WGBH Leadership');
        System.AssertEquals(hh[7].Annual_Giving_Level__c, 'WGBY Leadership');
        System.AssertEquals(hh[8].Annual_Giving_Level__c, 'Cape & Islands Leadership');
        System.AssertEquals(hh[9].Annual_Giving_Level__c, 'WGBH Ralph Lowell Society');
        System.AssertEquals(hh[10].Annual_Giving_Level__c, 'WGBY Murrow Society');
        System.AssertEquals(hh[11].Annual_Giving_Level__c, 'Cape & Islands Major Donor');
    }
}