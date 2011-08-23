global class BatchExecPAYMENT_BATCH implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global final String Query;
 
    global BatchExecPAYMENT_BATCH(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoPaymentBatchStatus(scope);
    }

    void DoPaymentBatchStatus(List<sObject> scope) {
        
        System.debug('###start1');
        
                
        Boolean Success;
        String strId;
        String M_ID;
        String M_KEY;
        
        String C_NAME;
        String C_ADDRESS;
        String C_CITY;
        String C_STATE;
        String C_ZIP;
        String C_COUNTRY;
        String C_EMAIL;
        String GUID;
        String T_CUSTOMER_NUMBER;
        String T_AMT;
        String T_SHIPPING;
        String T_TAX;
        String T_ORDERNUM;
        String C_TELEPHONE;
        String C_FAX;
        String C_SHIP_NAME;
        String C_SHIP_ADDRESS;
        String C_SHIP_CITY;
        String C_SHIP_STATE;
        String C_SHIP_ZIP;
        String C_SHIP_COUNTRY;
        
        String C_FIRST_NAME,C_MIDDLE_INITIAL,C_LAST_NAME,C_SUFFIX;
        
        for(sObject s : scope) {
            Transaction_Batch__c ObjTrasBatch = (Transaction_Batch__c)s;
            
            strId = BlankIsNull(ObjTrasBatch.Opportunity_Id__c);
            M_ID = BlankIsNull(ObjTrasBatch.Merchant_id__c);
            M_KEY = BlankIsNull(ObjTrasBatch.Merchant_key__c);
            C_NAME = '';
            C_ADDRESS = '';
            C_CITY = '';
            C_STATE = '';
            C_ZIP = '';
            C_COUNTRY = '';
            C_EMAIL= '';
            GUID = BlankIsNull(ObjTrasBatch.GUID__c);
            T_CUSTOMER_NUMBER = '';
            T_AMT = '';
            T_SHIPPING = '';
            T_TAX = '';
            T_ORDERNUM = '';
            C_TELEPHONE = '';
            C_FAX = '';
            C_SHIP_NAME = '';
            C_SHIP_ADDRESS = '';
            C_SHIP_CITY = '';
            C_SHIP_STATE = '';
            C_SHIP_ZIP = '';
            C_SHIP_COUNTRY = '';
            
            C_FIRST_NAME = '';
            C_MIDDLE_INITIAL = '';
            C_LAST_NAME = '';
            C_SUFFIX = '';
            
           If(strId != null && strId != ''){
                 List<Opportunity> lstOpp = New List<Opportunity>
                ([Select ID, CC_EFT_Alias__r.Contact__r.Preferred_Address__r.City__c,CC_EFT_Alias__r.Account__r.Preferred_Address__r.City__c 
                   ,Status__c,Response_message__c,Response_Code__c From Opportunity where ID=: strId]);
                System.debug('###lstoppsize:' + lstOpp.size());
                if(lstOpp.size() == 1)
                {
                    Opportunity o = lstOpp[0];
                    
                    
                    if (o.CC_EFT_Alias__r.Contact__c != null){
                        C_NAME = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.FirstName) + '' + BlankIsNull(o.CC_EFT_Alias__r.Contact__r.LastName);
                        C_ADDRESS =  BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Preferred_Address__r.Street_1__c);
                        C_CITY =  BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Preferred_Address__r.City__c);
                        C_STATE =  BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Preferred_Address__r.State__c);
                        C_ZIP =   BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Preferred_Address__r.Postal_Code__c);
                        C_COUNTRY = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Preferred_Address__r.Country__c);
                        C_EMAIL = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Email);
                        T_CUSTOMER_NUMBER = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Id);
                        
                        C_FIRST_NAME = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.FirstName);
                        C_MIDDLE_INITIAL = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.middle_name__c);
                        IF(C_MIDDLE_INITIAL != null && C_MIDDLE_INITIAL != '')
                        {
                            C_MIDDLE_INITIAL = C_MIDDLE_INITIAL.Substring(0,1).toUpperCase();
                        }
                        C_LAST_NAME = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.LastName);
                        C_SUFFIX = BlankIsNull(o.CC_EFT_Alias__r.Contact__r.Suffix__c);
                       
                    }
                    else if (o.CC_EFT_Alias__r.Account__c != null) {
                        C_NAME = BlankIsNull(o.CC_EFT_Alias__r.Account__r.Name);
                        C_ADDRESS =  BlankIsNull(o.CC_EFT_Alias__r.Account__r.Preferred_Address__r.Street_1__c);
                        C_CITY =  BlankIsNull(o.CC_EFT_Alias__r.Account__r.Preferred_Address__r.City__c);
                        C_STATE =  BlankIsNull(o.CC_EFT_Alias__r.Account__r.Preferred_Address__r.State__c);
                        C_ZIP =   BlankIsNull(o.CC_EFT_Alias__r.Account__r.Preferred_Address__r.Postal_Code__c);
                        C_COUNTRY = BlankIsNull(o.CC_EFT_Alias__r.Account__r.Preferred_Address__r.Country__c);
                        C_EMAIL = '';
                        T_CUSTOMER_NUMBER = BlankIsNull(o.CC_EFT_Alias__r.Account__r.Id);
                    }                   
                    
                    String strAmt='';
                    if(ObjTrasBatch.Payment_Amount__c != null){
                        strAmt= ObjTrasBatch.Payment_Amount__c.toPlainString();
                    }
                    T_AMT = BlankIsNull(strAmt);
                    T_SHIPPING = '';
                    T_TAX = '';
                    T_ORDERNUM = '';
                    C_TELEPHONE = '';
                    C_FAX = '';
                    C_SHIP_NAME = '';
                    C_SHIP_ADDRESS = '';
                    C_SHIP_CITY = '';
                    C_SHIP_STATE = '';
                    C_SHIP_ZIP = '';
                    C_SHIP_COUNTRY  = '';                   
                                       
                    Success = false;
                    SageTransactionProcess objSageTP = new SageTransactionProcess();
                    if(o.Payment_method__c == 'Electronic Funds Transfer')
                    {
                        String C_ORIGINATOR_ID= '';
                        
                        Success = objSageTP.SageVirtualCheckPaymentRequest(M_ID,M_KEY,C_ORIGINATOR_ID,C_FIRST_NAME,C_MIDDLE_INITIAL,
                                            C_LAST_NAME,C_SUFFIX,C_ADDRESS,C_CITY,C_STATE,C_ZIP,C_COUNTRY,C_EMAIL,GUID,T_AMT,
                                            T_SHIPPING,T_TAX,T_ORDERNUM,C_TELEPHONE,C_FAX,C_SHIP_NAME,C_SHIP_ADDRESS,C_SHIP_CITY,
                                            C_SHIP_STATE,C_SHIP_ZIP,C_SHIP_COUNTRY);
                    }
                    else
                    {
                        Success = objSageTP.SagePaymentRequest(M_ID,M_KEY,C_NAME,C_ADDRESS,C_CITY,C_STATE,C_ZIP,C_COUNTRY,C_EMAIL,GUID,
                                            T_CUSTOMER_NUMBER,T_AMT,T_SHIPPING,T_TAX,T_ORDERNUM,C_TELEPHONE,C_FAX,C_SHIP_NAME,
                                            C_SHIP_ADDRESS,C_SHIP_CITY,C_SHIP_STATE,C_SHIP_ZIP,C_SHIP_COUNTRY);
                    }
                    ObjTrasBatch.Process_date__c = System.Today();
                    ObjTrasBatch.Submit_count__c = ObjTrasBatch.Submit_count__c + 1 ;
                    
                    If(Success == true && objSageTP.strStatus =='A')
                    {
                      //if(ObjTrasBatch.Status__c != null && ObjTrasBatch.Status__c == 'FAIL') {
                      ObjTrasBatch.Response_Code__c = '';
                      ObjTrasBatch.Response_message__c = '';
                      //}
                      ObjTrasBatch.Status__c = 'SUCCESS';
                    } else
                    {
                       ObjTrasBatch.Response_message__c = objSageTP.Response_message;
                       ObjTrasBatch.Status__c = 'FAIL';
                       //if(Response_Code != ''){ 
                       ObjTrasBatch.Response_Code__c = objSageTP.Response_Code;
                       //}
                    }
                    //lstbatch.add(ObjTrasBatch);
                    Update ObjTrasBatch;
                    
                    //List<Opportunity> objOpp = new List<Opportunity>([Select Id From Opportunity Where Id =: strId]);
                    //if(objOpp.Size()>0)
                    //{
                    o.Status__c =  ObjTrasBatch.Status__c;
                    o.Response_Code__c =  ObjTrasBatch.Response_Code__c;
                    o.Response_message__c = ObjTrasBatch.Response_message__c;
                    Update o;
                    //}
                }               
            }
        }

    }

    Private String BlankIsNull(String Value)
    {
        if(Value == null) 
            return '';
        else
            return Value; 
    }

    global void finish(Database.BatchableContext BC) {
        //System.debug('####Update Completed...');
    }
}