public class positiondetail 
{
    public String p { get; set; }
    public string posid{get; set;}
    public position__c Pos{get; set;}
    public string strOpen {get;set;} 
    
    public pagereference met()
    {
        if (posid == null || posid == '')
        {
            posid = ApexPages.currentPage().getParameters().get('id');
        }
    /*Ketan Benegal - Added Classification Type and Project Length to the query*/
        Pos = [SELECT Id, Name, Affiliation__c, position_Title__r.Description__c, Responsibilities__c, Skills_Required__c, Job_Description__c, Location__c, Max_Pay__c, Min_Pay__c,Hours_Per_Week__c, 
             Educational_Requirements__c, Close_Date__c, publish_OpenDate__c, Project_Name__c,Project_length__c, Travel_Required__c, Project_Start_Date__c, 
             Number_of_Openings_for_this_job__c,Building_Location__c,departments__r.name,Union_Maximum_Salary__c,Union_Minimum_Salary__c, Type__c, Classification__c from Position__c where id=:posid];
             
        if (Pos.Publish_OpenDate__c != null)
        {
            strOpen = Pos.Publish_OpenDate__c.format();
        }
            
        return null;
     }

    public String travelRequired()
    {
        if (pos.Travel_Required__c == true) return 'Yes';
        else return 'No';
    }

    Public pagereference Apply()
    {
        if(Pos.Close_Date__c != null){
            String err='Thank you for your interest in employment opportunities at WGBH. Unfortunately, the position for which you are applying has been closed. For a list of current employment opportunities please visit the WGBH career website at <a href="http://www.wgbh.org/about/employmentOpportunities.cfm">here</a>';
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,err)); 
        }else{
                if(Userinfo.getUsertype()=='Guest')
                {
                    pagereference pg = new Pagereference('/apex/ats_login_user?thisid='+posid);
                    return pg;
                }
                else
                {
                     pagereference pg = new Pagereference('/apex/appwizard?id='+posid);
                    return pg;
                }
        }
        return null;
    }
    
    public static testMethod void testApply()
    {
        //Test.startTest();
        positiondetail pd   = new positiondetail();
        position__c p = new position__c();
        pd.pos = p;
        pd.Apply();
        //Test.stopTest();
    }
    
    public static testMethod void testMet()
    {
        WGBH_AUAC__c auac          = new WGBH_AUAC__c();
        //initialize auac
        auac.Name = 'Fred AUAC';
        auac.Activity__c    = 'Activity';
        auac.start_date__c  = system.today();
        auac.end_date__c    = system.today() + 1;
        auac.description__c = 'NEW AUAC';
        auac.auac__c        = 'YANKEES';
        //insert
        insert auac;
        
        Position__c jobReq         = new Position__c();
        jobReq.Created_By_Email__c = 'brian_wainwright@wgbh.org';
        jobReq.Max_Pay__c          = 10000.0;
        jobReq.Min_Pay__c          = 5000.0;
        jobReq.Activity_Code__c    = auac.id;
        jobReq.Publish_OpenDate__c = System.today();
        
        insert jobReq;
        
        //Test.startTest();
        positiondetail pd   = new positiondetail();
        pd.posid = jobReq.Id;
        pd.met();
        System.assertEquals(pd.travelRequired(), 'No');
        jobReq.Travel_Required__c  = true;
        jobReq.Publish_OpenDate__c = null;
        update jobReq;
        pd.met();
        System.assertEquals(pd.travelRequired(), 'Yes');
        //Test.stopTest();
    }
}