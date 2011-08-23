//LAST MODIFIED BY BRW
public without sharing class OpenPositions 
{

    public List<Position__c> pos {get; set;}
    Public Boolean Guest_User    {get; set;}
    Public String username       {get; set;}
    Public String password       {get; set;}
    /*Ketan Benegal - Code Start*/
    //public String myname{get;set;}
    public String myname
    {
        get { return (myname == null ? null : 'Welcome, ' + myname + '!' ); } 
        set;
    }
    
    public String getPositionDescription(Position__c p)
    {
        return pos[0].Position_Title__r.Description__c;
    }    
    /*Ketan Benegal - Code End*/    
    public OpenPositions()
    {
    //  System.debug(UserInfo.getUserType());
        if(UserInfo.getUserType() != 'Guest')
        {
            Guest_User=false;
            //Ketan Benegal - Commented out - this is incorrect. - Start
            //myname = UserInfo.getUserType();
            myname = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
            //Ketan Benegal - Code End
        }
        else
        {
            Guest_User = true;
            myname     = 'Guest';
        }
    }
    
    Public PageReference login() 
    {
        String StartUrl;
        List<Profile> profileName = [select p.name from profile p where p.id in (select u.profileid from user u where u.username = :username) LIMIT 1];
        if ((profileName != null && profileName.size() > 0) && profileName[0].Name == 'Hiring Managers')
        {
              //TODO DOES THIS NEED TO BE CHANGED FOR PRODUCTION
              //PageReference pageRef = System.Page.openpositionHiringManager;
             //pageRef.setRedirect(true);
             //return pageRef;  a0j
             //startURL = '/a0X?fcf=00BT0000002nCyT&rolodexIndex=-1&page=1';
             //startURL = '/a0j?fcf=00BT0000002nCyT&rolodexIndex=-1&page=1';
             startURL = '/a0j/o';
        }
        else
        {
            //MODIFIED BRW 2/19/2010
            //startUrl = System.currentPageReference().getParameters().get('startURL');
            pagereference pg = new pagereference('/apex/openpositions');
            startUrl = pg.geturl();
        }
        /*if (profileName[0].Name != 'Hiring Managers'){
            startUrl = System.currentPageReference().getParameters().get('startURL');
        }*/
        
        return Site.login(username, password, startUrl);
    }
    
    //wtf is met?
    public PageReference met() 
    {
        pos = [SELECT Id, Name, Job_Requisition_Details__c, Position__c.Title__c, Position__c.Functional_Area__c, Publish_OpenDate__c, Type__c, departments__r.name, Start_Date__c, position_Title__r.Description__c, Affiliation__C,
             Location__c from position__c where status__c= 'Open - Approved' and Active__c=True  and publish_OpenDate__c <= :date.today() order by publish_OpenDate__c desc];
             return null;
    }
    
    public static testMethod void testHiringManagerLogin()
    {
        String username    = 'hiringmanager1@gmail.com';
        String password    = 'abcd1234';
        //Test.startTest();
        OpenPositions op   = new OpenPositions();
        op.username        = username;
        op.password        = password;
        System.assertEquals(op.username, username);
        System.assertEquals(op.password, password);
        System.assertEquals(null, op.login());
        //Test.stopTest();
    }
    
    public static testMethod void testRegularLogin()
    {
        String username    = 'hiringmanager1@gmail.com';
        String password    = 'abcd1234';
        //Test.startTest();
        OpenPositions op   = new OpenPositions();
        op.username        = username;
        op.password        = password;
        System.assertEquals(op.username, username);
        System.assertEquals(op.password, password);
        System.assertEquals(null, op.login());
        //Test.stopTest();
    }
    
    public static testMethod void testMet()
    {
        //Test.startTest();
        OpenPositions op   = new OpenPositions();
        System.assertEquals(op.pos, null);
        System.assertEquals(op.met(), null);
        System.assertNotEquals(op.pos, null);
        //Test.stopTest();
    }
    
    public static testMethod void testOpenPositions()
    {   
        String username = 'username';
        String password = 'password';
        //Test.startTest();
        WGBH_Job_Titles__c jobTitle = new WGBH_Job_Titles__c(
                                        name = 'Apex code hacker',
                                        is_exempt__c = true,
                                        is_active__c = true,
                                        EEO_Category__c = 'Professionals',
                                        Description__c = 'SalesForce VisualForce Apex hacker',
                                        code__c = 'X123',
                                        affiliation__c = 'SAG'
                                        );
        insert jobTitle;
        
        WGBH_AUAC__c auac            = new WGBH_AUAC__c(
                                        Name = 'Fred AUAC',
                                        Activity__c = 'Activity',
                                        start_date__c=system.today(),
                                        end_date__c=system.today() + 1,
                                        description__c = 'new job',
                                        auac__c = 'clown'
                                        );
        
        insert auac;
        Position__c pos              = new Position__c(
                                        created_by_email__c = 'brian_wainwright@wgbh.org',
                                        max_pay__c = 30000.0,
                                        min_pay__c = 25000.0,
                                        position_title__c = jobTitle.Id,
                                        activity_code__c = auac.id,
                                        billing_accounting_unit__c = auac.id
                                        ); 
        insert pos;
        
        OpenPositions op   = new OpenPositions();
        op.pos = [SELECT Id, 
                        Name, 
                        Job_Requisition_Details__c, 
                        Position__c.Title__c, 
                        Position__c.Functional_Area__c, 
                        Publish_OpenDate__c, 
                        Type__c, 
                        departments__r.name, 
                        Start_Date__c, 
                        position_Title__r.Description__c, 
                        Affiliation__C,
                        Location__c 
                        FROM position__c WHERE id =: pos.id];
        
        //System.assertEquals(op.login(), null);
        System.assertEquals(op.getPositionDescription(pos), jobTitle.Description__c);
        
        //Test.stopTest();
    }
    
}