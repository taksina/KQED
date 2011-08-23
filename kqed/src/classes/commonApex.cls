Public Class commonApex{
    Public Static String getInEligibilityMessage(){
        return 'Premium is not eligible.';
    }
    Public Static Boolean isEligible(Opportunity Giving, Product2 Benefit){
        boolean eligibal = false;
        if((Benefit.Qualifying_Gift_Kind__c != null && Benefit.Qualifying_Gift_Kind__c.trim().length()>0) &&
        (Benefit.Qualifying_Payment_Method__c != null && Benefit.Qualifying_Payment_Method__c.trim().length()>0)){
            if((Giving.Gift_Kind__c != null && Giving.Gift_Kind__c.trim().toUpperCase() == Benefit.Qualifying_Gift_Kind__c.trim().toUpperCase()) &&
            (Giving.Payment_Method__c != null && Giving.Payment_Method__c.trim().toUpperCase() == Benefit.Qualifying_Payment_Method__c.trim().toUpperCase())){
                eligibal = true;
            }
            else{
                eligibal = false;
            }
        }else{
            eligibal = true;
        }
        return eligibal;
    }
    Public Static String getDeveloperNameById(ID recordId){
        String DeveloperName = '';
        if(recordId != null){
            List<RecordType> lstRc = [Select DeveloperName From RecordType Where Id=:recordId];
            if(lstRc != null && lstRc.size()>0){
                DeveloperName = NVL(lstRc[0].DeveloperName);
            }
        }
        Return DeveloperName;
    }
    Public Static String NVL(String val){
        if(val == null)
            return '';
        else
            return val.trim();
    }
    Public Static List<String> checkBenefitEligibility(Opportunity Giving, Set<ID> BenefitID){
        List<String> lstInEligibleBenefit = new List<String>();
        List<Product2> lstBenefit = new List<Product2>();
        Opportunity Parent = new Opportunity();
        Parent = getParentGiving(Giving);
        lstBenefit = [Select Id, ProductCode, Qualifying_Gift_Kind__c, Qualifying_Payment_Method__c From Product2 Where Id in: BenefitID];
        if(lstBenefit != null && lstBenefit.size()>0){
            for(Product2 Benefit:lstBenefit){
                if(isEligible(Giving, Benefit)==false){
                    if(Parent!= null && isEligible(Parent, Benefit)==false){
                        //lstInEligibleBenefit.add(Benefit.ProductCode);
                        lstInEligibleBenefit.add(Benefit.Id);
                    }
                    else{
                        //lstInEligibleBenefit.add(Benefit.ProductCode);
                        lstInEligibleBenefit.add(Benefit.Id);
                    }
                }
            }
        }
        return lstInEligibleBenefit;
    }
    
    Static Opportunity getParentGiving(Opportunity Giving){
        Opportunity Parent = new Opportunity();
        try{
            if(Giving != null && Giving.Recurring_Donation_Opportunity__c != null){
                Parent = [Select Id, Gift_Kind__c, Payment_Method__c 
                From Opportunity Where Id=:Giving.Recurring_Donation_Opportunity__c];
            }
        }catch(Exception ex){
        }
        return Parent;
    }

    Public Static String getDeveloperNameByCampaignName(String CampaignName){
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
                developerName = 'Foundation_Giving';
            if(CampaignName == 'Events')
                developerName = 'Events_Giving';    
        }
        return developerName;
    }
    Public Static String getCampaignByDeveloperName(String DeveloperName){
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
            if(DeveloperName == 'Foundation_Giving')
                CampaignName = 'Foundation';
            if(DeveloperName == 'Events_Giving')
                CampaignName = 'Events';    
        }
        return CampaignName;
    }
    
    Public Static String getTrack(String GiftType, String Channel, String SubChannel){
        String Track = '';
        String RadioTV = 'by Pledge';
        String Mail = 'by Mail';
        String Email = 'by Email';
        String TelesalesInbound = 'by Member Service';
        String TelesalesOutbound = 'by Telemarketing';
        String Mobile = 'by Mobile';
        String EventType = 'by Event';
        String Web = 'by Web';
        if(Channel == null) Channel = '';
        if(SubChannel == null) SubChannel = '';
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
        }
        
        return Track;
    }
    
    public static String getObjectNameById(String strId) 
    {
        Map<String, Schema.SObjectType> schemas = Schema.getGlobalDescribe();
        Set<String> keys = schemas.keySet();
        String strKey=''; 
        String strObject = 'Not Found';
        strId = strId.substring(0,3);            
        for (String key : keys) 
        {
            Schema.SObjectType schema = schemas.get(key);
            Schema.DescribeSObjectResult d = schema.getDescribe();
           strKey = d.getKeyPrefix();
           if(strKey == null)
               strKey = '';
            if(strId == strKey)
                strObject = d.getName();
        }            
        return strObject;
    }  
    public static String getFieldName(String strId){
        String strObject = getObjectNameById(strId);
        String field = strObject;
        if(field.lastIndexOf('__')<0)
        {
            field = field + '__c';
        }   
        return field;  
    }
    
    public static String getFields(String ObjectName){
        //List<String> fields = new List<String>();
        String[] fields;
        String strField='';
        fields = getFieldsInArray(ObjectName);
        for(integer i=0;i<fields.size();i++){
            if(strField=='')
                strField = fields[i];
            else
                strField = strField + ', ' + fields[i];            
        }
        
        return strField;
    }
    public static String[] getFieldsInArray(String ObjectName) {        
        //List<SelectOption> fields = new List<SelectOption>();             
//        List<String> fields = new List<String>();
        String[] fields;
        Map<String, Schema.SObjectField> accountFieldMap = Schema.getGlobalDescribe().get( ObjectName ).getDescribe().fields.getMap();            
        System.assert( accountFieldMap != null );                  
        for( String fieldName : accountFieldMap.keySet() ) {              
            Schema.DescribeFieldResult field = accountFieldMap.get( fieldName ).getDescribe();                
            String fieldType = ( '' + field.getType() ).replace( 'Schema.DisplayType.', '' );                
            //fields.add( new String( field.getLocalName(), field.getLabel() ) );                   
            fields.add( field.getLocalName());                   
        }     
        //System.debug( 'options values: ' + options );             
        //return options; 
        return fields;         
   } 
    static testMethod void commonApex()
    {
        //commonApex controller = new commonApex();
        commonApex.getInEligibilityMessage();
        
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
        opp.Gift_Kind__c = 'One Payment';
        opp.Payment_Method__c = 'Cash';
        insert opp;       
        
        Product2 p = new Product2();
        p.Qualifying_Gift_Kind__c='One Payment';
        p.Qualifying_Payment_Method__c='Cash';
        commonApex.isEligible(opp,p);
        
        
        Product2 p2 = new Product2();
        p2.ProductCode = '1222121';
        p2.Name = 'Test Products';
        p2.Qualifying_Gift_Kind__c = '3222222';
        p2.Qualifying_Payment_Method__c = 'Post';
        insert p2;
        
        Set<ID> pid1 = new Set<ID>();
        pid1.add(p2.Id);
        commonApex.checkBenefitEligibility(opp,pid1);
        
        commonApex.getObjectNameById('ObjName');
        commonApex.getFieldName('FieldName');
        //commonApex.getFields('Account');
        //commonApex.getFieldsInArray('Account');
        //commonApex.getDeveloperNameByCampaignName('Test Campaign');
        //commonApex.getLocalName();
       // commonApex.getFieldsInArray('FieldName1');
       
        //Insert p;
        try {
            Set<ID> pid;
            pid.add(p.Id);
            commonApex.checkBenefitEligibility(opp,pid);
        }catch(Exception ex) {}
        
        commonApex.getParentGiving(opp);
        commonApex.getDeveloperNameByCampaignName('Restricted');
        commonApex.getDeveloperNameByCampaignName('In Kind');
        commonApex.getDeveloperNameByCampaignName('Auction');
        commonApex.getDeveloperNameByCampaignName('Annual');
        commonApex.getDeveloperNameByCampaignName('Matching');
        commonApex.getDeveloperNameByCampaignName('Capital');
        commonApex.getDeveloperNameByCampaignName('Planned Gift');
        commonApex.getDeveloperNameByCampaignName('Sales');
        commonApex.getDeveloperNameByCampaignName('Foundation');
        commonApex.getDeveloperNameByCampaignName('Events');
        
        commonApex.getCampaignByDeveloperName('Restricted_Giving');
        commonApex.getCampaignByDeveloperName('In_Kind_Gifts');
        commonApex.getCampaignByDeveloperName('Auction_Giving');
        commonApex.getCampaignByDeveloperName('Annual_Giving');
        commonApex.getCampaignByDeveloperName('Matching_Gifts');
        commonApex.getCampaignByDeveloperName('Capital_Campaign_Giving');
        commonApex.getCampaignByDeveloperName('Planned_Giving');
        commonApex.getCampaignByDeveloperName('Sales_Giving');
        commonApex.getCampaignByDeveloperName('Foundation_Giving');
        commonApex.getCampaignByDeveloperName('Events_Giving');
        
        commonApex.getTrack('NEW','RADIO','');
        commonApex.getTrack('NEW','MAIL','');
        commonApex.getTrack('NEW','EMAIL',null);
        commonApex.getTrack('NEW','TELESALES','INBOUND');
        commonApex.getTrack('NEW','TELESALES','OUTBOUND');
        commonApex.getTrack('NEW','TV','OUTBOUND');
        commonApex.getTrack('NEW','MOBILE',null);
        commonApex.getTrack('NEW','EVENT TYPE','');
        commonApex.getTrack('NEW','WEB','');
        
    }
   
}