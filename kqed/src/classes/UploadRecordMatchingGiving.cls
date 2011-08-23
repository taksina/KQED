Public Class UploadRecordMatchingGiving{

    Static String ADDGIFT = 'Add Gift';
    Static String UPGRADERESET = 'Upgrade Reset';
    Static String RENEWAL = 'Renewal';
    Static String REJOIN = 'Rejoin';
    Static String NEWTYPE = 'New';
    Static String DONATION = 'Donation';
    Static String PURCHASE = 'Purchase';
    
    Static String ONEPAYMENT = 'One Payment';
    Static String INSTALLMENT = 'Installment';
    Static String SUSTAINING = 'Sustaining Gift';
    
    Static List<RecordType> lstRecordType;
    
    Static Map<ID,List<Opportunity>> mapPB5Giving;
    Static Map<String,ID> mapDeveloperName;
    Static Map<ID, String> mapRecordTypeID;
    
    Static String NVL(String Value){
        if(Value == null)
            return '';
        else
            return Value.trim();
    }

    Static ID getRecordTypeId(String DeveloperName){
        ID recordtypeid=null;
        if(mapDeveloperName != null && mapDeveloperName.size()>0 && mapDeveloperName.containsKey(DeveloperName)==true){
            recordtypeid = mapDeveloperName.get(DeveloperName);
        }
        Return recordtypeid;
    }
    Static ID getRecordTypeIdByName(String RecordTypeName){
        String DeveloperName;
        if(NVL(RecordTypeName) == 'Annual'){
            DeveloperName = 'Annual';
        }
        if(NVL(RecordTypeName) == 'Donation'){
            DeveloperName = 'Donation';
        }
        if(NVL(RecordTypeName) == 'Inkind'){
            DeveloperName = 'Inkind';
        }
        if(NVL(RecordTypeName) == 'Purchase'){
            DeveloperName = 'Purchase';
        }
        if(NVL(RecordTypeName) == 'Major Gifts'){
            DeveloperName = 'Major_Gifts';
        }
        return getRecordTypeId(DeveloperName);
    }
    Static ID getChildRecordTypeId(ID ParentRecordTypeID){
        String childName = '';
        ID ChildId = null;
        String DeveloperName = '';
        if(mapRecordTypeID != null && mapRecordTypeID.size()>0 && mapRecordTypeID.containsKey(ParentRecordTypeID)==true){
            DeveloperName = mapRecordTypeID.get(ParentRecordTypeID);
        }
        system.debug('################ Parent Record Type Id : ' + ParentRecordTypeID);
        system.debug('################ Parent Developer Name : ' + mapRecordTypeId);
        
        if(DeveloperName != null && DeveloperName.length()>0){
            if(DeveloperName.trim().toUpperCase() == 'ANNUAL'){
                childName = 'Annual_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'DONATION'){
                childName = 'Donation_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'INKIND'){
                childName = 'Inkind_Installment';
            }
            else if(DeveloperName.trim().toUpperCase() == 'PURCHASE'){
                childName = 'Purchase_Installment';
            }
            system.debug('########## child developerName : ' + childName);
            
            if(childName != null && childName.trim().length()>0){
                ChildId = getRecordTypeId(ChildName);
            }
            else{
                ChildId = null;
            }   
        }
        system.debug('######Child recordtype Id : ' + ChildId);
        return ChildId;
    }
    
    Static Void getRecordType(){
        lstRecordType = new List<RecordType>();
        lstRecordType = [select id, name, developerName from RecordType Where SOBJECTTYPE = 'Opportunity'];
        
        mapDeveloperName = new Map<String,ID>();
        mapRecordTypeID = new Map<ID,String>();
        if(lstRecordType != null && lstRecordType.size() > 0){
            for(RecordType rc:lstRecordType){
                mapDeveloperName.put(rc.DeveloperName, rc.Id);
                mapRecordTypeID.put(rc.Id, rc.DeveloperName);
            }
        }
    }    
    static string checkPaymentFrequency(String Frequency){
        Frequency = NVL(Frequency);
        
        if(Frequency == 'A')
            Frequency = 'Annual';
        else if(Frequency == 'Q')
            Frequency = 'Quarterly';
        else if(Frequency == 'B')
            Frequency = 'Bi-Monthly';
        else if(Frequency == 'S')
            Frequency = 'Semi-annually';
        
        return Frequency;
    }
    Static String checkGiftType(String GiftType){
        GiftType = NVL(GiftType);
        //RN = Renew RJ = Rejoin, UR = Upgrade Reset, AD = ADDGIFT,DO=Donation, PR=Purchase 
        if(GiftType.toUpperCase() == 'NW')
            GiftType = NEWTYPE;
        else if(GiftType.toUpperCase() == 'RN')
            GiftType = RENEWAL;
        else if(GiftType.toUpperCase() == 'RJ')
            GiftType = REJOIN;
        else if(GiftType.toUpperCase() == 'UR')
            GiftType = UPGRADERESET;
        else if(GiftType.toUpperCase() == 'AD')
            GiftType = ADDGIFT;
        else if(GiftType.toUpperCase() == 'DO')
            GiftType = DONATION;
        else if(GiftType.toUpperCase() == 'PR')
            GiftType = PURCHASE;
        
        Return GiftType;
    }
    Static string checkGiftKind(String GiftKind){
        GiftKind = NVL(GiftKind);
        if(GiftKind == 'O' || GiftKind == 'OP')
            GiftKind = ONEPAYMENT;
        if(GiftKind == 'I' || GiftKind == 'IN')
            GiftKind = INSTALLMENT;
        if(GiftKind == 'S' || GiftKind == 'SG')
            GiftKind = SUSTAINING;
            
        return GiftKind;
    }
    Static String checkPaymentMethod(String PaymentMethod){
        PaymentMethod = NVL(PaymentMethod);
        if(PaymentMethod == 'AA') PaymentMethod = 'CyberSource American Express';
        else if(PaymentMethod == 'AV') PaymentMethod = 'Cybersource Visa';
        else if(PaymentMethod == 'AM') PaymentMethod = 'CyberSource Mastercard';
        else if(PaymentMethod == 'AD') PaymentMethod = 'Cybersource Discover';
        else if(PaymentMethod == 'BA') PaymentMethod = 'Sage American Epxress';
        else if(PaymentMethod == 'BD') PaymentMethod = 'Sage Discover';
        else if(PaymentMethod == 'BM') PaymentMethod = 'Sage Mastercard';
        else if(PaymentMethod == 'BV') PaymentMethod = 'Sage Visa';
        else if(PaymentMethod == 'BX') PaymentMethod = 'Sage Unknown Charge Card';
        else if(PaymentMethod == 'CA') PaymentMethod = 'Cash';
        else if(PaymentMethod == 'CK') PaymentMethod = 'Check';
        else if(PaymentMethod == 'EF') PaymentMethod = 'Electronic Fund Transfer';
        else if(PaymentMethod == 'IK') PaymentMethod = 'In Kind Gift';
        else if(PaymentMethod == 'ND') PaymentMethod = 'No Donation';
        else if(PaymentMethod == 'NP') PaymentMethod = 'Non-Payment';
        else if(PaymentMethod == 'PD') PaymentMethod = 'Payroll Deduction';
        else if(PaymentMethod == 'PP') PaymentMethod = 'PayPal';
        else if(PaymentMethod == 'ST') PaymentMethod = 'Stock';
        else if(PaymentMethod == 'VG') PaymentMethod = 'Vehicle Giving';
        else if(PaymentMethod == 'KA') PaymentMethod = 'Kimbia American Express';
        else if(PaymentMethod == 'KD') PaymentMethod = 'Kimbia Discover';
        else if(PaymentMethod == 'KM') PaymentMethod = 'Kimbia Matsercard';
        
        Return PaymentMethod;
    }
    static Campaign getCPRT(String sourceCode){
        List<Campaign> lstCamp = new List<Campaign>();
        if(sourceCode != null){
            lstCamp = [Select id, name, Support_Designation__c, Override_Gift__c, Solicitation_Type__c, 
            Campaign_Name__c, Giving_Segment__c, station__c,Product_Program__c, Source_Code__c, 
            TA_Campaign_Source_Code__c, Package_Code__c, Response_Mechanism__c, TV_Radio_Show_Program__c 
            From Campaign Where Source_Code__c=:sourceCode];
        }
        system.debug('################ Campaign Source : ' + sourceCode);
        system.debug('################ Campaign : ' + lstCamp);
        if(lstCamp != null && lstCamp.size()>0){
            return lstCamp[0];
        }else{
            return null;
        }
    }
    static Campaign objCPRT;
    public static void processGiving(WGBH_PB5_UPLOAD__c PB, String ContactId, String householdId){
        System.debug('#############Process Giving Started ');
        getRecordType();
        Opportunity opp;
        
        Boolean blnProcess = false;
        Boolean blnUpdate = false;
        Boolean blnInsert = false;
        List<Opportunity> lstDuplicate = getDuplicateGivings(PB);
        objCPRT = getCPRT(NVL(pb.PB5_SOURCE__c));
        if(lstDuplicate != null && lstDuplicate.size()>0){
            if(lstDuplicate.size()>1){
                pb.Flag_for_Review__c = true;
                pb.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';
                pb.PB5_IS_PROCESSED__c = false;
                pb.PB5_IS_NEW__c = true;
                blnProcess = false;
            }
            else{
                opp = new Opportunity();
                opp = lstDuplicate[0];
                blnProcess = true;
                blnUpdate = true;
                blnInsert = false;
            }
        }else{
            opp = new Opportunity();
            blnProcess = true;
            blnUpdate = false;
            blnInsert = true;
        }
        if(blnProcess == true){
            system.debug('############# Process start');
            pb.Flag_for_Review__c = false;
            pb.PB5_IS_PROCESSED__c = true;
            pb.PB5_IS_NEW__c = false;                
            
            if(pb.PB5_GIFT_CDATE__c != null){
                opp.closeDate = pb.PB5_GIFT_CDATE__c;
            }
            if(opp.closeDate != null){
                //opp.Gift_Date_Time__c = DateTime.valueOf(opp.closeDate);
                opp.Gift_Date_Time__c = DateTime.newInstance(opp.closeDate.year(), opp.closeDate.month(), opp.closeDate.Day(),0,0,0);
            }else{
                opp.closeDate = system.today();
                opp.Gift_Date_Time__c = system.now();
            }
            String rcType = '';
            if(NVL(pb.Giving_Record_Type__c)=='')
                rcType = 'Annual';
            else
                rcType = NVL(pb.Giving_Record_Type__c);
            opp.RecordTypeId = getRecordTypeIdByName(rcType);
            system.debug('########## Giving RecordType : ' + pb.Giving_Record_Type__c + ' ---- ' + opp.RecordTypeId);
            opp.Schedule_Start_Date__c = opp.closeDate;
            opp.Gift_Kind__c = checkGiftKind(pb.PB5_GIFT_KIND__c);
            opp.payment_frequency__c = checkPaymentFrequency(pb.PB5_PAYMENT_FREQUENCY__c);
            opp.Installment_Amount__c = pb.PB5_INSTALLMENT_AMOUNT__c;
            //PB5_ORGANIZATION_NAME__c
            opp.Payment_Amount__c = pb.PB5_PAYMENT_AMOUNT__c;
            opp.Payment_Method__c = checkPaymentMethod(pb.PB5_PAYMENT_METHOD__c);
            opp.Installments__c = pb.PB5_PAYMENTS_IN_SCHEDULE__c;
            opp.Giving_Amount__c = pb.PB5_PLEDGE_AMOUNT__c;
            if(opp.Giving_Amount__c == null){
                opp.Giving_Amount__c = opp.Payment_Amount__c;
            }
            else if(opp.Giving_Amount__c == 0){
                opp.Giving_Amount__c = opp.Payment_Amount__c;
            }
            else if(opp.Payment_Amount__c != null && opp.Giving_Amount__c < opp.Payment_Amount__c){
                opp.Giving_Amount__c = opp.Payment_Amount__c;
            }
            //pb.PB5_PLEDGE_CTIME__c;
            opp.pledge_number__c = pb.PB5_PLEDGE_NUMBER__c;
            opp.Station__c = pb.PB5_STATION_SOURCE__c;
            opp.Support_Designation__c = pb.PB5_STATION_SUPPORT__c; //(Support Designation)
            opp.SFDC_Opportunity_ID__c = String.valueof(pb.PB5_SFDC_ID__c);
            
            opp.name = generatePledgeName(opp);
            
            opp.Oppty_Related_Contact__c = ContactId;
            ///////////////////////
            if(objCPRT != null){
                opp.CampaignId = objCPRT.Id;
                //OverloadedGiftType = objCPRT.Override_Gift__c;
                opp.Giving_Segment__c = objCPRT.Giving_Segment__c;
                //opp.Gift_Type__c = objCPRT.Gift_Type__c;
                opp.Support_Designation__c = objCPRT.Support_Designation__c;
                opp.station__c = objCPRT.station__c;
                opp.Response_Mechanism__c = objCPRT.Response_Mechanism__c;
                opp.product__c = objCPRT.Product_Program__c;
                opp.ta_campaign__c = objCPRT.TA_Campaign_Source_Code__c;
                opp.Source_Code__c = objCPRT.Source_Code__c;
                if(objCPRT.TV_Radio_Show_Program__c != null){
                    Program__c objProgram = new Program__c();
                    objProgram = [Select Id, name From Program__c where id =: objCPRT.TV_Radio_Show_Program__c];
                    if(objProgram != null){
                        opp.program__c = objProgram.name;
                    }
                }
                
                opp.Campaign_Name__c = objCPRT.Campaign_Name__c;
                opp.Solicitation_Type__c = objCPRT.Solicitation_Type__c;            
            }
            ///////////////////////
            if(NVL(pb.PB5_GIFT_TYPE__c)==''){
                opp.Gift_Type__c = GTR.GTR(opp);
            }else{
                opp.Gift_Type__c = checkGiftType(pb.PB5_GIFT_TYPE__c);
            }
            opp.StageName = 'Pledged';
            if(NVL(opp.Gift_Type__c) == '') opp.Gift_Type__c = NEWTYPE;
            system.debug('###############Gift Type LINE 275' + opp.Gift_Type__c);
            system.debug('###############Gift Kind LINE 276' + opp.Gift_Kind__c);
            ////////////SET FREQUENCY/////////////
            String Frequency = '';
            String giftKind = opp.gift_kind__c.trim().toUpperCase();
            if(giftKind == INSTALLMENT.toUpperCase() || giftKind == SUSTAINING.toUpperCase()){
                if(opp.payment_frequency__c != null){
                    Frequency = opp.payment_frequency__c.toUpperCase();            
                    if(Frequency == 'MONTHLY'){
                        opp.Installments__c = 12;
                        opp.Installment_Period__c = 'Monthly';
                    }
                    if(Frequency == 'QUARTERLY'){
                        opp.Installments__c = 4;
                        opp.Installment_Period__c = 'Quarterly';
                    }
                    if(Frequency == 'ANNUALLY'){
                        opp.Installments__c = 1;
                        opp.Installment_Period__c = 'Yearly';
                    }
                    if(Frequency == 'BI-MONTHLY'){
                        opp.Installments__c = 6;
                        opp.Installment_Period__c = 'Bi-Monthly';
                    }
                    if(Frequency == 'SEMI-ANNUALLY'){
                        opp.Installments__c = 2;
                        opp.Installment_Period__c = 'Semi-Annually';
                    }
                    if(Frequency == 'IRREGULAR SCHEDULE'){
                        opp.Installment_Period__c = 'IrregularSchedule';
                    }
                    if(opp.Giving_Amount__c != null && opp.Giving_Amount__c >0){
                        if(opp.Installments__c != null && opp.Installments__c >0){
                            opp.installment_amount__c = (opp.Giving_Amount__c / opp.Installments__c).setScale(2);
                        }
                    }
                }         
                system.debug('############### Installments : ' +  opp.Installments__c);
                
            }
            system.debug('########### is insert process : ' + blnInsert);
            system.debug('########### is update process : ' + blnUpdate);
            if(blnInsert == true){
                system.debug('####### inserting giving ');
                opp.AccountId = householdId;
                Insert opp;
                Set<ID> setGivingIds = new Set<ID>();
                setGivingIds.add(opp.Id);
                system.debug('######## Giving Ids : ' + setGivingIds);
                ProcessGivingSummary.UpdateSummary(setGivingIds,false);
                system.debug('############### calling function create child');
                createChild(opp);
            }
            if(blnUpdate == true){
                Update opp;
                Set<ID> setGivingIds = new Set<ID>();
                setGivingIds.add(opp.Id);
                system.debug('######## Giving Ids : ' + setGivingIds);
                ProcessGivingSummary.UpdateSummary(setGivingIds,true);
                String giftKind2 = opp.gift_kind__c.trim().toUpperCase();
                if(giftKind2 == INSTALLMENT.toUpperCase() || giftKind2 == SUSTAINING.toUpperCase()){
                    List<Opportunity> lstChild = new List<Opportunity>();
                    lstChild = [Select id from opportunity where Recurring_Donation_Opportunity__c =: opp.Id and Recurring_Donation_Opportunity__c != null];
                    if(lstChild != null && lstChild.size()>0){
                        delete lstChild;                        
                    }
                    createChild(opp);
                }
            }
            if(blnInsert == true || blnUpdate == true){
                addBenefits(pb,opp);
            }
            processClassification(pb, contactid, householdid, opp);
        }
        Update pb;
    }
    static void processClassification(WGBH_PB5_UPLOAD__c pb, String contactId, String householdId, Opportunity opp){
        List<Classification__c> lstClass = new List<Classification__c>();
        sObject spb = (sObject) pb;
        if(spb != null){
            Integer i = 0;
            for(i=1; i<=10; i++){
                String Preference = NVL(String.valueOf(spb.get('PB5_CLASSIFICATION_CODE_' + String.valueOf(i) + '__c')));
                List<RecordType> lstRc;
                if(opp.Gift_Kind__c.trim() == SUSTAINING){
                    lstRc = [Select ID from RecordType where DeveloperName='ongoing_membership' limit 1];
                }
                else{
                    lstRc = [Select ID from RecordType where DeveloperName='benefit_preferences' limit 1];
                }
                
                if(Preference.length()>0){
                    Classification__c cls = new Classification__c();
                    cls.Preference__c = Preference;
                    cls.Station__c = NVL(pb.PB5_STATION_SOURCE__c);
                    if(lstRc != null && lstRc.size()>0){
                        cls.RecordTypeId = lstRc[0].Id;
                    }
                    String startDate = NVL(String.valueOf(spb.get('PB5_START_CDATE_' + String.valueOf(i) + '__c')));
                    String endDate = NVL(String.valueOf(spb.get('PB5_END_CDATE_' + String.valueOf(i) + '__c')));
                    if(startDate.length()>0){
                        cls.start_date__c = date.valueOf(startDate);
                    }
                    if(endDate.length()>0){
                        cls.end_date__c = date.valueOf(endDate);
                    }
                    cls.Contact__c = contactId;
                    cls.Account__c = householdId;
                    cls.Preference_Value__c = NVL(String.valueOf(spb.get('PB5_CLASSIFICATION_VALUE_' + String.valueOf(i) + '__c')));
                    lstClass.add(cls);
                }
            }
            if(lstClass != null && lstClass.size()>0){
                insert lstClass;
            }
        }
    }
    Static void addBenefits(WGBH_PB5_UPLOAD__c PB5, Opportunity Opp){
        Set<String> setBenefitCode = new Set<String>();
        List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
        sObject sPB5 = (sObject) PB5;
        for(Integer i=1;i<=10;i++){
            String code = '';
            code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
            if(code != ''){
                setBenefitCode.add(code);
            }
        }
        
        List<Pricebook2> lstPricebook = [Select Id, name from Pricebook2 Where name =:Opp.Station__c];
        //PricebookEntry 
        if((setBenefitCode != null && setBenefitCode.size()>0) && (lstPricebook != null && lstPricebook.size()>0)){
            system.debug('######### benefits : ' + setBenefitCode);
            system.debug('#########Pricebook Entry ID : ' + lstPricebook[0].Id);
            Set<ID> setPriceBookIds = new Set<ID>();
            List<PricebookEntry> lstProduct = [Select UnitPrice, ProductCode, Product2Id, Product2.no_of_items__c, 
                Pricebook2Id, Name, Id, Product2.Description
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id =: lstPricebook[0].Id
                and ProductCode in: setBenefitCode];   
                
            if(lstProduct != null && lstProduct.size()>0){
                for(PricebookEntry prod:lstProduct){
                    OpportunityLineItem item = new OpportunityLineItem();    
                    item.Quantity = 1;
                    item.Description = Prod.Product2.Description;
                    item.UnitPrice = prod.UnitPrice;
                    item.Name__c = prod.Name;
                    item.Committed_Number__c = prod.Product2.no_of_items__c;
                    item.IsBenefit__c = true;
                    //item.TotalPrice = o.TotalPrice;
                    item.OpportunityId = opp.Id;
                    item.PricebookEntryId = prod.Id;                            
                    if(opp.Payment_Amount__c != null && opp.Payment_Amount__c >0)
                        item.Fulfillment_Status__c = 'Ready to Process';
                    else
                        item.Fulfillment_Status__c = 'Pending';
                        
                    lstLineItems.add(item);      
                }
            }
            
            if(lstLineItems != null && lstLineItems.size()>0){
                system.debug('###### total line items to add ' + lstLineItems.size());
                insert lstLineItems;
            }        
        }        
    }
    
    Static Void createChild(Opportunity Parent){
        system.debug('######### createchild');
        List<Opportunity> lstChild = new List<Opportunity>();
        String giftKind = parent.gift_kind__c.trim().toUpperCase();
        system.debug('###################### Gift Kind : ' + giftKind);
        if(giftKind == INSTALLMENT.toUpperCase() || giftKind == SUSTAINING.toUpperCase()){
            /////////////////////////////////////////////////////////////        
            Decimal installs = parent.Installments__c;
            Integer installments = installs.intValue();
            Decimal LastAmount = 0;
            system.debug('############## Total Installments : ' + parent.Installments__c);
            for ( Integer j=0;j<installments;j++ )
            {
                Opportunity opp = new Opportunity();
                if(parent.RecordTypeId != null){
                    opp.RecordTypeID = getChildRecordTypeId(parent.RecordTypeId);
                }
                opp.AccountId = parent.AccountId;
                opp.Recurring_Donation_Opportunity__c = parent.Id;
                //add the remainder to the last installment, otherwise use the amount
                opp.Solicitation_Type__c = parent.Solicitation_Type__c;
                opp.Response_Mechanism__c = parent.Response_Mechanism__c;
                //opp.Gift_Type__c = objPledges.Gift_Type__c;
                opp.Gift_Kind__c = parent.Gift_Kind__c;
                opp.Product__c = parent.Product__c;
                opp.Source_Code__c = parent.Source_Code__c;
                opp.Campaign_Name__c = parent.Campaign_Name__c;
                opp.Giving_Segment__c = parent.Giving_Segment__c;
                opp.Giving_Amount__c = parent.Giving_Amount__c;
                opp.Gift_Date_Time__c = parent.Gift_Date_Time__c;
                opp.Station__c = parent.Station__c;
                opp.Amount = parent.Installment_Amount__c;
                if(j==0){
                    opp.Payment_Amount__c = parent.payment_Amount__c;
                }
                opp.CloseDate = calculateDate(parent.schedule_start_date__c, parent.Installment_Period__c, j);
                opp.schedule_start_date__c = opp.CloseDate;
                opp.Installment_Period__c = parent.Installment_Period__c;
                
                opp.payment_number__c = j+1;
                opp.payment_method__c = parent.payment_method__c;
                //opp.StageName = System.Label.RecurringDonationStageName;
                opp.StageName = parent.Stagename;
                
                
                if(j == (installments-1)){
                    LastAmount = (parent.Giving_Amount__c - LastAmount).setScale(2);
                    opp.Installment_Amount__c = LastAmount;
                }
                else{
                    LastAmount += parent.Installment_Amount__c;
                    opp.Installment_Amount__c = parent.Installment_Amount__c;
                    if(j == 0){
                        //objPledges.Payment_Amount__c = opp.Installment_Amount__c;
                    }
                }
                
                opp.name = generateName(opp.CloseDate, j, Installments, Parent.Name);
                lstChild.add(opp);
            }                    
            /////////////////////////////////////////////////////////////
        }
        if(lstChild != null && lstChild.size()>0){
            system.debug('################### Total childs to create: ' + lstChild.size());
            Insert lstChild;
        }
    }
    Static Date calculateDate(DateTime bookDate, string InstallmentPeriod, integer element){
        Date closeDate;
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

    static String generatePledgeName(Opportunity objPledges){
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
                    pName += ', ' + objCPRT.Station__c;
                else
                    pName += objCPRT.Station__c;
            if(objCPRT.Campaign_Name__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Campaign_Name__c;
                else
                    pName += objCPRT.Campaign_Name__c;
            if(objCPRT.Giving_Segment__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Giving_Segment__c;
                else
                    pName += objCPRT.Giving_Segment__c;
                
            if(objCPRT.Solicitation_Type__c != null)
                if(pName.length()>0)
                    pName += ', ' + objCPRT.Solicitation_Type__c;
                else
                    pName += objCPRT.Solicitation_Type__c;
        
        }
        //objPledges.name = pName;
        return pName;
    }
    Static String generateName(Date CloseDate, integer Installments, integer TotalInstallment, String ParentName){
        String oName = '';
        //oName += objPledges.Donor_Name__c; 
        oName += ParentName; 
        oName += ' ';
        oName += System.Label.RecurringDonationPrefix;
        oName += ' (';
        oName += Installments+1;
        oName += ' of ';
        oName += TotalInstallment;
        oName += ') ';
        oName += CloseDate.format();
        return oName;
    }    
    
    
    Static List<Opportunity> getDuplicateGivings(WGBH_PB5_UPLOAD__c pb){
        List<Opportunity> lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
        From Opportunity Where (pledge_number__c =: String.ValueOf(pb.PB5_PLEDGE_NUMBER__c) and Pledge_number__c!='') 
        OR (SFDC_Opportunity_ID__c =: String.ValueOf(pb.PB5_SFDC_ID__c) and SFDC_Opportunity_ID__c!='')];
                
        return lstDuplicateGiving;
    }
}