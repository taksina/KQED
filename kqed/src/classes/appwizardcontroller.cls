//OMFG THIS CLASS NEEDS TO BE REFACTORED!!!!
public class appwizardcontroller 
{

    public String referencenumber{get; set;}
    public String Positionid{get; set;}
    public list<question__c> Ques{get; set;}
    public Boolean Accept{get; set;}
    public String Resumeid{get; set;}
    public String Coverletterid{get; set;}
    public Position__c pos;
    
    /*Ketan Benegal - Default Country Drop down to USA.*/
    //Country Lookup Code
//    public String selectedCountry = null;
/* Need to store the selectedCountryId.*/
    public list<Country__c> selectedCountryId {get;set;}
    
    public String selectedCountry { get { if(selectedCountry==null) selectedCountry='US'; selectedCountryId = [SELECT id FROM Country__c where code__c = :selectedCountry limit 1]; return selectedCountry; } set;}    
/*    public String getSelectedCountry()
    {
        return this.selectedCountry;
    }
    public void setSelectedCountry(String country)
    {
        this.selectedCountry = country;
    
    }
*/    
    public List<SelectOption> getCountries()
    {
        List<SelectOption> options = new List<SelectOption>();
        List<Country__c> countries = [SELECT id, name, code__c FROM Country__c ORDER BY name ASC];
        for(Country__c country:countries)
        { 
            /*Ketan Benegal - Commented out the following line and modified it.*/
            //options.add(new SelectOption(country.code__c, country.name));
            options.add(new SelectOption(country.code__c, country.name));
        }
        
        return options;
    }
    
    //State lookup code
    public String selectedState = null;
    
    public String getSelectedState()
    {
        return this.selectedState;
    }
    
    public void setSelectedState(String state)
    {
        this.selectedState = state;
    }
    
    public List<SelectOption> getStates()
    {
        List<SelectOption> options = new List<SelectOption>();
        /*Ketan Benegal - States should only appear for country code US. Added if clause.*/
        if (this.selectedCountry == 'US'){
            List<State__c> states = [SELECT id, name, code__c FROM State__c ORDER BY name ASC];
            for(State__c state:states)
            { 
                options.add(new SelectOption(state.id, state.name));
            }
        }
        return options;
    }
    
