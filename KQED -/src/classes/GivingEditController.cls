public class GivingEditController {
    
    Public Opportunity objGiving {get; set;}
    public Contact objContact {get; set;}
    public Account objHousehold {get; set;}    
    String Id;
    
    
    public GivingEditController (ApexPages.StandardController controller) {
        Id = ApexPages.CurrentPage().getParameters().get('id');
        objGiving = [Select AccountId,Oppty_Related_Contact__c,StageName, Refused_Reason__c 
           ,Schedule_Start_Date__c,Payment_Date__c,Payment_Method__c,payment_amount__c,RecordTypeId
           ,Payment_method_description__c,Charge_Card_Type__c    ,Giving_Amount__c,Station__c , installment_amount__c
            From Opportunity Where Id=:Id]; 
                        
            setContactDetail();
            setHouseholdDetail();
    }   
    
    public PageReference GivingSave()
    {

        GivingSaveMe();
        
        String retURL;
        retURL = ApexPages.CurrentPage().getParameters().get('Id');
        return RedirectPage('/'+retURL);

    }
    
    Private Boolean GivingSaveMe()
    {
        Update objGiving;
        Set<ID> setGivingIDs = new Set<ID>();
        if(objGiving.Id != null){
            setGivingIds.add(objGiving.Id);
            ProcessGivingSummary.UpdateSummary(setGivingIds,true);
        }
        return true;
    }
     void setContactDetail(){ 
       
        objContact = new Contact();
    
        if(objGiving.Oppty_Related_Contact__c != null){
            
            //Ketan Benegal - 05/16/2011 - added MailingCountry, MailingStreet, Fax to the following query for Sage Integration.
            objContact = [Select Id, Name, Salutation, FirstName, LastName, Email, MobilePhone,
            Birthdate, Phone, MailingCity, MailingState, MailingPostalCode, MailingCountry, MailingStreet, Fax,
            Preferred_Address__r.Street_2__c, Preferred_Address__r.Street_1__c, Preferred_Address__r.State__c, Preferred_Address__r.Postal_Code__c, Preferred_Address__r.Country__c, Preferred_Address__r.City__c
            From Contact 
            Where Id =: objGiving.Oppty_Related_Contact__c];
        }
       
    }
    void setHouseholdDetail(){
        objHousehold = new Account();
        if(objGiving.AccountId != null){
            objHousehold = [Select Id, Name, AccountNumber, Phone, AccountType__c
            From Account
            Where Id =: objGiving.AccountId];
        }
    }
    
    PageReference RedirectPage(String URL){   
              
        PageReference P = new PageReference(URL);
        P.SetRedirect(true);        
        return P;
    }
    
    Public PageReference ChoosePaymentMode(){
        return null;
    }
    
    Public List<CC_Alias__c> getExistingChargeCard(){
       
        List<CC_Alias__c> lstChargeCard = new List<CC_Alias__c>();
        
        lstChargeCard = [Select Id, Name, Card_Type__c, Expire_Date__c, Last_Four_Digits__c from CC_Alias__c where Account__c =: objGiving.AccountId and Contact__c =: objGiving.Oppty_Related_Contact__c];
        
        List<CC_Alias__c> lstReturn = new List<CC_Alias__c>();
        
        CC_Alias__c temp = new CC_Alias__c();
        //temp.Card_Type__c = 'New';
        lstReturn.add(temp);
        
        for(CC_Alias__c e: lstChargeCard) {
            lstReturn.add(e);
        }

        return lstReturn;
    }
    
    Public PageReference NewChargeCode(){
        if(GivingSaveMe()==true){
            PageReference P = New PageReference('/apex/SageHtml');
            P.SetRedirect(true);
            return P;            
        }
        else
            return null;
    }
    static testMethod void GivingEditController(){
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
        
        insert opp;
        
         ApexPages.currentPage().getParameters().put('id', opp.Id);
        SObject o = new Account();
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
             
        //EditGiving clsTest = new EditGiving(sc);
        GivingEditController clsTest = new GivingEditController(sc);
        clsTest.GivingSave();
        clsTest.GivingSaveMe();
        clsTest.setContactDetail();
        clsTest.setHouseholdDetail();
        clsTest.RedirectPage('https://cs3.salesforce.com/006/o');
        clsTest.ChoosePaymentMode();
        clsTest.getExistingChargeCard();
        clsTest.NewChargeCode();
        
    }
    
 }