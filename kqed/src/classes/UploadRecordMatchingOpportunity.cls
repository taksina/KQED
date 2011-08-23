public class UploadRecordMatchingOpportunity{

    Public static List<Opportunity> lstOppt = new List<Opportunity>();
    public static void processOpportunity(WGBH_PB5_UPLOAD__c PB5){
        if(IsTransactionPayment(PB5)==true){//transation type = payment? ; If true then check SFDC Opp Id or Pledge no exist?
            getOpportunity(PB5);
            if(IsSFDCOppIdOrPledgenoExist(PB5)==true){
                if(PB5.PB5_GIFT_TYPE__c == 'NW'){//Gift type new?
                    GTR(PB5);
                    ApplyPaymentToOpenOpportunitySubProcess3(PB5);
                    //Go to 1
                    //OVER
                }
                else{
                    ApplyPaymentToOpenOpportunitySubProcess3(PB5);
                    //Go to 1
                    //OVER
                }
            }
            else{
                //Other unfulfilled Partially fulfilled pladge of same station product and campaign
                List<sObject> lst = PledgeOfSameStation(PB5);
                if(lst.size()>0){
                    if(lst.size()>1){//More than 1?
                        //Flag review         
                        PB5.Flag_for_Review__c = true;
                        PB5.Flag_Review_Reason__c = 'MORE THAN 1 MATCH';
                        PB5.PB5_IS_PROCESSED__c = false;
                        PB5.PB5_IS_NEW__c = true;
                        //OVER
                    }
                    else{
                        if(PB5.PB5_GIFT_TYPE__c == 'NW'){//Gift type new?
                            GTR(PB5);
                            ApplyPaymentToPladgeSubProcess3(PB5);
                            //Goto 1
                            //OVER
                        }
                        else{
                            if(Installment_SustainingGift(PB5)==true){
                                //PB5_INSTALLMENT_AMOUNT__c
                                //PB5_PAYMENT_AMOUNT__c
                                if(PB5.PB5_INSTALLMENT_AMOUNT__c == PB5.PB5_PAYMENT_AMOUNT__c){
                                    ApplyPaymentToPladgeSubProcess3(PB5);
                                    //OVER
                                }
                                else{//Flag for review
                                    //INS AMT equal to PAYMENT AMT    
                                    PB5.Flag_for_Review__c = true;
                                    PB5.PB5_IS_PROCESSED__c = false;
                                    PB5.PB5_IS_NEW__c = true;
                                    //PB5.Flag_Review_Reason__c = 'INS AMT equal to PAYMENT AMT ';(actually it should be: INS AMT not equal to PAYMENT AMT)
                                    //OVER
                                }
                            }
                            else{
                                Opportunity opp = (Opportunity)lst[0];
                                if(PB5.PB5_PAYMENT_AMOUNT__c == opp.installment_amount__c){//Opp amt = payment amount?
                                    ApplyPaymentToPladgeSubProcess3(PB5);
                                    //Go to 1
                                    //OVER
                                }
                                else if(PB5.PB5_PAYMENT_AMOUNT__c < opp.installment_amount__c){//Opp amt < payment amount?
                                    //Apply Payment: Change stage to Partially fulfilled
                                    //Go to 1
                                    //OVER
                                }
                                else if(PB5.PB5_PAYMENT_AMOUNT__c > opp.installment_amount__c){//Opp amt < payment amount?
                                    //Update Opp amount = payment amount; Change stage Fulfilled
                                    //Go to 1
                                    //OVER
                                }
                            }
                        }
                    }
                }
                else{//
                    CreatePledgeSubProcess3(PB5);
                    GTR(PB5);
                    //PB5.PB5_Stage__c = 'D';
                    //OVER
                }
            }
        }
        else{//If false then check SFDC pledge Id or Pledge number exist?
            if(IsSFDCPledgeIdOrPledgenoExist(PB5)==true){                
                PB5.Flag_for_Review__c = true;
                PB5.Flag_Review_Reason__c = 'SFDC PLEDGE ID or PLEDGE NUMBER EXIST';
                PB5.PB5_IS_PROCESSED__c = false;
                PB5.PB5_IS_NEW__c = true;
                //OVER
            }
            else{
                //Create Pledge(Apply subprogramming subprocess3)
                CreatePledgeSubProcess3(PB5);
                GTR(PB5);
                //PB5.PB5_Stage__c = 'D';
                //OVER
            }
        }
    }
    public static boolean IsTransactionPayment(WGBH_PB5_UPLOAD__c PB5){

        if(PB5.PB5_TRANSACTION_TYPE__c == 'PLEDGE WITH PAYMENT' || PB5.PB5_TRANSACTION_TYPE__c == 'PLEDGE NO PAYMENT' || PB5.PB5_TRANSACTION_TYPE__c == 'PAYMENT' )
            return true;
        else
            return false;
    }
    public static void getOpportunity(WGBH_PB5_UPLOAD__c PB5){
        String pb5SFDCId = String.ValueOf(PB5.PB5_SFDC_ID__c);
        String pb5PledgeNo = String.ValueOf(PB5.PB5_PLEDGE_NUMBER__c);
        //SFDC_Opportunity_ID__c
        lstOppt = [Select Id From Opportunity Where (pledge_number__c =: pb5PledgeNo and Pledge_number__c!='') OR (SFDC_Opportunity_ID__c =: pb5SFDCId and SFDC_Opportunity_ID__c!='')];
        return;
    }
    public static boolean IsSFDCOppIdOrPledgenoExist(WGBH_PB5_UPLOAD__c PB5){
        if(lstOppt.size()>0)
            return true;
        else            
            return false;
    }
    public static boolean IsSFDCPledgeIdOrPledgenoExist(WGBH_PB5_UPLOAD__c PB5){
        List<Opportunity> lstOpp = new List<Opportunity>();
        String pb5SFDCId = String.ValueOf(PB5.PB5_SFDC_ID__c);
        String pb5PledgeNo = String.ValueOf(PB5.PB5_PLEDGE_NUMBER__c);
        //SFDC_Opportunity_ID__c
        lstOpp = [Select Id From Opportunity Where pledge_number__c =: pb5PledgeNo and Pledge_Number__c!=''];
        if(lstOpp.size()>0)
            return true;
        else            
            return false;
    }
    public static List<sObject> PledgeOfSameStation(WGBH_PB5_UPLOAD__c PB5){
        List<sObject> lst;
        //Other unfulfilled Partially fulfilled pladge of same station product and campaign
        return lst;
    }
    public static void ApplyPaymentToOpenOpportunitySubProcess3(WGBH_PB5_UPLOAD__c PB5){
        //pledge_amount__c; payment_Amount__c; installment_amount__c
        //PB5_INSTALLMENT_AMOUNT__c; PB5_PAYMENT_AMOUNT__c; PB5_PLEDGE_AMOUNT__c
        for(Opportunity opp:lstOppt){
            opp.pledge_amount__c = PB5.PB5_PLEDGE_AMOUNT__c;
            opp.payment_Amount__c = PB5.PB5_PAYMENT_AMOUNT__c;
            opp.installment_amount__c = PB5.PB5_INSTALLMENT_AMOUNT__c;
            if(opp.payment_Amount__c == null || opp.payment_Amount__c == 0)
                opp.StageName = 'Pledged';
            else if(opp.payment_Amount__c == opp.pledge_amount__c)
                opp.StageName = 'Closed Won';
            else if(opp.payment_Amount__c < opp.pledge_amount__c)
                opp.StageName = 'Partial Close';
        }
    }
    public static void GTR(WGBH_PB5_UPLOAD__c PB5){
        for(Opportunity opp:lstOppt){
            if(opp.Campaign_Type__c == 'Annual Giving')
                GiftTypeRule.GTR(PB5,lstOppt,GiftTypeRule.gtrType.ANNUALGTR);
            else if(opp.Campaign_Type__c == 'In-Kind Gifts')
                GiftTypeRule.GTR(PB5,lstOppt,GiftTypeRule.gtrType.INKINDGTR);
            else
                GiftTypeRule.GTR(PB5,lstOppt,GiftTypeRule.gtrType.DONATIONPURCHASEGTR);
        }
    }
    public static void CreatePledgeSubProcess3(WGBH_PB5_UPLOAD__c PB5){
        ApplyPaymentToOpenOpportunitySubProcess3(PB5);
    }
    public static boolean Installment_SustainingGift(WGBH_PB5_UPLOAD__c PB5){
        return false;
    }
    public static void ApplyPaymentToPladgeSubProcess3(WGBH_PB5_UPLOAD__c PB5){
        if(PB5.PB5_TRANSACTION_TYPE__c == 'PLEDGE WITH PAYMENT'){//TRANSACTION TYPE = PLEDGE WITH PAYMENT?: YES
            if(PB5.PB5_PAYMENT_METHOD__c == 'Stock'){//PAYMENT METHOD = STOCK: YES
                //lstOppt[0].gift_date__c = DELIVERY DATE FROM RLS   
                //lstOppt[0].last_payment_date__c = lstOppt[0].gift_date__c          
                //REVENUE DATE = lstOppt[0].gift_date__c
            }
            else{//PAYMENT METHOD = STOCK: NO
                //lstOppt[0].gift_date__c = DATE RECEIVED
                //lstOppt[0].last_payment_date__c = DATE RECEIVED
                //REVENUE DATE = PAYMENT DATE
            }
        }else{//TRANSACTION TYPE = PLEDGE WITH PAYMENT?: NO
            if(PB5.PB5_TRANSACTION_TYPE__c == 'PLEDGE NO PAYMENT'){//TRANSACTION TYPE = PLEDGE NO PAYMENT?: YES
                if(PB5.PB5_PAYMENT_METHOD__c == 'Vehicle Giving'){//PAYMENT METHOD = VEHICLE DONATION : YES
                    //lstOppt[0].gift_date__c = VEHICLE SELL DATE
                    //lstOppt[0].last_payment_date__c = PAYMENT RECEIVED       
                    //REVENUE DATE = PAYMENT DATE
                }
                else{//PAYMENT METHOD = VEHICLE DONATION : NO
                    //lstOppt[0].gift_date__c = PLEDGE DATE
                    //lstOppt[0].last_payment_date__c = NULL
                    //REVENUE DATE = NULL
                }
            }
            else{//TRANSACTION TYPE = PLEDGE NO PAYMENT?: NO
                if(PB5.PB5_PAYMENT_METHOD__c == 'Check'){//PAYMENT METHOD = CHECK : YES
                    //lstOppt[0].gift_date__c = NULL
                    //lstOppt[0].last_payment_date__c = DATE RECEIVED
                    //REVENUE DATE = PAYMENT DATE
                }
                else{//PAYMENT METHOD = CHECK : NO
                    if(PB5.PB5_PAYMENT_METHOD__c == 'Electronic Fund Transfer'){//PAYMENT METHOD = EFT : YES
                        if(PB5.PB5_GIFT_KIND__c == 'OP'){//GIFT KIND = ONE PAYMENT : YES
                            //lstOppt[0].gift_date__c = NULL
                            //lstOppt[0].last_payment_date__c = DATE RECEIVED
                            //REVENUE DATE = PAYMENT DATE
                        }
                        else{//GIFT KIND = ONE PAYMENT : NO
                            //lstOppt[0].gift_date__c = NULL
                            //lstOppt[0].last_payment_date__c = DATE RECEIVED
                            //REVENUE DATE = PAYMENT DATE
                        }
                    }
                    else{//PAYMENT METHOD = EFT : NO
                        if(PB5.PB5_GIFT_KIND__c == 'OP'){//GIFT KIND = ONE PAYMENT : YES
                            //GIFT DATE = NULL
                            //PAYMENT DATE = DATE RECEIVED
                            //REVENUE DATE = IF PLEDGE IN PREVIOUS MONTH AND CHARGE PAYMENT IN 1st 2 BUSINESS DAY OF CURRENT MONTH, SET TO GIFT DATE OF PLEDGE ELSE PAYMENT DATE
                        }
                        else{//GIFT KIND = ONE PAYMENT : NO
                            //IF 1st INSTALL PAYMENT(PAYMENT AMOUNT = PAID AMOUNT ON PARENT PLEDGE)
                                //GIFT DATE = NULL
                                //PAYMENT DATE = DATE RECEIVED
                                //REVENUE DATE = IF PLEDGE IN PREVIOUS MONTH AND CHARGE PAYMENT IN 1st 2 BUSINESS DAY OF CURRENT MONTH, SET TO GIFT DATE OF PLEDGE ELSE PAYMENT DATE
                            //ELSE
                                //GIFT DATE = NULL
                                //PAYMENT DATE = DATE RECEIVED
                                //REVENUE DATE = PAYMENT DATE                            
                        }
                    }
                }
            }
        }
    }
    
    static testmethod void myTest() {
        WGBH_PB5_UPLOAD__c PB5 = new WGBH_PB5_UPLOAD__c();
        insert PB5;
        UploadRecordMatchingOpportunity.IsTransactionPayment(PB5);
        UploadRecordMatchingOpportunity.getOpportunity(PB5);
        UploadRecordMatchingOpportunity.IsSFDCOppIdOrPledgenoExist(PB5);
        UploadRecordMatchingOpportunity.IsSFDCPledgeIdOrPledgenoExist(PB5);
        UploadRecordMatchingOpportunity.PledgeOfSameStation(PB5);
        UploadRecordMatchingOpportunity.ApplyPaymentToOpenOpportunitySubProcess3(PB5);
        UploadRecordMatchingOpportunity.GTR(PB5);
        UploadRecordMatchingOpportunity.CreatePledgeSubProcess3(PB5);
        UploadRecordMatchingOpportunity.Installment_SustainingGift(PB5);
        UploadRecordMatchingOpportunity.processOpportunity(PB5);
        UploadRecordMatchingOpportunity.ApplyPaymentToPladgeSubProcess3(PB5);

        
    }  
}