    public List<SelectOption> getOptions() 
    {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('NO','No')); 
        return options; 
    }
                       
    
    public List<SelectOption> getItems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }        
    
    public class questions
    {
        
        Public String Question{get; set;}
        Public String Qid{get; set;}
        Public String Yes{get; set;}
        // Public Boolean No{get; set;}
        public string Answer{get; set;}
    }
    
    public String Stage{get; set;}
    
    public string Approved{get; set;}
    public string CurrentlyEmployed{get;set;}
    public string currentEmployee{get; set;}
    public string RecentExperience{get; set;}
    
    public Job_Application__C ja{get; set;}
    public Candidate__c ca {get;set;}
    public boolean b{get; set;}
    public boolean questionsavailable{get; set;}
    public string coverletterName   
        {    get;set;    }  
          
        public Blob coverletterBody   
        {    get;set;    } 
    
    public string resumeName   
        {    get;set;    }  
          
        public Blob resumeBody   
        {    get;set;    } 
    
    Public String resumetext{get; set;}
    Public String coverlettertext{get; set;}
    Public User u{get; set;}
    
    Public List<Questions> qs{get; set;}
    
    public class customattachments
    {
        Public string title{get; set;}
        Public String attid{get; set;}
    }
    
    public List<customattachments> myattachs{get; set;}
    
    public static testMethod void testQuestions()
    {
        Test.startTest();
        Questions question = new Questions();
        question.Qid       = '123';
        question.Question  = 'Is anyone home?';
        question.Yes       = 'Yes';
        question.Answer    = 'No';
        
        Test.stopTest();
        
    }
    public static testMethod void testStage0Failure()
    {
        Candidate__c testCan       = new Candidate__c();
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        theWiz.ca                  = testCan;
        theWiz.GoNext();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testStage1Failure()
    {
        Question__c quest          = new Question__c();
        Position__c jobReq         = new Position__c();
        WGBH_AUAC__c auac          = new WGBH_AUAC__c();
        Test.startTest();
        appwizardcontroller theWiz = new appwizardcontroller();
        
        //initialize auac
        auac.Name = 'Fred AUAC';
        auac.Activity__c    = 'Activity';
        auac.start_date__c  = system.today();
        auac.end_date__c    = system.today() + 1;
        auac.description__c = 'NEW AUAC';
        auac.auac__c        = 'YANKEES';
        
        //insert
        insert auac;
        
        //initialize jobReq
        jobReq.Created_By_Email__c = 'brian_wainwright@wgbh.org';
        jobReq.Max_Pay__c          = 10000.0;
        jobReq.Min_Pay__c          = 5000.0;
        jobReq.Activity_Code__c    = auac.id;
        
        //insert
        insert jobReq;
        System.assertNotEquals(jobReq.id, null);
        
        //initialize question
        quest.Question__c = 'To be or not to be?';
        quest.Position__c = jobReq.id;
        
        //insert
        insert quest;
        
        //init the wiz
        theWiz.pos                = jobReq;
        theWiz.Positionid         = jobReq.id;
        theWiz.questionsavailable = true;
        theWiz.Ques.add(quest);
        theWiz.GoStage1();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testStage2Failure()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        theWiz.GoStage2();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testStage3Failure()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        theWiz.GoStage3();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testStage4Failure()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        theWiz.GoStage4();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testSubmitFailure()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        theWiz.submit();
        System.assertNotEquals(null, ApexPages.getMessages());
        Test.stopTest();
    }
    
    public static testMethod void testGetCountries()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        System.assertNotEquals(null, theWiz.getCountries());
        Test.stopTest();
    }
    
    public static testMethod void testGetStates()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        System.assertNotEquals(null, theWiz.getStates());
        Test.stopTest();
    }
    
    public static testMethod void testGetItems()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        System.assertNotEquals(null, theWiz.getItems());
        Test.stopTest();
    }
    
    public static testMethod void testGetOptions()
    {
        appwizardcontroller theWiz = new appwizardcontroller();
        Test.startTest();
        System.assertNotEquals(null, theWiz.getOptions());
        Test.stopTest();
    }
    
    public static testMethod void testAllFiveStepsAndSubmit()
    {
        Profile p = [select id from profile where name='Standard User'];
        //Get all required objects instantiated
        //Candidate__c testCan       = new Candidate__c();
        //User testUser              = new User();
        Job_Application__c jobApp  = new Job_Application__c();
        Question__c quest          = new Question__c();
        WGBH_AUAC__c auac          = new WGBH_AUAC__c();
        Position__c jobReq         = new Position__c();
        State__c state             = new State__c();
        Country__c country         = new Country__c();
        
        //start the testing
        Test.startTest();
        //initialize auac
        auac.Name = 'Fred AUAC';
        auac.Activity__c    = 'Activity';
        auac.start_date__c  = system.today();
        auac.end_date__c    = system.today() + 1;
        auac.description__c = 'NEW AUAC';
        auac.auac__c        = 'YANKEES';
        //insert
        insert auac;
        System.assertNotEquals(auac.id, null);
        
        //insitalize state
        state.Name    = 'Grace';
        state.code__c = 'GC';
        
        //insert
        insert state;
        System.assertNotEquals(state.id, null);
        //initialize country
        country.Name    = 'For Old Men';
        country.Code__c = 'XX';
        
        //insert
        insert country;
        System.assertNotEquals(country.id, null);
        
        User testUser = new User();
        testUser.Username = 'blech@gmail.com';
        testUser.Email = 'blech@gmail.com';
        //Changed by BRW
        //testUser.CommunityNickname = String.valueOf(Math.random());
        testUser.CommunityNickname = 'blech';
       
       // u.profileid='00eA0000000ZkMM';
        testUser.Firstname =  'Joe';
        testUser.Lastname='User';
        testUser.alias = 'juser';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Los_Angeles';
        testUser.EmailEncodingKey = 'UTF-8';
        testUser.LanguageLocaleKey = 'en_US';
        testUser.profileid = p.id;
        Candidate__c testCan = new Candidate__c();
        testCan.first_name__c = 'Joe';
        testCan.last_name__c = 'User';
        testCan.Street_Address1__c  = 'Main Street';
        testCan.City__c = 'Boston';
        testCan.State_lkp__c = state.id;
        testCan.Country_lkp__c = country.id;
        testCan.Email__c = 'brwainwright@gmail.com';
        testCan.Zip_Postal_Code__c = '12345';
        testCan.Phone__c = '6173003434';
        testCan.Recent_Salary__c = 55000;
        testCan.Desired_Salary__c = 55000;
        insert testCan;
        testUser.Candidate_Id__c = testCan.id;
        insert testUser;
       // u.contact=c;
        //insert u;
        /*User testUser = [SELECT contactid, 
                                portalrole, 
                                Candidate_Id__c, 
                                firstName, 
                                lastname, 
                                email, 
                                username, 
                                alias, 
                                communitynickname 
                                FROM User 
                                WHERE email = 'joeapplicantwgbh2@gmail.com' ];
                                
        Candidate__c testCan = [SELECT First_Name__c,
                                       Last_Name__c,
                                       Street_Address1__c,
                                       City__c,
                                       State_lkp__c,
                                       Country_lkp__c,
                                       Email__c,
                                       Zip_Postal_Code__c,
                                       Phone__c,
                                       Recent_Salary__c,
                                       Desired_Salary__c
                                       FROM Candidate__c
                                       WHERE id =: testUser.Candidate_Id__c];*/

        //System.assertNotEquals(testUser.id, null);
        
        //initialize jobReq
        jobReq.Created_By_Email__c = 'brian_wainwright@wgbh.org';
        jobReq.Max_Pay__c          = 10000.0;
        jobReq.Min_Pay__c          = 5000.0;
        jobReq.Activity_Code__c    = auac.id;
        
        //insert
        insert jobReq;
        System.assertNotEquals(jobReq.id, null);
        
        //initialize question
        quest.Question__c = 'To be or not to be?';
        quest.Position__c = jobReq.id;
        
        //insert
        insert quest;
        System.assertNotEquals(quest.id, null);
        System.assertEquals(quest.Position__c, jobReq.id);
        
        //initialize jobApp
        jobApp.Candidate__c = testCan.id;
        jobApp.Position__c  = jobReq.id;

        //insert
        insert jobApp;
        System.assertNotEquals(jobApp.id, null);
        System.assertEquals(jobApp.Candidate__c, testCan.id);
        System.assertEquals(jobApp.Position__c, jobReq.id);
        
        appwizardcontroller theWiz;
        System.runAs(testUser)
        {
            //this may fail and I may need to create a new constructor
            theWiz            = new appwizardcontroller();
            theWiz.ca         = testCan;
            theWiz.u          = testUser;
            theWiz.pos        = jobReq;
            theWiz.Positionid = jobReq.id;
            theWiz.ja         = jobApp;
            
            theWiz.Ques.add(quest);
//Ketan Benegal - Commented the following lines.                                                
            //set the state and country form the pick lits                                  
 /*           theWiz.setSelectedCountry(testCan.Country_lkp__c);
            theWiz.setSelectedState(testCan.State_lkp__c);
    */      
  //modified version of the above.
              //set the state and country form the pick lits                                  
            theWiz.selectedCountry=testCan.Country_lkp__c;
            theWiz.setSelectedState(testCan.State_lkp__c);
            
  
            //get them back and test them
            System.assertEquals(theWiz.getSelectedState(), testCan.State_lkp__c);
            //Ketan Benegal- Commented the following line.
           // System.assertEquals(theWiz.getSelectedCountry(), testCan.Country_lkp__c);
            System.assertEquals(theWiz.selectedCountry, testCan.Country_lkp__c);
            
            theWiz.GoStage0();
            System.assertEquals('0', theWiz.Stage);
            theWiz.GoNext();
            theWiz.GoStage1();
            
            for (Questions q : theWiz.qs)
            {
               q.Yes = 'No';
               Answer__c ans = new Answer__c();
               ans.Question__c = q.Question;
               ans.No__c = true;
               ans.yes__c = false;
            }
            //skip stage 1 - the questions
            theWiz.GoStage2();
            System.assertEquals('2', theWiz.Stage);
            //set copy and paste values
            theWiz.coverletterName = 'WillieShakesCover';
            theWiz.resumeName      = 'WillieShakesResume';
            theWiz.coverlettertext = 'I am the greatest playwright and poet in human history. You should hire me.';
            theWiz.resumetext      = 'My reputation precedes me.';
            //set attachemnt values
            theWiz.coverletterBody = Blob.valueOf('Cover Letter Body');
            theWiz.resumeBody      = Blob.valueOf('Resume Body');
            
            theWiz.GoStage3_final();
            //System.assertEquals('3', theWiz.Stage);
            //accept the terms and conditions
            theWiz.Accept                          = true;
            theWiz.currentEmployee                 = 'No';
            theWiz.CurrentlyEmployed               = 'No';
            testCan.Previously_employed_at_WGBH__c = 'No';
            
            theWiz.GoStage4();
            System.assertEquals('4', theWiz.Stage);
        }
        
        //Don't answer any of the EEO questions
        theWiz.submit();
        Test.StopTest();
    }
    
    public appwizardcontroller(){
        b=false;
        accept=false;
        ja= new job_application__c();
        ca = new Candidate__c();
        Stage='0';
        ques = new list<question__c>();
        qs = new List<Questions>();
       List<Attachment> attachs = new List<Attachment>();
       List<Attachment> coverletters = new List<Attachment>();
       myattachs = new List<customattachments>();
       
       if(Userinfo.getUsertype() != 'Guest'){
            try{
                u = [Select id, Candidate_Id__c, name, Street, city, state, postalcode, MobilePhone, Email, Fax, Phone, Candidate_first_name__c, Candidate_last_name__c,
                Candidate_middle_name__c, street_address2__c, country__c from User where id=:Userinfo.getUserid()]; 
            }
            catch(Exception ex){System.debug(ex.getmessage());}
            
            if (u.Candidate_Id__c != null){
                    
                    Map<String, Schema.SObjectField> FieldMap = Schema.SObjectType.candidate__c.fields.getMap();
                    Set<String> setFields = FieldMap.keySet();
                            
                            String strSoQL = 'Select Id';
                                    for (String fname : setFields) {
                                            if (fname != 'Id'){
                                                    strSoQL += ', ' +fname;
                                            }
                                    }
                                    strSoQL += ' from candidate__c where Id = \'' +u.Candidate_Id__c +'\'';
                                    List<Candidate__c> res = Database.query(strSoQL);
                                    
                                    if (res != null && res.size() >= 1)
                                    {
                                        ca = res[0];
                                    }
                                    //ca = Database.query(strSoQL);
                                    
                    try{
                            attachs = [Select id, body, name, createddate from Attachment where parentid =: ca.Id and name='Resume' ];
                            coverletters = [Select id, body, name, createddate from Attachment where parentid =: ca.Id and name='coverletter' ];
                    }
                    catch(Exception ex){System.debug(ex.getmessage());}
            } else {
                    ca = new candidate__c();
            }
        }  
        if(attachs.size()!=0){
            customattachments ct = new customattachments();
            ct.title = attachs[0].name;
            ct.attid = attachs[0].id;
            myattachs.add(ct);
        }
        if(coverletters.size()!=0){
        customattachments ct = new customattachments();
            ct.title = coverletters[0].name;
            ct.attid = coverletters[0].id;
        myattachs.add(ct);
        
        }
        
        Positionid = ApexPages.currentPage().getParameters().get('id');
        if(Positionid != null){
        
            ques=[Select id, name , question__c, position__c from Question__c where position__c=:positionid];
            pos = [Select Id, Name, position_Title__r.Description__c from Position__c where Id =: positionId];
        
        } 
        
        for(integer i = 0; i < ques.size(); i++){
            Questions q = new Questions();
            q.Qid=ques[i].id;
            q.Question=ques[i].Question__c;
            q.yes=null;
            qs.add(q);
        } 
        
        System.debug(positionid);
    }
    
    public void GoNext()
    {
        Boolean error=false;
        /*Ketan Benegal - Commented out following line. selectedCountry contains country code. - Start*/
        //ca.Country_lkp__c = this.selectedCountry;
        try{
            ca.Country_lkp__c = this.selectedCountryId[0].Id;
        }
        catch(Exception ex) {}
        ca.State_lkp__c   = this.selectedState;
        
        if(ca.First_Name__c == '' || ca.First_Name__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'First Name is a required field')); 
            error=true;
        }
        if(ca.Last_Name__c == '' || ca.Last_Name__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Last Name is a required field')); 
            error=true;
        }
        if(ca.Email__c == '' || ca.Email__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'ca.Email__c is a required field')); 
            error=true;
        }
        if(ca.Phone__c == '' || ca.Phone__c == null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Phone is a required field')); 
            error=true;
        }
        if(ca.Street_Address1__c == '' || ca.Street_Address1__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.Error,'Street Address1 is a required field'));
            error=true;
        }
        if(ca.City__c == '' || ca.City__c == null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'City is a required field'));
            error=true;
        }
        if(ca.Zip_Postal_Code__c==''||ca.Zip_Postal_Code__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Zipcode is a required field'));
            error=true;
        }
        if(error == true){
            Stage='0';
        }
        else{
            if( qs.size() == 0){questionsavailable=false;
                stage = '2';
            }
            else{stage = '1';questionsavailable = true;
            }    
        }    
    }
    
    public void GoStage2(){
        for (Questions q : qs){
            if (q.Yes == null){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please answer all questions before proceeding.'));
                    return;
            }
        }
        stage='2';
    }
    
    public void GoStage3_final(){
        ///MODIFIED 2/19/2010 BRW
        /*if ((coverletterbody == null && coverlettertext == '') ||(resumebody == null && resumetext == null))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add a cover letter and resume before proceeding.'));
            return;
        }*/
        if (ca.Previously_employed_at_WGBH__c == null ||  CurrentlyEmployed == null){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please answer all required questions before proceeding.'));
            return;
        }if ( (CurrentlyEmployed == 'Yes') &&ca.Previous_WGBH_employee_ID__c == '' ){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'You\'ve indicated that you are a current employee of WGBH, please enter your WGBH Employee ID.'));
            return;
        }
        System.debug('stage 3');
        Stage='3';
    }
        
    public void GoStage4(){
        if( Accept == null || Accept == false ){
            system.debug('in the false block');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please Accept Terms And Conditions before proceeding.' ));
            //coverletterBody = null;
            //resumeBody = null;
            return;
        }
        Stage='4';
    }
    public void GoStage3(){
       /*Ketan Benegal - Commented out currently/previously employed by WGBH. CR.*/
       /* if (ca.Previously_employed_at_WGBH__c == null ||  CurrentlyEmployed == null){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please answer all required questions before proceeding.'));
            return;
        }*/
        if ( (CurrentlyEmployed == 'Yes') &&ca.Previous_WGBH_employee_ID__c == '' ){ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'You\'ve indicated that you are a current employee of WGBH, please enter your WGBH Employee ID.'));
            return;
        }
