global class BatchExecRefund_BATCH implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global final String Query;
 
    global BatchExecRefund_BATCH(String q){Query=q;}

    global Database.QueryLocator start(Database.BatchableContext BC)   {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope)   {
        DoRefundBatchStatus(scope);
    }

    void DoRefundBatchStatus(List<sObject> scope) {

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

           If(strId != null && strId != ''){

                /*List<Opportunity> lstOpp = New List<Opportunity>
                ([Select ID, CC_EFT_Alias__r.Contact__r.Preferred_Address__r.City__c,CC_EFT_Alias__r.Account__r.Preferred_Address__r.City__c 
                    From Opportunity where ID=: strId]); */
                List<Refund__c> lstrefund = New List<Refund__c>
                ([Select ID, CC_Alias__r.Contact__r.Preferred_Address__r.City__c,CC_Alias__r.Account__r.Preferred_Address__r.City__c 
                   ,Status__c,Response_message__c,Response_Code__c From Refund__c where Giving__c =: strId]);

                System.debug('###lstoppsize:' + lstrefund .size());
                if(lstrefund .size() == 1)
                {
                    Refund__c r = lstrefund[0];


                    if (r.CC_Alias__r.Contact__c != null){
                        C_NAME = '';
                        C_ADDRESS =  BlankIsNull(r.CC_Alias__r.Contact__r.Preferred_Address__r.Street_1__c);
                        C_CITY =  BlankIsNull(r.CC_Alias__r.Contact__r.Preferred_Address__r.City__c);
                        C_STATE =  BlankIsNull(r.CC_Alias__r.Contact__r.Preferred_Address__r.State__c);
                        C_ZIP =   BlankIsNull(r.CC_Alias__r.Contact__r.Preferred_Address__r.Postal_Code__c);
                        C_COUNTRY = BlankIsNull(r.CC_Alias__r.Contact__r.Preferred_Address__r.Country__c);
                        C_EMAIL = BlankIsNull(r.CC_Alias__r.Contact__r.Email);
                        T_CUSTOMER_NUMBER = BlankIsNull(r.CC_Alias__r.Contact__r.Id);

                    }
                    else if (r.CC_Alias__r.Account__c != null) {
                        C_NAME = BlankIsNull(r.CC_Alias__r.Account__r.Name);
                        C_ADDRESS =  BlankIsNull(r.CC_Alias__r.Account__r.Preferred_Address__r.Street_1__c);
                        C_CITY =  BlankIsNull(r.CC_Alias__r.Account__r.Preferred_Address__r.City__c);
                        C_STATE =  BlankIsNull(r.CC_Alias__r.Account__r.Preferred_Address__r.State__c);
                        C_ZIP =   BlankIsNull(r.CC_Alias__r.Account__r.Preferred_Address__r.Postal_Code__c);
                        C_COUNTRY = BlankIsNull(r.CC_Alias__r.Account__r.Preferred_Address__r.Country__c);
                        C_EMAIL = '';
                        T_CUSTOMER_NUMBER = BlankIsNull(r.CC_Alias__r.Account__r.Id);
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
                    
                    Success = objSageTP.SageRefundRequest(M_ID,M_KEY,C_NAME,C_ADDRESS,C_CITY,C_STATE,C_ZIP,C_COUNTRY,C_EMAIL,GUID,
                                        T_CUSTOMER_NUMBER,T_AMT,T_SHIPPING,T_TAX,T_ORDERNUM,C_TELEPHONE,C_FAX,C_SHIP_NAME,
                                        C_SHIP_ADDRESS,C_SHIP_CITY,C_SHIP_STATE,C_SHIP_ZIP,C_SHIP_COUNTRY);
                                        
                    ObjTrasBatch.Process_date__c = System.Today();                    
                    If(Success == true && objSageTP.strStatus =='A')
                    {
                      if(ObjTrasBatch.Status__c != null && ObjTrasBatch.Status__c == 'FAIL') {
                          ObjTrasBatch.Response_Code__c = '';
                          ObjTrasBatch.Response_message__c = '';
                      }
                      ObjTrasBatch.Status__c = 'SUCCESS';
                      ObjTrasBatch.Submit_count__c = ObjTrasBatch.Submit_count__c + 1 ;
                    } else
                    {
                       ObjTrasBatch.Submit_count__c = ObjTrasBatch.Submit_count__c + 1 ;
                       ObjTrasBatch.Response_message__c = objSageTP.Response_message;
                       ObjTrasBatch.Status__c = 'FAIL';
                       if(objSageTP.Response_Code != ''){                           
                           ObjTrasBatch.Response_Code__c = objSageTP.Response_Code;
                       }
                    }
                    //lstbatch.add(ObjTrasBatch);
                    Update ObjTrasBatch;
                    /*
                    List<Opportunity> objOpp = new List<Opportunity>([Select Id From Opportunity Where Id =: strId]);
                    if(objOpp.Size()>0)
                    {
                        
                        Update objOpp;
                    } */
                    
                    r.Status__c =  ObjTrasBatch.Status__c;
                    r.Response_Code__c =  ObjTrasBatch.Response_Code__c;
                    r.Response_message__c = ObjTrasBatch.Response_message__c;
                    Update r;
                }               
            }
        }
        
        /*if(lstbatch != null && lstbatch.size()>0) 
        {
            //Insert lstbatch;
            
        }*/

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

   /* static testMethod void TestBatchExecTransaction_Batch() {
       Test.startTest();
        Opportunity o = new Opportunity();
        o.Payment_Date__c =  System.today();
        o.Payment_Amount__c= 15;
        insert o;
        
        Opportunity o1 = new Opportunity();
        o1.Payment_Date__c =  System.today();
        o1.Payment_Amount__c= 16;
        insert o1;
        
       
        BatchExecTransaction_Batch reassign = new BatchExecTransaction_Batch ('Select ID,Payment_Date__c,Payment_Amount__c,SFDC_GIVING_NUMBER__c from Opportunity Where Payment_Date__c = Today Limit 2');
        ID batchprocessid = Database.executeBatch(reassign,2);
 
        Test.StopTest();     
        
    }    
    */
}