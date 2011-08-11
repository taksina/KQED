Public Class UpdateSummary{

    Static Void UpdateAllSummary(List<Opportunity> lstOpp){
        Set<ID> accountIds = new Set<ID>();
        Set<String> campaignName = new Set<String>();
        Set<String> developerNames = new Set<String>();
        Set<ID> SummaryRecordType = new Set<ID>();
        Set<ID> ParentIds = new Set<ID>();
        
        Map<String, Giving_Summary__c> mapSummaryAccount = new Map<String, Giving_Summary__c>();
        Map<ID,Opportunity> mapParentGiving = new Map<ID,Opportunity>();
        Map<ID, List<Opportunity>> mapSummaryGiving = new Map<ID, List<Opportunity>>();
        
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        List<Opportunity> lstGiving = new List<Opportunity>();
        List<Opportunity> lstParentGiving = new List<Opportunity>();
        List<Giving_Summary__c> lstUpdateSummary = new List<Giving_Summary__c>();
        //try{
            if(lstOpp != null && lstOpp.size() > 0){
                for(Opportunity opp:lstOpp){
                    if(opp.AccountId != null)
                        accountIds.add(opp.AccountId);
                    campaignName.add(opp.Campaign_Name__c);
                }
                if(campaignName != null && campaignName.size()>0){
                    for(String camp:campaignName){
                        developerNames.add(getDeveloperNameByCampaignName(camp));
                    }
                }
                SummaryRecordType = getRecordTypeIDs(developerNames);
                lstSummary = [Select Id, RecordType.DeveloperName, Account__c, largest_recent_amt__c From Giving_Summary__c Where Account__c in:AccountIds and RecordTypeId in: SummaryRecordType];
                
                if(lstSummary != null && lstSummary.size()>0){
                    for(Giving_Summary__c s:lstSummary){
                        mapSummaryAccount.put(s.Account__c + s.RecordType.DeveloperName, s);
                    }
                }
                
                lstGiving = [Select Id, Campaign_Name__c, AccountID, Campaign.name, Recurring_Donation_Opportunity__c,
                Campaign.Channel_Technique__c, Campaign.Response_Mechanism__c, Campaign.Campaign_Name__c,
                Campaign.Sub_Channel__c From Opportunity 
                Where AccountID in:accountIds and Campaign_Name__c in:campaignName Order by CreatedDate desc];
                
                if(lstSummary != null && lstSummary.size() > 0){
                    for(Giving_Summary__c G:lstSummary){
                        List<Opportunity> lstTemp = new List<Opportunity>();
                        if(lstGiving != null && lstGiving.size()>0){
                            for(Opportunity O:lstGiving){
                                String strLocalDevName = getDeveloperNameByCampaignName(O.Campaign_Name__c);
                                if(O.AccountId == G.Account__c &&
                                   strLocalDevName.trim().toUpperCase() == G.RecordType.DeveloperName.trim().toUpperCase()){
                                    lstTemp.add(O);
                                }   
                            }
                        }
                        if(lstTemp != null && lstTemp.size()>0){
                            mapSummaryGiving.put(G.Id, lstTemp);
                        }
                    }
                }
                Integer i = 0;
                Integer totalGiving = 0;
                if(lstSummary != null && lstSummary.size() > 0){
                    for(Giving_Summary__c objSummary: lstSummary){
                        if(mapSummaryGiving != null && mapSummaryGiving.size()>0){
                            if(mapSummaryGiving.containsKey(objSummary.Id)){
                                lstGiving = new List<Opportunity>();
                                lstGiving = mapSummaryGiving.get(objSummary.Id);
                                /////////////////////////////////////////////////
                                if(lstGiving != null && lstGiving.size()>0){
                                    totalGiving = lstGiving.size();
                                    for(Opportunity o:lstGiving){
                                        if(o.Recurring_Donation_Opportunity__c != null)
                                            ParentIds.add(o.Recurring_Donation_Opportunity__c);
                                    }
                                    lstParentGiving = getParentGiving(ParentIds);
                                    for(Opportunity child:lstOpp){
                                        for(Opportunity parent:lstParentGiving){
                                            if(child.Recurring_Donation_Opportunity__c != null &&
                                            child.Recurring_Donation_Opportunity__c == parent.Id){
                                                mapParentGiving.put(child.Id, parent);
                                            }
                                        }
                                    }
                                    for(Opportunity opp:lstGiving){
                                        Opportunity ParentGiving = new Opportunity();
                                        if(mapParentGiving != null && 
                                        mapParentGiving.size()>0 && mapParentGiving.containsKey(opp.Id)){
                                            ParentGiving = mapParentGiving.get(opp.Id);
                                        }
                                        
                                        boolean addToList = true;
                                        if(lstUpdateSummary != null && lstUpdateSummary.size()>0){
                                            for(Giving_Summary__c g:lstUpdateSummary){
                                                if(objSummary.Id == g.Id)
                                                    objSummary = g;
                                                    addToList = false;
                                            }
                                        }
                                        if(i == 0){
                                            objSummary.current_mem_yr_renew_amt__c = 0;
                                            objSummary.current_mem_yr_add_amt__c = 0;
                                            objSummary.largest_recent_amt__c = 0;
                                            objSummary.total_amt__c = 0;
                                            
                                            objSummary.Largest_Giving_Source__c = '';
                                            
                                            objSummary.Most_Recent_Giving_Amount__c = 0;
                                            //objSummary.Most_Recent_Giving_Date__c
                                            //objSummary.Most_Recent_Payment_Date__c                                            
                                            
                                        }
                                        if(i == (totalGiving - 1)){//Updating first summary
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
                    
                                            if(opp.Gift_Type__c == 'New' ||opp.Gift_Type__c == 'Rejoin' || opp.Gift_Type__c == 'Upgrade Reset'){
                                                Date pledgeGiftDate = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                                                String month = String.valueOf(pledgeGiftDate.month() + 1);
                                                String year = String.valueOf(pledgeGiftDate.year());
                                                objSummary.start_date__c = date.valueOf(year + '-' + month + '-1');
                                            }
                                            else{
                                                objSummary.start_date__c = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month() + 1,opp.Gift_Date_Time__c.day());
                                            }
                    
                    
                                            objSummary.expiration_date__c = objSummary.start_date__c.addMonths(12);
                                            if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                                                objSummary.Member_Yr_Status__c = 'Active';
                                            }
                                            else{
                                                objSummary.Member_Yr_Status__c = 'Pending';
                                            }
                     
                                            if(opp.gift_kind__c!=null){
                                                String cycle = opp.gift_kind__c.trim().touppercase();
                                                //One Payment ; Installment ; Sustaining Gift ; Sustaining Pledge
                                                if(cycle == 'ONE PAYMENT')
                                                    objSummary.solicitation_cycle1__c = 'O';
                                                else if(cycle == 'INSTALLMENT')
                                                    objSummary.solicitation_cycle1__c = 'I';
                                                else if(cycle == 'SUSTAINING GIFT'){
                                                    if(objSummary.current_mem_yr_add_amt__c>0)
                                                        objSummary.solicitation_cycle1__c = 'M';
                                                }
                                                else if(cycle == 'SUSTAINING PLEDGE')
                                                    objSummary.solicitation_cycle1__c = 'I';
                                            }
                    
                    
                                            string responseMechanism='';                
                                            if(opp.Campaign.Response_Mechanism__c != null){
                                                responseMechanism = opp.Campaign.Response_Mechanism__c.trim().touppercase();
                                                if(responseMechanism == 'MAIL')
                                                    objSummary.track__c = 'M';
                                                else if(responseMechanism == 'INBOUND CALL')
                                                    objSummary.track__c = 'IC';
                                                else if(responseMechanism == 'WEB INBOUND')
                                                    objSummary.track__c = 'WI';
                                                else if(responseMechanism == 'RENEW BY MAIL')
                                                    objSummary.track__c = 'RN';
                                            }
                                            objSummary.first_date__c = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                                            objSummary.first_source__c = opp.Campaign.name;
                    
                                            objSummary.first_amt__c = opp.Giving_Amount__c;                                        
                                        
                                        }
                                        
                                        /////////////////////////////////////////////////////                                        
                                        if(opp.Gift_Type__c == 'New' ||
                                            opp.Gift_Type__c == 'Renewal' ||
                                            opp.Gift_Type__c == 'Rejoin' ||
                                            opp.Gift_Type__c == 'Upgrade Reset'){
                                            if(parentGiving != null && parentGiving.Gift_Date_Time__c != null){
                                                objSummary.current_mem_yr_renew_date__c = parentGiving.Gift_Date_Time__c.Date();                                
                                            }
                                            if(parentGiving != null && parentGiving.Giving_Amount__c != null){
                                                objSummary.current_mem_yr_renew_amt__c = parentGiving.Giving_Amount__c;                                
                                            }
                                        }
                                        if(opp.Campaign.Channel_Technique__c != null){
                                            objSummary.track__c = getTrack(opp.gift_type__c, opp.Campaign.Channel_Technique__c, opp.Campaign.Sub_Channel__c);
                                        }
                                        if(opp.Campaign != null)
                                            objSummary.Most_Recent_Giving_Source__c = opp.Campaign.name;
                                        if(opp.payment_amount__c != null && objSummary.largest_recent_amt__c != null){
                                            if(opp.payment_amount__c >= objSummary.largest_recent_amt__c){
                                                objSummary.largest_recent_amt__c = opp.payment_amount__c;
                                                objSummary.largest_date__c=Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                                                if(opp.Campaign != null)
                                                    objSummary.Largest_Giving_Source__c = opp.Campaign.name;
                                            }
                                        }
                                        if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                                            objSummary.Member_Yr_Status__c = 'Active';
                                        }
                                        else{
                                            objSummary.Member_Yr_Status__c = 'Pending';
                                        }
                                        objSummary.current_mem_yr_add_amt__c = opp.payment_amount__c;
                                        
                                        objSummary.total_amt__c += opp.Giving_Amount__c;
                                        if(objSummary.total_pd__c != null && opp.payment_amount__c != null)
                                            objSummary.total_pd__c += opp.payment_amount__c;
                                        
                                        objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                                        objSummary.Most_Recent_Giving_Date__c = opp.Gift_Date_Time__c.date();
                                        objSummary.Most_Recent_Payment_Date__c = opp.Gift_Date_Time__c.date();
                                        objSummary.Station__c = opp.Station__c;
                                        objSummary.Product__c = opp.Product__c;
                                        objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
                                        if(objSummary.Start_date__c != null){
                                            objSummary.Years_Since_First_Gift__c = system.today().year() - objSummary.Start_date__c.year();
                                        }
                                        objSummary.Years_Since_Previous_Gift__c = system.today().year() - objSummary.LastModifiedDate.year();
                                        objSummary.last_fis_yr_amt__c = objSummary.current_fis_yr_amt__c;
                                        objSummary.last_fis_yr_pd__c = objSummary.current_fis_yr_pd__c;
                                        objSummary.current_fis_yr_amt__c = opp.Giving_Amount__c;
                                        objSummary.current_fis_yr_pd__c =  opp.payment_amount__c;
                                        objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                                        objSummary.Most_Recent_Giving_Date__c = opp.Gift_Date_Time__c.date();
                                        objSummary.Most_Recent_Payment_Date__c = opp.Gift_Date_Time__c.date();
                                        objSummary.Station__c = opp.Station__c;
                                        objSummary.Product__c = opp.Product__c;
                                        objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
                                        /////////////////////////////////////////////////////
                                        
                                        i++;
                                        if(addToList == true)
                                            lstUpdateSummary.add(objSummary);
                                           
                                    }
                                }                                
                                /////////////////////////////////////////////////
                            }
                        }
                    }
                }
                

                
                if(lstUpdateSummary.size()>0){
                    List<String> lstStation = new List<String>();
                    List<String> lstProduct = new List<String>();
                    List<String> lstCampaign = new List<String>();
                    Map<Id,RecordType> MapRecordTypesId = new Map<Id,RecordType>();
                    for(RecordType r: lstRecordTypes) {
                        MapRecordTypesId.put(r.Id,r);
                    }
                    List<Giving_Summary_Control__c> lstControl = new List<Giving_Summary_Control__c>();
                    String strCampaignName = '';
                    for(Giving_Summary__c g:lstUpdateSummary){
                        if(g.Total_Member_Yr_Amount__c != null){
                            lstStation.add(g.Station__c);
                            lstProduct.add(g.Product__c);
                            if(MapRecordTypesId.size()>0 && MapRecordTypesId.containsKey(g.RecordTypeId)){
                                lstCampaign.add(getCampaignByDeveloperName(MapRecordTypesId.get(g.RecordTypeId).DeveloperName));
                            }
                        }
                    }
                    if(lstStation.size()>0 && lstProduct.size()>0 && lstCampaign.size()>0){
                        lstControl = [Select Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
                        Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
                        Renewal_Window_Start__c, Shopper_Threshold__c,
                        Station__c, Product__c, Campaign_Type__c
                        From Giving_Summary_Control__c 
                        Where Station__c in: lstStation and 
                        Product__c in: lstProduct and 
                        Campaign_Type__c in: lstCampaign ];
                    }
                    for(Giving_Summary__c giving:lstUpdateSummary){
                        System.debug('GIVING RECORD TYPE ----------------------------------------> ' + giving.RecordTypeId);
                        strCampaignName = getCampaignByDeveloperName(MapRecordTypesId.get(giving.RecordTypeId).DeveloperName);
                        for(Giving_Summary_Control__c control:lstControl){
                            if(giving.Station__c == control.Station__c &&
                            giving.Product__c == control.Product__c &&
                            strCampaignName == control.Campaign_Type__c){
                                if(giving.Total_Member_Yr_Amount__c >= control.Minimum_Total_Mem_Year_Amount__c &&
                                giving.Total_Member_Yr_Amount__c <= control.Maximum_Total_Mem_Year_Amount__c){
                                    giving.Giving_Level__c = control.Giving_Level__c;
                                    giving.Lapsed_Period__c = control.Lapsed_Window_Start__c;
                                }
                            }
                        }
                    }        
                    system.debug('#### Giving Level (Update) - ' + lstUpdateSummary[0].Id + ' : ' + lstUpdateSummary[0].Giving_Level__c );
                    update lstUpdateSummary;
                    }
            }
            
        //}catch(Exception ex){
        //}
    }
    
    
    Static Set<ID> getRecordTypeIDs(Set<String> developerNames){
        Set<ID> recordTypes = new Set<ID>();
        if(lstRecordTypes != null && lstRecordTypes.size()>0){
            for(RecordType rc : lstRecordTypes){
                for(String developer:developerNames){
                    if(developer.trim().toUpperCase() == rc.DeveloperName.trim().toUpperCase()){
                        recordTypes.add(rc.id);
                    }
                }
            }
        }
        return recordTypes;
    }
    
    
    Static List<RecordType> lstRecordTypes;
    
    
    Public Static void UpdateGivingSummary(List<Opportunity> lstOpp, boolean isInsert){
        List<ID> AccountIds = new List<ID>();
        List<String> summaryType = new List<String>();
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        lstRecordTypes = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Giving_Summary__c'];
        Map<String,RecordType> MapRecordTypes = new Map<String,RecordType>();
        for(RecordType r: lstRecordTypes) {
            MapRecordTypes.put(r.DeveloperName,r);
            system.debug('DeveloperName --> : ' + r.DeveloperName);
            system.debug('Name --> : ' + r.Name);
            system.debug('Id --> : ' + r.Id);
        }
        
        List<Giving_Summary__c> lstInsert = new List<Giving_Summary__c>();
        List<Giving_Summary__c> lstUpdate = new List<Giving_Summary__c>();
        Set<ID> CampaignId = new Set<ID>();
        String developerName = '';
        Set<ID> ParentIds = new Set<ID>();
        for(Opportunity o:lstOpp){
            AccountIds.add(o.AccountId);//Household
            CampaignId.add(o.CampaignId);
            developerName = '';
            developerName = getDeveloperNameByCampaignName(String.valueOf(o.Campaign_Name__c)); 
            if(MaprecordTypes.containsKey(developerName)){
                RecordType r = MaprecordTypes.get(developerName);
                summaryType.add(r.Id);
            }
            if(o.Recurring_Donation_Opportunity__c != null)
                ParentIds.add(o.Recurring_Donation_Opportunity__c);
        }
        
        List<Opportunity> lstParentGiving = new List<Opportunity>();
        lstParentGiving = getParentGiving(ParentIds);
        Map<ID,Opportunity> mapParentGiving = new Map<ID,Opportunity>();
        for(Opportunity child:lstOpp){
            for(Opportunity parent:lstParentGiving){
                if(child.Recurring_Donation_Opportunity__c != null &&
                child.Recurring_Donation_Opportunity__c == parent.Id){
                    mapParentGiving.put(child.Id, parent);
                }
            }
        }
        
        //Checking for summary exists or not
        Map<Id,Giving_Summary__c> mapSummary = new Map<Id,Giving_Summary__c>();
        List<Giving_Summary__c> lstGiving = [Select Account__c, name, Id, Shopper_Count__c, first_source__c, Years_Since_First_Gift__c , Largest_Giving_Source__c,
        Years_Since_Previous_Gift__c, Start_date__c, largest_recent_amt__c, largest_date__c, total_amt__c, total_pd__c, current_fis_yr_amt__c, RecordTypeId,
        current_fis_yr_pd__c, track__c, Total_Member_Yr_Amount__c, current_mem_yr_renew_date__c, LastModifiedDate, Most_Recent_Giving_Date__c, Most_Recent_Giving_Amount__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c
        From Giving_Summary__c 
        Where Account__c in:AccountIds and RecordTypeId in: summaryType];
        
        if(lstGiving != null && lstGiving.size()>0){
            for(Giving_Summary__c g:lstGiving){
                mapSummary.put(g.Account__c,g);
            }    
        }    
        Map<Id,Campaign> mapCampaign = new Map<Id,Campaign>
        ([Select Id, name, Campaign_Name__c, Response_Mechanism__c, Channel_Technique__c, Sub_Channel__c from Campaign Where Id in: CampaignId]);
        system.debug('############Summary map: ' + mapSummary);
        system.debug('############campaign map: ' + mapCampaign);
        /////////////////////////////////////
        List<Opportunity> lstUpdateGiving = new List<Opportunity>();
        /////////////////////////////////////
        for(Opportunity opp:lstOpp){
            system.debug('############mapSummary.containsKey(opp.AccountId):' + mapSummary.containsKey(opp.AccountId));
            system.debug('!!!!!!!!!!!!!!!!!!!!!!!!Campaign Name: ' + Opp.Campaign.name);
            Opportunity ParentGiving = new Opportunity();
            if(mapParentGiving != null && 
            mapParentGiving.size()>0 && mapParentGiving.containsKey(opp.Id)){
                ParentGiving = mapParentGiving.get(opp.Id);
            }
            
            
            if(mapSummary.size()>0 && mapSummary.containsKey(opp.AccountId)==true){//Update Summary
                system.debug('$$$$$$$$$$$$$$$$$$$$Update summary');
                Campaign objCamp = new Campaign();
                Giving_Summary__c objSummary = mapSummary.get(Opp.AccountId);                
                if(opp.Gift_Type__c == 'New' ||
                    opp.Gift_Type__c == 'Renewal' ||
                    opp.Gift_Type__c == 'Rejoin' ||
                    opp.Gift_Type__c == 'Upgrade Reset'){
                    if(parentGiving != null && parentGiving.Gift_Date_Time__c != null){
                        objSummary.current_mem_yr_renew_date__c = parentGiving.Gift_Date_Time__c.Date();                                
                    }
                    if(parentGiving != null && parentGiving.Giving_Amount__c != null){
                        objSummary.current_mem_yr_renew_amt__c = parentGiving.Giving_Amount__c;                                
                    }
                }
                if(mapCampaign.size()>0 && mapCampaign.containsKey(opp.CampaignId)){
                    objCamp = mapCampaign.get(Opp.CampaignId);
                    objSummary.track__c = getTrack(opp.gift_type__c, objCamp.Channel_Technique__c, objCamp.Sub_Channel__c);
                }
                System.debug('Updating Giving Summary ------------------------->');
                //Largest_Giving_Source__c
                if(objCamp != null)
                    objSummary.Most_Recent_Giving_Source__c = objCamp.name;
                if(opp.payment_amount__c != null && objSummary.largest_recent_amt__c != null){
                    if(opp.payment_amount__c >= objSummary.largest_recent_amt__c){
                        objSummary.largest_recent_amt__c = opp.payment_amount__c;
                        objSummary.largest_date__c=Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                        if(objCamp != null)
                            objSummary.Largest_Giving_Source__c = objCamp.name;
                    }
                }
                if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                    objSummary.Member_Yr_Status__c = 'Active';
                }
                else{
                    objSummary.Member_Yr_Status__c = 'Pending';
                }
                objSummary.current_mem_yr_add_amt__c = opp.payment_amount__c;
                
                objSummary.total_amt__c = opp.Giving_Amount__c;
                if(objSummary.total_pd__c != null && opp.payment_amount__c != null)
                    objSummary.total_pd__c = objSummary.total_pd__c + opp.payment_amount__c;
                
                objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                objSummary.Most_Recent_Giving_Date__c = opp.Gift_Date_Time__c.date();
                objSummary.Most_Recent_Payment_Date__c = opp.Gift_Date_Time__c.date();
                objSummary.Station__c = opp.Station__c;
                objSummary.Product__c = opp.Product__c;
                objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
                if(objSummary.Start_date__c != null){
                    objSummary.Years_Since_First_Gift__c = system.today().year() - objSummary.Start_date__c.year();
                }
                objSummary.Years_Since_Previous_Gift__c = system.today().year() - objSummary.LastModifiedDate.year();
                objSummary.last_fis_yr_amt__c = objSummary.current_fis_yr_amt__c;
                objSummary.last_fis_yr_pd__c = objSummary.current_fis_yr_pd__c;
                objSummary.current_fis_yr_amt__c = opp.Giving_Amount__c;
                objSummary.current_fis_yr_pd__c =  opp.payment_amount__c;
                objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                objSummary.Most_Recent_Giving_Date__c = opp.Gift_Date_Time__c.date();
                objSummary.Most_Recent_Payment_Date__c = opp.Gift_Date_Time__c.date();
                objSummary.Station__c = opp.Station__c;
                objSummary.Product__c = opp.Product__c;
                objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
                
                boolean blnUpdate = true;
                if(lstUpdate != null && lstUpdate.size()>0){
                    for(Giving_Summary__c g:lstUpdate){
                        if(g.id == objSummary.Id){
                            blnUpdate = false;
                            break;
                        }
                    }
                }
                if(blnUpdate == true) lstUpdate.add(objSummary);
            }
            
            else{//Insert Summary
                if(opp.AccountId != null){
                    if(opp.Campaign_Name__c != null && 
                    (opp.Campaign_Name__c=='Annual' || opp.Campaign_Name__c=='In Kind' || opp.Campaign_Name__c=='Auction' || opp.Campaign_Name__c=='Matching' || opp.Campaign_Name__c == 'Capital' || opp.Campaign_Name__c == 'Planned Gift' || opp.Campaign_Name__c == 'Sales' || opp.Campaign_Name__c == 'Restricted' || opp.Campaign_Name__c == 'Foundation' || opp.Campaign_Name__c == 'Events' )
                     && (opp.Gift_Type__c == 'New' || opp.Gift_Type__c == 'Renewal' || opp.Gift_Type__c == 'Rejoin' || opp.Gift_Type__c == 'Upgrade Reset' || opp.Gift_Type__c == 'Add Gift' || opp.Gift_Type__c == 'Donation' || opp.Gift_Type__c == 'Purchase' ) ){   
                        system.debug('$$$$$$$$$$$$$$$$$$$$Insert summary');
                        Giving_Summary__c objSummary = new Giving_Summary__c();
                        String recordTypeId='';
                        if(opp.Gift_Type__c == 'New' ||
                            opp.Gift_Type__c == 'Renewal' ||
                            opp.Gift_Type__c == 'Rejoin' ||
                            opp.Gift_Type__c == 'Upgrade Reset'){
                            if(parentGiving != null && parentGiving.Gift_Date_Time__c != null){
                                objSummary.current_mem_yr_renew_date__c = parentGiving.Gift_Date_Time__c.Date();                                
                            }
                            if(parentGiving != null && parentGiving.Giving_Amount__c != null){
                                objSummary.current_mem_yr_renew_amt__c = parentGiving.Giving_Amount__c;                                
                            }
                            else{
                                objSummary.current_mem_yr_renew_amt__c = opp.Giving_Amount__c;
                            }
                            
                        }
                        
                        System.debug('Inserting Giving Summary ------------------------->');
                        
                        if(opp.Campaign_Name__c != null){
                            
                            developerName = getDeveloperNameByCampaignName(String.valueOf(opp.Campaign_Name__c));   
                            
                            if(developerName != null && developerName.trim().length() > 0){
                                recordTypeId = getRecordType(developerName.trim());
                            }
                                
                            if(recordTypeId != null && recordTypeId.trim().length()>0){
                                objSummary.RecordTypeId = recordTypeId;
                            }
                        }
                        Campaign objCamp = new Campaign();
                        if(mapCampaign.containsKey(Opp.CampaignId)){
                            objCamp = mapCampaign.get(Opp.CampaignId);
                            objSummary.track__c = getTrack(opp.gift_type__c, objCamp.Channel_Technique__c, objCamp.Sub_Channel__c);
                            //objSummary.Shopper_Count__c = 0;
                            if(objCamp.Campaign_Name__c == 'Annual'){
                                if(objCamp.Channel_Technique__c != null){
                                    if(objCamp.Channel_Technique__c.trim().touppercase() == 'TV' ||
                                    objCamp.Channel_Technique__c.trim().touppercase() == 'RADIO' ||
                                    objCamp.Channel_Technique__c.trim().touppercase() == 'WEB'){
                                        if(objSummary.Shopper_Count__c < 3)
                                            objSummary.Shopper_Count__c ++;
                                    }
                                }
                            }
                        }
                        
                        objSummary.Account__c = opp.AccountId;
                        
                        if(opp.Gift_Type__c == 'New' ||opp.Gift_Type__c == 'Rejoin' || opp.Gift_Type__c == 'Upgrade Reset'){
                            Date pledgeGiftDate = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                            String month = String.valueOf(pledgeGiftDate.month() + 1);
                            String year = String.valueOf(pledgeGiftDate.year());
                            objSummary.start_date__c = date.valueOf(year + '-' + month + '-1');
                        }
                        else{
                            objSummary.start_date__c = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month() + 1,opp.Gift_Date_Time__c.day());
                        }
                        objSummary.expiration_date__c = objSummary.start_date__c.addMonths(12);
                        if(opp.payment_amount__c!= null && opp.payment_amount__c>0){///????????
                            objSummary.Member_Yr_Status__c = 'Active';
                        }
                        else{
                            objSummary.Member_Yr_Status__c = 'Pending';
                        }
                        objSummary.current_mem_yr_add_amt__c = 0;//???????????????????????????
                        
                        //Solicitation Cycle = O or M or I 
                        if(opp.gift_kind__c!=null){
                            String cycle = opp.gift_kind__c.trim().touppercase();
                            //One Payment ; Installment ; Sustaining Gift ; Sustaining Pledge
                            if(cycle == 'ONE PAYMENT')
                                objSummary.solicitation_cycle1__c='O';
                            else if(cycle == 'INSTALLMENT')
                                objSummary.solicitation_cycle1__c='I';
                            else if(cycle == 'SUSTAINING GIFT'){
                                if(objSummary.current_mem_yr_add_amt__c>0)
                                    objSummary.solicitation_cycle1__c='M';
                            }
                            else if(cycle == 'SUSTAINING PLEDGE')
                                objSummary.solicitation_cycle1__c='I';
                        }
                        string responseMechanism='';                            
                        if(mapCampaign.containsKey(Opp.CampaignId)){
                            if(objCamp.Response_Mechanism__c != null){
                                responseMechanism = objCamp.Response_Mechanism__c.trim().touppercase();
                                if(responseMechanism == 'MAIL')
                                    objSummary.track__c = 'M';
                                else if(responseMechanism == 'INBOUND CALL')
                                    objSummary.track__c = 'IC';
                                else if(responseMechanism == 'WEB INBOUND')
                                    objSummary.track__c = 'WI';
                                else if(responseMechanism == 'RENEW BY MAIL')
                                    objSummary.track__c = 'RN';
                            }
                        }
                        objSummary.first_date__c = Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                        if(mapCampaign.containsKey(Opp.CampaignId)){
                            objSummary.first_source__c = objCamp.name;
                            objSummary.Most_Recent_Giving_Source__c = objCamp.name;
                            objSummary.Largest_Giving_Source__c = objCamp.name;
                        }
                        objSummary.first_amt__c = opp.Giving_Amount__c;
                        objSummary.largest_date__c=Date.newInstance(opp.Gift_Date_Time__c.year(),opp.Gift_Date_Time__c.month(),opp.Gift_Date_Time__c.day());
                        objSummary.largest_recent_amt__c = opp.payment_amount__c;
                        objSummary.total_amt__c = opp.Giving_Amount__c;
                        objSummary.total_pd__c=opp.payment_amount__c;
                        objSummary.current_fis_yr_amt__c = opp.Giving_Amount__c;
                        objSummary.current_fis_yr_pd__c =  opp.payment_amount__c;
                        
                        objSummary.Years_Since_First_Gift__c = 0;
                        objSummary.Years_Since_Previous_Gift__c = 0;
                        objSummary.last_fis_yr_amt__c = 0;
                        objSummary.last_fis_yr_pd__c = 0;
                        objSummary.Most_Recent_Giving_Amount__c = opp.Giving_Amount__c;
                        objSummary.Most_Recent_Giving_Date__c = opp.Gift_Date_Time__c.date();
                        objSummary.Most_Recent_Payment_Date__c = opp.Gift_Date_Time__c.date();
                        objSummary.Station__c = opp.Station__c;
                        objSummary.Product__c = opp.Product__c;
                        objSummary.Fiscal_Year__c = String.ValueOf(opp.Gift_Date_Time__c.Year());
                        objSummary.Shopper_Count__c = 0;
                        lstInsert.add(objSummary);
                    }
                }
            }
        }
        
        List<String> lstStation = new List<String>();
        List<String> lstProduct = new List<String>();
        List<String> lstCampaign = new List<String>();
        Map<Id,RecordType> MapRecordTypesId = new Map<Id,RecordType>();
        for(RecordType r: lstRecordTypes) {
            MapRecordTypesId.put(r.Id,r);
        }
        List<Giving_Summary_Control__c> lstControl = new List<Giving_Summary_Control__c>();
        String CampaignName = '';
        if(lstInsert.size()>0){
            for(Giving_Summary__c g:lstInsert){
                if(g.Total_Member_Yr_Amount__c != null){
                    lstStation.add(g.Station__c);
                    lstProduct.add(g.Product__c);
                    System.debug('#### Station --> : ' + g.station__c);
                    System.debug('#### Product --> : ' + g.Product__c);
                    System.debug('#### RecordTypeID --> : ' + g.RecordTypeId);
                    if(MapRecordTypesId.size()>0 && MapRecordTypesId.containsKey(g.RecordTypeId)){
                        lstCampaign.add(getCampaignByDeveloperName(MapRecordTypesId.get(g.RecordTypeId).DeveloperName));
                        system.debug('##### Campaign Type : ---> ' + getCampaignByDeveloperName(MapRecordTypesId.get(g.RecordTypeId).DeveloperName));                        
                    }
                }
            }
            if(lstStation.size()>0 && lstProduct.size()>0 && lstCampaign.size()>0){
                lstControl = [Select Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
                Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
                Renewal_Window_Start__c, Shopper_Threshold__c,
                Station__c, Product__c, Campaign_Type__c
                From Giving_Summary_Control__c 
                Where Station__c in: lstStation and 
                Product__c in: lstProduct and 
                Campaign_Type__c in: lstCampaign ];
            }
            for(Giving_Summary__c giving:lstInsert){
                CampaignName = getCampaignByDeveloperName(MapRecordTypesId.get(giving.RecordTypeId).DeveloperName);
                system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Control Size : ------> ' + lstControl.size());
                for(Giving_Summary_Control__c control:lstControl){
                    if(giving.Station__c == control.Station__c &&
                    giving.Product__c == control.Product__c &&
                    CampaignName == control.Campaign_Type__c){
                        if(giving.Total_Member_Yr_Amount__c >= control.Minimum_Total_Mem_Year_Amount__c &&
                        giving.Total_Member_Yr_Amount__c <= control.Maximum_Total_Mem_Year_Amount__c){
                            giving.Giving_Level__c = control.Giving_Level__c;
                            giving.Lapsed_Period__c = control.Lapsed_Window_Start__c;
                        }
                    }
                    system.debug('$$$$$$$$$$$$$$$$ Giving Level :----> ' + control.Giving_Level__c);
                }
            }
            
            system.debug('#### Giving Level (Insert) - ' + lstInsert[0].Id + ' : ' + lstInsert[0].Giving_Level__c );
            insert lstInsert;
        }
        
        lstStation = new List<String>();
        lstProduct = new List<String>();
        lstCampaign = new List<String>();
        CampaignName = '';
        lstControl = new List<Giving_Summary_Control__c>();
        System.debug('MapRecordTypesId---------------------->' + MapRecordTypesId);
        System.debug('#### Update summary size : ' + lstUpdate.size());
        if(lstUpdate.size()>0){
            for(Giving_Summary__c g:lstUpdate){
                if(g.Total_Member_Yr_Amount__c != null){
                    lstStation.add(g.Station__c);
                    lstProduct.add(g.Product__c);
                    if(MapRecordTypesId.size()>0 && MapRecordTypesId.containsKey(g.RecordTypeId)){
                        lstCampaign.add(getCampaignByDeveloperName(MapRecordTypesId.get(g.RecordTypeId).DeveloperName));
                    }
                }
            }
            if(lstStation.size()>0 && lstProduct.size()>0 && lstCampaign.size()>0){
                lstControl = [Select Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
                Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
                Renewal_Window_Start__c, Shopper_Threshold__c,
                Station__c, Product__c, Campaign_Type__c
                From Giving_Summary_Control__c 
                Where Station__c in: lstStation and 
                Product__c in: lstProduct and 
                Campaign_Type__c in: lstCampaign ];
            }
            for(Giving_Summary__c giving:lstUpdate){
                System.debug('GIVING RECORD TYPE ----------------------------------------> ' + giving.RecordTypeId);
                CampaignName = getCampaignByDeveloperName(MapRecordTypesId.get(giving.RecordTypeId).DeveloperName);
                for(Giving_Summary_Control__c control:lstControl){
                    if(giving.Station__c == control.Station__c &&
                    giving.Product__c == control.Product__c &&
                    CampaignName == control.Campaign_Type__c){
                        if(giving.Total_Member_Yr_Amount__c >= control.Minimum_Total_Mem_Year_Amount__c &&
                        giving.Total_Member_Yr_Amount__c <= control.Maximum_Total_Mem_Year_Amount__c){
                            giving.Giving_Level__c = control.Giving_Level__c;
                            giving.Lapsed_Period__c = control.Lapsed_Window_Start__c;
                        }
                    }
                }
            }        
            system.debug('#### Giving Level (Update) - ' + lstUpdate[0].Id + ' : ' + lstUpdate[0].Giving_Level__c );
            //try{
                update lstUpdate;
            //}catch(Exception ex){
            //}
        }
    }
    
    Static String getTrack(String GiftType, String Channel, String SubChannel){
        String Track = '';
        String RadioTV = 'by Pledge';
        String Mail = 'by Mail';
        String Email = 'by Email';
        String TelesalesInbound = 'by Member Service';
        String TelesalesOutbound = 'by Telemarketing';
        String Mobile = 'by Mobile';
        String EventType = 'by Event';
        String Web = 'by Web';
        if(GiftType != null && GiftType.Trim().Length()>0){
            if(GiftType.Trim().ToUpperCase()=='NEW' || GiftType.Trim().ToUpperCase()=='RENEWAL' ||
            GiftType.Trim().ToUpperCase()=='REJOIN' || GiftType.Trim().ToUpperCase()=='Upgrade Reset'){   
                if(Channel.Trim().ToUpperCase() == 'RADIO'){
                    Track = RadioTV;
                }
                else if(Channel.Trim().ToUpperCase() == 'TV'){
                    Track = RadioTV;
                }
                else if(Channel.Trim().ToUpperCase() == 'MAIL'){
                    Track = Mail;
                }
                else if(Channel.Trim().ToUpperCase() == 'EMAIL'){
                    Track = Email;
                }
                else if(Channel.Trim().ToUpperCase() == 'TELESALES' && SubChannel.Trim().ToUpperCase() == 'INBOUND'){
                    Track = TelesalesInbound;
                }
                else if(Channel.Trim().ToUpperCase() == 'TELESALES' && SubChannel.Trim().ToUpperCase() == 'OUTBOUND'){
                    Track = TelesalesOutbound;
                }
                else if(Channel.Trim().ToUpperCase() == 'MOBILE'){
                    Track = Mobile;
                }
                else if(Channel.Trim().ToUpperCase() == 'EVENT TYPE'){
                    Track = EventType;
                }
                else if(Channel.Trim().ToUpperCase() == 'WEB'){
                    Track = Web;
                }
                Track = GiftType + ' ' + Track;             
            }

            /*if(GiftType.Trim().ToUpperCase()=='NEW'){    
            }
            else if(GiftType.Trim().ToUpperCase()=='RENEW'){
            }
            else if(GiftType.Trim().ToUpperCase()=='REJOIN'){
            }
            else if(GiftType.Trim().ToUpperCase()=='NEW'){
            }*/
        }
        
        return Track;
    }
    
    Static void UpdateGivingStage(List<Opportunity> lstOpp){
        List<Opportunity> lstUpdate = new List<Opportunity>();
        if(lstOpp.size()>0){
            for(Opportunity objPledges:lstOpp){
                if(objPledges.Gift_Kind__c == 'One Payment'){
                    Integer monthDifference = system.today().monthsBetween(objPledges.Gift_Date_Time__c.date());
                    if(objPledges.StageName == 'Pledged' && monthDifference >= 6)
                        objPledges.StageName = 'Uncollectible';
                }       
                lstUpdate.add(objPledges);         
            }
            if(lstUpdate.size()>0){
                update lstUpdate;
            }
        }
    }
    Static String getCampaignByDeveloperName(String DeveloperName){
        String CampaignName = '';
        if(DeveloperName != null && DeveloperName.trim().length()>0){
            if(DeveloperName == 'Restricted_Giving')
                CampaignName = 'Restricted';
            if(DeveloperName == 'In_Kind_Gifts')
                CampaignName = 'In Kind';
            if(DeveloperName == 'Auction_Giving')
                CampaignName = 'Auction';
            if(DeveloperName == 'Annual_Giving')
                CampaignName = 'Annual';
            if(DeveloperName == 'Matching_Gifts')
                CampaignName = 'Matching';
            if(DeveloperName == 'Capital_Campaign_Giving')
                CampaignName = 'Capital';
            if(DeveloperName == 'Planned_Giving')
                CampaignName = 'Planned Gift';
            if(DeveloperName == 'Sales_Giving')
                CampaignName = 'Sales';
            if(DeveloperName == 'Foundation')
                CampaignName = 'Foundation';
            if(DeveloperName == 'Events')
                CampaignName = 'Events';    
        }
        return CampaignName;
    }
    Static String getDeveloperNameByCampaignName(String CampaignName){
        String developerName = '';
        if(CampaignName != null && CampaignName.trim().length()>0){
            if(CampaignName == 'Restricted')
                developerName = 'Restricted_Giving';
            if(CampaignName == 'In Kind')
                developerName = 'In_Kind_Gifts';
            if(CampaignName == 'Auction')
                developerName = 'Auction_Giving';
            if(CampaignName == 'Annual')
                developerName = 'Annual_Giving';
            if(CampaignName == 'Matching')
                developerName = 'Matching_Gifts';
            if(CampaignName == 'Capital')
                developerName = 'Capital_Campaign_Giving';
            if(CampaignName == 'Planned Gift')
                developerName = 'Planned_Giving';
            if(CampaignName == 'Sales')
                developerName = 'Sales_Giving';
            if(CampaignName == 'Foundation')
                developerName = 'Foundation';
            if(CampaignName == 'Events')
                developerName = 'Events';    
        }
        return developerName;
    }
    
    string getGivingLevel(Giving_Summary__c objSummary){
    
        return '';
    }
    static String getRecordType(String name){
        string recordtypeId = '';
        
        RecordType objR = [select id from recordtype where developername =: name];
        
        if(objR != null){
            recordtypeId = objR.id;
        }
        
        return recordTypeId;
    
    }
    Public UpdateSummary(){}
    
    static List<Opportunity> getParentGiving(Set<ID> parentIds){
        List<Opportunity> lstOpp = [Select Id, AccountId, RecordTypeId, Name, Description, StageName, 
            Amount, Type, CampaignId, Pricebook2Id, FiscalYear, Campaign_Name__c, 
            Contact_Id_for_Role__c, Oppty_Related_Contact__c, Station__c, 
            TrackingNumber__c, Gift_Date_Time__c, gift_kind__c, gift_type__c, 
            payment_amount__c, payment_frequency__c, payment_number__c, 
            payments_in_schedule__c, Giving_Amount__c, pledge_number__c, program__c, purpose__c, 
            schedule_start_date__c, source__c, systemHouseholdContactRoleProcessor__c, 
            ta_campaign__c, ta_campaign_value__c,  bulk_load__c, 
            new_install_ment_date__c, pledge_amount__c ,  
            payment_method__c, batch_process_count__c, New_Balance__c, 
            Product__c, Ack_Sent_Date__c, Foundation_Name__c, 
            Foundation_Pay__c, Installment_Period__c, Installments__c, Matching_Gift__c, 
            Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
            Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, 
            Payment_Method_Description__c, Charge_Card_Type__c, Matching_Company__c, 
            Support_Designation__c, Anonymous__c, Restricted__c, Override_Gift_Type__c, 
            Payment_Date__c, Revenue_Date__c, Giving_Segment__c,
            Response_Mechanism__c, Closed_Lost_Reasons__c, Source_Code__c , Matching_Gift_Status__c 
            FROM Opportunity Where Id IN:parentIds];
            
            return lstOpp;
    }
    
    ///////////////////TEST METHODS////////////////////////
    Static TestMethod void MyTest(){
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign();
        c.Name = 'Test';
        c.Channel_Technique__c = 'TELESALES';
        c.Sub_Channel__c = 'INBOUND';
        c.campaign_name__c = 'Annual';
        c.station__c = 'WGBH';
        c.response_mechanism__c = 'Mail';
        Insert c;
        /*
        Giving_Summary__c g = new Giving_Summary__c();
        g.Account__c = a.Id;
        insert g;
        */
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
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        lstOpp.add(opp);
    
        UpdateSummary.UpdateGivingSummary(lstOpp,true);
        UpdateSummary.getTrack('NEW', 'RADIO', '');
        UpdateSummary.getTrack('NEW', 'TV', '');
        UpdateSummary.getTrack('NEW', 'MAIL', '');
        UpdateSummary.getTrack('NEW', 'EMAIL', '');
        UpdateSummary.getTrack('NEW', 'TELESALES', 'INBOUND');
        UpdateSummary.getTrack('NEW', 'TELESALES', 'OUTBOUND');
        UpdateSummary.getTrack('NEW', 'MOBILE', '');
        UpdateSummary.getTrack('NEW', 'EVENT TYPE', '');
        UpdateSummary.getTrack('NEW', 'WEB', 'INBOUND');

        UpdateSummary.UpdateGivingStage(lstOpp);
        
        UpdateSummary.getCampaignByDeveloperName('Restricted_Giving');
        UpdateSummary.getCampaignByDeveloperName('Auction_Giving');
        UpdateSummary.getCampaignByDeveloperName('Annual_Giving');
        UpdateSummary.getCampaignByDeveloperName('Matching_Gifts');
        UpdateSummary.getCampaignByDeveloperName('Capital_Campaign_Giving');
        UpdateSummary.getCampaignByDeveloperName('Planned_Giving');
        UpdateSummary.getCampaignByDeveloperName('Sales');
        UpdateSummary.getCampaignByDeveloperName('Foundation');
        UpdateSummary.getCampaignByDeveloperName('Events');
        
        UpdateSummary.getDeveloperNameByCampaignName('Restricted');
        UpdateSummary.getDeveloperNameByCampaignName('Restricted_Giving');
        UpdateSummary.getDeveloperNameByCampaignName('In_Kind_Gifts');
        UpdateSummary.getDeveloperNameByCampaignName('Auction_Giving');
        UpdateSummary.getDeveloperNameByCampaignName('Annual_Giving');
        UpdateSummary.getDeveloperNameByCampaignName('Matching_Gifts');
        UpdateSummary.getDeveloperNameByCampaignName('Capital_Campaign_Giving');
        UpdateSummary.getDeveloperNameByCampaignName('Planned_Giving');
        UpdateSummary.getDeveloperNameByCampaignName('Sales');
        UpdateSummary.getDeveloperNameByCampaignName('Foundation');
        UpdateSummary.getDeveloperNameByCampaignName('Events');
        
        
    }
}