/*Ketan Benegal - Current Employer Required field.*/
        if(ca.Current_Employer__c ==''||ca.Current_Employer__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Current Employer is a required field.'));
            return;
        }

/*Ketan Benegal - Years of Experience Required field.*/
        if(ca.Years_Of_Experience__c ==''||ca.Years_Of_Experience__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Years of experience is a required field.'));
            return;
        }

/*Ketan Benegal - Desired salary Required field.*/
  /*      if(ca.Desired_Salary__c == 0 ||ca.Desired_Salary__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Desired salary is a required field.'));
            return;
        }
*/
        if(ca.Recent_Salary__c == 0 ||ca.Recent_Salary__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Recent salary is a required field.'));
            return;
        }

/*Ketan Benegal - US Citizen Required field.*/
        if(ca.approved_to_work__c ==''||ca.approved_to_work__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Citizenship Information is required.'));
            return;
        }

/*Ketan Benegal - Sponsorship__c Required field.*/
        if(ca.Sponsorship__c ==''||ca.Sponsorship__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Sponsorship Information is required.'));
            return;
        }
        
/*Ketan Benegal - Education Required field.*/
        if(ca.Education__c ==''||ca.Education__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Education Information is required.'));
            return;
        }

/*Ketan Benegal - About us Required field.*/
        if(ca.about_us__c ==''||ca.about_us__c==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'How did you hear about us? is required.'));
            return;
        }

        stage='3';
    }
    
    public void GoStage0(){stage='0';}
    public void GoStage1(){
        if(questionsavailable){Stage='1';}
        else{stage='0';}
    }
    
    public PageReference submit(){  
        if ((coverletterbody == null && coverlettertext == '') ||(resumebody == null && resumetext == null))
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please add a cover letter and resume before proceeding.'));
            return null;
        }
        system.debug('Accepted --> ' + accept);
        /*if( Accept == null || Accept == false ){
            system.debug('in the false block');
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,'Please Accept Terms And Conditions before proceeding.' ));
            coverletterBody = null;
            resumeBody = null;
            return null;
        }*/
        if(u!=null){
            u.Candidate_first_name__c  = ca.First_Name__c ;
            u.Candidate_middle_name__c = ca.Middle_Name__c;
            u.Candidate_last_name__c   = ca.Last_Name__c;
            u.Email                    = ca.Email__c;
            u.Phone                    = ca.Phone__c;
            u.fax                      = ca.Fax__c;
            u.MobilePhone              = ca.Mobile__c;
            u.street                   = ca.Street_Address1__c;
            u.street_address2__c       = ca.Street_Address2__c;
            u.city                     = ca.City__c;
            u.state                    = ca.state_lkp__c;
            u.postalcode               = ca.Zip_Postal_Code__c;
            u.country__c               = ca.country_lkp__c;
        }
        ca.Name = '_';
        if(currentEmployee=='Yes') {ca.Current_employee_of_WGBH__c = true;}
        else {ca.Current_employee_of_WGBH__c = false;}  
        if(currentlyEmployed=='Yes'){ca.currently_employed__c = true;}
        else{ca.currently_employed__C = false;}
        if(coverlettertext != null){ca.cover_letter__c = coverlettertext; }
        if(resumetext != null) {ca.resume__c = resumetext;}try{
            upsert ca;
            ja.position__c    = positionid;
            ja.candidate__c   = ca.id;
            u.Candidate_Id__c = ca.Id;
            if(u != null){
                try{update u;}
                catch(Exception e){System.debug(e);}
            }try{ja.Name = '_';insert ja;
            }catch(Exception ex){System.debug(ex);}
        }catch(Exception e){System.debug(e);
        }if(ja.id != null){
            for(Questions Q: qs){
                Answer__c ans = new Answer__c();
                ans.Question__c = Q.Question;
                if(Q.yes==null || Q.yes=='No')
                    ans.No__c = true;
                else 
                    ans.yes__c = true;
                ans.Answer__c= Q.Answer;
                ans.job_application__c=ja.id;
                try{insert ans;}
                catch(Exception ex){System.debug(ex);}
            }
        }if((coverlettertext != null && coverlettertext.trim().length()>0) || (resumetext != null && resumetext.trim().length()>0)){
           Job_Application__c j = [Select id, cover_letter__c from job_application__c where id=:ja.id];
           if(coverlettertext!=null)
           j.cover_letter__c = coverlettertext;
           if(resumetext!=null) 
           j.resume__c = resumetext;
           update j;
        }
        if(coverletterBody != null){  
           Attachment myAttachment  = new Attachment();  
           myAttachment.Body = coverletterbody;  
           myAttachment.Name = 'coverletter';  
           myAttachment.ParentId = ja.id;  
           insert myAttachment;  
           System.debug('attachment ID:' + myattachment.id);
           Attachment att = new Attachment();
           att.Body = coverletterbody;  
           att.Name = 'coverletter';  
           att.ParentId = ca.id;  
           insert att; 
           coverletterBody = null;
        }
        if(resumeBody != null){ 
            try{ 
                  Attachment myResumeAttachment  = new Attachment();  
                  myResumeAttachment.Body = resumebody;  
                  myResumeAttachment.Name = 'Resume';  
                  myResumeAttachment.ParentId = ja.id;  
                  insert myResumeAttachment;  
                  System.debug('attachment ID:' + myResumeAttachment.id);
                  Attachment att = new Attachment();
                  System.debug('222attachment ID:' + myResumeAttachment.id);
                  att.Body = resumebody;  
                  att.Name = 'Resume';  
                  att.ParentId = ca.id;  
                  insert att;                 
                  resumeBody = null;
             }catch(DmlException e){ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getDmlMessage(0)));} 
            catch(Exception e){System.debug(e);}
        }try{
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {ca.Email__c}; 
            String[] ccAddresses = new String[] {'no-reply@wgbh.org'};
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('no-reply@wgbh.org');
            mail.setSenderDisplayName('WGBH Human Resources');
            mail.setSubject(pos.position_Title__r.Description__c +' (' +pos.Name +')'); //'WGBH Application Confirmation'
            mail.setBccSender(false);
            mail.setUseSignature(false);
            mail.setPlainTextBody('Dear ' + ca.first_name__c + ', \r\r' + 
            'Thank you for your interest in employment opportunities at WGBH. ' +
            'Your application has been received and is currently under review. ' +
            'A Human Resources representative will be in contact with you if your qualifications ' +
            'and skill set match the position. \r\r Regards,\r\rWGBH Human Resources');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }
        catch(exception e){ System.debug(e);}
        pagereference pg= new pagereference('/apex/ats_confirmation');
        return pg;  
    }  
}