Public class SageTransactionProcess {

    Public String strStatus =''; // Set Response status Value
    Public String Response_message =''; // Set Response Message
    Public String Response_Code ='';    // Set Response Error Code if any.

    Public SageTransactionProcess(){
        this.strStatus ='';
        this.Response_message ='';
        this.Response_Code = '';
    }

    Public Boolean SagePaymentRequest(String M_ID,String M_KEY,String C_NAME,String C_ADDRESS,String C_CITY,String C_STATE,
                String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_CUSTOMER_NUMBER,String T_AMT,String T_SHIPPING,
                String T_TAX,String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,
                String C_SHIP_CITY,String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VAULT_BANKCARD_SALE?';
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_NAME=' + EncodeValue(C_NAME);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        myurl += '&T_CUSTOMER_NUMBER='+ EncodeValue(T_CUSTOMER_NUMBER);
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);

        String ResXML='';
        ResXML = HTTPSageRequest(myurl);

        Success = false;
        this.strStatus ='';
        this.Response_message ='';
        this.Response_Code = '';
        Success = CheckTransactionResponse(ResXML);

        return Success;
    }

    Public Boolean SageRefundRequest(String M_ID,String M_KEY,String C_NAME,String C_ADDRESS,String C_CITY,String C_STATE,
                String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_CUSTOMER_NUMBER,String T_AMT,String T_SHIPPING,
                String T_TAX,String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,
                String C_SHIP_CITY,String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VAULT_BANKCARD_CREDIT?';                    
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_NAME=' + EncodeValue(C_NAME);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        myurl += '&T_CUSTOMER_NUMBER='+ EncodeValue(T_CUSTOMER_NUMBER);
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);
        
        String ResXML='';
        ResXML = HTTPSageRequest(myurl);
        
        Success = false;
        this.strStatus ='';
        this.Response_message ='';
        this.Response_Code = '';
        
        Success = CheckTransactionResponse(ResXML);
        
        return Success;
    }

    Private String HTTPSageRequest(String URL)
    {    
        try {
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(URL);
            req.setMethod('GET');
            req.setTimeOut(60000);
            HttpResponse res = h.send(req);
            return res.getBody();        
       }Catch(Exception Ex) {
           return '';
       }
    }

    Private Boolean CheckTransactionResponse(String strXMLResponse)
    {
         Boolean blnRetValue = false;
         If(strXMLResponse == null || strXMLResponse.Length() == 0) {
             return false;
         }
         else if(strXMLResponse.contains('diffgr') == false)
         {
             Response_message = strXMLResponse;
             return false;
         }
         else {
             try {

                 XMLDom dom = new XMLDom(strXMLResponse);
                 XMLDom.Element xmlObj ;
                 


                 if(dom.getElementByTagName('diffgr:diffgram') != null) {
                    xmlObj = dom.getElementByTagName('diffgr:diffgram');
                    if (xmlObj.getElementsByTagName('APPROVAL_INDICATOR').size()>0) {
                        
                        strStatus = xmlObj.getElementsByTagName('APPROVAL_INDICATOR')[0].nodeValue;
                        Response_message = xmlObj.getElementsByTagName('MESSAGE')[0].nodeValue;
                        Response_Code = xmlObj.getElementsByTagName('CODE')[0].nodeValue;

                        system.debug('###Status:' + strStatus + ' -Message:' + Response_message);
                        if(strStatus != null && strStatus.Length()>0 )
                        {
                            blnRetValue = true;
                        }
                    }
                }
                else {
                    Response_message = strXMLResponse;
                    blnRetValue = false;
                }
             }catch(Exception ex){
                 Response_Code = '';
                 Response_message = 'Response Reading Error';
             }
         }
         return blnRetValue;
    }

    Private String BlankIsNull(String Value)
    {
        if(Value == null) 
            return '';
        else
            return Value; 
    }

    Private String EncodeValue(String Value)
    {
        IF(Value != null && Value.Length()>0) {
            return EncodingUtil.urlEncode(Value,'UTF-8');
        }
        else {
            return '';
        }
    }
    
    //VIRTUAL_CHECK_PPD_SALE for EFT
    Public Boolean SageVirtualCheckPaymentRequest(String M_ID,String M_KEY,String C_ORIGINATOR_ID,String C_FIRST_NAME,
            String C_MIDDLE_INITIAL,String C_LAST_NAME,String C_SUFFIX,String C_ADDRESS,String C_CITY,String C_STATE,
            String C_ZIP,String C_COUNTRY,String C_EMAIL,String GUID,String T_AMT,String T_SHIPPING,String T_TAX,
            String T_ORDERNUM,String C_TELEPHONE,String C_FAX,String C_SHIP_NAME,String C_SHIP_ADDRESS,String C_SHIP_CITY,
            String C_SHIP_STATE,String C_SHIP_ZIP,String C_SHIP_COUNTRY) {

        Boolean Success;

        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultBankcard.asmx/VIRTUAL_CHECK_PPD_SALE?';
        myurl += 'M_ID=' + EncodeValue(M_ID);
        myurl += '&M_KEY=' + EncodeValue(M_Key);
        myurl += '&C_ORIGINATOR=' + EncodeValue(C_ORIGINATOR_ID);
        myurl += '&C_FIRST_NAME=' + EncodeValue(C_FIRST_NAME);
        myurl += '&C_MIDDLE_INITIAL=' + EncodeValue(C_MIDDLE_INITIAL);
        myurl += '&C_LAST_NAME=' + EncodeValue(C_LAST_NAME);
        myurl += '&C_SUFFIX=' + EncodeValue(C_SUFFIX);
        myurl += '&C_ADDRESS=' + EncodeValue(C_ADDRESS);
        myurl += '&C_CITY=' + EncodeValue(C_CITY);
        myurl += '&C_STATE=' + EncodeValue(C_STATE);
        myurl += '&C_ZIP=' + EncodeValue(C_ZIP);
        myurl += '&C_COUNTRY=' + EncodeValue(C_COUNTRY);
        myurl += '&C_EMAIL=' + EncodeValue(C_EMAIL);
        myurl += '&GUID=' + EncodeValue(GUID);
        myurl += '&T_AMT=' + EncodeValue(T_AMT);
        myurl += '&T_SHIPPING='+ EncodeValue(T_SHIPPING);
        myurl += '&T_TAX='+ EncodeValue(T_TAX);
        myurl += '&T_ORDERNUM=' + EncodeValue(T_ORDERNUM);
        myurl += '&C_TELEPHONE=' + EncodeValue(C_TELEPHONE);
        myurl += '&C_FAX=' + EncodeValue(C_FAX);
        myurl += '&C_SHIP_NAME=' + EncodeValue(C_SHIP_NAME);
        myurl += '&C_SHIP_ADDRESS=' + EncodeValue(C_SHIP_ADDRESS);
        myurl += '&C_SHIP_CITY=' + EncodeValue(C_SHIP_CITY);
        myurl += '&C_SHIP_STATE=' + EncodeValue(C_SHIP_STATE);
        myurl += '&C_SHIP_ZIP=' + EncodeValue(C_SHIP_ZIP);
        myurl += '&C_SHIP_COUNTRY=' + EncodeValue(C_SHIP_COUNTRY);

        String ResXML='';
        ResXML = HTTPSageRequest(myurl);

        Success = false;
        this.strStatus ='';
        this.Response_message ='';
        this.Response_Code = '';
        Success = CheckTransactionResponse(ResXML);

        return Success;
    }



