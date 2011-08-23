Public Class UploadRecordMatchingGiving_List{

    Static String ADDGIFT = 'Add Gift';
    Static String UPGRADERESET = 'Upgrade Reset';
    Static String RENEWAL = 'Renewal';
    Static String REJOIN = 'Rejoin';
    Static String NEWTYPE = 'New';
    Static String DONATION = 'Donation';
    Static String PURCHASE = 'Purchase';
    
    Static List<Opportunity> lstDuplicateGiving;
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
    Static ID getChildRecordTypeId(ID ParentRecordTypeID){
        String childName = '';
        ID ChildId = null;
        String DeveloperName = '';
        if(mapRecordTypeID != null && mapRecordTypeID.size()>0 && mapRecordTypeID.containsKey(ParentRecordTypeID)==true){
            DeveloperName = mapRecordTypeID.get(ParentRecordTypeID);
        }
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
            
            
            if(childName != null && childName.trim().length()>0){
                ChildId = getRecordTypeId(ChildName);
            }
            else{
                ChildId = null;
            }   
        }
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
        if(GiftKind == 'O')
            GiftKind = 'One Payment';
        if(GiftKind == 'I')
            GiftKind = 'Installment';
        if(GiftKind == 'O')
            GiftKind = 'Sustaining Gift';
            
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
    public static void processGiving(List<WGBH_PB5_UPLOAD__c> lstPB5){
        List<Opportunity> lstOppInsert = new List<Opportunity>();
        List<Opportunity> lstOppUpdate = new List<Opportunity>();
        List<Opportunity> lstOpp = new List<Opportunity>();
        System.debug('#############Process Giving Started ');
        getRecordType();
        getDuplicateGivings(lstPB5);
        List<WGBH_PB5_UPLOAD__c> lstPB5Review = new List<WGBH_PB5_UPLOAD__c>();
        List<WGBH_PB5_UPLOAD__c> lstPB5Success = new List<WGBH_PB5_UPLOAD__c>();
        if(lstPB5 != null && lstPB5.size()>0){
            for(WGBH_PB5_UPLOAD__c pb:lstPB5){
                //String MatchingCriteria = 'ACCOUNT_ID_ARIA__c=PB5_ALT_ACCOUNT_ID_ARIA__c;ACCOUNT_ID_AUCTION__c=PB5_ALT_ACCOUNT_ID_AUCTION__c;ACCOUNT_ID_CARS__c=PB5_ALT_ACCOUNT_ID_CARS__c;ACCOUNT_ID_FDNDEV__c=PB5_ALT_ACCOUNT_ID_FDNDEV__c;ACCOUNT_ID_LOCKBOX__c=PB5_ALT_ACCOUNT_ID_LOCKBOX__c;ACCOUNT_ID_PBSD__c=PB5_ALT_ACCOUNT_ID_PBSD__c';
                String MatchingCriteria = 'UniqueID__c=PB5_SFDC_ID__c';
                List<sObject> lstTarget;
                lstTarget = UploadRecordMatching.getMatchingRows(pb,'Account',MatchingCriteria);            
                Account objAcc = new Account();
                if(lstTarget != null && lstTarget.size()>0){
                    objAcc = (Account) lstTarget[0];
                }
                Opportunity opp;
                Boolean blnInsert = true;
                Boolean blnUpdate = false;
                if(mapPB5Giving != null && mapPB5Giving.size()>0 && mapPB5Giving.containsKey(pb.Id)){
                    List<Opportunity> lstDuplicate;
                    lstDuplicate = mapPB5Giving.get(pb.Id);
                    if(lstDuplicate != null && lstDuplicate.size()>0){
                        if(lstDuplicate.size()>1){
                            //More than 1?
                            //Flag review 
                            pb.Flag_for_Review__c = true;
                            pb.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';
                            pb.PB5_IS_PROCESSED__c = false;
                            pb.PB5_IS_NEW__c = true;
                            lstPB5Review.add(pb);
                            blnUpdate = false;
                            blnInsert = false;
                            system.debug('############ More than 1 match found ################');
                        }else{
                            opp = lstDuplicate[0];
                            blnUpdate = true;
                            blnInsert = false;
                        }
                    }else{
                        opp = new Opportunity();
                        blnInsert = true;
                        blnUpdate = false;
                    }
                }else{
                    opp = new Opportunity();
                }
                
                if(blnInsert == true || blnUpdate == true){
                    pb.Flag_for_Review__c = false;
                    pb.PB5_IS_PROCESSED__c = true;
                    pb.PB5_IS_NEW__c = false;
                    lstPB5Success.add(pb);
                    system.debug('############ Update or Insert operation ################');
                    
                    
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
                    opp.AccountId = objAcc.Id;
                    
                    if(NVL(pb.PB5_GIFT_TYPE__c)==''){
                        opp.Gift_Type__c = GTR.GTR(opp);
                    }else{
                        opp.Gift_Type__c = checkGiftType(pb.PB5_GIFT_TYPE__c);
                    }
                    opp.StageName = 'Pledged';
                    if(NVL(opp.Gift_Type__c) == '') opp.Gift_Type__c = NEWTYPE;
                    ////////////SET FREQUENCY/////////////
                    String Frequency = '';
                    String giftKind = opp.gift_kind__c.trim().toUpperCase();
                    if(giftKind == 'INSTALLMENT' || giftKind == 'SUSTAINING GIFT' || giftKind == 'SUSTAINING PLEDGE'){
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
                    }
                    //////////////////////////////////////
                    if(blnInsert == true){
                        opp.RecordTypeId = getRecordTypeId('Annual');
                        lstOppInsert.add(opp);
                    }else{
                        lstOppUpdate.add(opp);
                    }
                }
            }
            ///DML Operations
            
            if(lstPB5Review != null && lstPB5Review.size()>0){
                Update lstPB5Review;
            }
            if(lstPB5Success != null && lstPB5Success.size()>0){
                Update lstPB5Success;
            }
            List<Opportunity>lstForBenefit = new List<Opportunity>();
            if(lstOppUpdate != null && lstOppUpdate.size()>0){
                Update lstOppUpdate;
                Set<ID> setGivingIds = new Set<ID>();
                for(Opportunity o:lstOppUpdate){
                    setGivingIds.add(o.Id);
                }
                ProcessGivingSummary.UpdateSummary(setGivingIds,true); 
                for(Opportunity opp:lstOppUpdate){
                    if(NVL(opp.SFDC_Opportunity_ID__c) != '' || NVL(opp.pledge_number__c) != ''){
                        lstForBenefit.add(opp);
                    }
                }
            }
            if(lstOppInsert != null && lstOppInsert.size()>0){
                Insert lstOppInsert;
                Set<ID> setGivingIds = new Set<ID>();
                for(Opportunity o:lstOppInsert){
                    setGivingIds.add(o.Id);
                }
                ProcessGivingSummary.UpdateSummary(setGivingIds,false);
                createChild(lstOppInsert);
                for(Opportunity opp:lstOppInsert){
                    if(NVL(opp.SFDC_Opportunity_ID__c) != '' || NVL(opp.pledge_number__c) != ''){
                        lstForBenefit.add(opp);
                    }
                }
                if(lstForBenefit != null && lstForBenefit.size()>0){
                    addBenefits(lstPB5,lstForBenefit);
                }
            }
            /////////////////
        }
    }
    Static void addBenefits(List<WGBH_PB5_UPLOAD__c> lstPB5, List<Opportunity> lstOpp){
        Set<String> setBenefitCode = new Set<String>();
        Set<String> setStation = new set<String>();
        Map<ID, Opportunity> mapPB5Opp = new Map<ID, Opportunity>();
        List<OpportunityLineItem> lstLineItems = new List<OpportunityLineItem>();
        if((lstOpp != null && lstOpp.size()>0) && (lstPB5 != null && lstPB5.size()>0)){
            for(WGBH_PB5_UPLOAD__c pb:lstPB5){
                for(Opportunity opp:lstOpp){
                    if((NVL(opp.pledge_number__c) == NVL(pb.PB5_PLEDGE_NUMBER__c)) || (NVL(opp.SFDC_Opportunity_ID__c) == NVL(String.ValueOf(pb.PB5_SFDC_ID__c)))){
                        mapPB5Opp.put(pb.Id, opp);
                        break;
                    }
                }
                sObject sPB5 = (sObject) pb;
                for(Integer i=1;i<=10;i++){
                    String code = '';
                    code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
                    if(code != ''){
                        setBenefitCode.add(code);
                    }
                    if(NVL(pb.PB5_STATION_SOURCE__c) != ''){
                        setStation.add(NVL(pb.PB5_STATION_SOURCE__c));
                    }
                }
            }
            
            List<Pricebook2> lstPricebook = [Select Id, name from Pricebook2 Where name in:setStation];
            Set<ID> setPriceBookIds = new Set<ID>();
            Map<String,ID> mapPricebookId = new Map<String,ID>();
            if(lstPricebook != null && lstPricebook.size()>0){
                for(Pricebook2 p:lstPricebook){
                    setPriceBookIds.add(p.Id);
                    mapPricebookId.put(p.name, p.id);
                }
            }
            Map<String, PricebookEntry> mapProduct = new Map<String, PricebookEntry>();
            
            List<PricebookEntry> lstProduct = [Select UnitPrice, ProductCode, Product2Id, Product2.no_of_items__c, 
                Pricebook2Id, Name, Id, Product2.Description
                From PricebookEntry 
                Where IsActive = true 
                and Pricebook2Id In: setPriceBookIds
                and ProductCode in: setBenefitCode];   
            if(lstProduct != null && lstProduct.size()>0){
                for(PricebookEntry prod:lstProduct){
                    mapProduct.put(prod.ProductCode, prod);
                }
            }
            
            if(mapProduct != null && mapProduct.size()>0){
                for(WGBH_PB5_UPLOAD__c pb:lstPB5){                    
                    sObject sPB5 = (sObject) pb;
                    for(Integer i=1;i<=10;i++){
                        String code = '';
                        code = NVL(String.ValueOf(sPB5.get('PB5_BENEFIT_' + String.valueof(i) + '__c')));
                        if(code != '' && mapProduct.containsKey(code)){
                            PricebookEntry Prod = new PriceBookEntry();
                            Prod = mapProduct.get(code);
                            OpportunityLineItem item = new OpportunityLineItem();
                            Opportunity opp = new Opportunity();                            
                            if(mapPB5Opp.size()>0 && mapPB5Opp.containsKey(pb.Id)){
                                item.Quantity = 1;
                                item.Description = Prod.Product2.Description;
                                item.UnitPrice = prod.UnitPrice;
                                item.Name__c = prod.Name;
                                item.Committed_Number__c = prod.Product2.no_of_items__c;
                                item.IsBenefit__c = true;
                                //item.TotalPrice = o.TotalPrice;
                                opp = mapPB5Opp.get(pb.Id);
                                item.OpportunityId = opp.Id;
                                if(mapPricebookId.size()>0 && mapPricebookId.containsKey(pb.PB5_STATION_SOURCE__c)){
                                    item.PricebookEntryId = mapPricebookId.get(pb.PB5_STATION_SOURCE__c);                            
                                }
                                if(opp.Payment_Amount__c != null && opp.Payment_Amount__c >0)
                                    item.Fulfillment_Status__c = 'Ready to Process';
                                else
                                    item.Fulfillment_Status__c = 'Pending';
                                    
                                lstLineItems.add(item);
                            }
                        }
                    }
                }         
            }
            if(lstLineItems != null && lstLineItems.size()>0){
                insert lstLineItems;
            }
        }
    }
    Static Void createChild(List<Opportunity> lstParent){
        Map<ID,List<Opportunity>> mapParentChild = new Map<ID,List<Opportunity>>();
        List<Opportunity> lstChild = new List<Opportunity>();
        if(lstParent != null && lstParent.size()>0){
            for(Opportunity parent:lstParent){
                String giftKind = parent.gift_kind__c.trim().toUpperCase();
                if(giftKind == 'INSTALLMENT' || giftKind == 'SUSTAINING GIFT' || giftKind == 'SUSTAINING PLEDGE'){
                    
                    /////////////////////////////////////////////////////////////
            
                    Decimal installs = parent.Installments__c;
                    Integer installments = installs.intValue();
                    Decimal LastAmount = 0;
                    for ( Integer j=0;j<installments;j++ )
                    {
                        Opportunity opp = new Opportunity();
                        opp.RecordTypeID = getChildRecordTypeId(parent.RecordTypeId);
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
            }
            if(lstChild != null && lstChild.size()>0){
                Insert lstChild;
            }
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

    Static String generateName(Date CloseDate, integer Installment, integer TotalInstallment, String ParentName){
        String oName = '';
        //oName += objPledges.Donor_Name__c; 
        oName += ParentName; 
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
    
    Static String generatePledgeName(Opportunity objPledges){
        //Gift year (from gift date), STATION, CAMAPIGN & SOLICITATION TYPE 
        String pName='';
        //system.debug('############## YEAR: ' + String.ValueOf(objPledges.Gift_Date_Time__c.Year()));
        if(objPledges.Gift_Date_Time__c != null){
            pName = String.ValueOf(objPledges.Gift_Date_Time__c.Year());
            objPledges.Schedule_Start_Date__c = objPledges.Gift_Date_Time__c.Date();
        }
        if(objPledges.Station__c != null){
            if(pName.length()>0)
                pName += ', ' + objPledges.Station__c;
            else
                pName += objPledges.Station__c;        
        }
        return 'PB5 Upload (ACC): ' + pName;
        //return pName;
    }
    
    Static void getDuplicateGivings(List<WGBH_PB5_UPLOAD__c> lstPB5){
        Set<String> pb5SFDCId = new Set<String>();
        Set<String> pb5PledgeNo = new Set<String>();
        mapPB5Giving = new Map<ID,List<Opportunity>>();
        //SFDC_Opportunity_ID__c
        if(lstPB5 != null && lstPB5.size()>0){
            for(WGBH_PB5_UPLOAD__c PB5:lstPB5){
                pb5SFDCId.add(String.ValueOf(PB5.PB5_SFDC_ID__c));
                pb5PledgeNo.add(String.ValueOf(PB5.PB5_PLEDGE_NUMBER__c));
            }
        }
        lstDuplicateGiving = [Select Id, Amount, RecordTypeID, Solicitation_Type__c, Response_Mechanism__c, CloseDate, Gift_Date_Time__c,Gift_Kind__c, Gift_Type__c, Payment_Frequency__c, Installment_Amount__c,
        Payment_Amount__c, Payment_Method__c, Installments__c, Giving_Amount__c, Pledge_Number__c, Station__c, Support_Designation__c,
        SFDC_Opportunity_ID__c, AccountID, StageName, Campaign_Name__c, Giving_Segment__c, Override_Gift_Type__c, Payment_Date__c,
        Payment_Method_Description__c, Product__c, schedule_start_date__c, Source_Code__c, Oppty_Related_Contact__c, Recurring_Donation_Opportunity__c
        From Opportunity Where (pledge_number__c In: pb5PledgeNo and Pledge_number__c!='') 
        OR (SFDC_Opportunity_ID__c In: pb5SFDCId and SFDC_Opportunity_ID__c!='')];
        
        
        if(lstDuplicateGiving != null && lstDuplicateGiving.size()>0){
            if(lstPB5 != null && lstPB5.size()>0){
                for(WGBH_PB5_UPLOAD__c PB5:lstPB5){
                    List<Opportunity> lstOppTemp = new List<Opportunity>();
                    for(Opportunity opp:lstDuplicateGiving){
                        if(String.valueOf(PB5.PB5_PLEDGE_NUMBER__c) == String.valueOf(opp.pledge_number__c) ||
                        String.valueOf(PB5.PB5_SFDC_ID__c) == String.valueOf(opp.SFDC_Opportunity_ID__c)){
                            lstOppTemp.add(opp);
                        }
                    }
                    if(lstOppTemp != null && lstOppTemp.size()>0){
                        mapPB5Giving.put(PB5.Id, lstOppTemp);
                    }
                }
            }
        }
        return;
    }
}