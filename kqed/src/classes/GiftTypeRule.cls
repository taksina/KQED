public class GiftTypeRule{
    public enum gtrType{ANNUALGTR, DONATIONPURCHASEGTR, INKINDGTR}
    
    public static void GTR(WGBH_PB5_UPLOAD__c PB5, List<Opportunity> lstOpp, gtrType gt){
        setSummary(lstOpp);
        if(gt == gtrType.DONATIONPURCHASEGTR){
            gtrDonationPurchase(PB5, lstOpp);
        }
        if(gt == gtrType.ANNUALGTR){
            gtrAnnual(PB5, lstOpp);
        }
        if(gt == gtrType.INKINDGTR){
            gtrInkind(PB5, lstOpp);
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    public static void gtrInkind(WGBH_PB5_UPLOAD__c PB5, List<Opportunity> lstOpp){        
        for(Opportunity opp:lstOpp){
            /*IS CAMPAIGN ON CPRT INKIND GIVING?*/
            if(opp.Campaign_Name__c.trim().toUpperCase() == 'IN KIND'){/*YES*/
                /*IS GIFT TYPE IN UPLOAD?*/
                if(PB5.PB5_GIFT_TYPE__c != null & PB5.PB5_GIFT_TYPE__c.trim().length()>0){/*YES*/
                     /*IF YES THEN APPLY GIFT TYPE FROM UPLOAD OR CAMPAIGN*/
                    opp.Gift_Type__c = PB5.PB5_GIFT_TYPE__c;
                }
                else{/*NO*/
                    /*IF NO THEN CHECK: IS GIFT TYPE ON CAMPAIGN?*/
                    if(opp.Campaign.Override_Gift__c != null && opp.Campaign.Override_Gift__c.trim().length()>0){
                        /*IF YES THEN APPLY GIFT TYPE FROM UPLOAD OR CAMPAIGN*/
                        opp.Gift_Type__c = opp.Campaign.Override_Gift__c;
                    }
                    else{/*NO*/
                        /*DOES GIVING SUMMARY FOR STATION & PRODUCT EXISTS?*/
                        if(IsGivingSummaryExists(opp)==true){/*YES*/
                            /*IS GIFT DATE < 3 MONTH PRIOR TO EXPIRE DATE?*/
                            if(PB5.PB5_GIFT_CDATE__c.monthsBetween(Date.valueOf(PB5.PB5_CHARGE_EXPIRE_CDATE__c))>=3){/*YES*/
                                //IF(DOES THE GIVING LEVEL INCREASE TO CHALLANGE OR PARTNER?)
                                    //GIFT TYPE = UPGRADE RESET
                                //ELSE 
                                        //IF(DOES GIVING LEVEL INCREASE FROM SUBMEMBER?)
                                           //GIFT TYPE = UPGRADE RESET
                                        //ELSE
                                           //GIFT TYPE = ADDITIONAL GIFT                                     
                            }
                            else{/*NO*/
                                //IF STATUS ON GIVING SUMMARY LAPSED?
                                    //GIFT TYPE = REJOIN
                                //ELSE
                                    //GIFT TYPE = REJOIN
                                if(MemberyearStatusInGivingSummary(opp) == true)
                                    opp.Gift_Type__c = 'Rejoin';
                                else
                                    opp.Gift_Type__c = 'Renewal';
                            }
                        }
                        else{/*NO*/
                            opp.Gift_Type__c = 'New';
                        }
                    }
                }
            }
            else{/*NO*/
                //USE ANOTHER GTR
                gtrDonationPurchase(PB5, lstOpp);
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    public static void gtrAnnual(WGBH_PB5_UPLOAD__c PB5, List<Opportunity> lstOpp){
        for(Opportunity opp:lstOpp){
            /*IS PRODUCT MEMBERSHIP ON CPRT AND CAMPAIGN ON CPRT ANNUAL?*/
            if(opp.Campaign_Name__c.trim().toUpperCase() == 'ANNUAL'){
                /*IS GIFT TYPE IN UPLOAD?*/
                if(PB5.PB5_GIFT_TYPE__c != null && PB5.PB5_GIFT_TYPE__c.trim().length()>0){
                    /*IF YES THEN APPLY GIFT TYPE FROM UPLOAD OR CAMPAIGN*/
                    opp.Gift_Type__c = PB5.PB5_GIFT_TYPE__c;
                }
                else{
                    /*IF NO THEN CHECK: IS GIFT TYPE ON CAMPAIGN?*/
                    if(opp.Campaign.Override_Gift__c != null && opp.Campaign.Override_Gift__c.trim().length()>0){
                        /*IF YES THEN APPLY GIFT TYPE FROM UPLOAD OR CAMPAIGN*/
                        opp.Gift_Type__c = opp.Campaign.Override_Gift__c;
                    }
                    else{
                        /*Is HH a Sustaining Giver Classification code = AUTO_RENEW for STATION?*/
                        sObject w =(sObject)PB5;
                        boolean blnAutoReview = false;
                        for(integer i=1; i<11; i++){
                            if(String.valueOf(w.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c')).trim().toUpperCase() == 'AUTO_RENEW'){
                                blnAutoReview = true;
                                break;                                
                            }
                        }
                        if(blnAutoReview == true){/*YES*/
                            //opp.Gift_Type__c = 'Additional Gift';
                            opp.Gift_Type__c = 'Add Gift';
                        }
                        else{/*NO*/
                            /***************************************************/
                            /*DOES GIVING SUMMARY FOR STATION & PRODUCT EXISTS?*/
                            if(IsGivingSummaryExists(OPP)==true){/*YES*/
                                /*IS GIFT DATE < 3 MONTH PRIOR TO EXPIRE DATE?*/
                                if(PB5.PB5_GIFT_CDATE__c.monthsBetween(Date.valueOf(PB5.PB5_CHARGE_EXPIRE_CDATE__c))>=3){/*YES*/
                                    if(givingLevelIncreasetoMajorDonor(opp)==true){
                                        if(shopperFlagChecked(opp)==true)
                                            opp.Gift_Type__c = 'Add Gift';
                                        else
                                            opp.Gift_Type__c = 'Upgrade Reset';
                                    }
                                    else{
                                        if(opp.Gift_Kind__c != null &&
                                            (opp.Gift_Kind__c.trim().toUpperCase() == 'INSTALLMENT' || 
                                             opp.Gift_Kind__c.trim().toUpperCase() == 'SUSTAINING GIFT')){
                                             
                                        }
                                    }
                                    //IF(DOES THE GIVING LEVEL INCREASE TO MAJOR DONOR?)                                
                                        //IF(SHOPPER FLAG CHECKED?)
                                            //GIFT TYPE = ADDITIONAL GIFT
                                        //ELSE
                                            //GIFT TYPE = UPGRADE RESET
                                    //ELSE
                                        //IF(RECURRING GIFT?)
                                            //IF(WILL PAYMENTS ON OPP. EXTEND PAST EXPIRE?)
                                                //GIFT TYPE = UPGRADE RESET
                                            //ELSE
                                                //GIFT TYPE = ADDITIONAL GIFT
                                        //ELSE
                                            //IF(DOES CURRENT MEMBERSHIP BENIFITS INCLUDE MEM, CARD AND GUID?)
                                                //GIFT TYPE = ADDITIONAL GIFT
                                            //ELSE
                                                //GIFT TYPE = UPGRADE RESET
                                }
                                else{/*NO*/
                                    //IF(IS STATUS ON GIVING SUMMARY LAPSED?)
                                        //GIFT TYPE = REJOIN
                                    //ELSE
                                        //GIFT TYPE = RENEWAL
                                    if(MemberyearStatusInGivingSummary(opp) == true)
                                        opp.Gift_Type__c = 'Rejoin';
                                    else
                                        opp.Gift_Type__c = 'Renewal';
                                    }
                            }
                            else{/*NO*/
                                opp.Gift_Type__c = 'New';
                            }
                        }
                    }
                }
            }
            else{
                /*USE ANOTHER GTR*/
                gtrDonationPurchase(PB5, lstOpp);
            }
        }
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    
    static Map<ID,Giving_Summary__c> mapSummary;
    static List<Giving_Summary__c> lstGivingSummary;
    static void setSummary(List<Opportunity> lstOpp){
        List<ID> AccountIds = new List<ID>();
        List<String> summaryType = new List<String>();
        List<Giving_Summary__c> lstSummary = new List<Giving_Summary__c>();
        
        List<RecordType> lstRecordTypes = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Giving_Summary__c'];
        Map<String,RecordType> MapRecordTypes = new Map<String,RecordType>();
        for(RecordType r: lstRecordTypes) {
            MapRecordTypes.put(r.DeveloperName,r);
        }
        
        Set<ID> CampaignId = new Set<ID>();
        String developerName = '';
        for(Opportunity o:lstOpp){
            AccountIds.add(o.AccountId);//Household
            CampaignId.add(o.CampaignId);
            developerName = '';
            developerName = getDeveloperNameByCampaignName(String.valueOf(o.Campaign_Name__c)); 
            if(MaprecordTypes.containsKey(developerName)){
                RecordType r = MaprecordTypes.get(developerName);
                summaryType.add(r.Id);
            }
            
        }
        //Checking for summary exists or not
        mapSummary = new Map<Id,Giving_Summary__c>();
        
        List<Giving_Summary__c> lstGiving = [Select Account__c, name, Id, first_source__c, 
        largest_recent_amt__c, largest_date__c, total_amt__c, total_pd__c, current_fis_yr_amt__c,
        current_fis_yr_pd__c ,Giving_Level__c, Member_Yr_Status__c, Shopper__c
        From Giving_Summary__c 
        Where Account__c in:AccountIds and RecordTypeId in: summaryType];
        
        if(lstGiving != null && lstGiving.size()>0){
            for(Giving_Summary__c g:lstGiving){
                mapSummary.put(g.Account__c,g);
            }    
        }
       
    }
    public static boolean shopperFlagChecked(Opportunity opp){
        boolean result = false;
        
        if(mapSummary != null && mapSummary.size()>0 && mapSummary.containsKey(opp.AccountId)==true){
            if(mapSummary.get(opp.AccountId).Shopper__c == true)
                result = true;
            else
                result = false;
        }
        
        return result;
    }
    public static boolean givingLevelIncreasetoMajorDonor(Opportunity opp){
        boolean result = false;
        
        if(mapSummary != null && mapSummary.size()>0 && mapSummary.containsKey(opp.AccountId)==true){
            if(mapSummary.get(opp.AccountId).Giving_Level__c.trim().toUpperCase() == 'MAJOR DONOR')
                result = true;
            else
                result = false;
        }
        
        
        /*
        if(lstGivingSummary != null && lstGivingSummary.size()>0){
            if(lstGivingSummary[0].Giving_Level__c != null && 
               lstGivingSummary[0].Giving_Level__c.trim().toUpperCase() == 'MAJOR DONOR')
               result = true;
            else
               result = false; 
        }
        else{
            result = false;
        }
        String householdId = opp.AccountId;
        List<Giving_Summary__c> lstGiving = new List<Giving_summary__c>();
        String recordTypeId = getGivingSummaryRecordType(opp);
        
        lstGiving = [Select Id, Giving_Level__c From Giving_Summary__c
        Where Account__c =: householdId and RecordTypeId =: recordTypeId ];
        
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Giving_Level__c != null && 
               lstGiving[0].Giving_Level__c.trim().toUpperCase() == 'MAJOR DONOR')
               result = true;
            else
               result = false; 
        }
        */
        return result;
    }
    public static void gtrDonationPurchase(WGBH_PB5_UPLOAD__c PB5, List<Opportunity> lstOpp){
        for(Opportunity opp:lstOpp){
            if(opp.RecordType.DeveloperName.trim().toUpperCase() == 'DONATION'){
                opp.Gift_type__c = 'Donation';
            }
            else if(opp.RecordType.DeveloperName.trim().toUpperCase() == 'PURCHASE'){
                opp.Gift_type__c = 'Purchase';
            }
            else{                     
                PB5.Flag_for_Review__c = true;
                PB5.Flag_Review_Reason__c = 'GIFT TYPE IS NULL'; // GIFT TYPE IS NULL
            }
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////
    Public static boolean MemberyearStatusInGivingSummary(Opportunity opp){
        boolean result = false;
        if(mapSummary != null && mapSummary.size()>0 && mapSummary.containsKey(opp.AccountId)==true){
            if(mapSummary.get(opp.AccountId).Member_Yr_Status__c != null && 
            mapSummary.get(opp.AccountId).Member_Yr_Status__c.trim().toUpperCase() == 'LAPSED')
                result = true;
            else
                result = false;
        }
        /*
        if(lstGivingSummary != null && lstGivingSummary.size()>0){
            if(lstGivingSummary[0].Member_Yr_Status__c != null && 
               lstGivingSummary[0].Member_Yr_Status__c.trim().toUpperCase() == 'LAPSED')
               result = true;
            else
               result = false; 
        }
        else{
            result = false;
        }
        String householdId = opp.AccountId;
        List<Giving_Summary__c> lstGiving = new List<Giving_summary__c>();
        String recordTypeId = getGivingSummaryRecordType(opp);
        
        lstGiving = [Select Id, Member_Yr_Status__c From Giving_Summary__c
        Where Account__c =: householdId and RecordTypeId =: recordTypeId ];
        
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Member_Yr_Status__c != null && 
               lstGiving[0].Member_Yr_Status__c.trim().toUpperCase() == 'LAPSED')
               result = true;
            else
               result = false; 
        }
        */
        return result;
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
                developerName = 'Sales';
            if(CampaignName == 'Foundation')
                developerName = 'Foundation';
            if(CampaignName == 'Events')
                developerName = 'Events';    
        }
        return developerName;
    }
    static string getGivingSummaryRecordType(Opportunity o){
        String recordTypeId=null;
        List<RecordType> lstRecordTypes = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Giving_Summary__c'];
        Map<String,RecordType> MapRecordTypes = new Map<String,RecordType>();
        for(RecordType r: lstRecordTypes) {
            MapRecordTypes.put(r.DeveloperName,r);
        }
        
        Set<ID> CampaignId = new Set<ID>();
        String developerName = '';
            developerName = getDeveloperNameByCampaignName(o.Campaign_Name__c);
            if(MaprecordTypes.containsKey(developerName)){
                RecordType r = MaprecordTypes.get(developerName);
                recordTypeId = r.Id;
            }
         return recordTypeId;
    }
    static boolean IsGivingSummaryExists(Opportunity opp){
        boolean flag = false;
        if(mapSummary != null && mapSummary.size()>0 && mapSummary.containsKey(opp.AccountId)==true){
            flag = true;
        }
        else{
            flag = false;
        }
        /*
        if(lstGivingSummary != null && lstGivingSummary.size()>0){
            flag = true; 
        }
        else{
            flag = false;
        }
        String givingSummaryRecordType = getGivingSummaryRecordType(opp);
        List<Giving_Summary__c> lstGiving = [Select Id
        From Giving_Summary__c 
        Where Account__c =:opp.AccountId and RecordTypeId =: givingSummaryRecordType];
        
        if(lstGiving != null && lstGiving.size()>0){
            flag = true;
        }
        else{
            flag = false;
        }
        */
        return flag;
    }
      static testMethod void GiftTypeRule(){
      GiftTypeRule clsTest = new GiftTypeRule();
      //GiftTypeRule.GTR('test','test','test');
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
        WGBH_PB5_UPLOAD__c wgbh1 = new WGBH_PB5_UPLOAD__c();
            
        insert wgbh1;
        
        WGBH_PB5_UPLOAD__c wgbh2 = new WGBH_PB5_UPLOAD__c();
        wgbh2.PB5_GIFT_TYPE__c = 'New';   
        insert wgbh2;
        
        Opportunity opp = New Opportunity();
        
        opp.AccountID = a.Id;
       
        opp.Name = 'Test';
        opp.gift_kind__c = 'One Payment';
        opp.CloseDate = system.Today().AddDays(15);
        opp.Gift_Date_Time__c = system.now();
        opp.StageName = 'Pledged';
        opp.CampaignID = c.Id;
        opp.campaign_name__c = 'ANNUAL';
        opp.station__c = 'WGBH';
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';
        
        insert opp;
        List<Opportunity> lstopp = new List<Opportunity>();
        
        Opportunity opp1 = New Opportunity();
        
        opp1.AccountID = a.Id;       
        opp1.Name = 'Test';
        opp1.gift_kind__c = 'One Payment';
        opp1.CloseDate = system.Today().AddDays(15);
        opp1.Gift_Date_Time__c = system.now();
        opp1.StageName = 'Pledged';
        opp1.CampaignID = c.Id;
        opp1.campaign_name__c = 'IN KIND';
        opp1.station__c = 'WGBH';
        RecordType rc1 = [select id from recordtype where developername = 'Annual'];
        opp1.recordtypeid = rc1.id;
        opp1.Gift_Type__c = 'New';
        
        insert opp1;
        
        insert lstopp;
        //List<Opportunity> lstopp = new List<Opportunity>();
        //lstopp.add(opp);
        
        List<Opportunity> lstopp1 = new List<Opportunity>();
        
        Opportunity opp2 = New Opportunity();        
        opp2.AccountID = a.Id;       
        opp2.Name = 'Test';
        opp2.gift_kind__c = 'One Payment';
        opp2.CloseDate = system.Today().AddDays(15);
        opp2.Gift_Date_Time__c = system.now();
        opp2.StageName = 'Pledged';
        opp2.CampaignID = c.Id;
        opp2.campaign_name__c = 'IN KIND';
        opp2.station__c = 'WGBH';
        RecordType rc2 = [select id from recordtype where developername = 'Annual'];
        opp2.recordtypeid = rc2.id;
        opp2.Gift_Type__c = 'New';
                
        lstopp1.add(opp2);        
        insert lstopp1;
        
        Giving_Summary__c givSum1 = new Giving_Summary__c();
        givSum1.Account__c = a.Id;
        givSum1.first_source__c = 'Source1';
        Insert givSum1;
        
        /*Select Account__c, name, Id, first_source__c,
        largest_recent_amt__c, largest_date__c, total_amt__c, total_pd__c, current_fis_yr_amt__c,
        current_fis_yr_pd__c ,Giving_Level__c, Member_Yr_Status__c, Shopper__c
        From Giving_Summary__c
        Where Account__c in:AccountIds and RecordTypeId in: summaryType*/
        
        
               
        GiftTypeRule.GTR(wgbh1,lstopp,gtrType.DONATIONPURCHASEGTR);
        GiftTypeRule.GTR(wgbh1,lstopp,gtrType.ANNUALGTR);
        GiftTypeRule.GTR(wgbh1,lstopp,gtrType.INKINDGTR);
        
        GiftTypeRule.gtrInkind(wgbh1,lstopp);
        
        GiftTypeRule.gtrInkind(wgbh2,lstopp1);
        
        GiftTypeRule.setSummary(lstopp);
        GiftTypeRule.MemberyearStatusInGivingSummary(opp);
        GiftTypeRule.getDeveloperNameByCampaignName('Test');
        GiftTypeRule.getGivingSummaryRecordType(opp);
        GiftTypeRule.IsGivingSummaryExists(opp);
        GiftTypeRule.shopperFlagChecked(opp);
        GiftTypeRule.givingLevelIncreasetoMajorDonor(opp);
        GiftTypeRule.gtrDonationPurchase(wgbh1,lstopp);
        
        GiftTypeRule.gtrAnnual(wgbh1,lstopp);
        
        List<Opportunity> lstopp3 = new List<Opportunity>();        
        Opportunity opp3 = New Opportunity();        
        opp3.AccountID = a.Id;       
        opp3.Name = 'Test';
        opp3.gift_kind__c = 'One Payment';
        opp3.CloseDate = system.Today().AddDays(15);
        opp3.Gift_Date_Time__c = system.now();
        opp3.StageName = 'Pledged';
        opp3.CampaignID = c.Id;
        opp3.campaign_name__c = 'ANNUAL';
        opp3.station__c = 'WGBH';
        RecordType rc3 = [select id from recordtype where developername = 'DONATION'];
        opp3.recordtypeid = rc3.id;
        opp3.Gift_Type__c = 'Donation';
                
        lstopp3.add(opp3);        
        insert lstopp3;
        
        //GiftTypeRule.gtrDonationPurchase(wgbh2,lstopp3);
        GiftTypeRule.getDeveloperNameByCampaignName('Restricted');
        GiftTypeRule.getDeveloperNameByCampaignName('In Kind');
        GiftTypeRule.getDeveloperNameByCampaignName('Auction');
        GiftTypeRule.getDeveloperNameByCampaignName('Annual');
        GiftTypeRule.getDeveloperNameByCampaignName('Matching');
        GiftTypeRule.getDeveloperNameByCampaignName('Capital');
        GiftTypeRule.getDeveloperNameByCampaignName('Planned Gift');
        GiftTypeRule.getDeveloperNameByCampaignName('Sales');
        GiftTypeRule.getDeveloperNameByCampaignName('Foundation');
        GiftTypeRule.getDeveloperNameByCampaignName('Events');
        
        GiftTypeRule.gtrAnnual(wgbh2,lstopp3);
      
     }
}