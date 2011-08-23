public class HouseholdstabController {
    public List<Bios__c> EduBios{get;set;}
    public List<Bios__c> IntBios{get;set;}
    public List<Bios__c> AwaBios{get;set;}
    public List<Bios__c> EmpBios{get;set;}
    public List<Bios__c> FinBios{get;set;}
    public List<Bios__c> MemBios{get;set;}
    public List<Bios__c> VolBios{get;set;}
    public List<Bios__c> AffBios{get;set;}
    public List<Bios__c> RatBios{get;set;}
    public list<Bios__c> TruBios{get;set;}
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
    
    public String Edusize{get; set;}
    public string Intsize{get; set;}
    public string Awasize{get; set;}
    public string Empsize{get; set;}
    public string Finsize{get; set;}
    public string Memsize{get; set;}
    public string Volsize{get; set;}
    public string Affsize{get; set;}
    public string Ratsize{get; set;}
    public string Trusize{get; set;}
    

    public String Activetab{get; set;}    
    public householdsTabController(ApexPages.StandardController Controller) {
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
    TruRTid=[Select id from recordtype where name = 'Board/Trustee'][0].id;
    }
    catch(Exception ex)
    {
        System.debug('Exception in catch'+ex.getmessage());
    }
    
    id=ApexPages.CurrentPage().getParameters().get('id');
    Delid='aaa';
    List<Recordtype> rt = [Select r.Name, r.Id From RecordType r where name ='Education'];

    Edusize='';
    Intsize='';
    Awasize='';
    Empsize='';
    Finsize='';
    memsize='';
    Volsize='';
    Affsize='';
    Ratsize='';
    Trusize='';

    Activetab=rt[0].id;
    met();
    }
    
    public void Met(){
    
    EduBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c  from Bios__c 
             where Account__c=:id and recordtype.name='Education' and (school_code__c!='' OR degree_code__c!='' OR Year_Of_Degree__c!='' OR degree_major__c!=''
             OR Start_Date__c!=null OR End_Date__c!=null)];
             
             if(Edubios!=null)
             Edusize='Education' +' '+'['+String.valueof(Edubios.size()) +']';
             if(Edubios.size()==0)
             Edusize='Education';
            
    IntBios=[SELECT Id, Name,name__C, Interest_Code__c,recordtypeid, Interest_Description__c,Interest_Description_Type__c, Code__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c 
             where Account__c=:id and recordtype.name='Interest' and (Interest_Description__c!='' OR Interest_Description_Type__c!='' OR Code__c!='') ];
             
             if(Intbios!=null)
             Intsize='interest' +' '+'['+String.valueof(Intbios.size()) +']';
             if(Intbios.size()==0)
             Intsize='Interest';
             
    AwaBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Date_Awarded__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Award' and (Name__c!='' OR Account__c!='' OR Date_Awarded__c!=null)];
             
             if(Awabios!=null)
             Awasize='Award' +' '+'['+String.valueof(Awabios.size()) +']';
             if(Awabios.size()==0)
             Awasize='Award';
             
    EmpBios=[SELECT Id, Name,name__C, Interest_Code__c, Account__c, Title_Role__c, Department__c, Foundation_Name__c, Location__c,recordtypeid,
             Foundation_Assets__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Employment' and (Account__c!='' OR Title_Role__c!='' OR Department__c!='' OR Start_Date__c!=null
             OR End_Date__c!=null OR Foundation_Name__c!='' OR Location__c!='' OR Foundation_Assets__c!='')];
             
             if(Empbios!=null)
             Empsize='Employment' +' '+'['+String.valueof(Empbios.size()) +']';
             if(Empbios.size()==0)
             Empsize='Employment';
             
    FinBios=[SELECT Id, Name,name__C, Interest_Code__c, Real_Estate_Location__c, Real_Estate_Value__c, Boat_Location__c, Boat_Value__c,
             Car_Location__c, Car_Value__c, Banking_Location__c, Banking_Value__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Financial' and (Real_Estate_Location__c!='' OR Real_Estate_Value__c!=null OR Boat_Location__c!='' OR Boat_Value__c!=null
             OR Car_Location__c!='' OR Car_Value__c!=null OR Banking_Location__c!='' OR Banking_Value__c!=null)];
             
             if(Finbios!=null)
             Finsize='Financial' +' '+'['+String.valueof(Finbios.size()) +']';
             if(Finbios.size()==0)
             Finsize='Financial';
             
    MemBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Description__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, last_Interest_Source_Value__c, Start_Date__c, End_Date__c, Board_Level__c,
             Position__c, Nominated_by__c from Bios__c where Account__c=:id and recordtype.name='Membership' and (Account__c!='' OR Board_Level__c!='' OR Position__c!=''
             OR Nominated_By__c!='' OR Start_Date__c!=null OR End_Date__c!=null)];
             
             if(Membios!=null)
             Memsize='Membership' +' '+'['+String.valueof(Membios.size()) +']';
             if(Membios.size()==0)
             Memsize='Membership';
             
    VolBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Account__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c, Description__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c, Position__c
             from Bios__c where Account__c=:id and recordtype.name='Volunteering' and (Account__c!='' OR Position__c!='' OR Start_Date__c!=null OR End_Date__c!=null)];
             
             if(Volbios!=null)
             Volsize='Volunteering' +' '+'['+String.valueof(Volbios.size()) +']';
             if(Volbios.size()==0)
             Volsize='Volunteering';
             
    AffBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c, Gift_Amount__c,
             Location__c, Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_value__c, Start_Date__c, End_Date__c from Bios__c
             where Account__c=:id and recordtype.name='Affiliation' and (Name__c!='' OR Gift_Amount__c!=null OR Location__c!='' OR Start_Date__c!=null OR End_Date__c!=null)];
             
             if(Affbios!=null)
             Affsize='Affiliation' +' '+'['+String.valueof(Affbios.size()) +']';
             if(Affbios.size()==0)
             Affsize='Affiliation';
                          
    RatBios=[SELECT Id, Name,name__C, Rating_closeness__c, rating_type__c, Start_Date__c,recordtypeid, End_Date__c from Bios__c where Account__c=:id and 
             recordtypeid=:ratrtid and (Rating_Closeness__c!='' OR Rating_Type__c!='')]; 
             
             if(Ratbios!=null)
             Ratsize='Rating/Closeness' +' '+'['+String.valueof(Ratbios.size()) +']';
             if(Ratbios.size()==0)
             Ratsize='Rating/Closeness';
             
    TruBios=[SELECT Id, Name,name__C, Interest_Code__c, School_Code__c, Degree_Code__c, Degree_Year__c, Year_Of_Degree__c,
             Degree_Major__c, Education_Begin_Date__c, Education_End_Date__c, Interest_Code_Value__c, First_Program__c,recordtypeid,
             Last_Program__c, First_Interest_Source_Value__c, Last_Interest_Source_Value__c, Start_Date__c, End_Date__c  from Bios__c 
             where Account__c=:id and recordtypeid=:trurtid];
             
             if(Trubios!=null)
             Trusize='Other Board' +' '+'['+String.valueof(Trubios.size()) +']';
             if(Trubios.size()==0)
             Trusize='Other Board';
             
             System.debug('Activetab:'+activetab);
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
    
    public pagereference Newfun()
    {
    // System.debug(Sobject.get(Schema.Bios__c.related_to__c));
    Account h = [Select id, name from Account where id=:id];
    String householdname = h.name;
    if(householdname.contains('&'))
    {
    householdname = householdname.replaceall('&','%26');
    }
    String lookupid = 'CF00NA0000005bd7L';
    system.debug(activetab);
    pagereference pg = new pagereference('/a0C/e?RecordType='+activetab+'&CF00NA0000005bd7L_lkid='+id+'&'+lookupid+'='+householdname);
    system.debug('infun'+pg.geturl());
    pg.setredirect(true);
    return pg;
    }

    public static testmethod void tes(){
    contact c = new contact();
    c.Lastname='test';
    insert c;
    Account hh = new Account();
    hh.name=' hhhh';
    insert hh;
    List<Bios__c> bb = [Select id, name from Bios__c limit 1]; //RK - removed the where clause

    Apexpages.CurrentPage().getParameters().put('id', hh.id);
    householdstabcontroller tc = new householdstabcontroller(new ApexPages.StandardController(hh));
    //Pagereference pg = tc.bio();
    tc.met();
    Pagereference pgg = tc.newfun();
    System.debug(pgg.geturl());
    //List<Bios__c> b = new List<bios__c>([SELECT id, name from Bios__c where id=:bb[0].id limit 1]); // removed redundant soql
    //tc.delId=b[0].id;
    tc.delId=bb[0].id;
    pagereference pg = tc.delmet(); 
    }
 
}