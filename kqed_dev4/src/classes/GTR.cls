public class GTR{
    Static String ADDGIFT = 'Add Gift';
    Static String UPGRADERESET = 'Upgrade Reset';
    Static String RENEWAL = 'Renewal';
    Static String REJOIN = 'Rejoin';
    Static String NEWTYPE = 'New';
    Static String DONATION = 'Donation';
    Static String PURCHASE = 'Purchase';
    static String strRecordType;
    static String PricebookId = null;
    
    public enum gtrType{ANNUALGTR, DONATIONPURCHASEGTR, INKINDGTR}
    static Campaign objCampaign;
    
    static List<Giving_Summary__c> lstGiving;
    static List<PricebookEntry> lstProduct;
    static List<Giving_Summary_Control__c> lstControl;
    
    public static string GTR(Opportunity opp){
        String giftType = '';
        System.debug('############GTR#############');
        System.debug('CAMPAIGN ID: ' + opp.CampaignId);
        try{
            objCampaign = [Select Campaign_Name__c, Override_Gift__c, Product_Program__c, Station__c, Solicitation_Type__c From Campaign Where Id =: opp.CampaignId];
            RecordType rs = [select name from RecordType where id =: opp.RecordTypeId ];
            if(rs!=null)
                strRecordType = rs.name;
            else
                strRecordType = ''; 
            System.debug('CAMPAIGN TYPE: ' + objCampaign.Campaign_Name__c);
            if(opp != null){
                if(opp.CampaignId != null && objCampaign != null){
                    //if(opp.Campaign.Campaign_Name__c != null && opp.Campaign.Campaign_Name__c.trim().length()>0){
                    if(objCampaign.Campaign_Name__c != null && objCampaign.Campaign_Name__c.trim().length()>0){
                        //if(opp.Campaign.Campaign_Name__c.trim().toUpperCase() == 'ANNUAL GIVING'){//Annual Giving
                        if(objCampaign.Campaign_Name__c.trim().toUpperCase() == 'ANNUAL'){//Annual Giving
                            System.debug('GTR FUNCTION: ANNUAL GTR');
                            giftType = AnnualGTR(opp);
                        }
                        //else if(opp.Campaign.Campaign_Name__c.trim().toUpperCase() == 'IN-KIND GIFTS'){//In-Kind Gifts
                        else if(objCampaign.Campaign_Name__c.trim().toUpperCase() == 'IN KIND'){//In-Kind Gifts
                            System.debug('GTR FUNCTION: INKIND GTR');
                            giftType = InkindGTR(opp);
                        }
                        else{
                            System.debug('GTR FUNCTION: PURCHASE GTR');
                            giftType = PurchaseGTR(opp);
                        }
                    }
                }
            }
        }catch(Exception ex){
            giftType = '';
        }
        system.debug('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^final GTR:  ' + giftType);
        return giftType;
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    Public static string AnnualGTR(Opportunity opp){
        System.debug('###########AnnualGTR called##################');
        String giftType = '';
        if(opp != null){
            if((opp.Product__c != null && opp.Product__c.trim().toUpperCase() == 'MEMBERSHIP') && objCampaign.Campaign_Name__c.trim().toUpperCase() == 'ANNUAL'){
                /*1*/
                if(objCampaign.Override_Gift__c != null && objCampaign.Override_Gift__c.trim().length()>0){
                    giftType = objCampaign.Override_Gift__c;
                }
                else if(checkAnnualClassification(opp) == true){/*2*/
                    giftType = ADDGIFT;
                }
                else if(IsGivingSummaryExists(opp) == false){/*3*/
                    giftType = NEWTYPE;
                }
                else if(checkDateforAnnual(opp) == false){/*4*/
                    if(MemberyearStatusInGivingSummary(opp) == true){/*5*/
                        giftType = REJOIN;
                    }
                    else{
                        giftType = RENEWAL;
                    }
                }
                else if(checkAnnualAmount(opp)==true){/*6*/
                    if(shopperFlagChecked(opp)==true){ /*7*/
                        giftType = ADDGIFT;
                    }
                    else{
                        if(isUpgradeReset(opp)==true){
                            giftType = UPGRADERESET;
                        }else{
                            giftType = ADDGIFT;
                        }
                    }
                }
                else if(opp.Gift_Kind__c != null &&
                                (opp.Gift_Kind__c.trim().toUpperCase() == 'INSTALLMENT' || 
                                 opp.Gift_Kind__c.trim().toUpperCase() == 'SUSTAINING GIFT')){/*8*/
                    Date expDate = getExpireDate(opp);
                    if(opp.Schedule_Start_Date__c > expDate){/*9*/
                        if(isUpgradeReset(opp)==true){
                            giftType = UPGRADERESET;
                        }else{
                            giftType = ADDGIFT;
                        }
                    }
                    else{
                        giftType = ADDGIFT;
                    }
                }
                else{ 
                    if(benefitIncludesMEM_Card(opp)==false){/*10*/
                        giftType = ADDGIFT;
                    }
                    else{
                        if(isUpgradeReset(opp)==true){
                            giftType = UPGRADERESET;
                        }else{
                            giftType = ADDGIFT;
                        }
                    }
                }
            }
            else{
                PurchaseGTR(opp);
            }
        }
        return giftType;
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    Static String getGivingLevel(){
        if(lstGiving != null && lstGiving.size()>0)
            if(lstGiving[0].Giving_Level__c != null)
                return lstGiving[0].Giving_Level__c;
            else
                return '';
        else
            return '';                
    }
    Public static string InkindGTR(Opportunity opp){
        String giftType = '';
        System.debug('###########inkind called##################');
        if(opp != null){
            if((opp.Product__c != null && (opp.Product__c.trim().toUpperCase() == 'MEMBERSHIP' || opp.Product__c.trim().toUpperCase() == 'AUCTION')) && objCampaign.Campaign_Name__c.trim().toUpperCase() == 'IN KIND'){
                /*1*/
                if(objCampaign.Override_Gift__c != null && objCampaign.Override_Gift__c.trim().length()>0)
                    giftType = objCampaign.Override_Gift__c;
                else if(IsGivingSummaryExists(opp)==false)/*2*/
                    giftType = NEWTYPE;
                else if(checkDateforAnnual(opp) == false)/*3*/
                    if(MemberyearStatusInGivingSummary(opp) == true)/*4*/
                        giftType = REJOIN;
                    else
                        giftType = RENEWAL;
                else if(givingLevelIncreasetoMajorDonor(opp) == true)
                        giftType = UPGRADERESET;
                /*GIVING LEVEL ON STATION INKIND GIVING SUMMARY CHANGE FROM COMPLIMENTARY to NOT COMPLIMENTARY? */
                else{ //getNextGivingLevel
                    system.debug('#######Complementary');
                    String NextGivingLevel = getNextGivingLevel(opp);
                    if(NextGivingLevel == null) NextGivingLevel = '';
                    if(getGivingLevel() == 'Complimentary' && NextGivingLevel != 'Complimentary')
                        giftType = UPGRADERESET;
                    else
                        giftType = ADDGIFT;
                }
            }
            else{
                giftType = PurchaseGTR(opp);
            }
        }
        return giftType;
    }
    //////////////////////////////////////////////////////////////////////////////////////////
    Public static string PurchaseGTR(Opportunity opp){
        System.debug('###########PurchaseGTR called##################');
        String giftType = '';
        try{
            if(opp != null){
                if((opp.Product__c != null && opp.Product__c.trim().toUpperCase() == 'MEMBERSHIP') && objCampaign.Campaign_Name__c.trim().toUpperCase() == 'ANNUAL'){
                    giftType = annualGTR(opp);
                }
                else if((opp.Product__c != null && (opp.Product__c.trim().toUpperCase() == 'MEMBERSHIP' || opp.Product__c.trim().toUpperCase() == 'AUCTION')) && objCampaign.Campaign_Name__c.trim().toUpperCase() == 'IN KIND'){
                    giftType = inkindGTR(opp);
                }
                else{
                    if((opp.Product__c != null && opp.Product__c.trim().toUpperCase() == 'AUCTION') && objCampaign.Campaign_Name__c.trim().toUpperCase() == 'AUCTION'){
                        if(IsGivingSummaryExists(opp)==false)
                            giftType = NEWTYPE;
                        else if(checkDateforAnnual(opp) == true)
                            giftType = ADDGIFT;
                        else 
                            if(MemberyearStatusInGivingSummary(opp) == false)
                                giftType = RENEWAL;
                            else
                                giftType = REJOIN;                                                     
                    }
                    else{
                        if(objCampaign.Override_Gift__c != null && objCampaign.Override_Gift__c.trim().toUpperCase()=='DONATION')
                            giftType = DONATION;
                        else if(objCampaign.Override_Gift__c != null && objCampaign.Override_Gift__c.trim().toUpperCase()=='PURCHASE')
                            giftType = PURCHASE;
                        else if(objCampaign.Campaign_Name__c != null && 
                            (objCampaign.Campaign_Name__c.trim().toUpperCase() == 'EVENT' ||
                             objCampaign.Campaign_Name__c.trim().toUpperCase() == 'SALES'))
                            giftType = PURCHASE;
                        else if(objCampaign.Campaign_Name__c != null && 
                            objCampaign.Campaign_Name__c.trim().toUpperCase() == 'MATCHING')
                             giftType = DONATION;
                        else if(objCampaign.Product_Program__c != null && 
                            objCampaign.Product_Program__c.trim().toUpperCase() == 'MAJOR GIFT')
                             giftType = DONATION;
                        else
                             giftType = null;
                    }
                }
            }
        }catch(Exception ex){
            giftType = '';
        }
        return giftType;
    }  
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////// 
    static boolean isUpgradeReset(Opportunity opp){
        boolean flag = false;       
        //• A donor's gift with installment payment schedule dates continue after their expiration date
        if((checkMajorDonorLevel(opp) == true && AnnualSummaryShopperFlag(opp) ==false) 
        || checkPreviousGiving(opp) == false){
            flag = true;
        }
        else{
            flag = false;
        }
        //Station's Annual giving summary shopper flag = false
        return flag;
    }
    public static boolean AnnualSummaryShopperFlag(Opportunity opp){
        boolean flag = false;
        if(lstGiving != null && lstGiving.size()>0){
            if(commonApex.getDeveloperNameById(lstGiving[0].recordTypeId)=='Annual_Giving'){
                flag = shopperFlagChecked(opp);
            }
        }
        return flag;
    }
    public static boolean shopperFlagChecked(Opportunity opp){
        boolean result = false;
        
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Shopper__c != null && lstGiving[0].Shopper__c == true)
                result = true;
            else
                result = false;
        }
        
        return result;
    }
    public static boolean checkPreviousGiving(Opportunity opp){
        boolean flag = false;
        Set<ID> setPrevIds = new Set<ID>();
        List<Opportunity> lstPrev = new List<Opportunity>();
        Set<String> setGiftType = new Set<String>();
        setGiftType.add(NEWTYPE);
        setGiftType.add(RENEWAL);
        setGiftType.add(REJOIN);
        //Boolean blnMajorDonorLevel = checkMajorDonorLevel(opp);
        lstPrev = [Select Id From Opportunity where AccountId =: opp.AccountId and Gift_Type__c In: setGiftType];
        if(lstPrev != null && lstPrev.size()>0){
            for(Opportunity prev:lstPrev){
                setPrevIds.add(prev.Id);
                system.debug('########## Previous Giving ' + prev.Id);
            }
            if(setPrevIds != null && setPrevIds.size()>0){
                List<OpportunityLineItem> lstItem = new List<OpportunityLineItem>();
                lstItem = [Select PricebookEntry.ProductCode From OpportunityLineItem Where OpportunityId in:setPrevIds and IsBenefit__c = true];
                if(lstItem != null && lstItem.size()>0){
                    system.debug('########## Previous benefits ' + lstItem);
                    boolean membership = false;
                    boolean card = false;
                    boolean guid = false;
                    for(OpportunityLineItem item:lstItem){
                        system.debug('########## Product Code : ' + item.PricebookEntry.ProductCode.toUpperCase());
                        if(item.PricebookEntry.ProductCode.toUpperCase().contains('MEM')){
                            membership = true;
                        }
                        if(item.PricebookEntry.ProductCode.toUpperCase().contains('CARD')){
                            card = true;
                        }
                        if(item.PricebookEntry.ProductCode.toUpperCase().contains('GUID')){
                            guid = true;
                        }
                    }
                    if(membership==true && card==true && guid==true)flag=true;
                    /*
                    if(blnMajorDonorLevel == true && flag == true){
                        flag = true;
                    }
                    if(blnMajorDonorLevel == true && flag == false){
                        flag = false;
                    }
                    if(blnMajorDonorLevel == false){
                        flag = true;
                    }
                    */
                }
            }
        }
        system.debug('######### checkPreviousGiving --> ' + flag);
        return flag;
    }
    public static boolean checkMajorDonorLevel(Opportunity opp){
        boolean flag = false;
        Decimal GivingAmount = opp.Giving_Amount__c;
        if(lstGiving != null && lstGiving.size() > 0){
            Decimal TotalMemberYrAmount = lstGiving[0].Total_Member_Yr_Amount__c;
            System.debug('############Giving Amount on pledge : ' + GivingAmount);
            System.debug('############TotalMemberYrAmount on Giving Summary : ' + TotalMemberYrAmount);
            if(GivingAmount ==null) GivingAmount =0;
            if(TotalMemberYrAmount ==null) TotalMemberYrAmount =0;
            Decimal TotalAmount = GivingAmount + TotalMemberYrAmount;
            LoadGivingSummaryControl();
            system.debug('######Total Amount : ' + TotalAmount);
            
            if(lstGivingControl != null && lstGivingControl.size()>0){
                for(Giving_Summary_Control__c gsc: lstGivingControl){

                    if(TotalAmount >= gsc.Minimum_Total_Mem_Year_Amount__c &&
                        gsc.Station_Major_Donor_Level__c == true){
                        
                            system.debug('###### Control ID : ' + gsc.Id);
                            system.debug('###### Minimum Total Member Year Amount : ' + gsc.Minimum_Total_Mem_Year_Amount__c);
                            system.debug('###### Station Major Donor Leve; : ' + gsc.Station_Major_Donor_Level__c);                        
                        
                        
                            flag = true;
                            break;
                    }
                }
            }
        }
        system.debug('####checkAnnualAmount : ' + flag);
        return flag;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    static string getGivingSummaryRecordType(Opportunity o){
        String recordTypeId=null;
        List<RecordType> lstRecordTypes = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Giving_Summary__c'];
        Map<String,RecordType> MapRecordTypes = new Map<String,RecordType>();
        for(RecordType r: lstRecordTypes) {
            MapRecordTypes.put(r.DeveloperName,r);
        }
        
        List<Giving_Summary__c> lstInsert = new List<Giving_Summary__c>();
        List<Giving_Summary__c> lstUpdate = new List<Giving_Summary__c>();
        Set<ID> CampaignId = new Set<ID>();
        String developerName = '';
            developerName = commonApex.getDeveloperNameByCampaignName(o.Campaign_Name__c);
            if(MaprecordTypes.containsKey(developerName)){
                RecordType r = MaprecordTypes.get(developerName);
                recordTypeId = r.Id;
            }
         return recordTypeId;
    }
    static void loadGivingSummary(Opportunity opp){
        String givingSummaryRecordType = getGivingSummaryRecordType(opp);
        lstGiving = [Select Account__c, expiration_date__c, current_mem_yr_renew_amt__c, current_mem_yr_add_amt__c,  name, Id, first_source__c, 
        largest_recent_amt__c, Total_Member_Yr_Amount__c,largest_date__c, total_amt__c, total_pd__c, current_fis_yr_amt__c,
        Product__c, Station__c, current_fis_yr_pd__c ,Giving_Level__c, Member_Yr_Status__c, Shopper__c
        From Giving_Summary__c 
        Where History__c = false and Account__c =:opp.AccountId and RecordTypeId =: givingSummaryRecordType and Station__c =: opp.Station__c];
        
    }
    static boolean IsGivingSummaryExists(Opportunity opp){
        boolean flag = false;
        String givingSummaryRecordType = getGivingSummaryRecordType(opp);
        lstGiving = [Select Account__c, expiration_date__c, name, Id, first_source__c, current_mem_yr_renew_amt__c, current_mem_yr_add_amt__c, 
        largest_recent_amt__c, largest_date__c, total_amt__c, total_pd__c, current_fis_yr_amt__c,
        Product__c, Station__c, current_fis_yr_pd__c, History__c, Summary_Count__c, History_Date_Time__c ,Giving_Level__c, Member_Yr_Status__c, Shopper__c, Total_Member_Yr_Amount__c
        From Giving_Summary__c 
        Where History__c = false and Account__c =:opp.AccountId and RecordTypeId =: givingSummaryRecordType and Station__c =: opp.Station__c];
        
        if(lstGiving != null && lstGiving.size()>0){
            flag = true;
            loadGivingSummaryControlForStation(opp);
        }
        else{
            flag = false;
        }
        system.debug('####### Giving Summary Exists? ' + flag);
        return flag;
    }
    public static date getExpireDate(Opportunity opp){
        date expDate;
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].expiration_date__c != null)
                expDate = lstGiving[0].expiration_date__c;
            else
                expDate = null;
        }
        return expDate;
    }
    public static boolean givingLevelIncreasetoMajorDonor(Opportunity opp){
        boolean result = false;
        
        if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Giving_Level__c != null && lstGiving[0].Giving_Level__c.trim().toUpperCase() == 'MAJOR DONOR')
                result = true;
            else
                result = false;
        }
        
        return result;
    }
    Public static boolean MemberyearStatusInGivingSummary(Opportunity opp){
        boolean result = false;
        /*if(lstGiving != null && lstGiving.size()>0){
            if(lstGiving[0].Member_Yr_Status__c != null && 
            lstGiving[0].Member_Yr_Status__c.trim().toUpperCase() == 'LAPSED')
                result = true;
            else
                result = false;
        }*/
        if(lstGiving != null && lstGiving.size()>0){
            for(Giving_Summary__c g:lstGiving){
                if(g.Member_Yr_Status__c != null && g.History__c == false &&
                g.Member_Yr_Status__c.trim().toUpperCase() == 'LAPSED')
                    result = true;
                else
                    result = false;
            }            
        }
        System.debug('######Shopper flag LAPSED: ' + result);
        return result;
    }   
    static String getPricebookId(Opportunity objPledges){
        List<Pricebook2> lstPricebook;
        if(PricebookId == null){
            if(objPledges.Station__c!=null){
                lstPricebook = [Select Id from Pricebook2 Where name like:objPledges.Station__c];
                if(lstPricebook.size()>0){
                    //objPledges.Pricebook2Id = lstPricebook[0].Id;
                    pricebookId = lstPricebook[0].Id;
                }
            }
        }
        return pricebookId;
    }
    
    public static boolean benefitIncludesMEM_Card(Opportunity opp){
        boolean flag = false;
        boolean mem=false, card=false, guide=false;
        getBenefits(opp);
        if(lstProduct != null && lstProduct.size()>0){
            for(PricebookEntry benefit:lstProduct){
                if(benefit.Product2.Premium_Category__c != null &&
                benefit.Product2.Premium_Category__c.trim().length()>0){
                    string Category = benefit.Product2.Premium_Category__c.trim().toUpperCase();
                    if(Category.contains('MEM'))
                        mem=true;
                    if(Category.contains('CARD'))
                        card=true;
                }
            }
        }
        if(mem==true && card==true && guide==true)
            flag = true;
        else
            flag = false;
        return flag;
    }
    public static boolean benefitIncludesMEM_Card_Guid(Opportunity opp){
        boolean flag = false;
        boolean mem=false, card=false, guide=false;
        getBenefits(opp);
        if(lstProduct != null && lstProduct.size()>0){
            for(PricebookEntry benefit:lstProduct){
                if(benefit.Product2.Premium_Category__c != null &&
                benefit.Product2.Premium_Category__c.trim().length()>0){
                    string Category = benefit.Product2.Premium_Category__c.trim().toUpperCase();
                    if(Category.contains('MEM'))
                        mem=true;
                    if(Category.contains('CARD'))
                        card=true;
                    if(Category.contains('GUIDE'))
                        guide=true;
                }
            }
        }
        if(mem==true && card==true && guide==true)
            flag = true;
        else
            flag = false;
        return flag;
    }
    
    Public static void getBenefits(Opportunity objPledges){
        if(lstProduct != null && lstProduct.size()>0) return;
        try{
            List<Member_Benefits_Control__c>lstMem  = [select id, Membership_Benefit_Package__c , Gift_Type__c, Maximum__c, Minimum_Parent_Pledge_Amt__c
            from Member_Benefits_Control__c
            Where Station__c =: objPledges.Station__c
            and Product__c =: objPledges.Product__c];
            Set<ID> memIds = new Set<ID>();
            for(Member_Benefits_Control__c mbc:lstMem){
                if(mbc.Gift_Type__c!=null) {
                    if(mbc.Gift_Type__c.contains(objPledges.Gift_Type__c)) {
                        if(objPledges.Giving_Amount__c <= mbc.Maximum__c && objPledges.Giving_Amount__c >= mbc.Minimum_Parent_Pledge_Amt__c){
                            memIds.add(mbc.Membership_Benefit_Package__c);
                            system.debug('#### Member Benefit Control ID: ' + mbc.Id);
                            system.debug('#### Membership Benefit Package: ' + mbc.Membership_Benefit_Package__c);
                        }
                    }
                }
            }
            lstProduct = new List<PricebookEntry>();
            List<Package_Item__c> lstPackageItem = [Select Id,Item__r.ProductCode, Item__r.name, Item__r.Description from Package_Item__c Where Package__c IN:memIds];
            Set<ID> ProductIds = new Set<ID>();
            if(lstPackageItem.size()>0){
                for(Package_Item__c p:lstPackageItem){
                    ProductIds.add(p.Item__c);
                }
                if(ProductIds.size()>0){
                    lstProduct = [Select UnitPrice, ProductCode, Product2Id, 
                    Pricebook2Id, Name, Id, Product2.Description, Product2.Premium_Category__c
                    From PricebookEntry 
                    Where IsActive = true 
                    and Pricebook2Id =: getPricebookId(objPledges)
                    and Product2Id in: ProductIds];
                }
            }
        }catch(Exception ex){
        }
    }    
    
    //////////////////////////////////////////////////////////////////////////////////////////
    ///Classification
    Static Boolean checkAnnualClassification(Opportunity opp){
        Boolean flag = false;
        //STATION = STATION ON CPRT
        //Classification Type = ONGOING MEMBERSHIP (Record Type : ongoing_membership)
                    //Classification_Type__c = 'Ongoing Membership'
        //Preference = SUSTAINER TYPE
        RecordType rc = [Select id from RecordType Where DeveloperName = 'ongoing_membership'];
        List<Classification__c> lstClassification;
        if( rc != null ){
            lstClassification = 
            [Select Id From Classification__c Where
            Station__c =: objCampaign.Station__c And RecordTypeId =: rc.Id And
            Preference__c = 'Sustainer Type' And Account__c =: opp.AccountId Limit 1];
            
            if(lstClassification != null && lstClassification.size() > 0){
                system.debug('########## total classification records : ' + lstClassification.size());
                flag = true;
            }
        }
        system.debug('############# checkAnnualClassification : ' + flag);
        return flag;
    }
    
    static void LoadGivingSummaryControl(){
        if(lstControl != null && lstControl.size()>0) return;
        
        if(lstGiving != null && lstGiving.size() > 0){
            if(lstGiving[0].Giving_Level__c != null){
                lstControl = [Select id, 
                Station_Major_Donor_Level__c, 
                Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
                Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
                Renewal_Window_Start__c, Shopper_Threshold__c,
                Station__c, Product__c, Campaign_Type__c
                From Giving_Summary_Control__c
                Where Station__c =: objCampaign.Station__c And
                Product__c =: objCampaign.Product_Program__c And
                Campaign_Type__c =: objCampaign.Campaign_Name__c And
                Giving_Level__c =: lstGiving[0].Giving_Level__c];
            }
        }
        if(objCampaign!=null && lstControl!=null) {
            system.debug('####Giving level control for station ' + objCampaign.Station__c + ' found : ' + lstControl.size());
        }
    }
    public static boolean checkDateforAnnual(Opportunity opp){
        boolean flag = false;
        if(lstGiving != null && lstGiving.size() > 0){
            Date expDate = getExpireDate(opp);
            integer month = opp.Gift_Date_Time__c.Date().monthsBetween(expDate);
            if(lstGiving[0].Giving_Level__c != null){
                LoadGivingSummaryControl();
                system.debug('###### Control ID : ' + lstControl[0].Id);
                system.debug('######month : ' + month);
                system.debug('######lstControl[0].Renewal_Window_Start__c : ' + lstControl[0].Renewal_Window_Start__c);
                if(lstControl != null && lstControl.size() > 0){
                    if(month >= lstControl[0].Renewal_Window_Start__c){
                        flag = true;
                    }
                }
            }
        }
        system.debug('#####checkDateforAnnual : ' + flag);
        return flag;
    }
    static List<Giving_Summary_Control__c> lstGivingControl;
    public static void loadGivingSummaryControlForStation(Opportunity opp){
        if(lstGiving != null && lstGiving.size() > 0){
            lstGivingControl = new List<Giving_Summary_Control__c>();
            lstGivingControl = [Select id, 
            Station_Major_Donor_Level__c, 
            Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
            Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
            Renewal_Window_Start__c, Shopper_Threshold__c,
            Station__c, Product__c, Campaign_Type__c
            From Giving_Summary_Control__c
            Where Station__c =: objCampaign.Station__c And
            Product__c =: objCampaign.Product_Program__c And
            Campaign_Type__c =: objCampaign.Campaign_Name__c ];
        }
    }
    public static boolean checkAnnualAmount(Opportunity opp){
        boolean flag = false;
        Decimal GivingAmount = opp.Giving_Amount__c;
        if(lstGiving != null && lstGiving.size() > 0){
            Decimal TotalMemberYrAmount = lstGiving[0].Total_Member_Yr_Amount__c;
            System.debug('############Giving Amount on pledge : ' + GivingAmount);
            System.debug('############TotalMemberYrAmount on Giving Summary : ' + TotalMemberYrAmount);
            
            if(GivingAmount==null) GivingAmount = 0;
            if(TotalMemberYrAmount==null) TotalMemberYrAmount=0;
            
            Decimal TotalAmount = GivingAmount + TotalMemberYrAmount;
            LoadGivingSummaryControl();
            system.debug('######Total Amount : ' + TotalAmount);
            
            if(lstGivingControl != null && lstGivingControl.size()>0){
                for(Giving_Summary_Control__c gsc: lstGivingControl){

                    if(TotalAmount >= gsc.Minimum_Total_Mem_Year_Amount__c &&
                        gsc.Station_Major_Donor_Level__c == true){
                        
                            system.debug('###### Control ID : ' + gsc.Id);
                            system.debug('###### Minimum Total Member Year Amount : ' + gsc.Minimum_Total_Mem_Year_Amount__c);
                            system.debug('###### Station Major Donor Leve; : ' + gsc.Station_Major_Donor_Level__c);                        
                        
                        
                            flag = true;
                            break;
                    }
                }
            }
            /*
            if(lstControl != null && lstControl.size() > 0){
                system.debug('###### Control ID : ' + lstControl[0].Id);
                system.debug('###### Minimum Total Member Year Amount : ' + lstControl[0].Minimum_Total_Mem_Year_Amount__c);
                system.debug('###### Station Major Donor Leve; : ' + lstControl[0].Station_Major_Donor_Level__c);
                if(TotalAmount >= lstControl[0].Minimum_Total_Mem_Year_Amount__c &&
                    lstControl[0].Station_Major_Donor_Level__c == true)
                        flag = true;
            }*/
        }
        system.debug('####checkAnnualAmount : ' + flag);
        return flag;
    }
    
    Static String getNextGivingLevel(Opportunity opp){
        String sStation = opp.Station__c;
        String sProduct = opp.Product__c;
        String sCampaignName = opp.Campaign_Name__c;

        List<Giving_Summary_Control__c> lstSummaryControl = [Select Giving_Level__c, Giving_Summary__c, Lapsed_Window_Start__c,
        Maximum_Total_Mem_Year_Amount__c, Minimum_Total_Mem_Year_Amount__c,
        Renewal_Window_Start__c, Shopper_Threshold__c,
        Station__c, Product__c, Campaign_Type__c
        From Giving_Summary_Control__c 
        Where Station__c =: sStation and 
        Product__c =: sProduct and 
        Campaign_Type__c =: sCampaignName];
        
        String GivingLevel = '';
        Decimal CurrentMemberRenewAmount = 0.0;
        Decimal CurrentMemberAddAmount = 0.0;
        String CampaignName = '';
        Giving_Summary__c giving = new Giving_Summary__c();
        giving = lstGiving[0];
        if(lstSummaryControl != null && lstSummaryControl.size()>0){
            for(Giving_Summary_Control__c control:lstSummaryControl){
                Decimal TotalMemberYrAmount = 0.0;
                if(giving.current_mem_yr_renew_amt__c != null)
                    CurrentMemberRenewAmount = giving.current_mem_yr_renew_amt__c;
                else
                    CurrentMemberRenewAmount = 0.0;
                CurrentMemberRenewAmount += opp.Giving_Amount__c;    
                if(giving.current_mem_yr_add_amt__c != null)
                    CurrentMemberAddAmount = giving.current_mem_yr_add_amt__c;
                else
                    CurrentMemberAddAmount = 0.0;
                TotalMemberYrAmount = CurrentMemberRenewAmount + CurrentMemberAddAmount;
                if(giving.Station__c == control.Station__c &&
                giving.Product__c == control.Product__c &&
                sCampaignName == control.Campaign_Type__c){
                    if(TotalMemberYrAmount >= control.Minimum_Total_Mem_Year_Amount__c &&
                    TotalMemberYrAmount <= control.Maximum_Total_Mem_Year_Amount__c){
                        GivingLevel = control.Giving_Level__c;
                    }
                }
                system.debug('$$$$$$$$$$$$$$$$ Giving Level :----> ' + control.Giving_Level__c);
            }
        }
        return GivingLevel;
    }
    
    /////TEST METHODS///////////
    
    static testMethod void MyTest() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Campaign c = new Campaign(Name = 'Test',Campaign_Name__c = 'ANNUAL');
        Insert c;
        
        Campaign c1 = new Campaign(Name = 'Test1',Campaign_Name__c = 'IN KIND');
        Insert c1;
        
        Pricebook2 pb = new Pricebook2(Name = 'Standard Price Book 2009', Description = 'Price Book 2009 Products', IsActive = true);
        insert pb;
        
        Product2 prod = new Product2(Name = 'Anti-infectives 2007', productcode = 'test pd code1one',Family = 'Best Practices',  IsActive = true);
        insert prod;
        
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true limit 1];

        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pbook.Id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true, UseStandardPrice = false);
        insert pbe;
        
        Member_Benefits_Control__c MemBeC = new Member_Benefits_Control__c();
        MemBeC.Membership_Benefit_Package__c = prod.Id;
        MemBeC.Gift_Type__c= 'New';
        MemBeC.Maximum__c = 26;
        MemBeC.Minimum_Parent_Pledge_Amt__c = 21;
        MemBeC.Station__c = 'WGBH';
        //MemBeC.Product__c = 'Auction';
        insert MemBeC;
               
        Giving_Summary__c g = new Giving_Summary__c();
        g.Account__c = a.Id;
        g.Giving_Level__c = 'Complimentary';
        
        insert g;
        
        RecordType rs = [select ID from RecordType where DeveloperName = 'DONATION' ];
        
        
        
        
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
        opp.Giving_Amount__c = 26;
        RecordType rc = [select id from recordtype where developername = 'Annual'];
        opp.recordtypeid = rc.id;
        opp.Gift_Type__c = 'New';
        //opp.Product__c = 'MEMBERSHIP';
        opp.Gift_Date_Time__c = system.now();
        ///opp.expiration_date__c = system.today();
        insert opp;
        
        GTR.GTR(opp);
        GTR.AnnualGTR(opp);
        
        OpportunityLineItem olit = new OpportunityLineItem();
        olit.OpportunityId = opp.id;
        olit.Quantity = 4;
        olit.TotalPrice = 10000;
        olit.PricebookEntryId = pbe.Id;
        olit.IsBenefit__c = true;
        insert olit;
        
        Giving_Summary_Control__c givsuco = new Giving_Summary_Control__c();
        givsuco.Station_Major_Donor_Level__c = true;
        givsuco.Giving_Level__c = 'Bronze';
        givsuco.Giving_Summary__c = 'Annual Giving';
        givsuco.Lapsed_Window_Start__c = 1;
        givsuco.Maximum_Total_Mem_Year_Amount__c = 2;
        givsuco.Minimum_Total_Mem_Year_Amount__c = 3;
        givsuco.Renewal_Window_Start__c = 4;  
        givsuco.Shopper_Threshold__c = 5;
        givsuco.Station__c = 'WGBH';
        givsuco.Campaign_Type__c = 'Annual';
        insert givsuco;
        
        ///LRT07292011        
        Opportunity opp1 = New Opportunity();
        opp1.AccountID = a.Id;
        opp1.Name = 'Test2';
        opp1.gift_kind__c = 'INSTALLMENT';
        opp1.CloseDate = system.Today().AddDays(15);
        opp1.Gift_Date_Time__c = system.now();
        opp1.StageName = 'Pledged';
        opp1.CampaignID = c1.Id;
        opp.Giving_Amount__c = 26;
        opp1.campaign_name__c = 'IN KIND';
        opp1.station__c = 'WGBH';
        RecordType rc1 = [select id from recordtype where developername = 'Annual'];
        opp1.recordtypeid = rc1.id;
        opp1.Gift_Type__c = 'New';
        opp1.Gift_Date_Time__c = system.now();
        //opp.expiration_date__c = system.today();
        insert opp1;
        GTR.GTR(opp1);
        GTR.AnnualGTR(opp1);
        
        GTR.objCampaign.Campaign_Name__c = 'IN KIND';
        //update c;
        
        GTR.InkindGTR(opp);
        
        GTR.PurchaseGTR(opp);
        
        GTR.getGivingSummaryRecordType(opp);
        GTR.IsGivingSummaryExists(opp);
        GTR.givingLevelIncreasetoMajorDonor(opp);
        GTR.MemberyearStatusInGivingSummary(opp);
        GTR.shopperFlagChecked(opp);
        GTR.getGivingLevel();

        GTR.loadGivingSummary(opp);
        GTR.getExpireDate(opp);
        GTR.getPricebookId(opp);
        GTR.benefitIncludesMEM_Card(opp);
        GTR.benefitIncludesMEM_Card_Guid(opp);
        GTR.getBenefits(opp);
        GTR.checkAnnualClassification(opp);
        GTR.LoadGivingSummaryControl();
        GTR.checkAnnualAmount(opp);
        GTR.getNextGivingLevel(opp);
        GTR.loadGivingSummary(opp);
        GTR.checkPreviousGiving(opp);        
        try {
            GTR.checkDateforAnnual(opp);
        }
        Catch(Exception ex) {}
        
        GTR.checkMajorDonorLevel(opp);
        
    }
}