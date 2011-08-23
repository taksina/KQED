Public Class PRROtherBoards{

    public list<Bios__c> TruBios{get;set;}
    public String Delid{get;set;}
    public string id{get;set;}
    public string TruRTid{get; set;}
    public string Trusize{get; set;}
        
    Public String Contactname{get; set;}
    public PRROtherBoards(ApexPages.StandardController controller) {
        PageLoad();
    }
    public PRROtherBoards() {
        PageLoad();
    }
    public void PageLoad(){
        try{
            TruRTid=[Select id from recordtype where name = 'Board/Trustee'][0].id;
        }
        catch(Exception ex)
        {
            System.debug('Exception in catch'+ex.getmessage());
        }
    
        List<Prospect_Research_Reports__c> lstId =[select contact__c from Prospect_Research_Reports__c where id=: ApexPages.CurrentPage().getParameters().get('id')];
        id = lstId[0].contact__c;
        Delid='aaa';
        List<Recordtype> rt = [Select r.Name, r.Id From RecordType r where name ='Education'];
    
        Trusize='';
        met();
    }    
    

    
    public void Met(){
        TruBios=[SELECT Id, Name,name__C, Account__c, Board_Level__c,Nominated_By__c, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
         Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
         Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c  from Bios__c 
         where Related_To__c=:id and recordtypeid=:trurtid];
         
         if(Trubios!=null)
         Trusize='Other Board' +' '+'['+String.valueof(Trubios.size()) +']';
         if(Trubios.size()==0)
         Trusize='Other Board';
         
    }

    public PageReference Delmet() {
    System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'+''+Delid);
    try{
    Bios__c b= [SELECT Id, Name from Bios__c where id=:DelId];
    delete b;
    }
    catch(Exception e)
    {
    System.debug('Delid not available');
    System.debug(e);
    }
    pagereference pg = new pagereference('/apex/tabpanel?id='+id);
    return pg;
    }
    
    

    public static testmethod void tes(){
        Contact c = new Contact();
        c.Lastname='test';
        insert c;
        List<Bios__c> bb = [Select id, name from Bios__c limit 1];
        Apexpages.CurrentPage().getParameters().put('id', c.id);
        tabscontroller tc = new tabscontroller(new ApexPages.StandardController(c));
        //Pagereference pg = tc.bio();
        if(bb != null && bb.size() > 0) {              
        tc.met();
        pagereference pgg = tc.newfun();
        //List<Bios__c> b = new List<bios__c>([SELECT id, name from Bios__c where id=:bb[0].id limit 1]); 
        tc.delId=bb[0].id;
        pagereference pg = tc.delmet(); 
        }
    }
    
}