/***Ketan A Benegal-EFT Processing - Code Start*****************************************/
    public String createEFTGuid(String strRoutingNum, String strAccNum, String strAcctType, String strStation){
    //    System.debug('id:'+ objID + '---routingnum:'+strRoutingNum + '---strAccNum:'+strAccNum+'---strAcctType:'+strAcctType);
//        CC_Alias__c lstNewEFT = [SELECT AVSResult__c, Account__c, Amount__c, AuthCode__c, Bank_Account_Owner_Name__c, Bank_Account_Type__c, Bank_Name__c, Name, CVVResult__c, Card_Holder_Name__c, Card_Type__c, Contact__c, CreatedById, CreatedDate, IsDeleted, Do_Not_Use__c, Expire_Date__c, GUID__c, Last_Four_Digits__c, LastModifiedById, LastModifiedDate, Merchant_Account__c, OwnerId, Payment_Description__c, Payment_ID__c, PaymentTypeID__c, Id, RecordTypeId, Response__c, ResponseCode__c, ResponseIndicator__c, ResponseMessage__c, SystemModstamp, TransactionID__c, VANReference__c FROM CC_Alias__c  where Id = :objId LIMIT 1];
        Merchant_Accounts__c merchAcc = [SELECT Name, Merchant_ID__c, Merchant_Key__c, Id, Station__c FROM Merchant_Accounts__c where Station__c = :strStation];
        String M_ID, M_KEY, ROUTING_NUMBER, ACCOUNT_NUMBER, C_ACCT_TYPE;
        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVault.asmx/INSERT_VIRTUAL_CHECK_DATA?';                    
        myurl += 'M_ID=' + EncodeValue(merchAcc.Merchant_ID__c);
        myurl += '&M_KEY=' + EncodeValue(merchAcc.Merchant_Key__c);
        myurl += '&ROUTING_NUMBER=' + EncodeValue(strRoutingNum);
        myurl += '&ACCOUNT_NUMBER=' + EncodeValue(strAccNum);
        myurl += '&C_ACCT_TYPE=' + EncodeValue(strAcctType);

        /*myurl += 'M_ID=' + EncodeValue('858687144948');
        myurl += '&M_KEY=' + EncodeValue('Q7P7Y6G7N7J6');
        myurl += '&ROUTING_NUMBER=' + EncodeValue('056008849');
        myurl += '&ACCOUNT_NUMBER=' + EncodeValue('12345678901234');
        myurl += '&C_ACCT_TYPE=' + EncodeValue('DDA');
        */
        

        System.debug('request URL:'+ myurl);
        String ResXML='';
        //ResXML = HTTPSageRequest(myurl);
        try {
            Http h = new Http();
            
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(myurl);
            req.setMethod('GET');
            req.setTimeOut(60000);
            HttpResponse res = h.send(req);
            return checkCreateGuidResponse(res.getBody());        
       }Catch(Exception Ex) {
           return '';
       }
    }
    
    
    public String processEFTPayment(Id objId){
        CC_Alias__c lstNewEFT = [SELECT AVSResult__c, Account__c, Amount__c, AuthCode__c, Bank_Account_Owner_Name__c, Bank_Account_Type__c, Bank_Name__c, Name, CVVResult__c, Card_Holder_Name__c, Card_Type__c, Contact__c, Contact__r.FirstName, Contact__r.middle_name__c, Contact__r.LastName, CreatedById, CreatedDate, IsDeleted, Do_Not_Use__c, Expire_Date__c, GUID__c, Last_Four_Digits__c, LastModifiedById, LastModifiedDate, Merchant_Account__r.Merchant_Key__c, Merchant_Account__r.Merchant_ID__c, Merchant_Account__c, OwnerId, Payment_Description__c, Payment_ID__c, PaymentTypeID__c, Id, RecordTypeId, Response__c, ResponseCode__c, ResponseIndicator__c, ResponseMessage__c, SystemModstamp, TransactionID__c, VANReference__c FROM CC_Alias__c  where Id = :objId LIMIT 1];
        Merchant_Accounts__c merchAcc = [SELECT CreatedById, CreatedDate, IsDeleted, LastModifiedById, LastModifiedDate, Name, Merchant_ID__c, Merchant_Key__c, OwnerId, Id, Station__c, SystemModstamp FROM Merchant_Accounts__c where Id = :lstNewEFT.Merchant_Account__c];
        String M_ID, M_KEY, ROUTING_NUMBER, ACCOUNT_NUMBER, C_ACCT_TYPE, strOriginatorId;
        String myurl ;
        myurl = 'https://www.sagepayments.net/web_services/wsVault/wsVaultvirtualcheck.asmx?';                    
        myurl += 'M_ID=' + EncodeValue(merchAcc.Merchant_ID__c);
        myurl += '&M_KEY=' + EncodeValue(merchAcc.Merchant_Key__c);
        myurl += '&C_ORIGINATOR_ID=' + EncodeValue(strOriginatorId);
        myurl += '&C_FIRST_NAME=' + EncodeValue(lstNewEFT.Contact__r.FirstName);
        myurl += '&C_MIDDLE_INITIAL=' + EncodeValue(lstNewEFT.Contact__r.middle_name__c);
        myurl += '&C_LAST_NAME=' + EncodeValue(lstNewEFT.Contact__r.LastName);
        myurl += '&C_SUFFIX=' + EncodeValue(lstNewEFT.Contact__r.suffix__c);
     /*   myurl += '&C_ADDRESS=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_CITY=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_STATE=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_ZIP=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_COUNTRY=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_EMAIL=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&GUID=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&T_AMT=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);
        myurl += '&C_TELEPHONE=' + EncodeValue(lstNewEFT.Contact__r.MiddleName);*/
        System.debug('request URL:'+ myurl);
        String ResXML='';
        //ResXML = HTTPSageRequest(myurl);
        return HTTPSageRequest(myurl);
        
    }

    public String checkCreateGuidResponse(String strXMLResponse)
    {
         Boolean blnRetValue = false;
         String strResponseCode;
         If(strXMLResponse == null || strXMLResponse.Length() == 0) {
             return null;
         }
         else if(strXMLResponse.contains('diffgr') == false)
         {
             Response_message = strXMLResponse;
             return null;
         }
         else {
             try {

                 XMLDom dom = new XMLDom(strXMLResponse);
                 XMLDom.Element xmlObj ;
                 


                 if(dom.getElementByTagName('diffgr:diffgram') != null) {
                    xmlObj = dom.getElementByTagName('diffgr:diffgram');
                    if (xmlObj.getElementsByTagName('SUCCESS').size()>0) {
                        
                        strStatus = xmlObj.getElementsByTagName('SUCCESS')[0].nodeValue;
                        Response_message = xmlObj.getElementsByTagName('MESSAGE')[0].nodeValue;
                        Response_Code = xmlObj.getElementsByTagName('GUID')[0].nodeValue;

                        system.debug('###Status:' + strStatus + ' -Message:' + Response_message +' #### Response_Code:'+Response_Code );
                        if(strStatus != null && strStatus.Length()>0 )
                        {
                            blnRetValue = true;
	                    }
                    }
                }
                else {
                    Response_message = strXMLResponse;
                    blnRetValue = false;
                }
             }catch(Exception ex){
                 Response_Code = '';
                 Response_message = 'Response Reading Error';
             }
         }
         strResponseCode= Response_Code;
         return strResponseCode;
    }

    
/***Ketan A Benegal-EFT Processing - Code End*******************************************/


}