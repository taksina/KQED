global Class PledgesNewStep{
    Public Integer NoOfInstallments{get;set;}
    Public Integer FrequencyNumber{get;set;}
    Public Integer PledgeAmount{get;set;}
    Public Opportunity objPledges{get;set;}
    Public String strRecordType{get;set;}
    Public String strCPRT{get;set;}
    Public List<Opportunity> lstChild{get;set;}    
    Public List<Opportunity> lstDeleteChild;
    Public List<CC_Alias__c> lstChargeCard{get;set;}
    Public Contact objContact{get;set;}
    Public Opportunity objSageGiving{get;set;}
    Public Account objHousehold{get;set;}
    Public boolean fromAccount{get;set;}
    Public String selectedContact{get;set;}
    Public List<Stock> lstStock{get;set;}
    Map<ID,Ticker_Symbol__c> mapTicker;
    /******************************************************************************************/
    Static String ADDGIFT = 'ADD GIFT';
    Static String UPGRADERESET = 'UPGRADE RESET';
    Static String RENEWAL = 'RENEWAL';
    Static String REJOIN = 'REJOIN';
    Static String NEWTYPE = 'NEW';
    Static String DONATION = 'DONATION';
    Static String PURCHASE = 'PURCHASE';    
    /******************************************************************************************/    
    Public Decimal FirstInstallmentAmount{get;set;}
    
    Public String getRecordType(){
        if(mode=='new')
            Return ApexPages.CurrentPage().getParameters().get('RecordType'); 
        else
            Return objPledges.RecordTypeId;
    }
    
    String getId(){
        Return ApexPages.CurrentPage().getParameters().get('id');
    }
        
    
    void setMode(){
        if(mode == null){
            if(ApexPages.CurrentPage().getParameters().get('New') == '1')
                mode = 'new';
            else if(ApexPages.CurrentPage().getParameters().get('clone') == '1')
                mode = 'clone';
            else if(ApexPages.CurrentPage().getParameters().get('edit') == '1')
                mode = 'edit';
        }
    }
    Public String mode{get;set;}
    ///////////////Stock///////////////////
    public string selectedAction{get;set;}
    void initializeStock(){
        try{
            lstStock = new List<Stock>();
            if(mode=='new'){
                lstStock.add(new Stock(New Stock__c(),''));
                lstStock.add(new Stock(New Stock__c(),''));
                lstStock.add(new Stock(New Stock__c(),''));
                
                mapTicker = new Map<ID,Ticker_Symbol__c>([Select ID,Company_Name__c from Ticker_Symbol__c]);
            }
            else{
                List<Stock__c> lstGivingStock = new List<Stock__c>();
                lstGivingStock = [Select Id, Average__c, High__c, Low__c, Number_of_Shares__c, Ticker_Symbol__c, Ticker_Symbol__r.Company_Name__c From Stock__c Where Giving__c =: objPledges.Id];
                
                if(lstGivingStock != null && lstGivingStock.size()>0){
                    for(Stock__c st:lstGivingStock){
                        Stock temp = new Stock();
                        temp.objStock = st;
                        temp.CompanyName = st.Ticker_Symbol__r.Company_Name__c;
                        temp.average = st.Average__c;
                        lstStock.add(temp);
                    }
                }
                while(lstStock.size()<3){
                    lstStock.add(new Stock(New Stock__c(),''));
                }            
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
    }
    Public PageReference AddNewStockLine(){
        lstStock.add(new Stock(New Stock__c(),''));
        return null;
    }

    Public PageReference selecTickerSymbol(){
        for(Stock s: lstStock) {
            if(s.objStock.Ticker_Symbol__c!=null) {
                if(mapTicker.containsKey(s.objStock.Ticker_Symbol__c)) {
                    s.CompanyName = mapTicker.get(s.objStock.Ticker_Symbol__c).Company_Name__c;
                }
            }
        }
        return null;
    }
    
    void saveStock(){
        //List<Stock__c> lstSaveStock = new List<Stock__c>();
        List<Stock__c> lstInsert = new List<Stock__c>();
        List<Stock__c> lstUpdate = new List<Stock__c>();
        try{
            if(lstStock != null && lstStock.size()>0){
                for(Stock s:lstStock){
                    if(s.objStock.Ticker_Symbol__c != null){
                        if(s.objStock.Id != null){
                            lstUpdate.add(s.objStock);
                        }else{
                            s.objStock.Giving__c = objPledges.Id;
                            lstInsert.add(s.objStock);
                        }
                    }
                }
                if(lstInsert != null && lstInsert.size()>0)
                    insert lstInsert;
                if(lstUpdate != null && lstUpdate.size()>0)
                    update lstInsert;
            }
            /*if(lstStock != null && lstStock.size()>0){
                for(Stock s:lstStock){
                    if(s.objStock.Ticker_Symbol__c != null){
                        s.objStock.Giving__c = objPledges.Id;
                        lstSaveStock.add(s.objStock);
                    }
                }
                if(lstSaveStock != null && lstSaveStock.size()>0){
                    insert lstSaveStock;
                }
            }*/
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
    }
    
    public Class Stock {
        public Stock__c objStock{get;set;}
        public string CompanyName{get;set;}
        public double average{get;set;}
        public Stock(){}
        public Stock (Stock__c s,String c){
            objStock = s;
            CompanyName = c;
        }
    }    
    ///////////////Stock///////////////////
    Public String retURL(){
        Return ApexPages.CurrentPage().getParameters().get('retURL');
    }
    String returnURL = '';
    Public PageReference Cancel(){
        try{
            Return RedirectPage(returnURL);
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }
    }
    String strObj = '';
    boolean fromContact = false;
    boolean fromCampaign = false;
    boolean fromPlannedGiving = false;
    void defaultSettings(){
        if(retURL()!= null && retURL().trim().length()>0){
            returnURL = retURL();
            strObj = retURL().trim().replace('/','').substring(0,3);
            if(strObj != null && strObj.trim().length()>0){
                if(strObj.trim() == '001'){//Account
                    try{
                    objPledges.AccountId = retURL().trim().replace('/','').substring(0,15);
                    returnURL = '/' + objPledges.AccountId;
                    }catch(Exception ex){
                        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,retURL().trim().replace('/','').substring(0,15))); 
                    }
                    fromAccount = true;
                    fromContact=false;
                    fromCampaign = false;
                    fromPlannedGiving = false;
                }
                if(strObj.trim() == '003'){
                    objPledges.Oppty_Related_Contact__c = retURL().trim().replace('/','').substring(0,15);
                    returnURL = '/' + objPledges.Oppty_Related_Contact__c;
                    Contact objCon = [Select AccountId from Contact Where Id=:objPledges.Oppty_Related_Contact__c];
                    if(objCon != null){
                        objPledges.AccountId = objCon.AccountId;
                    }
                    fromContact = true;
                    fromAccount = false;
                    fromCampaign = false;
                    fromPlannedGiving = false;
                }
                if(strObj.trim() == '701'){
                    objPledges.CampaignId = retURL().trim().replace('/','').substring(0,15);
                    returnURL = '/' + objPledges.CampaignId;
                    fromCampaign = true;
                    fromContact = false;
                    fromAccount = false;
                    fromPlannedGiving = false;
                    SelectCampaign();                    
                }
                if(strObj.trim() == 'a0B'){
                    objPledges.bequest__c = retURL().trim().replace('/','').substring(0,15);
                    returnURL = '/' + objPledges.bequest__c;
                    fromPlannedGiving = true;
                    fromCampaign = false;
                    fromContact = false;
                    fromAccount = false;  
                    LoadPlannedGiving();                  
                }
            }
        }    
    }
    Bequest__c objPlanGiving = new Bequest__c();
    Public void LoadPlannedGiving(){
        if(objPledges.bequest__c==null) return;
        try{
            objPlanGiving = [Select Id, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, 
            LastActivityDate, TaBequests_Id__c, activity_type__c, actual_remainder_date__c, actual_remainder_value__c, annual_payment__c, 
            anonymous_code__c, bank_name__c, bequest_confirmed_date__c, bequest_confirmed_flag__c, bequest_intended_amount__c, 
            bequest_intended_date__c, bequest_seq__c, Status__c, bequest_sts_value__c, Bequest_Terms__c, capital_gain_income__c, 
            comments__c, date_estate_closed__c, date_final_acct_rcvd__c, date_will_executed__c, deferred_to_date__c, 
            Planned_Giving_Opportunity_Detail__c, Discount_rate__c, Anticipated_gift_amount__c, expected_gift_date__c, 
            final_acct_requested_date__c, fund__c, First_Payment_Date__c, giving_vehicle__c, giving_vehicle_value__c, inventory_amount__c, 
            inventory_requested_date__c, Cash_Surrender_Value__c, life_ins_death_benefit_amount__c, life_ins_death_benefit_date__c, 
            life_ins_number_of_years__c, life_insurance_company__c, name_id__c, discount_date_month__c, payment_method__c, 
            payment_method_value__c, Payout_Rate__c, policy_number__c, premium_payment_amount__c, probate_date__c, Gift_amount__c, 
            recip_account_id__c, recip_name_id__c, Remainder_Amount__c, Station_percent__c, source__c, sts__c, term_years__c, 
            trust_market_value__c, Principle_amount__c, trust_value_date__c, will_drafted_date__c, will_received_date__c, 
            will_requested_date__c, Gift_Date__c, Designation__c, Discount_Date_Year__c, Giving_Payment_Frequency__c, 
            Total_Value_of_Property__c, Value_of_Buildings__c, Estimated_Useful_Life_of_Buildings__c, Salvage_Value_of_Buildings__c, 
            Percentage_of_Estate__c, Expected_Date__c, Fair_Market_Date__c, Fair_Market_Value__c, revocable__c, Trustee_Name__c, 
            Co_Trustee_Name__c, Birth_Day__c, Birth_Month__c, Birth_Year__c, payment_frequency__c, TaTransactions_Id__c, Donor__c, 
            Organization__c, Household__c, Managed__c, Close_Sever_Date__c, Discount_Rate_Date__c, External_Managing_Organization__c, 
            Date_Station_Notified__c, Type__c, Charitable_Deduction__c, Ordinary_Income__c, Tax_Free_Income__c, Fund_Lookup__c, 
            Campaign__c, Notes__c, Total_Estate__c, Date_of_Death__c, Count_of_Bene_A__c, Count_of_Bene_I__c, Count_Of_Donor_Bene_A__c, 
            Count_Of_Donor_Bene_I__c, Station__c, Trust_ID__c, Gift_Subtype__c, Initial_Gift_Amount__c, Station_Total_Gift_Amount__c, 
            Term_Type__c, Discount_Rate_Month__c, Discount_Rate_Year__c, External_Manager__c, Anticipated_Percentage_of_Trust__c, 
            Market_Value__c, Market_Value_Date__c, Final_Distribution_Amount__c, Term_End_Date__c, Contact_Name__c, Contact_Roles__c, 
            Date_of_Birth__c, Address__c, Additional_Gifts__c, Life_Insurance_Provider_Address__c, Life_Insurance_Policy_Name__c, 
            Life_Insurance_Annual_Premium__c, Life_Insurance_Premium_Due_Date__c, Life_Insurance_Premium_Pmt_Address__c, Appraisal_Value__c, 
            Appraisal_Date__c, Bequest_Type__c, PIF_Total_Units__c, Contract_Date__c, Planned_Giving_Asset__c, Source_Code__c 
            FROM Bequest__c
            Where Id =: objPledges.bequest__c];
            if(objPlanGiving != null && mode != 'edit' && mode != 'clone'){
                objPledges.CampaignId = objPlanGiving.Campaign__c;
                objPledges.Oppty_Related_Contact__c = objPlanGiving.Donor__c;
                objPledges.Fund_Lookup__c = objPlanGiving.Fund_Lookup__c;
                objPledges.Giving_Amount__c = objPlanGiving.Gift_amount__c;
                objPledges.payment_frequency__c = objPlanGiving.Giving_Payment_Frequency__c;//objPlanGiving.payment_frequency__c
                objPledges.AccountId = objPlanGiving.Household__c;
                objPledges.payment_method__c = objPlanGiving.payment_method__c;
                objPledges.AccountId = objPlanGiving.Household__c;
                //objPlanGiving.Contact_Roles__c
                //objPlanGiving.expected_gift_date__c
                //objPlanGiving.Initial_Gift_Amount__c
                //objPlanGiving.Organization__c (Lookup-Account)
                //objPlanGiving.payment_method_value__c
                if(objPlanGiving.Gift_Date__c != null){
                    objPledges.CloseDate = objPlanGiving.Gift_Date__c;
                    DateTime dt = DateTime.newInstance(objPledges.CloseDate.Year(),objPledges.CloseDate.month(),objPledges.CloseDate.day(),0,0,0);
                    objPledges.Gift_Date_Time__c = dt;
                    objPledges.Schedule_Start_Date__c = dt.date();
                }
                if(objPledges.CampaignId != null)
                    selectCampaign();
            }
        }        
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    }
    Public PageReference SaveAndNew(){
       if(SavePledge()==true){
           String URL = '/setup/ui/recordtypeselect.jsp?ent=Opportunity';
           if(fromAccount==true){
               URL += '&retURL=%2F' + returnURL.replace('/','');
               URL += '&save_new_url=%2F006%2Fe%3FretURL%3D%252F' + objPledges.AccountID + '%26accid%3D' + objPledges.AccountID;
           }
           else if(fromContact==true){
               Contact objCon = [Select Id, AccountID From Contact Where Id=:objPledges.Oppty_Related_Contact__c];
               URL += '&retURL=%2F' + returnURL.replace('/','');
               URL += '&save_new_url=%2F006%2Fe%3Flookupcmpgn%3D1%26retURL%3D%252F' + objCon.Id + '%26accid%3D' + objCon.AccountId + '%26conid%3D' + objCon.Id;
           }
           else if(fromCampaign==true){
               URL += '&retURL=%2Fapex%2FCampaignProgramView%3FId%3D' + returnURL.replace('/','');
               URL += '&save_new_url=%2F006%2Fe%3FretURL%3D%252Fapex%252FCampaignProgramView%253FId%253D' + returnURL.replace('/','') + '%26campid%3D' + returnURL.replace('/','');
           }
           else{
               URL += '&retURL=' + returnURL;
               URL += '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo';
           }
           return redirectPage(URL);
       }
       else
           Return null;
    }
    String oldGivingStage='';
    String oldGiftType = '';
    String oldGiftKind = '';
    void PageLoad(){
        allowMove = true;
        system.debug('########### mode before: ' + mode);
        if (objPledges == null){
            objPledges = new Opportunity();
        }
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        lstChild = new List<Opportunity>();
        setMode();
        system.debug('########### mode after: ' + mode);
        fromAccount = false;
        System.debug('############################# MODE: ' + mode);
            defaultSettings();
        if(mode=='new'){
            //defaultSettings();
            objPledges.RecordTypeId = getRecordType();
        }
        else{
            List<Opportunity> lstOpp = [Select Id, AccountId, RecordTypeId, Name, bequest__c, Description, StageName, 
            Amount, Type, CampaignId, Pricebook2Id, FiscalYear, Campaign_Name__c, 
            Contact_Id_for_Role__c, Oppty_Related_Contact__c, Station__c, 
            TrackingNumber__c, Gift_Date_Time__c, gift_kind__c, gift_type__c, 
            payment_frequency__c, payment_number__c, Fund_Lookup__c, Fund__c,
            payments_in_schedule__c, Giving_Amount__c, pledge_number__c, program__c, purpose__c, 
            schedule_start_date__c, source__c, systemHouseholdContactRoleProcessor__c, 
            ta_campaign__c, ta_campaign_value__c,  bulk_load__c, 
            new_install_ment_date__c, pledge_amount__c, installment_amount__c,
            payment_method__c, batch_process_count__c, New_Balance__c, 
            Product__c, Ack_Sent_Date__c, Foundation_Name__c, payment_amount__c,
            Foundation_Pay__c, Installment_Period__c, Installments__c, Matching_Gift__c, 
            Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
            Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, 
            Payment_Method_Description__c, Charge_Card_Type__c, Matching_Company__c, 
            Support_Designation__c, Anonymous__c, Restricted__c, Override_Gift_Type__c, 
            Payment_Date__c, Revenue_Date__c, Giving_Segment__c, Solicitation_Type__c,
            Response_Mechanism__c, Closed_Lost_Reasons__c, Source_Code__c , Matching_Gift_Status__c, CC_EFT_Alias__c
            FROM Opportunity Where Id=:getId()];
            if(lstOpp != null && lstOpp.size()>0){
                
                if(mode=='clone'){
                    Opportunity objGiving = new Opportunity();
                    objGiving = lstOpp[0];
                    system.debug('############## recortype id: ' + objGiving.recordtypeid);
                    objPledges = objGiving.clone(false,true);
                    if(objPledges.bequest__c != null){
                        fromPlannedGiving = true;
                        LoadPlannedGiving();
                    }  
                    system.debug('############## recordtypeid in objPledges: ' + objPledges.recordtypeid);
                    objPledges.RecordTypeId = objGiving.recordtypeid;
                }
                if(mode=='edit'){
                    objPledges = lstOpp[0];
                    if(objPledges.bequest__c != null){
                        fromPlannedGiving = true;
                        LoadPlannedGiving();
                    }                
                    if(objPledges.StageName != null){
                        oldGivingStage = objPledges.StageName;
                    }
                    oldGiftType = objPledges.Gift_Type__c;
                    oldGiftKind = objPledges.Gift_Kind__c;
                    if(objPledges.Gift_Kind__c != null && objPledges.Gift_Kind__c.trim().length()>0 &&
                    ( objPledges.Gift_Kind__c.trim().toUpperCase() == 'INSTALLMENT' ||
                      objPledges.Gift_Kind__c.trim().toUpperCase() == 'SUSTAINING GIFT' )){
                      lstChild = new List<Opportunity>();
                      lstChild = [Select Id, AccountId, RecordTypeId, Name, Description, StageName, 
                        Amount, Type, CampaignId, Pricebook2Id, FiscalYear, Campaign_Name__c, 
                        Contact_Id_for_Role__c, Oppty_Related_Contact__c, Station__c, closeDate, 
                        TrackingNumber__c, Gift_Date_Time__c, gift_kind__c, gift_type__c, 
                        payment_frequency__c, payment_number__c, Fund_Lookup__c, Fund__c,
                        payments_in_schedule__c, Giving_Amount__c, pledge_number__c, program__c, purpose__c, 
                        schedule_start_date__c, source__c, systemHouseholdContactRoleProcessor__c, 
                        ta_campaign__c, ta_campaign_value__c,  bulk_load__c, 
                        new_install_ment_date__c, pledge_amount__c, installment_amount__c,
                        payment_method__c, batch_process_count__c, New_Balance__c, 
                        Product__c, Ack_Sent_Date__c, Foundation_Name__c, payment_amount__c,
                        Foundation_Pay__c, Installment_Period__c, Installments__c, Matching_Gift__c, 
                        Recurring_Donation_Opportunity__c, Schedule_Type__c, Total__c, 
                        Tribute_Description__c, Tribute_Flag__c, Tribute_Name__c, Tribute_Type__c, 
                        Payment_Method_Description__c, Charge_Card_Type__c, Matching_Company__c, 
                        Support_Designation__c, Anonymous__c, Restricted__c, Override_Gift_Type__c, 
                        Payment_Date__c, Revenue_Date__c, Giving_Segment__c, Solicitation_Type__c,
                        Response_Mechanism__c, Closed_Lost_Reasons__c, Source_Code__c , Matching_Gift_Status__c, CC_EFT_Alias__c 
                        FROM Opportunity Where Recurring_Donation_Opportunity__c=:getId() Order By payment_number__c asc];                     
                    }
                }
                system.debug('############## fromAccount: ' + fromAccount);
                system.debug('############## Contact: ' + objPledges.Oppty_Related_Contact__c);
                if(fromAccount == true && objPledges.Oppty_Related_Contact__c != null)
                    selectedContact = objPledges.Oppty_Related_Contact__c;
            }
            else{
                mode = 'new';
            }
            defaultSettings();
            LoadProduct();
        }
        initializeStock();
        List<RecordType> lstRc = [select name from RecordType where id =:getRecordType()];
        if(lstRc.size()>0){
            strRecordType = lstRc[0].name;
        }
        else{
            strRecordType = 'Annual Inkind';
        }
        //PledgeAmount = integer.valueof('33');
        System.debug('############################# ' + ApexPages.currentPage().getUrl());
    }
    String NVL(String val){
        if(val == null)
            return '';
        else
            return val; 
    }

    Public List<SelectOption> getShipToAddress(){
        System.debug('######### ShipToAddress Called ########');
        List<SelectOption> shipAddress = new List<SelectOption>();
        List<Address__c> lstAdd = new List<Address__c>();
        
        if(objPledges.accountId != null){
            lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
            State__c, Country__c from Address__c 
            where account_household__c =: objPledges.accountId and Account_Household__c!=null];
        }
        if(lstAdd.size()>0){
            for(Address__c a:lstAdd){
                shipAddress.add(new SelectOption(a.id,a.name));
                if(objPledges.Account.Preferred_Address__c == a.id){
                    for(OppProduct prod:lstOppProduct){
                        if(prod.AddressId == null){
                            prod.Street = a.Street_1__c;
                            prod.City = a.City__c;
                            prod.State = a.State__c;
                            prod.Zip = a.Postal_Code__c;
                            prod.Country = a.Country__c;
                            prod.AddressId = a.id;
                        }
                    }
                }
            }
        }
        
        shipAddress.add(new SelectOption('other','Other'));
        return shipAddress;
    }    
    Public void LoadProduct(){
        try{
            System.debug('######### Load Product Called ########');
            List<OpportunityLineItem> lstLineItem = new List<OpportunityLineItem>();
            lstLineItem = [Select Id, PricebookEntry.ProductCode, PricebookEntry.Product2.Name, PricebookEntry.Product2Id, OpportunityId, PricebookEntryId, Street__c, Shipping_Method__c, Committed_Number__c, IsBenefit__c,
            State__c, Postal_Code__c, Name__c, Country__c, Quantity, Description, UnitPrice, TotalPrice, City__c
            From OpportunityLineItem 
            Where OpportunityId =: objPledges.Id and Fulfillment_Status__c != 'Cancelled'];
            //Ketan Benegal-system debug statement
            System.debug('LoadProduct***********************************************PledgeId: '+ objPledges.Id +'AccountId: ' + objPledges.AccountId);
            List<Address__c> lstAddress = new List<Address__c>();
            if(objPledges.AccountId != null){
                lstAddress = [Select Id, City__c, State__c, Street_1__c, Postal_Code__c, 
                Country__c, Name From Address__c Where Account_Household__c =: objPledges.AccountId];
            }
            lstOppProduct = new List<OppProduct>();
            if(lstLineItem != null && lstLineItem.Size()>0){
                for(OpportunityLineItem o:lstLineItem){
                    OppProduct benefit = new OppProduct();
                    benefit.ProductCode = o.PricebookEntry.ProductCode;
                    benefit.ProductName = o.PricebookEntry.Product2.Name;
                    benefit.PricebookEntryId = o.PricebookEntryId;
                    benefit.Product2Id = o.PricebookEntry.Product2Id;
                    benefit.CommittedNo = o.Committed_Number__c;
                    system.debug('############## LineItem Id : ' + o.Id);
                    benefit.LineId = o.Id;
                    benefit.Name = NVL(o.Name__c);
                    benefit.Street = NVL(o.Street__c);
                    benefit.City = NVL(o.City__c);
                    benefit.State = NVL(o.State__c);
                    benefit.Zip = NVL(o.Postal_Code__c);
                    benefit.Country = NVL(o.Country__c);
                    benefit.Quantity = Integer.valueOf(o.Quantity);
                    benefit.Description = NVL(o.Description);
                    benefit.UnitPrice = o.UnitPrice;
                    benefit.TotalPrice = o.TotalPrice;
                    benefit.IsBenefit = o.IsBenefit__c;
                    benefit.ShippingMethod = o.Shipping_Method__c;
                    if(lstAddress != null && lstAddress.size()>0){
                        for(Address__c add:lstAddress){
                            if((add.Street_1__c != null && add.Street_1__c.trim().toUpperCase() == benefit.Street.trim().toUpperCase()) &&
                               (add.City__c != null && add.City__c.trim().toUpperCase() == benefit.City.trim().toUpperCase()) &&
                               (add.State__c != null && add.State__c.trim().toUpperCase() == benefit.State.trim().toUpperCase()) &&
                               (add.Postal_Code__c != null && add.Postal_Code__c.trim().toUpperCase() == benefit.Zip.trim().toUpperCase()) &&
                               (add.Country__c != null && add.Country__c.trim().toUpperCase() == benefit.Country.trim().toUpperCase())){
                               
                               benefit.AddressId = add.Id;
                               benefit.blnOtherAddress = false;
                               
                            }
                                
                        }
                    }else{
                        benefit.AddressId = 'other';
                        benefit.blnOtherAddress = true;
                    }
                    lstOppProduct.add(benefit);
                }
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    } 
    Public List<SelectOption> getAccountContacts(){
    
        List<SelectOption> rsContact = new List<SelectOption>();
        try{
            List<Contact> lstContact = new List<Contact>();
            if(objPledges.AccountId != null){
                lstContact = [Select Id, Name From Contact where AccountId =:objPledges.AccountId limit 100];
            }
            rsContact.add(new SelectOption('--None--', '--None--'));
            if(lstContact != null && lstContact.size()>0){
                for(Contact c:lstContact){
                    rsContact.add(new SelectOption(c.Id, c.name));
                }
            }
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return rsContact;
    }
    Public List<CC_Alias__c> getExistingChargeCard(){
        lstChargeCard = new List<CC_Alias__c>();
        system.debug('###### AccountID : ' +  objPledges.AccountId + ' and Contact__c : ' + objPledges.Oppty_Related_Contact__c + ' and Pledge:  '+ objPledges.Id);

        lstChargeCard = [Select c.Payment_Method__c, c.VANReference__c, c.TransactionID__c, c.SystemModstamp, c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, c.RecordTypeId, c.Payment_ID__c, c.Payment_Description__c, c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Merchant_Account__r.Merchant_ID__c, c.Merchant_Account__r.Merchant_Key__c, c.Last_Four_Digits__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.Card_Type__c, c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c  from CC_Alias__c c where c.Account__c =: objPledges.AccountId and c.Contact__c =: objPledges.Oppty_Related_Contact__c and c.Payment_Method__c='Charge Card' and c.Card_Holder_Name__c != null];
        
        List<CC_Alias__c> lstReturn = new List<CC_Alias__c>();
        
        CC_Alias__c temp = new CC_Alias__c();
        //temp.Card_Type__c = 'New';
        lstReturn.add(temp);
        
        for(CC_Alias__c e: lstChargeCard) {
            lstReturn.add(e);
        }

        return lstReturn;
    }
    
    Public PledgesNewStep(ApexPages.StandardController controller){
        PageLoad();
        /*Ketan Benegal - boolean properties set.*/
        displaySageHtml = false;
        bDisplayNewCard = false;
    }
    
    //Public PledgesNewStep(){
        //PageLoad();
    //}
    
    public List<SelectOption> getGivingSegment()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Campaign.Giving_Segment__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    public List<SelectOption> getOverrideGiftType()
    {
        List<SelectOption> options = new List<SelectOption>();
        boolean blnRenewal = false;
        boolean blnAddGift = false;
        Schema.DescribeFieldResult fieldResult = Campaign.Override_Gift__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        options.add(new SelectOption('--None--', '--None--'));
        /*
        if(objPledges.Gift_Type__c != null && objPledges.Gift_Type__c.trim().length()>0 &&
        (objPledges.Gift_Type__c.trim().toUpperCase() == 'ADD GIFT' ||
        objPledges.Gift_Type__c.trim().toUpperCase() == 'DONATION')){
            blnRenewal = true;
        }
        
        if(objPledges.Gift_Type__c != null && objPledges.Gift_Type__c.trim().length()>0 &&
        (objPledges.Gift_Type__c.trim().toUpperCase() == 'RENEWAL' ||
        objPledges.Gift_Type__c.trim().toUpperCase() == 'UPGRADE RESET')){
            blnAddGift = true;
        }
        */
        for( Schema.PicklistEntry f : ple)
        {
            if(blnRenewal == true){
                if(f.getValue().trim().toUpperCase() == 'RENEWAL'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
            else if(blnAddGift == true){
                if(f.getValue().trim().toUpperCase() == 'ADD GIFT' || f.getValue().trim().toUpperCase() == 'ADDITIONAL GIFT'){
                    options.add(new SelectOption(f.getLabel(), f.getValue()));
                }
            }
            else{
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }
        }       
        
        return options;
    }
    
    public List<SelectOption> getShippingMethod()
    {
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Shipping_Method__c.getDescribe();
        
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        
        
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;
    }
    
    
    
    String QueryStrings(){
        return 'RecordType=' + getRecordType() + '&retURL=' + retURL();
    }
    
    Public String OverloadedGiftType{get;set;}
    Public PageReference ApplyGiftType(){
        //value="{!objPledges.gift_type__c}"
        if(OverloadedGiftType != null && OverloadedGiftType != '--None--'){
            objPledges.gift_type__c = OverloadedGiftType;
        }
        if(lstOppProduct != null && lstOppProduct.size()>0){
            system.debug('##### Total Product : ' + lstOppProduct.size());
            List<OppProduct> tempProduct = new List<OppProduct>();
            for(OppProduct temp:lstOppProduct){
                if(temp.IsBenefit==false)
                    tempProduct.add(temp);
            }
            system.debug('##### Total Premium: ' + tempProduct.size());
            lstOppProduct = new List<OppProduct>();
            if(tempProduct != null && tempProduct.size()>0){ 
                for(OppProduct temp:tempProduct){
                    lstOppProduct.add(temp);
                }
            }
        }else{
            lstOppProduct = new List<OppProduct>();
        } 
        getProduct();
        return null;
    }
    Boolean ProcessStep2(){
        //Boolean blnGo=false;
        //objPledges.Gift_Type__c = 'Donation';
        System.debug('##########################Gift type before: ' + objPledges.Gift_Type__c);
        if(mode=='new'){// && (OverloadedGiftType == null && OverloadedGiftType.trim().length() == 0)){
            objPledges.Gift_Type__c = GTR.GTR(objPledges);
        }
        System.debug('##########################Gift type after: ' + objPledges.Gift_Type__c);
        return true;
    }
    Campaign objCPRT = new Campaign();
    Public PageReference SelectCampaign(){
        //Giving_Segment__c
        List<Campaign> lstCamp = new List<Campaign>();
        if(objPledges.CampaignId != null){
            lstCamp = [Select id, name, Support_Designation__c, Override_Gift__c, Solicitation_Type__c, 
            Campaign_Name__c, Giving_Segment__c, station__c,Product_Program__c, Source_Code__c, 
            TA_Campaign_Source_Code__c, Package_Code__c, Response_Mechanism__c, TV_Radio_Show_Program__c 
            From Campaign Where id=:objPledges.CampaignId];
        }
        String pName='';
        try{
            system.debug('##########Gift Date : ----------> ' + objPledges.Gift_Date_Time__c);
            if(objPledges.Gift_Date_Time__c != null)
                pName = String.ValueOf(objPledges.Gift_Date_Time__c.Year());
            if(lstCamp.size()>0){      
                OverloadedGiftType = lstCamp[0].Override_Gift__c;
                objPledges.Giving_Segment__c = lstCamp[0].Giving_Segment__c;
                //objPledges.Gift_Type__c = lstCamp[0].Gift_Type__c;
                objPledges.Support_Designation__c = lstCamp[0].Support_Designation__c;
                objPledges.station__c = lstCamp[0].station__c;
                objPledges.Response_Mechanism__c = lstCamp[0].Response_Mechanism__c;
                objPledges.product__c = lstCamp[0].Product_Program__c;
                objPledges.ta_campaign__c = lstCamp[0].TA_Campaign_Source_Code__c;
                objPledges.Source_Code__c = lstCamp[0].Source_Code__c;
                if(lstCamp[0].TV_Radio_Show_Program__c != null){
                    Program__c objProgram = new Program__c();
                    objProgram = [Select Id, name From Program__c where id =: lstCamp[0].TV_Radio_Show_Program__c];
                    if(objProgram != null){
                        objPledges.program__c = objProgram.name;
                    }
                }
                
                objPledges.Campaign_Name__c = lstCamp[0].Campaign_Name__c;
                objPledges.Solicitation_Type__c = lstCamp[0].Solicitation_Type__c;
                objCPRT = lstCamp[0];  
                generatePledgeName();   
            }           
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        return null;
    }
    
    public void generatePledgeName(){
        //Gift year (from gift date), STATION, CAMAPIGN & SOLICITATION TYPE 
        String pName='';
        //system.debug('############## YEAR: ' + String.ValueOf(objPledges.Gift_Date_Time__c.Year()));
        if(objPledges.Gift_Date_Time__c != null){
            pName = String.ValueOf(objPledges.Gift_Date_Time__c.Year());
            objPledges.Schedule_Start_Date__c = objPledges.Gift_Date_Time__c.Date();
        }
        if(objCPRT != null){
            if(objCPRT.Station__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Station__c;
                else
                    pName += objCPRT.Station__c;
            if(objCPRT.Campaign_Name__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Campaign_Name__c;
                else
                    pName += objCPRT.Campaign_Name__c;
            if(objCPRT.Giving_Segment__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Giving_Segment__c;
                else
                    pName += objCPRT.Giving_Segment__c;
                
            if(objCPRT.Solicitation_Type__c != null)
                if(pName.length()>0)
                    pName += ' ' + objCPRT.Solicitation_Type__c;
                else
                    pName += objCPRT.Solicitation_Type__c;
        
        }
        objPledges.name = pName;
        //return pName;
    }
    
    Public PageReference ChoosePaymentMode(){
        return null;
    }
    
    Public PageReference GoToStep1(){  
        //Pagereference P = new Pagereference('/apex/PledgesNewStep1?' + QueryStrings());
        //P.setRedirect(true);
        //Return P;
        Return Page.PledgesNewStep1;
        //Return null;
    }
    

    
    String getPricebookId(){
        List<Pricebook2> lstPricebook;
        String pricebookId=null;
        if(objPledges.Station__c!=null){
            lstPricebook = [Select Id from Pricebook2 Where name like:objPledges.Station__c];
            if(lstPricebook.size()>0){
                //objPledges.Pricebook2Id = lstPricebook[0].Id;
                pricebookId = lstPricebook[0].Id;
            }
        }
        return pricebookId;
    }
    
    Public PageReference GoToStep3(){
        ProcessStep2();  
        //Pagereference P = new Pagereference('/apex/PledgesNewStep3?' + QueryStrings());
        //P.setRedirect(true);
        //Return P;
        Return Page.PledgesNewStep3;
    }   
    
    Public PageReference GoToStep4(){    
        //Pagereference P = new Pagereference('/apex/PledgesNewStep4?' + QueryStrings());
        //P.setRedirect(true);
        //Return P;
        if(lstOppProduct != null && lstOppProduct.size()>0){
            for(OppProduct o:lstOppProduct){
                if(o.Quantity <= 0){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Quantity cannot be zero.')); 
                    return null;
                }
            }
        }
        Return Page.PledgesNewStep4;
    }    
    boolean hasChildGiving(){
        boolean flag = false;
        String giftKind = objPledges.gift_kind__c.trim().toUpperCase();
        if(giftKind == 'INSTALLMENT' || giftKind == 'SUSTAINING GIFT' || giftKind == 'SUSTAINING PLEDGE')
            return true;
        else if(giftKind == 'ONE PAYMENT')
            return false;
        else
            return false;                    
    }
    boolean setInstallment(){
        String Frequency = '';
        boolean flag = false;
        String giftKind = objPledges.gift_kind__c.trim().toUpperCase();
        System.debug('###### Gift Kind Selected : ' + giftKind);
        if(giftKind == 'INSTALLMENT' || giftKind == 'SUSTAINING GIFT' || giftKind == 'SUSTAINING PLEDGE'){
            if(objPledges.payment_frequency__c != null){
                Frequency = objPledges.payment_frequency__c.toUpperCase();            
                if(Frequency == 'MONTHLY'){
                    objPledges.Installments__c = 12;
                    objPledges.Installment_Period__c = 'Monthly';
                }
                if(Frequency == 'QUARTERLY'){
                    objPledges.Installments__c = 4;
                    objPledges.Installment_Period__c = 'Quarterly';
                }
                if(Frequency == 'ANNUALLY'){
                    objPledges.Installments__c = 1;
                    objPledges.Installment_Period__c = 'Yearly';
                }
                if(Frequency == 'BI-MONTHLY'){
                    objPledges.Installments__c = 6;
                    objPledges.Installment_Period__c = 'Bi-Monthly';
                }
                if(Frequency == 'SEMI-ANNUALLY'){
                    objPledges.Installments__c = 2;
                    objPledges.Installment_Period__c = 'Semi-Annually';
                }
                if(Frequency == 'IRREGULAR SCHEDULE'){
                    objPledges.Installment_Period__c = 'IrregularSchedule';
                }
                system.debug('########objPledges.Giving_Amount__c : ' + objPledges.Giving_Amount__c);
                system.debug('########objPledges.Installments__c : ' + objPledges.Installments__c);
                if(objPledges.Giving_Amount__c != null && objPledges.Giving_Amount__c >0){
                    if(objPledges.Installments__c != null && objPledges.Installments__c >0){
                        objPledges.installment_amount__c = (objPledges.Giving_Amount__c / objPledges.Installments__c).setScale(2);
                    }
                }
                system.debug('########objPledges.installment_amount__c : ' + objPledges.installment_amount__c);
                flag = true;
            }
            else{
                flag = false;
            }            
        }
        else{
            flag = false;
        }
        return flag;
    }
    Public PageReference PreviousFromStep3(){
        if (hasChildGiving() == false)
            Return Page.PledgesNewStep1;
        else
            Return Page.PledgesNewStep2;
    }
    Public PageReference GoToStep2(){  
        Return Page.PledgesNewStep2;
    }
    void setContactDetail(){ 
        System.debug('Creating ObjContact 111');       
        objContact = new Contact();
        System.debug('Creating ObjContact 22');       
        if(objPledges.Oppty_Related_Contact__c != null){
        System.debug('Creating ObjContact 333');       
            
            //Ketan Benegal - 05/16/2011 - added MailingCountry, MailingStreet, Fax to the following query for Sage Integration.
            objContact = [Select Id, Name, Salutation, FirstName, LastName, Email, MobilePhone,
            Birthdate, Phone, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStreet, Fax,
            Preferred_Address__r.Street_2__c, Preferred_Address__r.Street_1__c, Preferred_Address__r.State__c, Preferred_Address__r.Postal_Code__c, Preferred_Address__r.Country__c, Preferred_Address__r.City__c
            From Contact 
            Where Id =: objPledges.Oppty_Related_Contact__c];
        }
        System.debug('Inside setContactDetail: ' + objContact.FirstName);
    }
    void setHouseholdDetail(){
        objHousehold = new Account();
        if(objPledges.AccountId != null){
            objHousehold = [Select Id, Name, AccountNumber, Phone, AccountType__c
            From Account
            Where Id =: objPledges.AccountId];
        }
    }
    Public PageReference ProcessStep1(){
        
        System.debug('In Process Step1');
        Boolean blnGo=false;
        if(fromAccount==true){
            if(selectedContact != '--None--')
                objPledges.Oppty_Related_Contact__c = selectedContact;
            else
                objPledges.Oppty_Related_Contact__c = null;
        }
        objPledges.schedule_Start_Date__c = Date.valueOf(objPledges.schedule_Start_Date__c);
        //objPledges.RecordTypeId = getRecordType();
        if(objPledges.CampaignId == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select CPRT.')); 
            return null;
        }
        if (objPledges.Account == null && objPledges.Oppty_Related_Contact__c == null && objPledges.AccountId == null)
        {
            objPledges.addError(System.Label.RecurringDonationMissingDataError);
            return null;
        }
        if(objPledges.gift_kind__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Gift kind.')); 
            return null;
        }
        if(objPledges.schedule_start_date__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select Schedule Start Date.')); 
            return null;
        }
        if(objPledges.Foundation_Pay__c == true &&  (objPledges.Foundation_Name__c==null ||  objPledges.Foundation_Name__c=='')) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Enter Foundation Name.')); 
            return null;
        }
        if(objPledges.Matching_Gift__c == true &&  objPledges.Matching_Company__c==null) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Select Matching Company.')); 
            return null;
        }
                
        //lstChild = new List<Opportunity>();
        
        System.debug('Calling ContactDetail 11');
        setContactDetail();
        System.debug('Calling ContactDetail 222 : ' + this.objContact + '   '+ this.objContact.firstName );
        setHouseholdDetail();
        if (setInstallment() == false){
            //return GoToStep2();
            return GoToStep3();
        }
        integer totalChilds = Integer.valueOf(objPledges.Installments__c);
        if ( objPledges.Installments__c > 50 )
        {
            objPledges.addError(System.Label.RecurringDonationTooManyInstallmentsError);
            return null;
        }
        try{
            if(mode=='edit'){
                System.debug('######### Previous Gift Kind ---> ' + oldGiftKind);
                System.debug('######### Current Gift Kind ---> ' + objPledges.Gift_Type__c);
                if(oldGiftKind == 'One Payment' && (objPledges.Gift_Kind__c == 'Installment' || objPledges.Gift_Kind__c == 'Sustaining Gift')){
                    setChildValues('Contact');
                }else{
                    editChildValues();
                }
            }
            else
                setChildValues('Contact');
            blnGo = true;
        }catch(Exception ex){
            blnGo = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
        }
        if(blnGo==true)
            return GoToStep2();
        else
            return null;
    }
    String getChildRecordType(){
        String ParentId = getRecordType();
        String childName = '';
        String ChildId = null;
        List<RecordType> lstParent = [Select DeveloperName from RecordType Where Id =: ParentId];
        if(lstParent != null && lstParent.size()>0){
            if(lstParent[0].DeveloperName.trim().toUpperCase() == 'ANNUAL'){
                childName = 'Annual_Installment';
            }
            if(lstParent[0].DeveloperName.trim().toUpperCase() == 'DONATION'){
                childName = 'Donation_Installment';
            }
            if(lstParent[0].DeveloperName.trim().toUpperCase() == 'INKIND'){
                childName = 'Inkind_Installment';
            }
            if(lstParent[0].DeveloperName.trim().toUpperCase() == 'PURCHASE'){
                childName = 'Purchase_Installment';
            }
            if(childName != null && childName.trim().length()>0){
                List<RecordType> lstChildRc = [Select Id from RecordType Where DeveloperName =: childName];
                if(lstChildRc != null && lstChildRc.size()>0){
                    ChildId = lstChildRc[0].Id;
                }
                else
                    ChildId = null;
            }
            else
                ChildId = null;
                
        }
        return ChildId;
    }
    void updateChildGiving(){
        //update lstChild;   
        List<Opportunity> lstInsert = new List<Opportunity>();
        List<Opportunity> lstUpdate = new List<Opportunity>();
        for(Opportunity ch:lstChild){
            if(ch.id != null)
                lstUpdate.add(ch);
            else
                lstInsert.add(ch);
        }                        
        if(lstUpdate != null && lstUpdate.size()>0)
            update lstUpdate;
        if(lstInsert != null && lstInsert.size()>0)
            insert lstInsert;
        if(lstDeleteChild != null && lstDeleteChild.size()>0)
            delete lstDeleteChild;
    }
    public void editChildValues()
    {
        system.debug('***** Total Childs: ' + lstChild.size());
        String RecordTypeID='';
        Id contactIds;
        Decimal installs = objPledges.Installments__c;
        Integer installments = installs.intValue();
        Decimal LastAmount = 0;
        Decimal remainGiving = 0;
        Decimal newInstallment = 0;
        Decimal pendingInstallment = 0;
        Decimal paidAmount = 0;
        system.debug('###### Total installments : ' + installments);
        integer j = 0;
        if(lstChild != null && lstChild.size() > 0){
            for(Opportunity child:lstChild){
                if(child.Payment_Amount__c != null && child.Payment_Amount__c > 0){
                    paidAmount += child.Payment_Amount__c;
                    j++;
                }
            }            
            remainGiving = (objPledges.Giving_Amount__c - paidAmount).setScale(2);
            pendingInstallment = installments - (j);
            newInstallment = (remainGiving/pendingInstallment).setScale(2);
        }
        for(Integer i=0;i<installments;i++)
        {
            //lstChild[i].RecordTypeID = getChildRecordType();
            if(i>=lstChild.size()){
                Opportunity objTemp = new Opportunity();
                lstChild.add(objTemp);
            }                        
            lstChild[i].AccountId = objPledges.AccountId;
            //add the remainder to the last installment, otherwise use the amount
            lstChild[i].Solicitation_Type__c = objPledges.Solicitation_Type__c;
            lstChild[i].Response_Mechanism__c = objPledges.Response_Mechanism__c;
            //opp.Gift_Type__c = objPledges.Gift_Type__c;
            lstChild[i].Gift_Kind__c = objPledges.Gift_Kind__c;
            lstChild[i].Product__c = objPledges.Product__c;
            lstChild[i].Source_Code__c = objPledges.Source_Code__c;
            lstChild[i].Campaign_Name__c = objPledges.Campaign_Name__c;
            lstChild[i].Giving_Segment__c = objPledges.Giving_Segment__c;
            lstChild[i].Giving_Amount__c = objPledges.Giving_Amount__c;
            lstChild[i].Gift_Date_Time__c = objPledges.Gift_Date_Time__c;
            lstChild[i].Station__c = objPledges.Station__c;
            lstChild[i].Amount = objPledges.Installment_Amount__c;
            
            lstChild[i].CloseDate = calculateDate(objPledges.schedule_start_date__c, objPledges.Installment_Period__c, i);
            lstChild[i].schedule_start_date__c = lstChild[i].CloseDate;
            lstChild[i].Installment_Period__c = objPledges.Installment_Period__c;
            
            lstChild[i].payment_number__c = i+1;
            lstChild[i].payment_method__c = objPledges.payment_method__c;
            //lstChild[i].StageName = System.Label.RecurringDonationStageName;            
            lstChild[i].StageName = objPledges.Stagename;
            ////////////////////////
            if(lstChild[i].Payment_Amount__c != null && lstChild[i].Payment_Amount__c > 0){
                /*remainGiving = (objPledges.Giving_Amount__c - lstChild[i].Payment_Amount__c).setScale(2);
                pendingInstallment = installments - (i+1);
                newInstallment = (remainGiving/pendingInstallment).setScale(2);*/
            }
            else{            
                if(i == (installments-1)){
                    LastAmount = (remainGiving - LastAmount).setScale(2);
                    lstChild[i].Installment_Amount__c = LastAmount;
                }
                else{
                    LastAmount += newInstallment;
                    lstChild[i].Installment_Amount__c = newInstallment;
                }
            }
            ////////////////////////
            /*
            if(i == (installments-1)){
                LastAmount = (objPledges.Giving_Amount__c - LastAmount).setScale(2);
                lstChild[i].Installment_Amount__c = LastAmount;
            }
            else{
                LastAmount += objPledges.Installment_Amount__c;
                lstChild[i].Installment_Amount__c = objPledges.Installment_Amount__c;
            }
            */
            lstChild[i].name = generateName(lstChild[i].CloseDate, i, Installments);
        }
        lstDeleteChild = new List<Opportunity>();
        if(lstChild.size()>installments){
            system.debug('##### before child size : ' + lstChild.size());
            integer max = lstChild.size()-1;
            for(Integer i = max; i>=installments; i--){
                system.debug('####Current : ' + i);
                lstDeleteChild.add(lstChild[i]);
                lstChild.remove(i);
            }
        }
        if(lstDeleteChild != null && lstDeleteChild.size()>0)
            system.debug('####Childs to remove : ' + lstDeleteChild.size());
        if(lstChild != null && lstChild.size()>0)
            FirstInstallmentAmount = lstChild[0].Installment_Amount__c;
        else
            FirstInstallmentAmount = 0.0; 
    }
    
    public void setChildValues( String donorType )
    {
        String RecordTypeID='';
        //List<RecordType> lstRecordType = [Select id, developername, name from RecordType where DeveloperName = 'Donation'];
        //RecordTypeID = lstRecordType[0].id;
        lstChild = new List<Opportunity>();
        List<Opportunity> lstTemp = new List<Opportunity>();
        Id contactIds;
        Map<Id,Contact> contactMap;
        if ( objPledges.Oppty_Related_Contact__c != null )
        {
            contactIds = objPledges.Oppty_Related_Contact__c;
        }
        if ( contactIds != null && String.valueOf(contactIds).trim().length() > 0 )
        {
            contactMap = new Map<Id,Contact>([Select Id, AccountId, Account_Household__c from Contact where Id =:contactIds and AccountId != null]);
        }
        Decimal installs = objPledges.Installments__c;
        Integer installments = installs.intValue();
        Decimal LastAmount = 0;
        for ( Integer j=0;j<installments;j++ )
        {
            Opportunity opp = new Opportunity();
            opp.RecordTypeID = getChildRecordType();
            opp.AccountId = objPledges.AccountId;
            //add the remainder to the last installment, otherwise use the amount
            opp.Solicitation_Type__c = objPledges.Solicitation_Type__c;
            opp.Response_Mechanism__c = objPledges.Response_Mechanism__c;
            //opp.Gift_Type__c = objPledges.Gift_Type__c;
            opp.Gift_Kind__c = objPledges.Gift_Kind__c;
            opp.Product__c = objPledges.Product__c;
            opp.Source_Code__c = objPledges.Source_Code__c;
            opp.Campaign_Name__c = objPledges.Campaign_Name__c;
            opp.Giving_Segment__c = objPledges.Giving_Segment__c;
            opp.Giving_Amount__c = objPledges.Giving_Amount__c;
            opp.Gift_Date_Time__c = objPledges.Gift_Date_Time__c;
            opp.Station__c = objPledges.Station__c;
            opp.Amount = objPledges.Installment_Amount__c;
            
            //objPledges.Booked_Date__c = objPledges.schedule_start_date__c;
            //opp.Booked_Date__c = objPledges.schedule_start_date__c;
            opp.CloseDate = calculateDate(objPledges.schedule_start_date__c, objPledges.Installment_Period__c, j);
            opp.schedule_start_date__c = opp.CloseDate;
            opp.Installment_Period__c = objPledges.Installment_Period__c;
            
            opp.payment_number__c = j+1;
            opp.payment_method__c = objPledges.payment_method__c;
            //opp.StageName = System.Label.RecurringDonationStageName;
            opp.StageName = objPledges.Stagename;
            
            
            if(j == (installments-1)){
                LastAmount = (objPledges.Giving_Amount__c - LastAmount).setScale(2);
                opp.Installment_Amount__c = LastAmount;
            }
            else{
                LastAmount += objPledges.Installment_Amount__c;
                opp.Installment_Amount__c = objPledges.Installment_Amount__c;
                if(j == 0){
                    //objPledges.Payment_Amount__c = opp.Installment_Amount__c;
                }
            }
            
            opp.name = generateName(opp.CloseDate, j, Installments);
            //if (objPledges.CampaignId != null){
                //opp.CampaignId = objPledges.CampaignId;
            //}
            lstChild.add(opp);
        }
        if(lstChild != null && lstChild.size()>0)
            FirstInstallmentAmount = lstChild[0].Installment_Amount__c;
        else
            FirstInstallmentAmount = 0.0;
    }
    Public boolean allowMove{get;set;}
    Public PageReference resetInstallment(){
        allowMove = true;
        Decimal installs = objPledges.Installments__c;
        Integer installments = installs.intValue();
        Decimal GivingAmount = objPledges.Giving_Amount__c;
        Decimal remainingGivingAmount = 0.00;
        Integer remaininginstallments = 0;
        Decimal restInstallments = 0.00;
        Decimal totalAmount = 0.00;
        Decimal LastAmount = 0.00;
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Installment amount should not be greater than Giving Amount.')); 
        if(lstChild != null && lstChild.size()>0){
            for(integer i=0 ; i < lstChild.size(); i++){
                totalAmount += lstChild[i].Installment_Amount__c;
                if(startfrom == (i+1)){
                    if(totalAmount > GivingAmount){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Total of Installment amount should not be greater than Giving Amount.')); 
                        allowMove = false;
                        return null;
                    }
                    remainingGivingAmount = GivingAmount - totalAmount;
                    remainingInstallments = installments - startfrom;
                    if(remainingInstallments > 0)
                        restInstallments = (remainingGivingAmount/remainingInstallments).setScale(2);
                }
                if((i+1) == lstChild.size()){
                    lstChild[i].Installment_Amount__c = (GivingAmount - LastAmount).setScale(2);
                }
                else if((i+1) > startfrom){
                    lstChild[i].Installment_Amount__c = restInstallments;
                    totalAmount += restInstallments;
                }
                LastAmount += lstChild[i].Installment_Amount__c;
                if(i == 0 && mode != 'edit'){
                    //objPledges.Payment_Amount__c = lstChild[i].Installment_Amount__c;
                }
            }
        }
        if(totalAmount < GivingAmount){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Total of Installment amount should not be less than Giving Amount.')); 
            allowMove = false;
            return null;
        }
        allowMove = true;
        if(lstChild != null && lstChild.size()>0)
            FirstInstallmentAmount = lstChild[0].Installment_Amount__c;
        else
            FirstInstallmentAmount = 0.0; 
        return null;
    }
    Public integer startfrom{get;set;}
    Public Date recountDate{get;set;}
    Public PageReference reCalculateStartDate(){
        Decimal installs = objPledges.Installments__c;
        Integer installments = installs.intValue();
        
        if(startfrom >0 ){
            for(Opportunity opp:lstChild){
                if(opp.payment_number__c == startfrom){
                    recountDate = opp.schedule_start_date__c;
                    break;
                }
            }  
            integer i = 1;      
            for(integer inst = startfrom; inst <= lstChild.size(); inst++){
                for(Opportunity opp:lstChild){
                    if(opp.payment_number__c == inst){ 
                        opp.CloseDate = calculateDate(recountDate, objPledges.Installment_Period__c, i-1);
                        opp.schedule_start_date__c = opp.CloseDate; 
                        opp.name = generateName(opp.CloseDate, (inst-1), Installments);
                        i++;                       
                    }
                }
            }
        }
        return null;
    }
    
    String generateName(Date CloseDate, integer Installment, integer TotalInstallment){
        String oName = '';
        //oName += objPledges.Donor_Name__c; 
        oName += objPledges.Name; 
        oName += ' ';
        oName += System.Label.RecurringDonationPrefix;
        oName += ' (';
        oName += Installment+1;
        oName += ' of ';
        oName += TotalInstallment;
        oName += ') ';
        oName += CloseDate.format();
        return oName;
    }
    
    Date calculateDate(DateTime bookDate, string InstallmentPeriod, integer element){
        Date closeDate;
        /*
        if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodYearly)
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addYears(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodQuarterly)
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addMonths(3*element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodMonthly)
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addMonths(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodWeekly)
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addDays(7*element);
        else if (InstallmentPeriod == 'Bi-Monthly')
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addMonths(2*element).addDays(1);
        else if (InstallmentPeriod == 'Semi-Annually')
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addMonths(6*element).addDays(1);
        else
            closeDate = (Date.valueOf(String.valueOf(bookDate))).addDays(1);
        */
        if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodYearly)
            closeDate = bookDate.date().addYears(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodQuarterly)
            closeDate = bookDate.date().addMonths(3*element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodMonthly)
            closeDate = bookDate.date().addMonths(element).addDays(1);
        else if (InstallmentPeriod == System.Label.RecurringDonationInstallmentPeriodWeekly)
            closeDate = bookDate.date().addDays(7*element);
        else if (InstallmentPeriod == 'Bi-Monthly')
            closeDate = bookDate.date().addMonths(2*element).addDays(1);
        else if (InstallmentPeriod == 'Semi-Annually')
            closeDate = bookDate.date().addMonths(6*element).addDays(1);
        else
            closeDate = bookDate.date().addDays(1);        
        return closeDate;
    }
    
    Public List<SelectOption> getResponseMechanism(){
        List<SelectOption> rsMechanism = new List<SelectOption>();
        rsMechanism.add(new SelectOption('MAIL','Mail'));
        rsMechanism.add(new SelectOption('CALLINBOUND','Call Inbound'));
        rsMechanism.add(new SelectOption('WEBINBOUND','Web Inbound'));  
        rsMechanism.add(new SelectOption('EMAILINBOUND','Email Inbound'));
        rsMechanism.add(new SelectOption('TELESALEPLEDGE','Telesale Pledge'));         
        return rsMechanism;
    }
    
    Public List<SelectOption> getChargeCardInformation(){
        List<SelectOption> information = new List<SelectOption>();
        information.add(new SelectOption('LAST4DIGITS','Last 4 Digits'));
        information.add(new SelectOption('NEW','New'));
        return information;
    }
    
    Public PageReference Save(){
       if(SavePledge()==true)
           Return RedirectPage('/' + objPledges.Id);
       else
           Return null;
    }
    
    Public PageReference SaveAndPayment(){
        SavePledge();
        ApplyPayment();
        return GoToStep3();
    }
    
    Public PageReference NewChargeCode(){
        //Ketan Benegal -- System debug
        System.Debug('111 -- Inside NewchargeCode');
        
        if(SavePledge()==true){
        //Ketan Benegal -- System debug
        System.Debug('222 -- Inside NewchargeCode');
            PageReference P = New PageReference('/apex/SageHtml');
            P.SetRedirect(true);
            return P;            
        }
        else
        //Ketan Benegal -- System debug
        System.Debug('333 -- Inside NewchargeCode');
        
            return null;
    }
    void savePartner(){
        if(objPledges.Matching_Gift__c==true && objPledges.Matching_Company__c != null){
            try{
                Partner objPartner = new Partner();
                objPartner.OPPORTUNITYID = objPledges.Id;
                objPartner.ROLE = 'Distributor';
                objPartner.ACCOUNTTOID = objPledges.Matching_Company__c;
                objPartner.ISPRIMARY = true;
                insert objPartner;
                system.debug('@@@@@@@@ PartnerId: ' + objPartner.Id);
            }Catch(Exception ex){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage())); 
            }
        }
    }
    boolean SavePledge(){
        boolean blnSuccess=false;
        try{
            objPledges.Pricebook2Id = getPricebookId();
            if(hasChildGiving()==true){
                Decimal installs = objPledges.Installments__c;
                Integer installments = installs.intValue();
                objPledges.CloseDate = calculateDate(objPledges.schedule_start_date__c, objPledges.Installment_Period__c, installments);
            }
            else{
                objPledges.CloseDate = Date.newInstance(objPledges.Gift_Date_Time__c.year(),objPledges.Gift_Date_Time__c.month(),objPledges.Gift_Date_Time__c.day());
                if(objPledges.Payment_Amount__c > 0){
                    objPledges.Payment_Date__c = system.today();
                    objPledges.Revenue_Date__c = system.today();
                }
            }
            
            if(!(mode == 'edit' && oldGivingStage != null && oldGivingStage.trim() != objPledges.StageName)){
                if(objPledges.Payment_Method__c != 'Charge Card'){
                    if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c > 0){
                        if(objPledges.Gift_Kind__c == 'One Payment'){
                            if(objPledges.Giving_Amount__c >= objPledges.Payment_Amount__c)
                                objPledges.StageName = 'Fulfilled';
                            
                            if(objPledges.Payment_Amount__c < objPledges.Giving_Amount__c)
                                objPledges.StageName = 'Partially Fulfilled';
                            Integer monthDifference = system.today().monthsBetween(objPledges.Gift_Date_Time__c.date());
                            if(objPledges.StageName == 'Pledged' && monthDifference >= 6)
                                objPledges.StageName = 'Uncollectible';
                            
                        }
                        
                        if(objPledges.Gift_Kind__c == 'Installment' || objPledges.Gift_Kind__c == 'Sustaining Gift'){
                            if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c > 0)
                                objPledges.StageName = 'Partially Fulfilled';
                        }
                    }
                    else{
                        objPledges.StageName = 'Pledged';
                    }        
                }
            }    
            if(objPledges.Payment_Method__c != 'Charge Card' && hasChildGiving()==true && objPledges.payment_amount__c != null && objPledges.payment_amount__c > 0){
                if(lstChild != null && lstChild.size()>0){
                    lstChild[0].payment_amount__c = objPledges.payment_amount__c;
                    if(lstChild[0].payment_amount__c >= lstChild[0].installment_amount__c){
                        lstChild[0].Stagename = 'Fulfilled';
                    }
                    else{
                        lstChild[0].Stagename = 'Partially Fulfilled';
                    }
                    lstChild[0].Payment_Date__c = system.today();
                    objPledges.Payment_Date__c = lstChild[0].Payment_Date__c;
                    lstChild[0].Revenue_Date__c = system.today();
                }
            }
            if(objPledges.Gift_Kind__c == 'One Payment'){
                Integer monthDifference = system.today().monthsBetween(objPledges.Gift_Date_Time__c.date());
                if(objPledges.StageName == 'Pledged' && monthDifference >= 6)
                    objPledges.StageName = 'Uncollectible';
            }
            system.debug('#############################ID: ' + objPledges.Id);
            system.debug('###########Gift Date: ' + objPledges.Gift_Date_Time__c);
                system.debug('################ CC EFT Alias ID : ' + objPledges.CC_EFT_Alias__c);
            
            if(objPledges.Id == null || mode=='clone') {
                insert objPledges;
                oppContactRole(objPledges.Id);
            }
            else {
                system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%% MODE : ' + mode);
                if(mode=='edit'){
                    system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%Updating Pledges   ( ' + objPledges.Id + ' )  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                    system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%Updating Pledges contactid   ( ' + objPledges.Oppty_Related_Contact__c + ' )  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
                    update objPledges;
                }
            }
            updatePlannedGiving();
          if(objPledges.Id != null){
                savePartner();
                saveStock();
                saveBenefit();
                for(Opportunity opp:lstChild){
                    opp.Recurring_Donation_Opportunity__c = objPledges.Id;
                    opp.Pricebook2Id = objPledges.Pricebook2Id;
                }
                system.debug('######## no of installment giving : ' + lstChild.size());
                if(lstChild.size()>0){
                    //insert lstChild;
                    Database.SaveResult[] lsr;
                    if(mode == 'edit'){
                        updateChildGiving();
                    }
                    else{
                        lsr = Database.insert(lstChild, false);
                        system.debug('#####' + lsr );
                        Set<Id> createdOppIds = new Set<Id>();
                        for (Database.SaveResult s : lsr)
                        {
                            if ( s.isSuccess() == true ){
                                //get all the new OppIds into a list
                                createdOppIds.add(s.getId());
                                system.debug('###### Child Giving Ids : ' + s.getID());
                            }
                        }   
                   }
                }
                
                blnSuccess = true;
            }else{
                blnSuccess = false;
            }
                Set<ID> setGivingIDs = new Set<ID>();
                if(objPledges.Id != null){
                    setGivingIds.add(objPledges.Id);
                    if(mode=='edit'){
                        rollbackRenewalSummary();
                        ProcessGivingSummary.UpdateSummary(setGivingIds,true);
                    }
                    else
                        ProcessGivingSummary.UpdateSummary(setGivingIds,false);
                }
        }catch(Exception ex){
            blnSuccess = false;
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Save Giving: ' + ex.getMessage())); 
        }
        return blnSuccess;
    }
    void rollbackRenewalSummary(){
        if(oldGiftType != null && oldGiftType.trim() == RENEWAL && objPledges.Gift_Type__c.trim() == ADDGIFT){
            Giving_Summary__c objActiveSummary;
            Giving_Summary__c objHistory;
            List<Giving_Summary__c> lstSummary = this.getGivingSummary();
            if(lstSummary != null && lstSummary.size()>0){
                for(Giving_Summary__c summary: lstSummary){
                    if(summary.History__c == false && objActiveSummary == null){
                        objActiveSummary = summary;
                    }
                    else if(summary.History__c == true && objHistory == null){
                        objHistory = summary;
                    }
                    if(objHistory != null && objActiveSummary != null){
                        break;
                    }
                }
            }
            if(objHistory != null && objActiveSummary != null){
                objHistory.History__c = false;
                objHistory.Summary_Count__c = 0;
                objHistory.History_Date_Time__c = null;
                String CurrentGivingId = String.valueOf(objPledges.Id);
                if(objHistory.GivingIds__c.contains(CurrentGivingId)==false){
                    if(objHistory.GivingIds__c.trim().length()==0){
                        objHistory.GivingIds__c = CurrentGivingId;
                    }
                    else{
                        objHistory.GivingIds__c += '#' + CurrentGivingId;
                    }
                }
                Update objHistory;
                Delete objActiveSummary;
            }
        }
    }
    List<Giving_Summary__c> getGivingSummary(){
        String DeveloperName = CommonApex.getDeveloperNameByCampaignName(objPledges.Campaign_Name__c);
        ID RecordTypeId = null;
        if(DeveloperName != null && DeveloperName.trim().length()>0){
            List<RecordType> lstRc = [Select ID From RecordType Where DeveloperName =: DeveloperName];
            if(lstRc != null && lstRc.size()>0){
                RecordTypeId = lstRc[0].ID;
            }
        }
        
        List<Giving_Summary__c> lstSummary = [Select Id, OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, Account__c, current_fis_yr_amt__c, current_fis_yr_pd__c, current_mem_yr_add_amt__c, current_mem_yr_renew_amt__c, 
        current_mem_yr_renew_date__c, expiration_date__c, first_amt__c, first_date__c, first_source__c, largest_date__c, largest_recent_amt__c, Most_Recent_Giving_Amount__c, Most_Recent_Giving_Date__c, last_fis_yr_amt__c, last_fis_yr_pd__c, start_date__c, total_amt__c, total_pd__c, track__c, Fiscal_Year__c, Station__c, 
        Largest_Giving_Source__c, Shopper__c, Shopper_Count__c, Years_Since_First_Gift__c, Years_Since_Previous_Gift__c, Most_Recent_Giving_Source__c, Most_Recent_Payment_Date__c, Giving_Level__c, Solicitation_Cycle1__c, Member_Yr_Status__c, Grace_Date__c, Lapsed_Period__c, Lapsed_Date__c, Product__c, Total_Member_Yr_Amount__c, 
        History__c, Summary_Count__c, History_Date_Time__c, IsGrace__c, Gift_Type__c, GivingIds__c 
        FROM Giving_Summary__c 
        Where Station__c =:objPledges.Station__c and Account__c =:objPledges.AccountID 
        and RecordTypeId =: RecordTypeId
        Order by CreatedDate desc];    
        
        
        return lstSummary;
    }
    void updatePlannedGiving(){
        if(fromPlannedGiving ==true && objPlanGiving != null){
            Decimal totalGivingAmount = 0.0;
            List<Opportunity> lstopp = [Select Id, Giving_Amount__c From Opportunity
            Where bequest__c =: objPledges.bequest__c];
            if(lstopp != null && lstopp.size()>0){
                for(Opportunity o:lstopp){
                    if(o.Giving_Amount__c != null)
                        totalGivingAmount += o.Giving_Amount__c;
                }
            }
            objPlanGiving.Gift_amount__c = totalGivingAmount;
            update objPlanGiving;
        }
    }
    boolean needToDelete(){
        boolean flag = false;
        system.debug('############## oldGiftType : ' + oldGiftType);
        if(mode == 'edit' && oldGiftType != null){
            String oldType = oldGiftType.trim().toUpperCase();
            String newGiftType = objPledges.Gift_Type__c.trim().toUpperCase();
            system.debug('######### New gift type : ' + newGiftType);
            if((oldType == 'NEW' || oldType == 'RENEWAL' || oldType == 'UPGRADE RESET' || oldType == 'REJOIN') &&
            (newGiftType == 'ADD GIFT' || newGiftType == 'DONATION' || newGiftType == 'PURCHASE')){
            
                flag = true;
            }
        }
        return flag;
    }
    Decimal decimalNVL(decimal val){
        if(val == null)
            return 0;
        else
            return val;
    }
    void saveBenefit(){
        List<OpportunityLineItem> lstLineItemInsert = new List<OpportunityLineItem>();
        List<OpportunityLineItem> lstLineItemUpdate = new List<OpportunityLineItem>();
        Set<ID> benefitIds = new Set<ID>();
        Boolean blnBenefitApplied = false;
        try{
            if(lstOppProduct != null && lstOppProduct.size()>0){
                List<OpportunityLineItem> lstLineItem = new List<OpportunityLineItem>();
                for(OppProduct o:lstOppProduct){
                    OpportunityLineItem item = new OpportunityLineItem();
                    if(o.LineId != null){
                        item = [select id from OpportunityLineItem where Id =: o.LineId];
                    }
                    if(mode != 'edit' && o.LineId == null && o.IsBenefit == true){
                        blnBenefitApplied = true;
                    }
                    item.Street__c = o.Street;
                    item.City__c = o.City;
                    item.State__c = o.State;
                    item.Postal_Code__c = o.Zip;
                    item.Country__c = o.Country;
                    item.Quantity = Decimal.valueOf(o.Quantity);
                    item.Description = o.Description;
                    item.UnitPrice = o.UnitPrice;
                    item.Name__c = o.Name;
                    item.Committed_Number__c = o.CommittedNo;
                    item.IsBenefit__c = o.IsBenefit;
                    //item.TotalPrice = o.TotalPrice;
                    item.Shipping_Method__c = o.ShippingMethod;
                    if(o.LineId == null){
                        item.OpportunityId = objPledges.Id;
                        item.PricebookEntryId = o.PricebookEntryId;
                        lstLineItemInsert.add(item);
                    }
                    if(o.LineId != null){
                        lstLineItemUpdate.add(item);
                    }
                    if(objPledges.Payment_Amount__c != null && objPledges.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                    
                }
                if(lstLineItemInsert.size()>0){
                    system.debug('##### Total Benefits to insert: ' + lstLineItemInsert.size());
                    insert lstLineItemInsert;
                    for(OpportunityLineItem it:lstLineItemInsert){
                        benefitIds.add(it.id);
                    }
                }
                if(lstLineItemUpdate.size()>0){
                    system.debug('##### Total Benefits to update: ' + lstLineItemUpdate.size());
                    update lstLineItemUpdate;
                    for(OpportunityLineItem it:lstLineItemUpdate){
                        benefitIds.add(it.id);
                    }
                }    
           }
                if(mode == 'edit'){
                    List<OpportunityLineItem> lstItem;
                    if(benefitIds != null && benefitIds.size()>0){
                        lstItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: objPledges.Id And Id not in: benefitIds];
                    }else{
                        lstItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: objPledges.Id];
                    }
                    system.debug('########## oldgivingstage : ' + oldGivingStage);
                    system.debug('########## need to delete : ' + needToDelete());
                    if(oldGivingStage != null && (oldGivingStage.trim().toUpperCase() == 'PLEDGED' || needToDelete()==true)){
                        if(lstItem != null && lstItem.size()>0){
                            system.debug('##### Total Benefits to Delete: ' + lstItem.size());
                            //delete lstItem;
                            for(OpportunityLineItem o:lstItem){
                                o.Fulfillment_Status__c = 'Cancelled';
                            }
                            update lstItem;
                        }                    
                    }
                    Map<String, Decimal> mapCodeWithCommitted = New Map<String, Decimal>();
                    if(oldGivingStage != null && oldGivingStage.trim().toUpperCase() != 'PLEDGED'){
                        if(lstItem != null && lstItem.size()>0){
                            for(OpportunityLineItem it:lstItem){
                                if(it.PricebookEntry.ProductCode != null && it.Fulfillment_Status__c != 'Cancelled' &&
                                    (it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMBEN') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMCARD') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMGUIDE'))){
                                    
                                    it.Fulfillment_Status__c = 'Superceded';
                                    Decimal PendingCommitted = 0;
                                    PendingCommitted = decimalNVL(it.Committed_Number__c) - decimalNVL(it.Sent_Number__c);
                                    mapCodeWithCommitted.put(it.PricebookEntry.ProductCode, PendingCommitted);
                                }
                                else{
                                    it.Fulfillment_Status__c = 'Cancelled';
                                }
                            }
                            system.debug('##### Total Benefits to Cancel: ' + lstItem.size());
                            update lstItem;
                        }
                    }
                    if(mapCodeWithCommitted != null && mapCodeWithCommitted.size() > 0){
                        List<OpportunityLineItem> lstOppNumber = [Select Id, PricebookEntry.ProductCode, Committed_Number__c, Sent_Number__c From OpportunityLineItem 
                        Where OpportunityId =: objPledges.Id and Fulfillment_Status__c <> 'Superceded' and Fulfillment_Status__c <> 'Cancelled'];
                        if(lstOppNumber != null && lstOppNumber.size()>0){
                            boolean blnUpdate = false;
                            for(OpportunityLineItem item:lstOppNumber){
                                if(mapCodeWithCommitted.containsKey(item.PricebookEntry.ProductCode)){
                                    Decimal committedNumber = decimalNVL(item.Committed_Number__c);
                                    committedNumber += mapCodeWithCommitted.get(item.PricebookEntry.ProductCode);
                                    item.Committed_Number__c = committedNumber;
                                    blnUpdate = true;
                                }
                            }
                            if(blnUpdate) Update lstOppNumber;
                        }
                    }
                }
                /////////////////////////////////////////////////////////////
                List<Opportunity> lstPreviousGiving = new List<Opportunity>();
                Id PrevGivingId = null;
                String PrevStage = null;
                lstPreviousGiving = [Select Id, StageName From Opportunity 
                Where AccountId =: objPledges.AccountId and id <>:objPledges.Id and
                Station__c =: objPledges.Station__c and Campaign_Name__c =: objPledges.Campaign_Name__c
                Order by createddate desc ];
                
                if(lstPreviousGiving != null && lstPreviousGiving.size()>0){
                    Map<String, Decimal> mapCodeWithCommitted = New Map<String, Decimal>();
                    PrevGivingId = lstPreviousGiving[0].Id;
                    PrevStage = lstPreviousGiving[0].StageName;
                    List<OpportunityLineItem> lstPrevItem;
                    lstPrevItem = [select id, Committed_Number__c, Sent_Number__c, isBenefit__c, Fulfillment_Status__c, PricebookEntry.ProductCode
                            from OpportunityLineItem 
                            where IsBenefit__c = true and OpportunityId =: PrevGivingId and Fulfillment_Status__c != 'Cancelled'];
                            
                    
                    if(PrevStage != null && PrevStage.trim().toUpperCase() == 'PLEDGED' && blnBenefitApplied == true ){
                        if(lstPrevItem != null && lstPrevItem.size()>0){
                            system.debug('##### Total Benefits to Delete: ' + lstPrevItem.size());
                            for(OpportunityLineItem it:lstPrevItem){
                                it.Fulfillment_Status__c = 'Cancelled';
                            }
                            //delete lstPrevItem;
                            update lstPrevItem;
                        }                    
                    }
                    
                    if(PrevStage != null && PrevStage.trim().toUpperCase() != 'PLEDGED' && blnBenefitApplied == true){
                        if(lstPrevItem != null && lstPrevItem.size()>0){
                            for(OpportunityLineItem it:lstPrevItem){
                                if(it.PricebookEntry.ProductCode != null &&
                                    (it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMBEN') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMCARD') ||
                                    it.PricebookEntry.ProductCode.trim().toUpperCase().Contains('MEMGUIDE'))){
                                    
                                    it.Fulfillment_Status__c = 'Superceded';
                                    Decimal PendingCommitted = 0;
                                    PendingCommitted = decimalNVL(it.Committed_Number__c) - decimalNVL(it.Sent_Number__c);
                                    mapCodeWithCommitted.put(it.PricebookEntry.ProductCode, PendingCommitted);
                                }
                                else{
                                    it.Fulfillment_Status__c = 'Cancelled';
                                }
                            }
                            system.debug('##### Total Benefits to Cancel: ' + lstPrevItem.size());
                            update lstPrevItem;
                        }
                    }
                    if(mode != 'edit' && mapCodeWithCommitted != null && mapCodeWithCommitted.size() > 0){
                        List<OpportunityLineItem> lstOppNumber = [Select Id, PricebookEntry.ProductCode, Committed_Number__c, Sent_Number__c From OpportunityLineItem 
                        Where OpportunityId =: objPledges.Id and Fulfillment_Status__c <> 'Superceded' and Fulfillment_Status__c <> 'Cancelled'];
                        if(lstOppNumber != null && lstOppNumber.size()>0){
                            boolean blnUpdate = false;
                            for(OpportunityLineItem item:lstOppNumber){
                                if(mapCodeWithCommitted.containsKey(item.PricebookEntry.ProductCode)){
                                    Decimal committedNumber = decimalNVL(item.Committed_Number__c);
                                    committedNumber += mapCodeWithCommitted.get(item.PricebookEntry.ProductCode);
                                    item.Committed_Number__c = committedNumber;
                                    blnUpdate = true;
                                }
                            }
                            if(blnUpdate) Update lstOppNumber;
                        }
                    }
                }
            
        }Catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
        }
    
    }
    
    void oppContactRole(string OppID ){
        List<OpportunityContactRole> contactRoleInserts = new List<OpportunityContactRole>();
        map <String,Id> contactOppToContactRole = new Map <String,Id> ();
            
        Opportunity[] oppsFromRecurringDontaions = [select id, Oppty_Related_Contact__c from Opportunity where Id =:oppId AND Oppty_Related_Contact__c!=null];
        
        if(oppsFromRecurringDontaions.size()>0){
                Opportunity createdOpp = oppsFromRecurringDontaions[0];
                OpportunityContactRole ocr = new OpportunityContactRole();
                ocr.OpportunityId = OppID;
                ocr.Role = System.Label.RecurringDonationContactRole;
                ocr.IsPrimary = true;
                
                ocr.ContactId = createdOpp.Oppty_Related_Contact__c;
                contactRoleInserts.add(ocr);
                if ( contactRoleInserts.size() == 100 )
                {
                    Database.SaveResult[] osr = Database.insert(contactRoleInserts, false);
                    contactRoleInserts.clear();
                }
        }
        if ( contactRoleInserts.size() > 0 )
        {
            Database.SaveResult[] osr = Database.insert(contactRoleInserts, false);
        }
    }
    void ApplyPayment(){
    }
    

    
    Public PageReference RedirectPage(String URL){
        PageReference P;
        P = new PageReference(URL);
        P.SetRedirect(true);
        Return P;
    }

    Public PageReference AddPremiumBenefit(){
        //getPricebookId()
        return Page.AddPremiumBenefit;
    }     
    

    
    Public List<Package_Item__c> lstProduct{get;set;}
    Public List<OpportunityLineItem> oppProduct{get;set;}
    
    Public void getProduct(){
        system.debug('########### Package Code : ' + objCPRT.Package_Code__c);
        List<Member_Benefits_Control__c>lstMem  = [select id, Membership_Benefit_Package__c , Gift_Type__c, Maximum__c, Minimum_Parent_Pledge_Amt__c,
        Membership_Benefit_Package__r.name
        from Member_Benefits_Control__c
        Where Station__c =: objPledges.Station__c
        and Product__c =: objPledges.Product__c
        and Campaign_Type__c =: objPledges.Campaign_Name__c
        and Package__c =: objCPRT.Package_Code__c];
        Set<ID> memIds = new Set<ID>();
        String PackageName = '';
        if(lstMem != null)system.debug('###### total member benefit records ==> ' + lstMem.size());
        for(Member_Benefits_Control__c mbc:lstMem){
            if(mbc.Gift_Type__c!=null) {
                if(mbc.Gift_Type__c.contains(objPledges.Gift_Type__c)) {
                    if(objPledges.Giving_Amount__c <= mbc.Maximum__c && objPledges.Giving_Amount__c >= mbc.Minimum_Parent_Pledge_Amt__c){
                        memIds.add(mbc.Membership_Benefit_Package__c);
                        PackageName = mbc.Membership_Benefit_Package__r.name;
                        system.debug('#### Member Benefit Control ID: ' + mbc.Id);
                        system.debug('#### Membership Benefit Package: ' + mbc.Membership_Benefit_Package__c);                        
                        system.debug('#### Gift Type: ' + mbc.Gift_Type__c);
                    }
                }
            }
        }
        List<PricebookEntry> lstProduct = new List<PricebookEntry>();
        system.debug('####### member benefit package ==> ' + memIds);
        List<Package_Item__c> lstPackageItem = [Select Id,Item__r.ProductCode, Item__r.name, 
        Item__r.Description, Package__r.name, Package__r.Id, Package__c from Package_Item__c 
        Where Package__c IN:memIds];
        
        Set<ID> ProductIds = new Set<ID>();
        Map<ID,String> mapPackage = new Map<ID, String>();
        if(lstPackageItem.size()>0){
            for(Package_Item__c p:lstPackageItem){
                ProductIds.add(p.Item__c);
                mapPackage.put(p.Item__c, p.Package__r.name);
                
            }
            if(ProductIds.size()>0){
                system.debug('####### Product Ids : ' + ProductIds);
                system.debug('####### Price book id : ' + getPricebookId());
                lstProduct = [Select UnitPrice, ProductCode, Product2Id, Product2.no_of_items__c, 
                Pricebook2Id, Name, Id, Product2.Description
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: getPricebookId()
                and Product2Id in: ProductIds];
            }
        }
        if(mode=='new'){
            //lstOppProduct = new List<OppProduct>();
        }else{
            if(lstOppProduct == null)
                lstOppProduct = new List<OppProduct>();
        }
        Account objAcc = new Account();
        List<Address__c> lstAdd = new List<Address__c>();
        lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
        State__c, Country__c from Address__c 
        where account_household__c =: objPledges.accountId and account_household__c!=null];
        
        List<Account> lstPrefAddress = [select preferred_address__c from account where id =: objPledges.accountId];
        String PreferredAddress = '';
        if(lstPrefAddress.size()>0){
            PreferredAddress = lstPrefAddress[0].preferred_address__c;
        }
        List<Contact> lstContact = [Select name from Contact where id =: objPledges.Oppty_Related_Contact__c];
        String strName = '';
        if(lstContact.size()>0){
            strName = lstContact[0].name;        
        }        
        system.debug('#####Total products : ' + lstProduct.size());
        for(PricebookEntry it:lstProduct){
            OppProduct o = new OppProduct();
            o.selected = false;
            /*if(mapPackage != null && mapPackage.size()>0 && mapPackage.containsKey(it.Product2Id)){
                o.PackageName = mapPackage.get(it.Product2Id);
            }*/
            o.PackageName = PackageName;
            o.IsBenefit = true;
            o.ProductCode = it.ProductCode;//it.Item__r.ProductCode;
            o.ProductName = it.name;//it.Item__r.Name;
            o.Description = it.Product2.Description;//it.Item__r.Description;
            o.PricebookEntryId = it.id;//it.Item__r.Id;
            o.Quantity = 1;
            o.CommittedNo = it.Product2.no_of_items__c;
            o.UnitPrice = it.UnitPrice;
            o.TotalPrice = o.UnitPrice*o.Quantity;
            o.name = strName;
            o.AddressId = objPledges.Account.Preferred_Address__c;
            if(lstAdd.size()>0){
                for(Address__c a:lstAdd){
                    if(a.id == PreferredAddress){
                        o.Street = a.Street_1__c;
                        o.City = a.City__c;
                        o.State = a.State__c;
                        o.Zip = a.Postal_Code__c;
                        o.Country = a.Country__c;
                        o.AddressId = a.id;
                        o.blnOtherAddress = false;
                    }
                }
            }else{
                o.AddressId = 'other';
                o.blnOtherAddress = true;
            }
            lstOppProduct.add(o);
        }
    }
    Public PageReference RemoveProduct(){
        List<OppProduct> lstTemp = new List<OppProduct>();
        if(lstOppProduct != null && lstOppProduct.size()>0){
            for(OppProduct p:lstOppProduct){
                if(p.selected == false){
                    lstTemp.add(p);
                }
            }
        }
        lstOppProduct = new List<OppProduct>();
        if(lstTemp != null && lstTemp.size()>0){
            lstOppProduct = lstTemp;
        }
        return null;
    }
    Public List<OppProduct> lstOppProduct{get;set;}
    Public Class OppProduct{
        Public boolean selected{get;set;}
        Public String PackageName{get;set;}
        Public String PackageId{get;set;}
        Public String LineId{get;set;}
        Public String ProductCode{get;set;}
        Public String ProductName{get;set;}
        Public String Description{get;set;}
        //Public Decimal Quantity{get;set;}
        Public Integer Quantity{get;set;}
        Public String Name{get;set;}
        Public String Street{get;set;}
        Public String City{get;set;}
        Public String State{get;set;}
        Public String Zip{get;set;}
        Public String Country{get;set;}
        Public String ShippingMethod{get;set;}
        Public String PricebookEntryId{get;set;}
        Public Double UnitPrice{get;set;}
        Public Double TotalPrice{get;set;}
        Public String AddressId{get;set;}
        Public String Product2Id{get;set;}
        Public Boolean blnOtherAddress{get;set;}
        Public Decimal CommittedNo{get;set;}
        Public Boolean IsBenefit{get;set;}
    }
    
    Public List<SelectOption> getTributeType(){
        List<SelectOption> TributeType = new List<SelectOption>();
        TributeType.add(new SelectOption('INHONOR','In Honor'));
        TributeType.add(new SelectOption('MEMORIAL','Memorial'));
        return TributeType;
    }
    
    
    Public String selectedAddress{get;set;}
    Public boolean blnOther{get;set;}
    Public PageReference SelectAddress(){
        System.debug('Selected Address: ----> ' + selectedAddress);
        List<Address__c> lstAdd = new List<Address__c>();                
        Set<ID> lstAddId = new Set<ID>();    
        blnOther = false;    
        for(OppProduct prod:lstOppProduct){
            if(prod.AddressId.trim().toLowerCase() != 'other'){
                lstAddId.add(prod.AddressId);
            }
        }        
        lstAdd = [select id, Street_1__c, City__c, State__c, Postal_Code__c, 
        Country__c from Address__c where id IN: lstAddId];
        if(lstAdd != null && lstAdd.size()>0){
            for(Address__c add:lstAdd){
                for(OppProduct prod:lstOppProduct){
                    if(prod.AddressId.trim().toLowerCase() != 'other' && prod.AddressId == add.Id){
                        prod.blnOtherAddress = false;
                        prod.Street = add.Street_1__c;
                        prod.City = add.City__c;
                        prod.Zip = add.Postal_Code__c;
                        prod.Country = add.Country__c;
                        prod.State = add.State__c;
                    }
                }
            }
        }
        for(OppProduct prod:lstOppProduct){
            if(prod.AddressId.trim().toLowerCase() == 'other'){
                if(prod.blnOtherAddress == false){
                    prod.Street = '';
                    prod.City = '';
                    prod.Zip = '';
                    prod.Country = '';
                    prod.State = '';
                }
                prod.blnOtherAddress = true;
            }
        }
        /*
        if(lstAdd.size()>0){
        system.debug('#### Total address found : ' + lstAdd.size());
            for(Address__c add:lstAdd){
                for(OppProduct prod:lstOppProduct){
                    if(prod.AddressId.trim().toLowerCase() == 'other'){
                        blnOther = true;
                        //prod.blnOtherAddress = true;
                        if(prod.blnOtherAddress == false){
                            prod.Street = '';
                            prod.City = '';
                            prod.Zip = '';
                            prod.Country = '';
                            prod.State = '';
                        }
                        prod.blnOtherAddress = true;
                    }
                    else if(prod.AddressId == add.Id){
                        prod.blnOtherAddress = false;
                        prod.Street = add.Street_1__c;
                        prod.City = add.City__c;
                        prod.Zip = add.Postal_Code__c;
                        prod.Country = add.Country__c;
                        prod.State = add.State__c;
                    }
                }
            }
        } 
        */       
        return null;
    }
    
    /////////////////////////////Add product/////////////////////////////////
    
    private List<String> noMatch;
    private List<PricebookEntry> results;
    private List<PricebookEntry> smallresults;
    private String name;
    public String index{get;set;}
    private String value;
    public string getValue(){
        return this.value;
    }  
    private String typeOf;
    
    private String DistributorID='';
    private String MfgAccID='';
    private String EndCustomer='';
    public String pricebook{get;set;}
    //-------------------Property Section ----------------------------//
  
    public void setName(String name){
        this.name = name;
    }
   
    public String getName(){
        return this.name;
    }
    
    public List<PricebookEntry> getSmallResults(){
        return this.smallresults;
    }
  
    public List<String> getNoMatch() {
        return this.noMatch;
    }
  
    public Boolean getShowResults() {
        if(lstResult.size() > 0)
            return true;
        else
            return false;
    }
    
    Public String selectedProducts{get;set;}
    public PageReference cancelAddProduct(){
        //return GoToStep3();
        Return Page.PledgesNewStep3;
    }
    
    Public List<SearchResult> lstResult{get;set;}
    Map<ID,Boolean> mapEligibility = new Map<ID,Boolean>();
    Public Class SearchResult{
        Public Boolean selected{get;set;}
        Public Boolean eligible{get;set;}
        Public String PricebookEntryId{get;set;}
        Public String Product2Id{get;set;}
        Public String Name{get;set;}
        Public String ProductCode{get;set;}
        Public String Description{get;set;}
        Public Decimal UnitPrice{get;set;}
        Public Decimal ItemNo{get;set;}
        Public String RecordType{get;set;}
        Public String PackageName{get;set;}
        Public Boolean IsPackage{get;set;}
    }
    public PageReference addProduct(){
        try{
            if(mode=='new' && (lstOppProduct == null || lstOppProduct.size()<=0)){
                lstOppProduct = new List<OppProduct>();
            }else{
                if(lstOppProduct == null)
                    lstOppProduct = new List<OppProduct>();
            }
            List<Account> lstPrefAddress = [select preferred_address__c from account where id =: objPledges.accountId];
            String PreferredAddress = '';
            if(lstPrefAddress.size()>0){
                PreferredAddress = lstPrefAddress[0].preferred_address__c;
            }
            List<Address__c> lstAdd = new List<Address__c>();
            lstAdd = [select id, name, Street_1__c, City__c, Postal_Code__c, 
            State__c, Country__c from Address__c 
            where account_household__c =: objPledges.accountId and account_household__c!=null];
            
            List<Contact> lstContact = [Select name from Contact where id =: objPledges.Oppty_Related_Contact__c];
            String strName = '';
            if(lstContact.size()>0){
                strName = lstContact[0].name;        
            }
            Set<ID> packageIds = new Set<ID>();
            Map<ID, String> mapPackageName = new Map<ID, String>();
            if(lstResult != null && lstResult.size()>0){
                for(SearchResult result:lstResult){
                    if(result.selected == true){
                        OppProduct o = new OppProduct();
                        if(result.IsPackage == false){
                            o.ProductCode = result.ProductCode;//it.Item__r.ProductCode;
                            o.ProductName = result.name;//it.Item__r.Name;
                            o.Description = result.Description;//it.Item__r.Description;
                            o.PricebookEntryId = result.PricebookEntryId;//it.Item__r.Id;
                            o.Quantity = 1;
                            o.UnitPrice = result.UnitPrice;
                            o.TotalPrice = o.UnitPrice*o.Quantity;
                            o.name = strName;
                            o.IsBenefit = false;
                            o.CommittedNo = result.ItemNo;
                            o.AddressId = objPledges.Account.Preferred_Address__c;
                            if(lstAdd.size()>0){
                                for(Address__c a:lstAdd){
                                    if(a.id == PreferredAddress){
                                        o.Street = a.Street_1__c;
                                        o.City = a.City__c;
                                        o.State = a.State__c;
                                        o.Zip = a.Postal_Code__c;
                                        o.Country = a.Country__c;
                                        o.AddressId = a.id;
                                        o.blnOtherAddress = false;
                                    }
                                }
                            }   
                            else{
                                o.AddressId = 'other';
                                o.blnOtherAddress = true;
                            }        
                            lstOppProduct.add(o);  
                        }else{
                            packageIds.add(result.Product2Id);
                            system.debug('######### This is a package : ' + result.PackageName);
                            //mapPackageName.put(result.Product2Id, result.PackageName);
                        } 
                    }
                }
                
                if(packageIds != null && packageIds.size()>0){
                
                
                
                    List<PriceBookEntry> lstItem = [ select id,  Name, ProductCode, Product2.Description, 
                    Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                    from PricebookEntry where Pricebook2Id =: getPricebookId() and IsActive = true 
                    and Product2ID in(Select Item__c from Package_Item__c Where Package__c In:packageIds)
                    order by Name limit 100];
                    
                    List<Package_Item__c> lstPackageName = [Select Package__r.Name, Item__c from Package_Item__c Where Package__c in:packageIds];
                    if(lstPackageName != null && lstPackageName.size()>0){
                        for(Package_Item__c p:lstPackageName){
                            mapPackageName.put(p.Item__c, p.Package__r.Name);
                        }
                    }                    
                    if(lstItem != null && lstItem.size()>0){
                        
                        //List<Package_Item__c> lstPackage = [Select Item__c, Package__r.Name From Package_Item__c where Package__c in:packageIds];
                        system.debug('######### lstItem : ' + lstItem);
                        system.debug('######### mapPackageName : ' + mapPackageName);
                        
                        for(PricebookEntry result2:lstItem){
                            OppProduct o2 = new OppProduct();
                            o2.ProductCode = result2.ProductCode;
                            o2.ProductName = result2.Name;
                            o2.Description = result2.Product2.Description;
                            o2.PricebookEntryId = result2.Id;//it.Item__r.Id;
                            o2.Quantity = 1;
                            o2.UnitPrice = result2.UnitPrice;
                            o2.TotalPrice = o2.UnitPrice*o2.Quantity;
                            o2.name = strName;
                            o2.IsBenefit = false;
                            o2.CommittedNo = result2.Product2.no_of_items__c;
                            o2.AddressId = objPledges.Account.Preferred_Address__c;
                            
                            system.debug('########## mapPackageName : ' + mapPackageName);
                            system.debug('########## Pricebook id : ' + result2.id);
                            system.debug('########## product2 id: ' + result2.Product2.Id);
                            if(mapPackageName != null && mapPackageName.size()>0 && mapPackageName.containsKey(result2.Product2.Id)){
                                o2.PackageName = mapPackageName.get(result2.Product2.Id);
                            }
                            
                            if(lstAdd.size()>0){
                                for(Address__c a:lstAdd){
                                    if(a.id == PreferredAddress){
                                        o2.Street = a.Street_1__c;
                                        o2.City = a.City__c;
                                        o2.State = a.State__c;
                                        o2.Zip = a.Postal_Code__c;
                                        o2.Country = a.Country__c;
                                        o2.AddressId = a.id;
                                        o2.blnOtherAddress = false;
                                    }
                                }
                            }   
                            else{
                                o2.AddressId = 'other';
                                o2.blnOtherAddress = true;
                            }        
                            lstOppProduct.add(o2);                                                                                                                  
                        }
                    }
                 }                
                
                
            }
            Return Page.PledgesNewStep3;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,ex.getMessage()));
            return null;
        }                    
    }
    public PageReference searchProduct() {
        smallresults = new List<PricebookEntry>();
        system.debug('###################SearchProduct');
        noMatch = new List<String>();
        noMatch.add('No Matches Found.');
        pricebook = getPricebookId();
        if(name != null && name.length() > 0) {
            string sName = name + '%';
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description, Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                        from PricebookEntry where (Name like :sName or ProductCode like :sName or Product2.Description like :sName) 
                        and Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
        }else{
            results = (List<PricebookEntry>)[ select id,  Name, ProductCode, Product2.Description, Product2.RecordType.DeveloperName, UnitPrice, Product2.Id, Product2.no_of_items__c
                        from PricebookEntry where Pricebook2Id =: pricebook and IsActive = true order by Name limit 100];
        }             
        lstResult = new List<SearchResult>();
        getEligibility();
        system.debug('###############mapEligibility ' + mapEligibility);
        if(results != null && results.size()>0){
            for(PricebookEntry p:results){
                SearchResult res = new SearchResult();
                res.selected = false;
                if(mapEligibility != null && mapEligibility.size()>0 && mapEligibility.containsKey(p.Product2.Id)){
                    res.eligible = mapEligibility.get(p.Product2.Id);
                }
                else{
                    res.eligible = true;
                }
                res.PricebookEntryId = p.Id;
                res.Product2Id = p.Product2.Id;
                res.Name = p.Name;
                res.ProductCode = p.ProductCode;
                res.Description = p.Product2.Description;
                res.UnitPrice = p.UnitPrice;
                res.ItemNo = p.Product2.no_of_items__c;
                
                res.RecordType = p.Product2.RecordType.DeveloperName;
                res.PackageName = p.Name;
                if(res.RecordType == 'Package'){
                    res.IsPackage = true;
                    system.debug('######### Package Name: ' + p.name);
                }
                else{
                    res.IsPackage = false;
                    system.debug('######### Item Name: ' + p.name);
                }
                
                lstResult.add(res);
            }
        }
        return null;
    }
    void getEligibility(){
        boolean eligible = true;
        Set<ID> productIds = new Set<ID>();
        String strMessage = '';
        List<String> lstInEligibleBenefit = new List<String>();
        if(results != null && results.size() > 0 && objPledges != null){
            for(PricebookEntry p:results){
                productIds.add(p.Product2.Id);
                mapEligibility.put(p.Product2.Id,true);
            }
            lstInEligibleBenefit = commonApex.checkBenefitEligibility(objPledges,productIds);
            system.debug('#######lstInEligibleBenefit : ' + lstInEligibleBenefit);
            if(lstInEligibleBenefit != null && lstInEligibleBenefit.size()>0){
                for(String s:lstInEligibleBenefit){
                    if(mapEligibility != null && mapEligibility.size()>0){
                        if(mapEligibility.containsKey(ID.valueOf(s))){
                            mapEligibility.put(ID.valueOf(s),false);
                        }
                    }
                }
            } 
        }
    }
    
    /**Ketan A Benegal - Code Start
       05/17/2011
       Creates the xml that is posted to Sage.
    */
   /**********EFT PROCESSING***************************************************************/
   public String strBankAccNo{get;set;}
   public String strRoutingNo{get;set;}
   public String strAccType{get;set;}
   public String strEFTGuid{get;set;}
   public String strBankName{get;set;}
   Public List<CC_Alias__c> lstExistingEFT{get{return getExistingEFTInfo();}set;} 
   public void createEFTGuid(){
        SageTransactionProcess stp = new SageTransactionProcess();
        String strObjId;
/*        String strObjId = this.insertObjCCAlias();*/
        String strXmlResponse ;
//        if(strObjId instanceof ID){
            System.debug('#####Station: '+ objPledges.Station__c);
            strEFTGuid = stp.createEFTGuid(this.strRoutingNo,  this.strBankAccNo, this.strAccType, objPledges.Station__c);
            //strXmlResponse = stp.createEFTGuid(this.strRoutingNo,  this.strBankAccNo, this.strAccType, objPledges.Station__c);
//        }
//        if (strXmlResponse != null){
//            strEFTGuid = stp.checkCreateGuidResponse(strXmlResponse, strObjId);
            System.debug('########strBankAccNo:' + strBankAccNo+ '   #####strXmlResponse:'+strXmlResponse);
//        }
   }
   public void getEFTResponseInformation(){
    String strObjId = this.insertObjCCAlias();
    if(strObjId instanceof ID){
        this.objPledges.CC_EFT_Alias__c = strObjId;
        System.debug('######this.objPledges.Id:'+ this.objPledges.Id + '   ############# this.objPledges.CC_EFT_Alias__c: '+ this.objPledges.CC_EFT_Alias__c);
        Opportunity objCurrPledge = [Select CC_EFT_Alias__c, Id from Opportunity where Id = :objPledges.Id];
        objCurrPledge.CC_EFT_Alias__c = strObjId;
        update objCurrPledge;
        System.debug('#########objCurrPledge.CC_EFT_Alias__c:'+ objCurrPledge.CC_EFT_Alias__c);
//      update this.objPledges;
    }
    System.debug('###########strObjId:'+ strObjId);
   }
   private String insertObjCCAlias(){
            CC_Alias__c objCCAlias = new CC_Alias__c();

        if (this.SavePledge()){
            System.debug('Calling save');
            String strHouseHoldId = this.objHousehold.Id;
           objCCAlias.Account__c = this.objHousehold.Id;
           objCCAlias.Contact__c = this.objContact.Id;
           objCCAlias.TransactionID__c = this.objPledges.Id; 
           //Insert Merchant Account
           List<Merchant_Accounts__c> lMerchID = [Select Id from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
           objCCAlias.Merchant_Account__c = lMerchId[0].Id;
           objCCAlias.GUID__c = strEFTGuid;
           objCCAlias.Bank_Account_Owner_Name__c = strCardHolderName;
           objCCAlias.Bank_Name__c = strBankName;
           objCCAlias.Payment_Method__c = 'Electronic Funds Transfer'; 
          //to get the child pledges use lstChild.
            this.strPledgeId = this.objPledges.Id;
            System.debug('insertObjCCAlias householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
            upsert objCCAlias;
           System.debug('######objCCAlias.Id:'+ objCCAlias.Id);
            return objCCAlias.Id;
        }
        return null;
   }
   public List<CC_Alias__c> getExistingEFTInfo(){
        lstChargeCard = new List<CC_Alias__c>();
        system.debug('getExistingEFTInfo ###### AccountID : ' +  objPledges.AccountId + ' and Contact__c : ' + objPledges.Oppty_Related_Contact__c );
        lstChargeCard = [SELECT AVSResult__c, Account__c, Amount__c, AuthCode__c, Bank_Account_Owner_Name__c, Bank_Account_Type__c, Bank_Name__c, Name, CVVResult__c, Card_Holder_Name__c, Card_Type__c, Contact__c,  IsDeleted, Do_Not_Use__c, Expire_Date__c, GUID__c, Last_Four_Digits__c, Merchant_Account__c, OwnerId, Payment_Description__c, Payment_ID__c, PaymentTypeID__c, Id, RecordTypeId, Response__c, ResponseCode__c, ResponseIndicator__c, ResponseMessage__c,  TransactionID__c, VANReference__c, Payment_Method__c from CC_Alias__c where Account__c =: objPledges.AccountId and Contact__c =: objPledges.Oppty_Related_Contact__c and Payment_Method__c = 'Electronic Funds Transfer'];
        
        List<CC_Alias__c> lstReturn = new List<CC_Alias__c>();
        
        CC_Alias__c temp = new CC_Alias__c();
        //temp.Card_Type__c = 'New';
        lstReturn.add(temp);
        
        for(CC_Alias__c e: lstChargeCard) {
            lstReturn.add(e);
        }

        return lstReturn;
    }
   /*************************************************************************/
    public class ApplicationException extends Exception{}
    public boolean displaySageHtml{get;set;}
    public boolean bDisplayNewCard{get;set;}
    public String strDisplayInformation{get{   return '<br/> Card Holder Name:' + this.strCardHolderName + '<br/> Giving Amount:' + this.objPledges.Giving_Amount__c + '<br/> Card Type:' + this.objPledges.Charge_Card_Type__c;} set;}
    public void setDisplayStatus(){
        if (objPledges.Charge_Card_Type__c != null){
            bDisplayNewCard = true;
        }
        return;
    }
    public void showSageHtml(){
        System.debug('inside show');
        this.displaySageHtml = true;
    }
    public void hideSageHtml(){
        System.debug('inside hide');
        this.displaySageHtml = false;
    }
   public String strCardHolderName{get;set;}
    public String strOutPut{get{return getOutPutString();} set;}
    //string contains preferred address for display on sagehtml.
   public String strPreferredAddress{get{
    if (this.objContact != null){
        if (this.objContact.Preferred_Address__c != null){
            return '<br/> Street1: ' + this.objContact.Preferred_Address__r.Street_1__c + '<br/> Street 2:'+ this.objContact.Preferred_Address__r.Street_2__c + '<br/> City:' + this.objContact.Preferred_Address__r.City__c + '<br/> State:' + this.objContact.Preferred_Address__r.State__c + '<br/> Country:' + this.objContact.Preferred_Address__r.Country__c;
        }
    }
    return null;
   }set;}
   
    public String getVaultId(){
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        String strVaultId1 = this.objHousehold.Id ;
        strVaultId1 +=  this.objPledges.Id;
        System.debug('vaultid:' + strVaultId1 + '  householdid:' + this.objHousehold.Id + '   pledgeid:' + this.objPledges.Id );
        return strVaultId1;
    }
   
   public String getOutPutString(){
        System.debug('getOutPutString 111');
        return createGUID();
     }

     /*This function is used to create the get parameters while calling the SageHtml page.*/
    public PageReference soapPost2(){
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        System.debug('SoapPost2 111');
        CC_Alias__c objCCAlias = new CC_Alias__c();

        if(this.objPledges.Charge_Card_Type__c == '' || this.objPledges.Charge_Card_Type__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the card type.')); 
            return null;
        }
        if(this.strCardHolderName == '' || this.strCardHolderName == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter card holder\'s name.')); 
            return null;
        }

        if (this.SavePledge()){
            System.debug('Calling save');
            String strHouseHoldId = this.objHousehold.Id;
           objCCAlias.Account__c = this.objHousehold.Id;
           objCCAlias.Contact__c = this.objContact.Id;
           objCCAlias.TransactionID__c = this.objPledges.Id;
           objCCAlias.Payment_Method__c = this.objPledges.Payment_Method__c; 
           objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
           objCCAlias.Card_Holder_Name__c = strCardHolderName;
           //Insert Merchant Account
           Merchant_Accounts__c lMerchID = [Select Id from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
           objCCAlias.Merchant_Account__c = lMerchId.Id;
           objCCAlias.GUID__c = null;
          //to get the child pledges use lstChild.
            this.strPledgeId = this.objPledges.Id;
            System.debug('SoapPost2 householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
            insert objCCAlias;
            System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
            return Page.SageHtml;
        }
        
        return null;
        
    }

     /*This function is used to create the get parameters while calling the SageHtml in a popup.*/
    public void soapPost3(){
    //Check if displaySageHtml is false, then process. To prevent the user from clicking process payment button twice.  
    if (this.displaySageHtml != true){
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        System.debug('SoapPost3 111');
        CC_Alias__c objCCAlias = new CC_Alias__c();

        if(this.objPledges.Charge_Card_Type__c == '' || this.objPledges.Charge_Card_Type__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select the card type.')); 
            return;
        }
        if(this.strCardHolderName == '' || this.strCardHolderName == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter card holder\'s name.')); 
            return;
        }

        if (this.SavePledge()){
            System.debug('Calling save');
            String strHouseHoldId = this.objHousehold.Id;
           objCCAlias.Account__c = this.objHousehold.Id;
           objCCAlias.Contact__c = this.objContact.Id;
           objCCAlias.TransactionID__c = this.objPledges.Id;
           objCCAlias.Payment_Method__c = this.objPledges.Payment_Method__c; 
           objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
           objCCAlias.Card_Holder_Name__c = strCardHolderName;
           //Insert Merchant Account
           Merchant_Accounts__c lMerchID = [Select Id from Merchant_Accounts__c where Station__c = :objPledges.Station__c limit 1];
           objCCAlias.Merchant_Account__c = lMerchId.Id;
           objCCAlias.GUID__c = null;
          //to get the child pledges use lstChild.
            this.strPledgeId = this.objPledges.Id;
            System.debug('SoapPost2 householdId:' + strHouseHoldId + '   MerchantId:'+ objCCAlias.Merchant_Account__c); 
            insert objCCAlias;
           System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        }
        showSageHtml();
    }   
        return;
    }

    public String createGUID(){
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId );
        String strVaultId2 = getVaultId();
        System.debug('CreateGuid strVaultId :' + strVaultId2 );
       CC_Alias__c objCCAlias = [Select c.Payment_Method__c, c.VANReference__c, c.TransactionID__c, c.SystemModstamp, c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, c.RecordTypeId, c.Payment_ID__c, c.Payment_Description__c, c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Merchant_Account__r.Merchant_ID__c, c.Merchant_Account__r.Merchant_Key__c, c.Last_Four_Digits__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.Card_Type__c, c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c From CC_Alias__c c where c.Account__c = :objPledges.AccountId and c.Contact__c = :objContact.Id and c.Payment_Method__c = 'Charge Card' and c.GUID__c = null LIMIT 1];
        // Merchant ID and Merchant Key will change based on the station for which the pledge is created.
       String strMerchantId = objCCAlias.Merchant_Account__r.Merchant_ID__c;
       String strMerchantKey = objCCAlias.Merchant_Account__r.Merchant_Key__c;
            String value='<input type="hidden" name="request" value="<?xml version=&quot;1.0&quot; encoding=&quot;utf-16&quot;?>';
            value += '<Request_v1 xmlns:xsi=&quot;http://www.w3.org/2001/XMLSchema-instance&quot; xmlns:xsd=&quot;http://www.w3.org/2001/XMLSchema&quot;>';
            value += '<Application><ApplicationID>ROUNSALE2011000CRMTAAF8USEN</ApplicationID><LanguageID>EN</LanguageID></Application>';
            value += '<VaultOperation><Merchant><MerchantID>'+ strMerchantId +'</MerchantID><MerchantKey>'+ strMerchantKey +'</MerchantKey></Merchant><VaultStorage><Service>CREATE</Service></VaultStorage><VaultID>' + strVaultId2 +'</VaultID></VaultOperation></Request_v1>" />';
        System.debug('createguid value:' + value);
       System.debug('PledgeId: ' + objPledges.Id+ '***********************************'+ objPledges.AccountId + '----'+ this.objPledges.Pledge_number__c);
       return value;      
    }
    public String strPledgeId{get; set;}
    
    public void getVaultResponseInformation(){
       System.debug('PledgeId: ' + this.objPledges.Id + '***********************************'+ this.objPledges.AccountId + '----'+ this.objPledges.Pledge_number__c);
       CC_Alias__c objCCAlias = [Select c.Payment_Method__c, c.VANReference__c, c.TransactionID__c, c.SystemModstamp, c.Response__c, c.ResponseMessage__c, c.ResponseIndicator__c, c.ResponseCode__c, c.RecordTypeId, c.Payment_ID__c, c.Payment_Description__c, c.PaymentTypeID__c, c.OwnerId, c.Name, c.Merchant_Account__c, c.Merchant_Account__r.Merchant_ID__c, c.Merchant_Account__r.Merchant_Key__c, c.Last_Four_Digits__c, c.LastModifiedDate, c.LastModifiedById, c.IsDeleted, c.Id, c.GUID__c, c.Expire_Date__c, c.Do_Not_Use__c, c.CreatedDate, c.CreatedById, c.Contact__c, c.Card_Type__c, c.Card_Holder_Name__c, c.CVVResult__c, c.Bank_Name__c, c.Bank_Account_Type__c, c.Bank_Account_Owner_Name__c, c.AuthCode__c, c.Amount__c, c.Account__c, c.AVSResult__c From CC_Alias__c c where c.Account__c = :objPledges.AccountId and c.Contact__c = :objContact.Id and c.Payment_Method__c = 'Charge Card' and c.GUID__c = null LIMIT 1];
       if(objCCAlias != null){
           Opportunity objCurrentPledge = [Select o.ta_campaign_value__c, o.ta_campaign__c, o.systemHouseholdContactRoleProcessor__c, o.source__c, o.schedule_start_date__c, o.purpose__c, o.project_del__c, o.program__c, o.pledge_number__c, o.pledge_amount__c, o.payments_in_schedule__c, o.payment_number__c, o.payment_method__c, o.payment_frequency__c, o.payment_amount__c, o.new_install_ment_date__c, o.installment_amount__c, o.gift_type__c, o.gift_kind__c, o.fund__c, o.effort__c, o.caller__c, o.bulk_load__c, o.bequest__c, o.batch_process_count__c, o.batch_number__c, o.alt_transaction_id__c, o.Type, o.Tribute_Type__c, o.Tribute_Name__c, o.Tribute_Flag__c, o.Tribute_Description__c, o.TrackingNumber__c, o.Total__c, o.TotalOpportunityQuantity, o.TA_Account_ID__c, o.SystemModstamp, o.Support_Designation__c, o.Station__c, o.StageName, o.Source_Code__c, o.Solicitation_Type__c, o.Schedule_Type__c, o.SFDC_Opportunity_ID__c, o.SFDC_GIVING_NUMBER__c, o.Revenue_Date__c, o.Restricted__c, o.Response_Mechanism__c, o.Remove_Opportunity__c, o.Reminder_Sent__c, o.Reminder_Sent_Date__c, o.Refused_Reason__c, o.Refund_Type__c, o.Recurring_Donation_Opportunity__c, o.RecordTypeId, o.Product__c, o.Probability, o.Pricebook2Id, o.Payment_Method_Description__c, o.Payment_Date__c, o.Parent_Giving_Stage__c, o.OwnerId, o.Override_Gift_Type__c, o.OrderNumber__c, o.Oppty_Related_Contact__c, o.NextStep, o.New_Balance__c, o.Name, o.Matching_Gift__c, o.Matching_Gift_Status__c, o.Matching_Company__c, o.MainCompetitors__c, o.LeadSource, o.Last_Payment_Date__c, o.Last_Payment_Date_1_Year__c, o.Last_Payment_Date_18_Month__c, o.LastModifiedDate, o.LastModifiedById, o.LastActivityDate, o.IsWon, o.IsPrivate, o.IsDeleted, o.IsClosed, o.Installments__c, o.Installment_Period__c, o.Id, o.HasOpportunityLineItem, o.Giving_Segment__c, o.Giving_Amount__c, o.Gift_Date_Time__c, o.Gift_Date_6_Month__c, o.Gift_Date_3_Month__c, o.Gift_Date_18_Month__c, o.Fund_Lookup__c, o.Foundation_Pay__c, o.Foundation_Name__c, o.ForecastCategoryName, o.ForecastCategory, o.FiscalYear, o.FiscalQuarter, o.Fiscal, o.ExpectedRevenue, o.Description, o.DeliveryInstallationStatus__c, o.CurrentGenerators__c, o.CreatedDate, o.CreatedById, o.Contact_Id_for_Role__c, o.CombinedRollupFieldset__c, o.Closed_Lost_Reasons__c, o.Close_Month__c, o.CloseDate, o.Charge_Card_Type__c, o.Campaign_Type__c, o.Campaign_Name__c, o.CampaignId, o.CC_EFT_Alias__c, o.Benefit_Counts__c, o.Anonymous__c, o.Amount, o.Ack_Sent__c, o.Ack_Sent_Date__c, o.AccountId From Opportunity o where o.Id = :objCCAlias.TransactionID__c];
           this.objPledges = objCurrentPledge;
           String strMerchantId = objCCAlias.Merchant_Account__r.Merchant_ID__c;
           String strMerchantKey = objCCAlias.Merchant_Account__r.Merchant_Key__c;
           String strVaultId3 = objCCAlias.Account__c; 
           strVaultId3 += objCCAlias.TransactionID__c;
           objCCAlias.TransactionID__c = strVaultId3; 
           System.debug('*********************************** ' + strVaultId3);     
           HttpRequest req = new HttpRequest();
           req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
           req.setEndpoint('https://www.sagevault.com/VirtualPaymentTerminal/frmPayment.aspx');
           req.setMethod('POST');
            
           String value = '<?xml version="1.0" encoding="utf-16"?><Request_v1 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">';
           value += '<Application><ApplicationID>ROUNSALE2011000CRMTAAF8USEN</ApplicationID><LanguageID>EN</LanguageID></Application>';
           value += '<VaultStatusQuery><Merchant><MerchantID>'+ strMerchantId +'</MerchantID><MerchantKey>'+ strMerchantKey +'</MerchantKey></Merchant><VaultID>'+ strVaultId3 +'</VaultID></VaultStatusQuery></Request_v1>';
            System.debug('POSTRESPONSE request string:' + value);
           String encodedValue = EncodingUtil.urlEncode(value, 'UTF-8');            
           req.setBody('request='+ encodedValue);
           System.debug(req.getBody());
           Http http = new Http();
           HTTPResponse res = http.send(req);
           Dom.Document doc = res.getBodyDocument();
           //get root element
           Dom.Xmlnode rootNode = doc.getRootElement();
           //traverse the xml
           for(Dom.Xmlnode body : rootNode.getChildElements()){
                 for(Dom.XMLNode child : Body.getChildElements()) {
                    for(Dom.XMLNode subchild : child.getChildElements()) {
                        System.debug('Node Info: '+ subchild.getName()+'---' + subchild.getText());
                        if (subchild.getName() == 'GUID'){
                            objCCAlias.GUID__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'ExpirationDate'){
                            objCCAlias.Expire_Date__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'Last4'){
                            objCCAlias.Last_Four_Digits__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'PaymentDescription'){
                            objCCAlias.Payment_Description__c = subchild.getText();
                            continue;
                        } 
                        if (subchild.getName() == 'PaymentTypeID'){
                            objCCAlias.PaymentTypeID__c = subchild.getText();
                            continue;
                        } 
                        
                    }
                }      
           }
    /*       objCCAlias.Account__c = this.objHousehold.Id;
           objCCAlias.Contact__c = this.objContact.Id;
           objCCAlias.TransactionID__c = strVaultId3;
    */       
          objCCAlias.Card_Type__c = this.objPledges.Charge_Card_Type__c;
           update objCCAlias;
           this.objPledges.CC_EFT_Alias__c = objCCAlias.Id;
           objCurrentPledge.CC_EFT_Alias__c = objCCAlias.Id;
           update objCurrentPledge;
           //hide the popup.
           hideSageHtml();
           //Clear the text box of Card Holder Name.
           this.strCardHolderName = '';
       } 
     
//       System.debug('Response:  toString: ' +res.toString()+ '   getStatus/Code: '+ res.getStatusCode()+ ' --' + res.getStatus() + '    Body:' + res.getBody());
//       System.Debug('Body Document: ' + res.getBodyDocument().toXmlString());
       
          //get the list of header names (keys)
/*        string[] headerkeys = res.getHeaderKeys();
        for(string s : headerkeys){
           system.debug('header: ' + s  );
           if (s != null){
            System.debug(' value: ' + res.getHeader(s));
           } 
        }*/
             System.debug('Leaving PostResponse ');     
    }


    /**Ketan A Benegal - Code End */
        
    static testMethod void PledgesNewStep() {
        Account a = new Account(Name = 'Test');
        insert a;
        
        Contact cont = new Contact(LastName = 'TestLast',AccountId = a.Id);
        insert cont;
        
        Campaign c = new Campaign(Name = 'Test');
        c.Station__c = 'WGBH';
        c.Campaign_Name__c = 'Annual';
        Insert c;
        
        RecordType r = [select id from RecordType where DeveloperName = 'Annual' limit 1];
        
        Opportunity opp2 = New Opportunity();
        opp2.AccountID = a.Id;
        opp2.Name = 'Test';
        opp2.CloseDate = system.Today().AddDays(15);
        opp2.StageName = 'Pledged';
        opp2.CampaignID = c.Id;
        opp2.RecordTypeId = r.id;
        insert opp2;
        
        Ticker_Symbol__c tsym = New Ticker_Symbol__c();
        tsym.Active__c = true;
        tsym.Company_Name__c = 'Test Company';
        insert tsym;
        
       /* Stock__c stock2 = New Stock__c();
        stock2.High__c = 20;
        stock2.Number_of_Shares__c = 55;
        stock2.Ticker_Symbol__c = tsym.Id;
        stock2.Giving__c = opp2.Id;
        insert opp2;*/
        
        
        Opportunity opp = New Opportunity();
        ApexPages.StandardController controller = new ApexPages.StandardController(opp);
        ApexPages.CurrentPage().getParameters().put('New','1');
        ApexPages.CurrentPage().getParameters().put('RecordType',r.id);
        ApexPages.CurrentPage().getParameters().put('retURL','%2F' + a.id);
        PledgesNewStep clsTest = new PledgesNewStep(controller);
        clsTest.getAccountContacts();
        clsTest.getExistingChargeCard();
        clsTest.getGivingSegment();
        clsTest.getOverrideGiftType();
        clsTest.getShippingMethod();
        clsTest.QueryStrings();
        //clsTest.ApplyGiftType();
        clsTest.getId();
        clsTest.generatePledgeName();
        clsTest.setContactDetail();
        clsTest.setHouseholdDetail();
        clsTest.AddNewStockLine();
        clsTest.objPledges.CampaignId = c.Id;
        clsTest.SelectCampaign();
        clsTest.selecTickerSymbol();
        
        
        clsTest.objPledges.Gift_Date_Time__c = System.now();
        clsTest.objPledges.Schedule_Start_Date__c = System.today();
        clsTest.objPledges.Foundation_Pay__c=true;
        clsTest.objPledges.Foundation_Name__c = 'test';
        clsTest.objPledges.Matching_Gift__c = true;
        clsTest.objPledges.Matching_Company__c = a.Id;
        clsTest.objPledges.Giving_Amount__c = 600;
        clsTest.objPledges.gift_kind__c = 'INSTALLMENT';
        clsTest.objPledges.payment_frequency__c = 'MONTHLY';
        clsTest.objPledges.stagename = 'Pledged';
        clsTest.objPledges.Payment_Method__c = 'stock';
                
        clsTest.ProcessStep1();
        //clsTest.reCalculateStartDate();
        clsTest.getResponseMechanism();
        clsTest.getChargeCardInformation();
        clsTest.setInstallment();
        clsTest.ChoosePaymentMode();
        clsTest.getPricebookId();
        
        
        clsTest.searchProduct();
        clsTest.Save();
        clstest.GoToStep3();
        clstest.GoToStep4();
        clstest.PreviousFromStep3();
        clstest.GoToStep2();
        clstest.SaveAndPayment();
        clstest.Cancel();
        clstest.AddPremiumBenefit();
        clstest.getProduct();
        
        clstest.setName('test');
        clstest.getName();
        clsTest.getSmallResults();
        clstest.getNoMatch();
        clsTest.getShowResults();
        clsTest.cancelAddProduct();
        clsTest.addProduct();
        clsTest.ApplyGiftType();
        clsTest.GoToStep1();
        try{
            clsTest.setChildValues('');
        }
        catch(Exception ex){}
        clsTest.reCalculateStartDate();
        clsTest.generateName(system.today(),1,1);
        clsTest.NewChargeCode();
        clsTest.getTributeType();
        clsTest.getShipToAddress();
        clsTest.LoadPlannedGiving();
        clsTest.SaveAndNew();
        clsTest.getShipToAddress();
        clsTest.editChildValues();
        //cls.Test.generateName(system.today(),1,1);
        test.startTest();
        clsTest.NewChargeCode();
        clsTest.getValue();
        clsTest.getExistingEFTInfo();
        clsTest.getVaultId();
        clsTest.initializeStock();
        try {
            clsTest.getOutPutString();
        }Catch(Exception ex){}

        Try{
            clsTest.soapPost2();
        }Catch(Exception ex){}

        Try {
            clsTest.createGUID();
        } Catch(Exception ex){}
        
        Try {        
            clsTest.getVaultResponseInformation();
        } Catch(Exception ex){}
        
        Try {
            clstest.SelectAddress();
        } Catch(Exception ex){}
        
        test.StopTest();
        
        
        ApexPages.StandardController controller2 = new ApexPages.StandardController(opp2);
        ApexPages.CurrentPage().getParameters().put('clone','1');
        ApexPages.CurrentPage().getParameters().put('id',opp2.id);
        ApexPages.CurrentPage().getParameters().put('RecordType',r.id);
        ApexPages.CurrentPage().getParameters().put('retURL',a.id);
        clsTest.retURL();
        clsTest.defaultSettings();
        ApexPages.CurrentPage().getParameters().put('retURL',cont.id);
        clsTest.retURL();
        clsTest.defaultSettings();
        ApexPages.CurrentPage().getParameters().put('retURL',c.id);
        clsTest.retURL();
        clsTest.defaultSettings();
        //PledgesNewStep clsTest2 = new PledgesNewStep(controller2);
        
        
    }
}