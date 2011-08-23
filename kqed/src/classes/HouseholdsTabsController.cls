public class HouseholdsTabsController {

    public List<Bios__c> EduBios{get;set;}
    public List<Bios__c> IntBios{get;set;}
    public List<Bios__c> AwaBios{get;set;}
    public List<Bios__c> EmpBios{get;set;}
    public List<Bios__c> FinBios{get;set;}
    public List<Bios__c> MemBios{get;set;}
    public List<Bios__c> VolBios{get;set;}
    public List<Bios__c> AffBios{get;set;}
    public List<Bios__c> RatBios{get;set;}
    public list<Bios__c> Trubios{get;set;}
    
     
       
    public String Delid{get;set;}
    public string id{get;set;}
    
    Public String EduRTid{get; set;}
    Public String IntRTid{get; set;}
    public string AwaRTid{get; set;}
    public string EmpRTid{get; set;}
    public string FinRTid{get; set;}
    public string MemRTid{get; set;}
    public string VolRTid{get; set;}
    public string AffRTid{get; set;}
    public string RatRTid{get; set;}
    public string TruRTid{get; set;}
    
    public String Activetab{get; set;}
    public HouseholdsTabsController(ApexPages.StandardController Controller) {
    try{
    EduRTid=[Select id from recordtype where name = 'Education'][0].id;
    IntRTid=[Select id from recordtype where name = 'Interest'][0].id;
    AwaRTid=[Select id from recordtype where name = 'Award'][0].id;
    EmpRTid=[Select id from recordtype where name = 'Employment'][0].id;
    FinRTid=[Select id from recordtype where name = 'Financial'][0].id;
    MemRTid=[Select id from recordtype where name = 'Membership'][0].id;
    VolRTid=[Select id from recordtype where name = 'Volunteering'][0].id;
    AffRTid=[Select id from recordtype where name = 'Affiliation'][0].id;
    RatRTid=[Select id from recordtype where name = 'Rating/Closeness'][0].id;
    //BbrRTid=[Select id from recordtype where name = 'BlackBaud Ratings'][0].id;
    TruRTid=[Select id from recordtype where name = 'Board/Trustee'][0].id;
    }
    catch(Exception ex)
    {
        System.debug('Exception in catch'+ex.getmessage());
    }
    
    id=ApexPages.CurrentPage().getParameters().get('id');
    Delid='aaa';
    List<Recordtype> rt = [Select r.Name, r.Id From RecordType r where name ='Education'];


    Activetab=rt[0].id;
    met();
    }
    
    //public pagereference Bio() {
    //System.debug('##################################################################################');
    //pagereference p= new pagereference('https://tapp0.salesforce.com/setup/ui/recordtypeselect.jsp?ent=01IT000000055sN&retURL=%2Fa0E%2Fo&save_new_url=%2Fa0E%2Fe%3FretURL%3D%252Fa0E%252Fo');
    //p.setredirect(true);
    //return p;
    //}
    
    public void Met(){
    
    EduBios=[SELECT Id, Name,name__C, recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c  from Bios__c 
             where Account__c=:id and recordtype.name='Education'];
             
    IntBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c 
             where Account__c=:id and recordtype.name='Interest'];
             
    AwaBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Date_Awarded__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Award'];
             
    EmpBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, Account__c, Title_Role__c, Department__c, Foundation_Name__c, Location__c,
             Foundation_Assets__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Employment'];
             
    FinBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, Real_Estate_Location__c, Real_Estate_Value__c, Boat_Location__c, Boat_Value__c,
             Car_Location__c, Car_Value__c, Banking_Location__c, Banking_Value__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Financial'];
             
    MemBios=[SELECT Id, Name,name__C, recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Description__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, last_Interest_Source_Value__c, Start_Date__c, End_Date__c, Board_Level__c,
             Position__c, Nominated_by__c from Bios__c where Account__c=:id and recordtype.name='Membership'];
             
    VolBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c, Description__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c, Position__c
             from Bios__c where Account__c=:id and recordtype.name='Volunteering'];
             
    AffBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Gift_Amount__c,
             Location__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Affiliation'];
             
    RatBios=[SELECT Id, Name,name__C,recordtypeid, Rating_closeness__c, rating_type__c, Start_Date__c, End_Date__c from Bios__c where Account__c=:id and 
             recordtype.name='Rating'];
             
    
             
    TruBios=[SELECT Id, Name,name__C,recordtypeid, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c  from Bios__c 
             where Account__c=:id and recordtype.name='Board_Trustee'];
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
    pagereference pg = new pagereference('/apex/Household_tabpanel?id='+id);
   // pg.setredirect(true);
    return pg;
    }
    
    public pagereference Bio() {
    System.debug('##################################################################################'+Activetab);
    if(activetab!=null && activetab!=''){
    pagereference pg = new pagereference('/a0C/e?RecordType='+Activetab+'&retURL=/'+id);
    return pg;
    }
    
    else
    return null;
    }
    
    public static testmethod void tes(){
    
        contact c = new contact();
        c.Lastname='test';
        insert c;
        
        Account hh = new Account();
        hh.name=' hhhh';
        insert hh;
        
        List<Bios__c> bb = [Select id, name from Bios__c limit 1];

 /*   bb.Related_To__c = c.id;
    bb.recordtype.name='Education';
    bb.interest__c='1';
    bb.interest_code_value__c='2';
    insert bb;
    */

        Apexpages.CurrentPage().getParameters().put('id', hh.id);
        householdstabscontroller tc = new householdstabscontroller(new ApexPages.StandardController(hh));
        
        //Pagereference pg = tc.bio();
        
        
tc.met();

//List<Bios__c> b = new List<bios__c>([SELECT id, name from Bios__c where id=:bb[0].id limit 1]); 
tc.delId=bb[0].id;
 pagereference pg = tc.delmet(); 
 
 }
 
}