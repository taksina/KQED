Public Class ProcessGivingSummary{
    Static List<RecordType> lstRecordType;
    Static List<Giving_Summary__c> lstSummary;
    Static List<Giving_Summary__c> lstInsert;
    Static List<Giving_Summary__c> lstUpdate;
    Static List<Giving_Summary__c> lstDelete;
    Static List<Giving_Summary__c> lstHistory;
    Static List<Opportunity> lstGiving;
    Static List<Opportunity> lstParentGiving;
    Static List<Giving_Summary_Control__c> lstSummaryControl;
    /******************************************************************************************/
    Static Map<ID,String> mapRecordTypeID;
    Static Map<String,ID> mapDeveloperName;
    Static Map<String, Giving_Summary__c> mapAccountSummaryAll;
    Static Map<String, Giving_Summary__c> mapAccountSummaryActive;
    Static Map<String, Giving_Summary__c> mapAccountSummaryHistory;
    Static Map<String, List<Giving_Summary__c>> mapAccountSummaryStation;
    Static Map<ID,Opportunity> mapParentGiving;
    /******************************************************************************************/
    Static String ADDGIFT = 'ADD GIFT';
    Static String UPGRADERESET = 'UPGRADE RESET';
    Static String RENEWAL = 'RENEWAL';
    Static String REJOIN = 'REJOIN';
    Static String NEWTYPE = 'NEW';
    Static String DONATION = 'DONATION';
    Static String PURCHASE = 'PURCHASE';    
    /******************************************************************************************/
    Static Void LoadRequiredData(Set<ID> sGivingIds){
        lstGiving = getGivingRecords(sGivingIds);
        loadParentGiving();
        getRecordType();
        getSummary();
        LoadGivingSummaryControl();
        lstInsert = new List<Giving_Summary__c>();
        lstUpdate = new List<Giving_Summary__c>();
        lstHistory = new List<Giving_Summary__c>();
        lstDelete = new List<Giving_Summary__c>();
    }
    /******************************************************************************************/
    //@future
    Public Static Void UpdateSummary(Set<ID> sGivingIds, Boolean IsDelete){
        System.debug('***************Update Summary Start******************');
        
        if(IsDelete == true)
            system.debug('###### Called for after update or after delete');
        else
            system.debug('###### Called for insert');
        Boolean IsInsert=true;
        if(IsDelete == true)IsInsert=false;
        LoadRequiredData(sGivingIds);
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity Giving:lstGiving){
                system.debug('###### Current Giving   --->   ' + Giving.Id);
                if(Giving.AccountID != null && Giving.Station__c != null){
                    setHistory(Giving,IsInsert);
                    if(IsAddOperation(Giving,IsInsert)==true){
                        lstInsert.add(setSummaryValues(Giving));
                    }else{
                        ResetSummary(IsDelete);
                    }
                }
            }            
            if(lstInsert != null && lstInsert.size() > 0){
                if(lstHistory != null && lstHistory.size() > 0){
                    system.debug('*******Total history update : ' + lstHistory.size());
                    Update lstHistory;            
                }
                system.debug('******** Total Sammary to insert : ' + lstInsert.size());
                Insert lstInsert;
            }
        }
        System.debug('***************Update Summary End******************');
    }
    
    Static Void setHistory(Opportunity Giving, Boolean IsInsert){
        if(IsAddOperation(Giving, IsInsert) == true){
            List<Giving_Summary__c> lstTempHistory = new List<Giving_Summary__c>();
            Giving_Summary__c objHistory = new Giving_Summary__c();
            if(Giving.Gift_Type__c != null 
            && (Giving.Gift_Type__c.trim().toUpperCase() == RENEWAL ||
                Giving.Gift_Type__c.trim().toUpperCase() == REJOIN )){
                if(mapAccountSummaryStation != null && mapAccountSummaryStation.containsKey(Giving.AccountID + Giving.Station__c)){
                    List<Giving_Summary__c> tmpSummary = mapAccountSummaryStation.get(Giving.AccountID + Giving.Station__c);
                    String DeveloperName = CommonApex.getDeveloperNameByCampaignName(Giving.Campaign_Name__c);
                    ID recordTypeid = getRecordTypeId(DeveloperName);
                    
                    if(tmpSummary != null && tmpSummary.size()>0){
                        for(Giving_Summary__c tmp:tmpSummary){
                            if(tmp.History__c == true && tmp.RecordTypeId == recordTypeid){
                                lstTempHistory.add(tmp);
                            }
                            if(tmp.History__c == false && tmp.RecordTypeId == recordTypeid){
                                objHistory = tmp;
                            }
                        }
                    }
                    
                    if(objHistory.Summary_Count__c == null){
                        objHistory.Summary_Count__c = 1.0;
                    }
                    else{
                        if(lstTempHistory != null && lstTempHistory.size()>0){
                            objHistory.Summary_Count__c = lstTempHistory.size();
                        }
                        else{
                            objHistory.Summary_Count__c = 1.0;
                        }
                    }
                    objHistory.History__c = true;
                    objHistory.History_Date_Time__c = Giving.CreatedDate; 
                    if(objHistory.id != null && IsInsert == true){
                        lstHistory.add(objHistory);
                        system.debug('######## Summary goes to history ' + objHistory);
                    }
                }
            }
        }
    }
    
    Static Boolean IsAddOperation(Opportunity Giving, Boolean IsInsert){
        Boolean flag = false;
        if(mapAccountSummaryStation != null && Giving.Station__c != null && mapAccountSummaryStation.containsKey(Giving.AccountID + Giving.Station__c)){
            List<Giving_Summary__c> tmpSummary = mapAccountSummaryStation.get(Giving.AccountID + Giving.Station__c);
            if(tmpSummary != null && tmpSummary.size()>0){
                system.debug('**********Summary Eixists****************');
                if(IsInsert == true && Giving.Gift_Type__c != null 
                && (Giving.Gift_Type__c.trim().toUpperCase() == RENEWAL ||
                    Giving.Gift_Type__c.trim().toUpperCase() == REJOIN )){
                    
                    Boolean SummaryFound = false;
                    
                    if(tmpSummary != null && tmpSummary.size()>0){
                        for(Giving_Summary__c tmp:tmpSummary){
                            
                            if(tmp.Gift_Type__c == null) tmp.Gift_Type__c = '';
                            
                            if(tmp.History__c == false && 
                            Giving.Gift_Type__c.trim().toUpperCase() == tmp.Gift_Type__c.trim().toUpperCase() &&
                            (tmp.GivingIds__c != null && tmp.GivingIds__c.trim().contains(String.valueOf(Giving.Id)))){
                                SummaryFound = true;
                            }
                            system.debug('#######Sammary Active : ' + tmp.History__c );
                            system.debug('#######Giving Gift Type : ' + Giving.Gift_Type__c);
                            system.debug('#######Summary Gift Type : ' + tmp.Gift_Type__c);
                            system.debug('#######Giving ID : ' + Giving.Id);
                            system.debug('#######Summary Giving ID : ' + tmp.GivingIds__c);
                        }
                    }
                    /*
                    if(SummaryFound == false){
                        for(Giving_Summary__c tmp:tmpSummary){
                            if(tmp.History__c == false && 
                            ((Giving.Gift_Type__c.trim().toUpperCase() == RENEWAL && tmp.Track__c.trim().toUpperCase().contains(RENEWAL)==false) || (Giving.Gift_Type__c.trim().toUpperCase() == REJOIN && tmp.Track__c.trim().toUpperCase().contains(REJOIN)==false) || (Giving.Gift_Type__c.trim().toUpperCase() == UPGRADERESET && tmp.Track__c.trim().toUpperCase().contains(UPGRADERESET)==false))){
                                SummaryFound = true;
                            }
                        }
                    }
                    */
                    if(SummaryFound == true)
                        flag = false;
                        //flag = true;
                    else
                        flag = true;
                        
                    ///////////////
                    //flag = true;
                    ///////////////
               }
               else{
                   flag = false;
               }            
            }
            else{
                flag = true;
            }            
        }
        else{
            flag = true;
        }
        if(flag == true)
            system.debug('************** Insert operation **********************');
        else
            system.debug('************** Update operation **********************');
        Return flag;
            
    }
    Static Integer ResetSummaryCounter = 1;
    Static Void ResetSummary(Boolean IsDelete){
        System.debug('***************Reset Summary Start******************');
        system.debug('######## Reset summary call ' + String.valueof(ResetSummaryCounter));
        ResetSummaryCounter++;
        Set<ID> sOldGivingIds = new Set<ID>();
        Set<ID> sAccountIds = new Set<ID>();
        List<Opportunity> lstAllGiving = new List<Opportunity>();
        Map<ID, List<Opportunity>> mapOppSummary = new Map<ID, List<Opportunity>>();
        if(lstGiving != null && lstGiving.size()>0){
            //getGivingByAccount
            for(Opportunity currentGiving:lstGiving){
                sAccountIds.add(currentGiving.AccountId);
            }
            if(sAccountIds != null && sAccountIds.size()>0){
                lstAllGiving = getGivingByAccount(sAccountIds);
            }
            for(Opportunity currentGiving:lstGiving){
                Giving_Summary__c objSummary = new Giving_Summary__c();
                Boolean SummaryFound = false;            
                if(mapAccountSummaryStation != null && mapAccountSummaryStation.containsKey(currentGiving.AccountID + currentGiving.Station__c)){
                    List<Giving_Summary__c> tmpSummary = mapAccountSummaryStation.get(currentGiving.AccountID + currentGiving.Station__c);
                    
                    String DeveloperName = CommonApex.getDeveloperNameByCampaignName(currentGiving.Campaign_Name__c);
                    ID recordTypeid = getRecordTypeId(DeveloperName);
                    
                    if(tmpSummary != null && tmpSummary.size()>0){
                        for(Giving_Summary__c tmp:tmpSummary){
                            if(tmp.History__c == false && tmp.RecordTypeId == recordTypeid){
                                objSummary = tmp;
                                SummaryFound = true;
                                system.debug('######### Summary to update: ' + objSummary.Id + ' (' + objSummary.Gift_Type__c + ')');
                            }
                        }
                    }
                }
                if(objSummary!=null) {
                    if(objSummary.GivingIds__c == null) objSummary.GivingIds__c = '';
                }
                if(SummaryFound == true){
                    System.debug('####### Giving Ids from Giving Summary: ' + objSummary.GivingIds__c.trim());
                    List<String> strIds = objSummary.GivingIds__c.trim().split('#');
                    List<Opportunity> lstTempOpp = new List<Opportunity>();
                    if(strIds != null && strIds.size()>0){
                        for(String str:strIds){
                            sOldGivingIds.add(ID.valueOf(str));
                        }
                        if(IsDelete == false) sOldGivingIds.add(currentGiving.Id);
                        if(lstAllGiving != null && lstAllGiving.size()>0){
                            for(Opportunity opp:lstAllGiving){
                                if(sOldGivingIds != null && sOldGivingIds.size()>0){
                                    for(String oppId:sOldGivingIds){
                                        if(oppId == string.valueOf(opp.Id)){
                                            lstTempOpp.add(opp);
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if(lstTempOpp.size()==0)lstTempOpp.add(currentGiving);
                    mapOppSummary.put(objSummary.Id, lstTempOpp);
                    system.debug('#### MAP for giving summary ' + objSummary.Id + ' ----> ' + mapOppSummary);
                }
            }
            Map<ID,Opportunity> mapChildParent = new Map<ID,Opportunity>();
            Map<ID,ID> mapChildParentIds = new Map<ID,ID>();
            List<Opportunity> lstOppParent = new List<Opportunity>();
            if(lstAllGiving != null && lstAllGiving.size()>0){
                for(Opportunity opp:lstAllGiving){
                    if(opp.Recurring_Donation_Opportunity__c != null){
                        mapChildParentIds.put(opp.Id,opp.Recurring_Donation_Opportunity__c);
                    }else{
                        lstOppParent.add(opp);
                    }
                }
                if(mapChildParentIds != null && mapChildParentIds.size()>0){
                    if(lstOppParent != null && lstOppParent.size()>0){
                        for(Opportunity opp:lstAllGiving){
                            if(opp.Recurring_Donation_Opportunity__c != null){
                                if(mapChildParentIds.containsKey(opp.Id)==true){
                                    ID ParentId = mapChildParentIds.get(opp.Id);
                                    if(ParentId != null){
                                        for(Opportunity parent:lstOppParent){
                                            if(parent.Id == ParentId){
                                                mapChildParent.put(opp.Id,parent);
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            lstUpdate = new List<Giving_Summary__c>();
            if(mapOppSummary != null && mapOppSummary.size()>0){
                system.debug('#####Total summaries : ' + lstSummary.size());
                for(Giving_Summary__c objSummary:lstSummary){                   
                    Integer totalGiving = 0;
                    Date currentDate, LastPaymentDate;
                    Integer CurrentFYYear = System.today().year();
                    Integer LastFYYear = System.today().year()-1;
                    system.debug('################## mapOppSummary: ' + mapOppSummary);
                    system.debug('################## mapOppSummary Size: ' + mapOppSummary.size());
                    system.debug('################## current objSummary : ' + objSummary.id);
                    if(mapOppSummary.containsKey(objSummary.Id) == true){
                        List<Opportunity> lstUpdatedGiving = mapOppSummary.get(objSummary.Id);
                        if(lstUpdatedGiving == null)
                            lstDelete.add(objSummary);
                        if(lstUpdatedGiving != null && lstUpdatedGiving.size()==0)
                            lstDelete.add(objSummary);
                        if(lstUpdatedGiving != null && lstUpdatedGiving.size()>0){
                            Integer i=0;
                            for(Opportunity opp:lstUpdatedGiving){
                                
                                boolean addToList = true;
                                if(lstUpdate != null && lstUpdate.size()>0){
                                    for(Giving_Summary__c g:lstUpdate){
                                        if(objSummary.Id == g.Id)
                                            objSummary = g;
                                            addToList = false;
                                    }
                                }
                                system.debug('**************** Updated Giving : ' + opp.Id);
                                Opportunity ParentGiving;
                                if(mapChildParent != null && mapChildParent.size()>0 && mapChildParent.containsKey(opp.Id)==true){
                                    ParentGiving = mapChildParent.get(opp.Id);
                                }
                                if(opp.Giving_Amount__c == null) opp.Giving_Amount__c = 0;
                                if(opp.Payment_Amount__c == null) opp.Payment_Amount__c = 0;
                                if(i == 0){
                                    objSummary.total_pd__c = 0;
                                    objSummary.GivingIds__c = '';
                                    objSummary.current_mem_yr_renew_amt__c = 0;
                                    objSummary.current_mem_yr_add_amt__c = 0;
                                    objSummary.largest_recent_amt__c = 0;
                                    objSummary.total_amt__c = 0;
                                    objSummary.Most_Recent_Payment_Date__c = null;
                                    objSummary.current_fis_yr_amt__c = 0;
                                    objSummary.current_fis_yr_pd__c = 0;
                                    
                                    objSummary.last_fis_yr_amt__c = 0;
                                    objSummary.last_fis_yr_pd__c = 0;
                                    
                                    objSummary.Largest_Giving_Source__c = '';
                                    
                                    objSummary.Most_Recent_Giving_Amount__c = 0;
                                    //objSummary.Most_Recent_Giving_Date__c
                                    //objSummary.Most_Recent_Payment_Date__c  
                                    objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                                    objSummary.Most_Recent_Giving_Date__c = opp.CloseDate;
                                    //objSummary.Most_Recent_Payment_Date__c = opp.CloseDate; 
                                    objSummary.current_mem_yr_renew_date__c = null;
                                    if(opp.Campaign != null)
                                        objSummary.Most_Recent_Giving_Source__c = opp.Campaign.name;                  

                       
                                    CurrentDate = opp.CloseDate;    
                                    LastPaymentDate = opp.Payment_Date__c;                                        
                                }
                                if(LastPaymentDate == null && opp.Payment_Date__c != null){
                                    objSummary.Most_Recent_Payment_Date__c = opp.Payment_Date__c;
                                    LastPaymentDate = opp.Payment_Date__c;
                                }
                                else if(LastPaymentDate != null && opp.Payment_Date__c >= LastPaymentDate){
                                    objSummary.Most_Recent_Payment_Date__c = opp.Payment_Date__c;
                                    LastPaymentDate = opp.Payment_Date__c;
                                }
                                system.debug('##############Last Payment Date : ' + LastPaymentDate);
                                system.debug('##############opp.Payment_Date__c : ' + opp.Payment_Date__c);
                                system.debug('##############objSummary.Most_Recent_Payment_Date__c : ' + objSummary.Most_Recent_Payment_Date__c);
                                
                                LastPaymentDate = opp.Payment_Date__c; 
                                if(opp.CloseDate > CurrentDate){
                                    objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                                    objSummary.Most_Recent_Giving_Date__c = opp.CloseDate;
                                    if(opp.Campaign != null)
                                        objSummary.Most_Recent_Giving_Source__c = opp.Campaign.name;
                                    
                                }
                                integer numberDays = objSummary.Most_Recent_Giving_Date__c.daysBetween(system.today());
                                objSummary.Years_Since_Previous_Gift__c = numberDays/365;
                                //objSummary.Years_Since_Previous_Gift__c = system.today().year() - objSummary.Most_Recent_Giving_Date__c.year();
                                if(opp.Recurring_Donation_Opportunity__c == null){
                                    objSummary.total_amt__c += opp.Giving_Amount__c;
                                    system.debug('####### Total Amount ' + string.valueof(i) + ' : ' + objSummary.total_amt__c);
                                    if(opp.payment_amount__c != null){
                                        if(objSummary.total_pd__c != null){
                                            objSummary.total_pd__c += opp.payment_amount__c;
                                        }
                                        else{
                                            objSummary.total_pd__c = opp.payment_amount__c;
                                        }
                                    }
                                    if(opp.CloseDate.Year() == CurrentFYYear){
                                        objSummary.current_fis_yr_amt__c += opp.Giving_Amount__c;
                                        if(objSummary.current_fis_yr_pd__c==null)objSummary.current_fis_yr_pd__c=0.0;
                                        if(opp.payment_amount__c!=null)
                                            objSummary.current_fis_yr_pd__c +=  opp.payment_amount__c;
                                    }
                                    if(opp.CloseDate.Year() == LastFYYear){
                                        objSummary.last_fis_yr_amt__c += opp.Giving_Amount__c;
                                        if(objSummary.last_fis_yr_pd__c==null)objSummary.last_fis_yr_pd__c=0.0;
                                        if(opp.payment_amount__c!=null)
                                            objSummary.last_fis_yr_pd__c +=  opp.payment_amount__c;
                                    }
                                }
                                
                                //objSummary.last_fis_yr_amt__c = objSummary.current_fis_yr_amt__c;
                                //objSummary.last_fis_yr_pd__c = objSummary.current_fis_yr_pd__c;
                                objSummary.Fiscal_Year__c = String.ValueOf(opp.CloseDate.year());
                                if(opp.Recurring_Donation_Opportunity__c == null && (opp.Gift_Type__c != null && opp.Gift_Type__c.trim() == ADDGIFT) && 
                                (opp.Product__c != null && opp.Product__c.trim().toUpperCase() == 'MEMBERSHIP' )){
                                    if(opp.Campaign.Campaign_Name__c == 'Annual'){
                                        if(opp.Campaign.Channel_Technique__c != null){
                                            if(opp.Campaign.Channel_Technique__c.trim().touppercase() == 'TV' ||
                                            opp.Campaign.Channel_Technique__c.trim().touppercase() == 'RADIO' ||
                                            opp.Campaign.Channel_Technique__c.trim().touppercase() == 'WEB'){
                                                if(objSummary.Shopper_Count__c < 3)
                                                    objSummary.Shopper_Count__c ++;
                                            }
                                        }
                                    }
                                }
                                
                                if(i == (totalGiving - 1)){//Updating first summary
            
                                    if(opp.Gift_Type__c == 'New' ||opp.Gift_Type__c == 'Rejoin' || opp.Gift_Type__c == 'Upgrade Reset'){
                                        Date GiftDate;
                                        if(opp.Gift_Date_Time__c != null)
                                            GiftDate = opp.Gift_Date_Time__c.date();
                                        else
                                            GiftDate = opp.CloseDate;
                                        Date pledgeGiftDate = Date.newInstance(GiftDate.year(),GiftDate.month(),GiftDate.day());
                                        String month = String.valueOf(pledgeGiftDate.month() + 1);
                                        String year = String.valueOf(pledgeGiftDate.year());
                                        objSummary.start_date__c = date.valueOf(year + '-' + month + '-1');
                                    }
                                    else{
                                        objSummary.start_date__c = Date.newInstance(opp.CloseDate.year(),opp.CloseDate.month() + 1,opp.CloseDate.day());
                                    }
            
                                    //#####Issue#225 30-Jun-2011
                                    Date dtStart = objSummary.start_date__c.addMonths(13);
                                    Date expDate = date.newInstance(dtStart.Year(), dtStart.month(), 1);
                                    objSummary.expiration_date__c = objSummary.start_date__c.addMonths(12);
                                    //#####Issue#225 30-Jun-2011
                                    /*if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                                        objSummary.Member_Yr_Status__c = 'Active';
                                    }
                                    else{
                                        objSummary.Member_Yr_Status__c = 'Pending';
                                    }*/
                                    if(objSummary.total_pd__c != null && objSummary.total_pd__c >0){
                                        objSummary.Member_Yr_Status__c = 'Active';
                                    }
                                    else{
                                        objSummary.Member_Yr_Status__c = 'Pending';
                                    }
             
                                    if(opp.gift_kind__c!=null){
                                        String cycle = opp.gift_kind__c.trim().touppercase();
                                        //One Payment ; Installment ; Sustaining Gift ; Sustaining Pledge
                                        if(cycle == 'ONE PAYMENT')
                                            objSummary.solicitation_cycle1__c = 'One Payment';
                                        else if(cycle == 'INSTALLMENT')
                                            objSummary.solicitation_cycle1__c = 'Installment';
                                        else if(cycle == 'SUSTAINING GIFT'){
                                            if(objSummary.current_mem_yr_add_amt__c>0)
                                                objSummary.solicitation_cycle1__c = 'Multiple Gifts';
                                        }
                                        else if(cycle == 'SUSTAINING PLEDGE')
                                            objSummary.solicitation_cycle1__c = 'Installment';
                                    }
            
            
                                    string responseMechanism=''; 
                                    objSummary.track__c = commonApex.getTrack(opp.gift_type__c, opp.Campaign.Channel_Technique__c, opp.Campaign.Sub_Channel__c);
                                    objSummary.first_date__c = Date.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day());
                                    objSummary.first_source__c = opp.Campaign.name;
            
                                    objSummary.first_amt__c = opp.Giving_Amount__c;                                   

     
                                
                                }
                                
                                /////////////////////////////////////////////////////                                 

       
                                if(opp.Gift_Type__c == 'New' ||
                                    opp.Gift_Type__c == 'Renewal' ||
                                    opp.Gift_Type__c == 'Rejoin' ||
                                    opp.Gift_Type__c == 'Upgrade Reset'){
                                    
                                    if(parentGiving != null && parentGiving.Gift_Date_Time__c != null){
                                        //objSummary.current_mem_yr_renew_date__c = parentGiving.CloseDate;                                
                                    }
                                    if(parentGiving != null && parentGiving.Giving_Amount__c != null){
                                        objSummary.current_mem_yr_renew_amt__c = parentGiving.Giving_Amount__c;       

                         
                                    }
                                    else{
                                        objSummary.current_mem_yr_renew_amt__c = opp.Giving_Amount__c;
                                    }
                                }
                                if(opp.Campaign.Channel_Technique__c != null){
                                    objSummary.track__c = commonApex.getTrack(opp.gift_type__c, opp.Campaign.Channel_Technique__c, opp.Campaign.Sub_Channel__c);
                                }
                                if(opp.payment_amount__c != null && objSummary.largest_recent_amt__c != null){
                                    if(opp.Giving_amount__c >= objSummary.largest_recent_amt__c){
                                        objSummary.largest_recent_amt__c = opp.Giving_amount__c;
                                        objSummary.largest_date__c=Date.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day());
                                        if(opp.Campaign != null)
                                            objSummary.Largest_Giving_Source__c = opp.Campaign.name;
                                    }
                                }
                                /*if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                                    objSummary.Member_Yr_Status__c = 'Active';
                                }
                                else{
                                    objSummary.Member_Yr_Status__c = 'Pending';
                                }*/
                                if(objSummary.total_pd__c != null && objSummary.total_pd__c >0){
                                    objSummary.Member_Yr_Status__c = 'Active';
                                }
                                else{
                                    objSummary.Member_Yr_Status__c = 'Pending';
                                }
                                if(opp.Gift_Type__c != null && (opp.Gift_Type__c.trim() == ADDGIFT || opp.Gift_Type__c.trim() == UPGRADERESET)){
                                    objSummary.current_mem_yr_add_amt__c += opp.Giving_Amount__c;
                                }
                                if(opp.Gift_Type__c != null && opp.Gift_Type__c.trim().toUpperCase() == 'RENEWAL'){
                                    //objSummary.current_mem_yr_renew_amt__c += opp.Giving_Amount__c;
                                }
                                if(objSummary.Start_date__c != null){
                                    //objSummary.Years_Since_First_Gift__c = system.today().year() - objSummary.Start_date__c.year();                                            
                                    numberDays = objSummary.Start_date__c.daysBetween(system.today());
                                    objSummary.Years_Since_First_Gift__c = numberDays/365;
                                }
                                //if(opp.Gift_Type__c != null && opp.Gift_Type__c.trim().toUpperCase()==RENEWAL)
                                //objSummary.current_mem_yr_renew_date__c = opp.CloseDate;
                                    
                                //objSummary.Gift_Type__c = opp.Gift_Type__c;
                                if(objSummary.GivingIds__c == ''){
                                    objSummary.GivingIds__c =String.valueOf(opp.Id);
                                }
                                else if(String.valueof(objSummary.GivingIds__c).trim().contains(opp.Id)==false){
                                    objSummary.GivingIds__c += '#' + String.valueOf(opp.Id);
                                }
                                objSummary.Station__c = opp.Station__c;
                                if(i==0){
                                    objSummary.Product__c = opp.Product__c;
                                    objSummary.Gift_Type__c = opp.Gift_Type__c;
                                }
                                objSummary.Giving_Level__c = getGivingLevel(objSummary);
                                if(opp.Gift_Type__c==null) opp.Gift_Type__c = '';
                                if(opp.Gift_Type__c.trim().toUpperCase() == NEWTYPE ||
                                    opp.Gift_Type__c.trim().toUpperCase() == RENEWAL ||
                                    opp.Gift_Type__c.trim().toUpperCase() == REJOIN ||
                                    opp.Gift_Type__c.trim().toUpperCase() == UPGRADERESET){
                                        //objSummary.current_mem_yr_renew_date__c = getRenewalDate(objSummary.expiration_date__c, objSummary);
                                        
                                        if(objSummary.current_mem_yr_renew_date__c == null){
                                            objSummary.current_mem_yr_renew_date__c = opp.closeDate;
                                        }
                                        if(objSummary.current_mem_yr_renew_date__c != null &&
                                        objSummary.current_mem_yr_renew_date__c < opp.closeDate){
                                            objSummary.current_mem_yr_renew_date__c = opp.closeDate;
                                        }
                                }
                                //objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());                              
                                /////////////////////////////////////////////////////
                                //objSummary.Years_Since_Previous_Gift__c = system.today().year() - objSummary.LastModifiedDate.year();
                                i++;
                                if(addToList == true) lstUpdate.add(objSummary);
                            }
                        }
                    }
                }
            }
            List<Giving_Summary__c> lstFinalUpdate = new List<Giving_Summary__c>();
            if(lstUpdate != null && lstUpdate.size()>0){
                system.debug('********* Total summary to update : ' + lstUpdate.size());
                integer i=1;
                for(Giving_Summary__c g:lstUpdate){
                    system.debug('######### Total Amount : [' + string.valueof(i) + '] ' + g.total_amt__c);
                }
                for(Giving_Summary__c g:lstUpdate){
                    if(g.GivingIds__c != null && g.GivingIds__c.trim().length()>0)
                        lstFinalUpdate.add(g);
                    else
                        lstDelete.add(g);
                }
                if(lstFinalUpdate != null && lstFinalUpdate.size()>0)
                    update lstFinalUpdate;     
                               
                if(lstDelete != null && lstDelete.size()>0){
                    System.debug('####### Summary to delete : ' + lstDelete.size());
                    integer TotalSummary = lstSummary.size() - 1;
                    Giving_Summary__c objPrevious = new Giving_Summary__c();
                    integer j=0;
                    for(j=0;j<lstSummary.size();j++){
                        if(j==TotalSummary){
                            objPrevious = lstSummary[j];
                            system.debug('###### Previous summary to reopen : ' + objPrevious.id);
                            break;
                        }
                    }
                    Delete lstDelete;
                    if(objPrevious != null && objPrevious.History__c == true){
                        objPrevious.History__c = false;
                        objPrevious.Summary_Count__c = 0;
                        objPrevious.History_Date_Time__c = null;
                        system.debug('***********Removing from history ' + objPrevious);
                        update objPrevious;
                    }
                } 
            }
        }
        System.debug('***************Reset Summary End******************');
    }
    Static Giving_Summary__c setSummaryValues(Opportunity opp){
        Giving_Summary__c objSummary = new Giving_Summary__c();
        String recordTypeId='';
        String developerName = '';
        System.debug('Inserting Giving Summary ------------------------->');        
        if(opp.Campaign_Name__c != null){            
            developerName = commonApex.getDeveloperNameByCampaignName(String.valueOf(opp.Campaign_Name__c));          

     
            if(developerName != null && developerName.trim().length() > 0){
                recordTypeId = getRecordTypeId(developerName.trim());
            }
            if(recordTypeId != null && recordTypeId.trim().length()>0){
                objSummary.RecordTypeId = recordTypeId;
            }
        }
        objSummary.track__c = commonApex.getTrack(opp.gift_type__c, opp.Campaign.Channel_Technique__c, opp.Campaign.Sub_Channel__c);
        objSummary.Shopper_Count__c = 0; 
        if(opp.Gift_Type__c == NEWTYPE || opp.Gift_Type__c == REJOIN || opp.Gift_Type__c == UPGRADERESET){
            Date pledgeGiftDate = Date.newInstance(opp.Closedate.year(),opp.Closedate.month(),opp.Closedate.day());
            String month = String.valueOf(pledgeGiftDate.month() + 1);
            String year = String.valueOf(pledgeGiftDate.year());
            objSummary.start_date__c = date.valueOf(year + '-' + month + '-1');
        }
        else{
            objSummary.start_date__c = Date.newInstance(opp.Closedate.year(),opp.Closedate.month() + 1,opp.Closedate.day());
        }
        objSummary.expiration_date__c = objSummary.start_date__c.addMonths(12);
        
        if(opp.payment_amount__c!= null && opp.payment_amount__c>0){
            objSummary.Member_Yr_Status__c = 'Active';
        }
        else{
            objSummary.Member_Yr_Status__c = 'Pending';
        }
        
        if(opp.gift_kind__c!=null){
            String cycle = opp.gift_kind__c.trim().touppercase();
            if(cycle == 'ONE PAYMENT')
                objSummary.solicitation_cycle1__c='One Payment';
            else if(cycle == 'INSTALLMENT')
                objSummary.solicitation_cycle1__c='Installment';
            else if(cycle == 'SUSTAINING GIFT'){
                if(objSummary.current_mem_yr_add_amt__c>0)
                    objSummary.solicitation_cycle1__c='Multiple Gifts';
            }
            else if(cycle == 'SUSTAINING PLEDGE')
                objSummary.solicitation_cycle1__c='Installment';
        }
        objSummary.first_date__c = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
        objSummary.first_amt__c = opp.Giving_Amount__c;
        objSummary.first_source__c = opp.Campaign.name;
        
        objSummary.current_mem_yr_add_amt__c = 0;
        objSummary.current_fis_yr_amt__c = opp.Giving_Amount__c;
        objSummary.current_fis_yr_pd__c =  opp.payment_amount__c;        
        if(opp.Gift_Type__c == null) opp.Gift_Type__c = '';
        if(opp.Gift_Type__c.trim().toUpperCase() == NEWTYPE ||
            opp.Gift_Type__c.trim().toUpperCase() == RENEWAL ||
            opp.Gift_Type__c.trim().toUpperCase() == REJOIN ||
            opp.Gift_Type__c.trim().toUpperCase() == UPGRADERESET){
                objSummary.current_mem_yr_renew_amt__c = opp.Giving_Amount__c;
        }
        
        objSummary.Largest_Giving_Source__c = opp.Campaign.name;        
        objSummary.largest_date__c = opp.CloseDate;
        objSummary.largest_recent_amt__c = opp.Giving_amount__c;
        
        objSummary.total_amt__c = opp.Giving_Amount__c;
        objSummary.total_pd__c = opp.payment_amount__c;
        
        objSummary.Years_Since_First_Gift__c = 0;
        objSummary.Years_Since_Previous_Gift__c = 0;
        objSummary.last_fis_yr_amt__c = 0;
        objSummary.last_fis_yr_pd__c = 0;
        
        objSummary.Most_Recent_Giving_Source__c = opp.Campaign.name;
        objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
        objSummary.Most_Recent_Giving_Date__c = opp.CloseDate;
        //if(opp.Gift_Type__c != null && opp.Gift_Type__c.trim().toUpperCase()==RENEWAL)
            //objSummary.current_mem_yr_renew_date__c = opp.CloseDate;
        if(opp.payment_amount__c == null)
            objSummary.Most_Recent_Payment_Date__c = null;
        else if(opp.payment_amount__c == 0)
            objSummary.Most_Recent_Payment_Date__c = null;
        else
            objSummary.Most_Recent_Payment_Date__c = opp.Payment_Date__c;
        
        objSummary.Account__c = opp.AccountId;
        objSummary.Station__c = opp.Station__c;
        objSummary.Product__c = opp.Product__c;
        objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
        objSummary.Shopper_Count__c = 0;
        objSummary.Summary_Count__c = 0;
        objSummary.History__c = false;
        system.debug('######## New summary with giving amount: ' + opp.Giving_Amount__c);
        objSummary.Giving_Level__c = getGivingLevel(objSummary);
        objSummary.Gift_Type__c = opp.Gift_Type__c;
        objSummary.GivingIds__c = String.valueOf(opp.Id);
        if(opp.Gift_Type__c.trim().toUpperCase() == NEWTYPE ||
            opp.Gift_Type__c.trim().toUpperCase() == RENEWAL ||
            opp.Gift_Type__c.trim().toUpperCase() == REJOIN ||
            opp.Gift_Type__c.trim().toUpperCase() == UPGRADERESET){
                //objSummary.current_mem_yr_renew_date__c = getRenewalDate(objSummary.expiration_date__c, objSummary);
                objSummary.current_mem_yr_renew_date__c = opp.closedate;
        }
        
        Return objSummary;
    }
    /******************************************************************************************/    
    Static Date getRenewalDate(Date ExpDate, Giving_Summary__c giving){
        Date RenewDate;
        String CampaignName = '';
        Decimal CurrentMemberRenewAmount = 0.0;
        Decimal CurrentMemberAddAmount = 0.0;
        if(mapRecordTypeID != null && mapRecordTypeID.size()>0 && mapRecordTypeID.containsKey(giving.RecordTypeId)==true){
            CampaignName = commonApex.getCampaignByDeveloperName(mapRecordTypeID.get(giving.RecordTypeId));
        }  
        Integer RenewalWindowStart = 0;
        if(lstSummaryControl != null && lstSummaryControl.size()>0){
            for(Giving_Summary_Control__c control:lstSummaryControl){
                Decimal TotalMemberYrAmount = 0.0;
                if(giving.current_mem_yr_renew_amt__c != null)
                    CurrentMemberRenewAmount = giving.current_mem_yr_renew_amt__c;
                else
                    CurrentMemberRenewAmount = 0.0;
                    
                if(giving.current_mem_yr_add_amt__c != null)
                    CurrentMemberAddAmount = giving.current_mem_yr_add_amt__c;
                else
                    CurrentMemberAddAmount = 0.0;
                TotalMemberYrAmount = CurrentMemberRenewAmount + CurrentMemberAddAmount;
                    
                if(giving.Station__c == control.Station__c &&
                giving.Product__c == control.Product__c &&
                CampaignName == control.Campaign_Type__c){
                    if(TotalMemberYrAmount >= control.Minimum_Total_Mem_Year_Amount__c &&
                    TotalMemberYrAmount <= control.Maximum_Total_Mem_Year_Amount__c){
                        RenewalWindowStart = Integer.valueOf(control.Renewal_Window_Start__c);
                    }
                }
            }
        }
        if(RenewalWindowStart > 0){
            RenewDate = ExpDate.addMonths((RenewalWindowStart * -1));
        }
        else{
            RenewDate = ExpDate;
        }
        return RenewDate;
    }
    Static String getGivingLevel(Giving_Summary__c giving){
        String GivingLevel = '';
        Decimal CurrentMemberRenewAmount = 0.0;
        Decimal CurrentMemberAddAmount = 0.0;
        String CampaignName = '';
        if(mapRecordTypeID != null && mapRecordTypeID.size()>0 && mapRecordTypeID.containsKey(giving.RecordTypeId)==true){
            CampaignName = commonApex.getCampaignByDeveloperName(mapRecordTypeID.get(giving.RecordTypeId));
        }        
        
        if(lstSummaryControl != null && lstSummaryControl.size()>0){
            for(Giving_Summary_Control__c control:lstSummaryControl){
                Decimal TotalMemberYrAmount = 0.0;
                if(giving.current_mem_yr_renew_amt__c != null)
                    CurrentMemberRenewAmount = giving.current_mem_yr_renew_amt__c;
                else
                    CurrentMemberRenewAmount = 0.0;
                    
                if(giving.current_mem_yr_add_amt__c != null)
                    CurrentMemberAddAmount = giving.current_mem_yr_add_amt__c;
                else
                    CurrentMemberAddAmount = 0.0;
                TotalMemberYrAmount = CurrentMemberRenewAmount + CurrentMemberAddAmount;
                system.debug('#####TotalMemberYrAmount : ' + TotalMemberYrAmount);
                system.debug('#####control.Minimum_Total_Mem_Year_Amount__c : ' + control.Minimum_Total_Mem_Year_Amount__c);
                system.debug('#####control.Maximum_Total_Mem_Year_Amount__c : ' + control.Maximum_Total_Mem_Year_Amount__c);                
                system.debug('#####CampaignName : ' + CampaignName);
                if(giving.Station__c == control.Station__c &&
                giving.Product__c == control.Product__c &&
                CampaignName == control.Campaign_Type__c){
                    if(TotalMemberYrAmount >= control.Minimum_Total_Mem_Year_Amount__c &&
                    TotalMemberYrAmount <= control.Maximum_Total_Mem_Year_Amount__c){
                        giving.Giving_Level__c = control.Giving_Level__c;
                        GivingLevel = control.Giving_Level__c;
                        giving.Lapsed_Period__c = control.Lapsed_Window_Start__c;
                        system.debug('#####Giving Level Found : ' + giving.Giving_Level__c);
                    }
                }
                system.debug('$$$$$$$$$$$$$$$$ Giving Level :----> ' + control.Giving_Level__c);
            }
        }
        Return GivingLevel;
    }
    Static Void LoadGivingSummaryControl(){
        Set<String> sStation = new Set<String>();
        Set<String> sProduct = new Set<String>();
        Set<String> sCampaignName = new Set<String>();
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity opp:lstGiving){
                if(opp.Station__c != null)
                    sStation.add(opp.Station__c);
                if(opp.Product__c != null)
                    sProduct.add(opp.Product__c);
                if(opp.Campaign_Name__c != null)
                    sCampaignName.add(opp.Campaign_Name__c);
            }
            if(sStation.size()>0 && sProduct.size()>0 && sCampaignName.size()>0){
                lstSummaryControl = [Select Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
                Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
                Renewal_Window_Start__c, Shopper_Threshold__c,
                Station__c, Product__c, Campaign_Type__c
                From Giving_Summary_Control__c 
                Where Station__c in: sStation and 
                Product__c in: sProduct and 
                Campaign_Type__c in: sCampaignName];
            }
        }
    }
    Static ID getRecordTypeId(String DeveloperName){
        ID recordtypeid=null;
        if(mapDeveloperName != null && mapDeveloperName.size()>0 && mapDeveloperName.containsKey(DeveloperName)

==true){
            recordtypeid = mapDeveloperName.get(DeveloperName);
        }
        Return recordtypeid;
    }
    Static Void getRecordType(){
        lstRecordType = new List<RecordType>();
        lstRecordType = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Giving_Summary__c'];
        mapRecordTypeID = new Map<ID,String>();
        mapDeveloperName = new Map<String,ID>();
        if(lstRecordType != null && lstRecordType.size() > 0){
            for(RecordType rc:lstRecordType){
                mapRecordTypeID.put(rc.Id, rc.DeveloperName);
                mapDeveloperName.put(rc.DeveloperName, rc.Id);
            }
        }
    }
    Static Void getSummary(){
        lstSummary = new List<Giving_Summary__c>();
        Set<String> sCampaignType = new Set<String>();
        Set<String> sStation = new Set<String>();
        Set<String> sAccountID = new Set<String>();
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity opp:lstGiving){
                if(opp.AccountId != null)
                    sAccountID.add(opp.AccountId);
                if(opp.Station__c != null)
                    sStation.add(opp.Station__c);
                if(opp.Campaign_Name__c != null){
                    String DeveloperName = CommonApex.getDeveloperNameByCampaignName(opp.Campaign_Name__c);
                    if(mapDeveloperName != null && mapDeveloperName.size()>0){
                        sCampaignType.add(mapDeveloperName.get(DeveloperName));
                    }
                }
            }
            
            lstSummary = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, current_fis_yr_pd__c, current_mem_yr_add_amt__c, current_mem_yr_renew_amt__c, 
            current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, largest_date__c, largest_recent_amt__c, Most_Recent_Giving_Amount__c, Most_Recent_Giving_Date__c, last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, Station__c, 
            Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, Solicitation_Cycle1__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c, Total_Member_Yr_Amount__c, 
            History__c, Summary_Count__c, History_Date_Time__c, IsGrace__c, Gift_Type__c, GivingIds__c 
            FROM Giving_Summary__c 
            Where Station__c in:sStation and Account__c in:sAccountID and RecordTypeId in: sCampaignType
            Order by LastModifiedDate desc];
            
            mapAccountSummaryAll = new Map<String,Giving_Summary__c>();            
            mapAccountSummaryActive = new Map<String,Giving_Summary__c>();
            mapAccountSummaryHistory = new Map<String,Giving_Summary__c>();
            if(lstSummary != null && lstSummary.size()>0){
                for(Giving_Summary__c Summary:lstSummary){
                    mapAccountSummaryAll.put(Summary.Account__c + Summary.Station__c + Summary.Summary_Count__c, summary);
                    if(Summary.History__c == false)
                        mapAccountSummaryActive.put(Summary.Account__c + Summary.Station__c, Summary);
                    if(Summary.History__c == true)
                        mapAccountSummaryAll.put(Summary.Account__c + Summary.Station__c + Summary.Summary_Count__c, summary);
                }
            }
            mapAccountSummaryStation = new Map<String, List<Giving_Summary__c>>();
            if(sAccountID != null && sAccountID.size()>0){                
                for(String strAcc:sAccountID){
                    List<Giving_Summary__c> lstTemp = new List<Giving_Summary__c>();
                    for(String strStation:sStation){
                        for(Giving_Summary__c Summary:lstSummary){
                            if(Summary.Account__c == strAcc && Summary.Station__c == strStation){
                                lstTemp.add(Summary);
                            }
                        }
                        mapAccountSummaryStation.put(strAcc + strStation, lstTemp);
                    }                    
                }
            }
        }
    }    
    Static Void loadParentGiving(){
        lstParentGiving = new List<Opportunity>();
        mapParentGiving = new Map<ID,Opportunity>();
        Set<ID> sParentId = new Set<ID>();
        Set<ID> sChildId = new Set<ID>();
        if(lstGiving != null && lstGiving.size()>0){
            for(Opportunity opp:lstGiving){
                if(opp.Recurring_Donation_Opportunity__c != null){
                    sParentId.add(opp.Recurring_Donation_Opportunity__c);
                    sChildId.add(opp.Id);
                }
            }
            if(sParentId != null && sParentId.size()>0){
                lstParentGiving = [Select Id, IsDeleted, AccountId, RecordTypeId, IsPrivate, Name, Description, 

StageName, Amount, Probability, 
                Campaign.name, Campaign.Campaign_Name__c, Campaign.Channel_Technique__c, Campaign.Sub_Channel__c,
                ExpectedRevenue, TotalOpportunityQuantity, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, 

ForecastCategory, 
                ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, 

CreatedById, 
                LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, 

Fiscal, 
                Campaign_Type__c, CombinedRollupFieldset__c, Contact_Id_for_Role__c, CurrentGenerators__c, 
                DeliveryInstallationStatus__c, MainCompetitors__c, Oppty_Related_Contact__c, OrderNumber__c, 
                SFDC_Opportunity_ID__c, Station__c, TrackingNumber__c, alt_transaction_id__c, batch_number__c, 
                bequest__c, caller__c, effort__c, fund__c, gift_kind__c, gift_type__c, installment_amount__c, 

payment_amount__c, 
                payment_frequency__c, Close_Month__c, payment_number__c, payments_in_schedule__c, pledge_amount__c, 

pledge_number__c, 
                program__c, project_del__c, purpose__c, schedule_start_date__c, source__c, 

systemHouseholdContactRoleProcessor__c, 
                ta_campaign__c, ta_campaign_value__c, bulk_load__c, new_install_ment_date__c, payment_method__c, 

batch_process_count__c,
                New_Balance__c, Product__c, Ack_Sent_Date__c, Foundation_Name__c, Foundation_Pay__c, 

Installment_Period__c, 
                Installments__c, Matching_Gift__c, Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
                Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, 

Payment_Method_Description__c, 
                Charge_Card_Type__c, Matching_Company__c, Support_Designation__c, Anonymous__c, Restricted__c, 

Override_Gift_Type__c, 
                Payment_Date__c, Revenue_Date__c, Giving_Segment__c, CC_EFT_Alias__c, Gift_Date_Time__c, 

Response_Mechanism__c, 
                Closed_Lost_Reasons__c, Source_Code__c, Matching_Gift_Status__c, Giving_Amount__c, Campaign_Name__c, 
                Remove_Opportunity__c, Gift_Date_3_Month__c, Gift_Date_6_Month__c, Gift_Date_18_Month__c, 

Parent_Giving_Stage__c, 
                Refused_Reason__c, Last_Payment_Date__c, Last_Payment_Date_1_Year__c, Last_Payment_Date_18_Month__c, 
                SFDC_GIVING_NUMBER__c, Ack_Sent__c, Reminder_Sent__c, Reminder_Sent_Date__c, Solicitation_Type__c, 
                Refund_Type__c, Fund_Lookup__c 
                FROM Opportunity
                where ID In: sParentId Order by CreatedDate desc];
                
                if(lstParentGiving != null && lstParentGiving.size()>0){
                    for(Opportunity child:lstGiving){
                        for(Opportunity parent:lstParentGiving){
                            if(child.Recurring_Donation_Opportunity__c != null &&
                            child.Recurring_Donation_Opportunity__c == parent.Id){
                                mapParentGiving.put(child.Id, parent);
                            }
                        }
                    }
                }
            }
        }
    }
    Static List<Opportunity> getGivingRecords(Set<ID> sGivingIds){
        List<Opportunity> lstTempGiving = new List<Opportunity>();
        lstTempGiving = [Select Id, IsDeleted, AccountId, RecordTypeId, IsPrivate, Name, Description, StageName, 

Amount, Probability, 
        Campaign.name, Campaign.Campaign_Name__c, Campaign.Channel_Technique__c, Campaign.Sub_Channel__c,
        ExpectedRevenue, TotalOpportunityQuantity, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, 

ForecastCategory, 
        ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, 
        Campaign_Type__c, CombinedRollupFieldset__c, Contact_Id_for_Role__c, CurrentGenerators__c, 
        DeliveryInstallationStatus__c, MainCompetitors__c, Oppty_Related_Contact__c, OrderNumber__c, 
        SFDC_Opportunity_ID__c, Station__c, TrackingNumber__c, alt_transaction_id__c, batch_number__c, 
        bequest__c, caller__c, effort__c, fund__c, gift_kind__c, gift_type__c, installment_amount__c, 

payment_amount__c, 
        payment_frequency__c, Close_Month__c, payment_number__c, payments_in_schedule__c, pledge_amount__c, 

pledge_number__c, 
        program__c, project_del__c, purpose__c, schedule_start_date__c, source__c, 

systemHouseholdContactRoleProcessor__c, 
        ta_campaign__c, ta_campaign_value__c, bulk_load__c, new_install_ment_date__c, payment_method__c, 

batch_process_count__c,
        New_Balance__c, Product__c, Ack_Sent_Date__c, Foundation_Name__c, Foundation_Pay__c, Installment_Period__c, 
        Installments__c, Matching_Gift__c, Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
        Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, Payment_Method_Description__c, 
        Charge_Card_Type__c, Matching_Company__c, Support_Designation__c, Anonymous__c, Restricted__c, 

Override_Gift_Type__c, 
        Payment_Date__c, Revenue_Date__c, Giving_Segment__c, CC_EFT_Alias__c, Gift_Date_Time__c, 

Response_Mechanism__c, 
        Closed_Lost_Reasons__c, Source_Code__c, Matching_Gift_Status__c, Giving_Amount__c, Campaign_Name__c, 
        Remove_Opportunity__c, Gift_Date_3_Month__c, Gift_Date_6_Month__c, Gift_Date_18_Month__c, 

Parent_Giving_Stage__c, 
        Refused_Reason__c, Last_Payment_Date__c, Last_Payment_Date_1_Year__c, Last_Payment_Date_18_Month__c, 
        SFDC_GIVING_NUMBER__c, Ack_Sent__c, Reminder_Sent__c, Reminder_Sent_Date__c, Solicitation_Type__c, 
        Refund_Type__c, Fund_Lookup__c 
        FROM Opportunity
        where ID In: sGivingIds Order by CreatedDate desc];
        
        Return lstTempGiving;
    }
    Static List<Opportunity> getGivingByAccount(Set<ID> sAccIds){
        List<Opportunity> lstTempGiving = new List<Opportunity>();
        lstTempGiving = [Select Id, IsDeleted, AccountId, RecordTypeId, IsPrivate, Name, Description, StageName, 

Amount, Probability, 
        Campaign.name, Campaign.Campaign_Name__c, Campaign.Channel_Technique__c, Campaign.Sub_Channel__c,
        ExpectedRevenue, TotalOpportunityQuantity, CloseDate, Type, NextStep, LeadSource, IsClosed, IsWon, 

ForecastCategory, 
        ForecastCategoryName, CampaignId, HasOpportunityLineItem, Pricebook2Id, OwnerId, CreatedDate, CreatedById, 
        LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, FiscalQuarter, FiscalYear, Fiscal, 
        Campaign_Type__c, CombinedRollupFieldset__c, Contact_Id_for_Role__c, CurrentGenerators__c, 
        DeliveryInstallationStatus__c, MainCompetitors__c, Oppty_Related_Contact__c, OrderNumber__c, 
        SFDC_Opportunity_ID__c, Station__c, TrackingNumber__c, alt_transaction_id__c, batch_number__c, 
        bequest__c, caller__c, effort__c, fund__c, gift_kind__c, gift_type__c, installment_amount__c, 

payment_amount__c, 
        payment_frequency__c, Close_Month__c, payment_number__c, payments_in_schedule__c, pledge_amount__c, 

pledge_number__c, 
        program__c, project_del__c, purpose__c, schedule_start_date__c, source__c, 

systemHouseholdContactRoleProcessor__c, 
        ta_campaign__c, ta_campaign_value__c, bulk_load__c, new_install_ment_date__c, payment_method__c, 

batch_process_count__c,
        New_Balance__c, Product__c, Ack_Sent_Date__c, Foundation_Name__c, Foundation_Pay__c, Installment_Period__c, 
        Installments__c, Matching_Gift__c, Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
        Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, Payment_Method_Description__c, 
        Charge_Card_Type__c, Matching_Company__c, Support_Designation__c, Anonymous__c, Restricted__c, 

Override_Gift_Type__c, 
        Payment_Date__c, Revenue_Date__c, Giving_Segment__c, CC_EFT_Alias__c, Gift_Date_Time__c, 

Response_Mechanism__c, 
        Closed_Lost_Reasons__c, Source_Code__c, Matching_Gift_Status__c, Giving_Amount__c, Campaign_Name__c, 
        Remove_Opportunity__c, Gift_Date_3_Month__c, Gift_Date_6_Month__c, Gift_Date_18_Month__c, 

Parent_Giving_Stage__c, 
        Refused_Reason__c, Last_Payment_Date__c, Last_Payment_Date_1_Year__c, Last_Payment_Date_18_Month__c, 
        SFDC_GIVING_NUMBER__c, Ack_Sent__c, Reminder_Sent__c, Reminder_Sent_Date__c, Solicitation_Type__c, 
        Refund_Type__c, Fund_Lookup__c 
        FROM Opportunity
        where AccountId In: sAccIds Order by CreatedDate desc];
        
        Return lstTempGiving;
    }
    static testMethod void ProcessGivingSummary(){
        ProcessGivingSummary clsTest = new ProcessGivingSummary();
        Account a = new Account(Name = 'Test');
        insert a;
        Giving_Summary__c giv = new Giving_Summary__c();
       
        insert giv;
        Set<ID> aid = new Set<ID>();
        aid.add(giv.Id);
       
        //ProcessGivingSummary.setHistory(giv,true);
        
       
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        
        Opportunity opp = New Opportunity();
        
        opp.AccountID = a.Id;
       
        opp.Name = 'Test';
        opp.gift_kind__c = 'One Payment';
        opp.CloseDate = system.Today().AddDays(15);
        opp.Gift_Date_Time__c = system.now();
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        opp.campaign_name__c = 'Annual';
        opp.station__c = 'WGBH';
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';
        
        insert opp;
        Set<ID> oppid = new Set<ID>();
        oppid.add(opp.Id);
        
        
        
        ProcessGivingSummary.LoadRequiredData(aid);
        ProcessGivingSummary.UpdateSummary(oppid,true);
        ProcessGivingSummary.UpdateSummary(oppid,false);
        ProcessGivingSummary.ResetSummary(true);
        ProcessGivingSummary.ResetSummary(false);
        ProcessGivingSummary.setSummaryValues(opp);
        
        Opportunity opp1 = New Opportunity();        
        opp1.AccountID = a.Id;
        
        opp1.Name = 'Test';
        opp1.gift_kind__c = 'One Payment';
        opp1.CloseDate = system.Today().AddDays(15);
        opp1.Gift_Date_Time__c = system.now();
        opp1.StageName = 'Pledged';
        opp1.CampaignID = c.Id;
        opp1.campaign_name__c = 'Annual';
        opp1.station__c = 'WGBH';
        RecordType rc1 = [select id from recordtype where developername = 'Annual'];
        opp1.recordtypeid = rc1.id;
        opp1.Gift_Type__c = 'RENEWAL';
        
        insert opp1;
        ProcessGivingSummary.setHistory(opp1,true);
        ProcessGivingSummary.setHistory(opp1,false);
        ProcessGivingSummary.IsAddOperation(opp,false);
        ProcessGivingSummary.IsAddOperation(opp,true);
        
        //List<OpportunityLineItem> oppli = new List<OpportunityLineItem>();
        //insert oppli;
     
        //ProcessGivingSummary.setProduct(oppli);     
        
        ProcessGivingSummary.getGivingLevel(giv);
        ProcessGivingSummary.LoadGivingSummaryControl();
        ProcessGivingSummary.getRecordTypeId('test');
        ProcessGivingSummary.getRecordType();
        ProcessGivingSummary.getSummary();
        ProcessGivingSummary.loadParentGiving();
        ProcessGivingSummary.getGivingRecords(aid);
        //Account a = new Account(Name = 'Test');
        //insert a;
        Set<ID> acid = new Set<ID>();
        acid.add(a.Id);
        ProcessGivingSummary.getGivingByAccount(acid);
       }
     
    
   
}